package space.mai.mai_household.wear

import android.content.Context
import com.google.android.gms.tasks.Tasks
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.WearableListenerService
import org.json.JSONArray
import org.json.JSONObject
import space.mai.mai_household.widgets.HouseholdWidgets
import space.mai.mai_household.widgets.WidgetStore
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

/**
 * Brücke zur Uhr-App (`android/wear`) über die Datenschicht der
 * Google-Play-Dienste — dieselben Daten wie die Homescreen-Widgets:
 *
 * - `/household/state` (Telefon → Uhr): Widget-Stand, auf dem Homescreen
 *   abgehakte Einträge und Bestätigungen (`acks`) für die Uhr.
 * - `/household/watch` (Uhr → Telefon): auf der Uhr gesetzte Markierungen
 *   `[{kind, id, checked, at}]`. Sie landen in derselben Warteliste wie die
 *   Homescreen-Widgets ([WidgetStore]); die App trägt sie beim nächsten
 *   Öffnen ein — mit `ctx.stamp()`, also auch für andere Geräte.
 *
 * Ohne gekoppelte Uhr mit installierter Uhr-App wird nichts übertragen.
 * Ohne Play-Dienste schlägt alles still fehl; die Widgets laufen weiter.
 */
object WearBridge {
    const val PATH_STATE = "/household/state"
    const val PATH_WATCH = "/household/watch"
    private const val KEY_SNAPSHOT = "snapshot"
    private const val KEY_PENDING = "pending"
    private const val KEY_ACKS = "acks"
    const val KEY_ACTIONS = "actions"

    /** Fähigkeit der Uhr-App (`android/wear/src/main/res/values/wear.xml`). */
    private const val CAPABILITY = "mai_household_watch"

    private const val PREFS = "mai_household_wear"
    private const val KEY_APPLIED = "applied"
    private const val TIMEOUT_S = 15L

    private val executor = Executors.newSingleThreadExecutor()

    /** Stand an die Uhr geben (im Hintergrund); [done] läuft danach. */
    fun publish(context: Context, done: (() -> Unit)? = null) {
        val app = context.applicationContext
        executor.execute {
            try {
                publishNow(app, onlyWithWatch = true)
            } catch (_: Exception) {
                // Keine Uhr, keine Play-Dienste oder Zeitüberschreitung.
            } finally {
                done?.invoke()
            }
        }
    }

    /** Blockierend — nicht auf dem Hauptthread aufrufen. */
    fun publishNow(context: Context, onlyWithWatch: Boolean) {
        if (onlyWithWatch) {
            val info = Tasks.await(
                Wearable.getCapabilityClient(context)
                    .getCapability(CAPABILITY, CapabilityClient.FILTER_ALL),
                TIMEOUT_S,
                TimeUnit.SECONDS,
            )
            if (info.nodes.isEmpty()) return
        }
        val request = PutDataMapRequest.create(PATH_STATE).apply {
            dataMap.putString(KEY_SNAPSHOT, WidgetStore.snapshotJson(context) ?: "")
            dataMap.putString(KEY_PENDING, WidgetStore.pendingJson(context))
            dataMap.putString(KEY_ACKS, applied(context).toString())
        }.asPutDataRequest().setUrgent()
        Tasks.await(Wearable.getDataClient(context).putDataItem(request), TIMEOUT_S, TimeUnit.SECONDS)
    }

    /**
     * Markierungen der Uhr übernehmen. Jede Zeile zählt je Zeitstempel nur
     * einmal (die Uhr schickt ihren Ausgang, bis er bestätigt ist). Liefert
     * `true`, wenn sich die Warteliste geändert hat.
     */
    @Synchronized
    fun applyFromWatch(context: Context, actionsJson: String?): Boolean {
        val actions = try {
            JSONArray(actionsJson ?: "[]")
        } catch (_: Exception) {
            return false
        }
        val before = applied(context)
        val after = JSONObject()
        var changed = false
        for (i in 0 until actions.length()) {
            val a = actions.optJSONObject(i) ?: continue
            val kind = a.optString("kind")
            val id = a.optString("id")
            val at = a.optLong("at")
            if (id.isEmpty() || at <= 0) continue
            if (kind != WidgetStore.KIND_CHORE && kind != WidgetStore.KIND_SHOP) continue
            val key = "$kind|$id"
            val seen = before.optLong(key, 0L)
            if (at > seen) {
                WidgetStore.set(context, kind, id, a.optBoolean("checked"), at)
                changed = true
            }
            // Nur behalten, was die Uhr noch schickt — bleibt klein.
            after.put(key, maxOf(at, seen))
        }
        prefs(context).edit().putString(KEY_APPLIED, after.toString()).apply()
        return changed
    }

    private fun applied(context: Context): JSONObject =
        try {
            JSONObject(prefs(context).getString(KEY_APPLIED, null) ?: "{}")
        } catch (_: Exception) {
            JSONObject()
        }

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
}

/** Empfängt den Ausgang der Uhr (auch wenn die App nicht läuft). */
class WearListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        var fromWatch = false
        var changed = false
        for (event in dataEvents) {
            if (event.type != DataEvent.TYPE_CHANGED) continue
            val item = event.dataItem
            if (item.uri.path != WearBridge.PATH_WATCH) continue
            fromWatch = true
            val actions = DataMapItem.fromDataItem(item).dataMap.getString(WearBridge.KEY_ACTIONS)
            if (WearBridge.applyFromWatch(this, actions)) changed = true
        }
        if (!fromWatch) return
        if (changed) HouseholdWidgets.refreshAll(this)
        // Antwort mit Stand und Bestätigungen (auch auf „Hallo“ einer neuen Uhr).
        try {
            WearBridge.publishNow(this, onlyWithWatch = false)
        } catch (_: Exception) {
        }
    }
}
