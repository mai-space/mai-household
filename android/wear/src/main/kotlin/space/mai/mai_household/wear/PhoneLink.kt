package space.mai.mai_household.wear

import android.content.ComponentName
import android.content.Context
import android.net.Uri
import androidx.wear.tiles.TileService
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
import com.google.android.gms.tasks.Tasks
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMap
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.PutDataRequest
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.WearableListenerService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

/**
 * Verbindung zum Telefon über die Datenschicht (Gegenstück:
 * `android/app/…/wear/WearBridge.kt`).
 *
 * - `/household/state` (Telefon → Uhr): Widget-Stand, dort abgehakte
 *   Einträge und Bestätigungen.
 * - `/household/watch` (Uhr → Telefon): [Outbox] der Uhr.
 */
object PhoneLink {
    const val PATH_STATE = "/household/state"
    const val PATH_WATCH = "/household/watch"
    private const val KEY_SNAPSHOT = "snapshot"
    private const val KEY_PENDING = "pending"
    private const val KEY_ACKS = "acks"
    private const val KEY_ACTIONS = "actions"
    private const val KEY_HELLO = "hello"
    private const val TIMEOUT_S = 15L

    private val executor = Executors.newSingleThreadExecutor()

    /** Ausgang an das Telefon (die Datenschicht stellt zu, sobald es erreichbar ist). */
    fun sendOutbox(context: Context) {
        val app = context.applicationContext
        executor.execute {
            try {
                put(app, hello = false)
            } catch (_: Exception) {
                // Nächster Versuch beim nächsten Abhaken oder Stand.
            }
        }
    }

    /**
     * Vorhandenen Stand lesen und das Telefon um einen frischen bitten
     * (z. B. direkt nach der Installation). Höchstens alle [minIntervalMs].
     */
    fun refresh(context: Context, minIntervalMs: Long = 60_000L) {
        val app = context.applicationContext
        if (!WatchStore.claimRefresh(app, System.currentTimeMillis(), minIntervalMs)) return
        executor.execute {
            try {
                fetch(app)
            } catch (_: Exception) {
            }
            try {
                put(app, hello = true)
            } catch (_: Exception) {
            }
        }
    }

    /** Neuer Stand vom Telefon: speichern, Ausgang aufräumen, alles neu zeichnen. */
    fun receive(context: Context, map: DataMap) {
        val pruned = WatchStore.saveState(
            context,
            map.getString(KEY_SNAPSHOT),
            map.getString(KEY_PENDING),
            map.getString(KEY_ACKS),
        )
        if (pruned) sendOutbox(context)
        Refresh.all(context)
    }

    private fun put(context: Context, hello: Boolean) {
        val request = PutDataMapRequest.create(PATH_WATCH).apply {
            dataMap.putString(KEY_ACTIONS, WatchStore.outboxJson(context))
            // Geänderter Wert = neues Datenobjekt = Telefon antwortet mit Stand.
            if (hello) dataMap.putLong(KEY_HELLO, System.currentTimeMillis())
        }.asPutDataRequest().setUrgent()
        Tasks.await(Wearable.getDataClient(context).putDataItem(request), TIMEOUT_S, TimeUnit.SECONDS)
    }

    private fun fetch(context: Context) {
        val uri = Uri.Builder().scheme(PutDataRequest.WEAR_URI_SCHEME).path(PATH_STATE).build()
        val buffer = Tasks.await(Wearable.getDataClient(context).getDataItems(uri), TIMEOUT_S, TimeUnit.SECONDS)
        try {
            for (item in buffer) receive(context, DataMapItem.fromDataItem(item).dataMap)
        } finally {
            buffer.release()
        }
    }
}

/** Empfängt neue Stände vom Telefon (auch wenn die Uhr-App nicht läuft). */
class PhoneListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        for (event in dataEvents) {
            if (event.type != DataEvent.TYPE_CHANGED) continue
            val item = event.dataItem
            if (item.uri.path != PhoneLink.PATH_STATE) continue
            PhoneLink.receive(this, DataMapItem.fromDataItem(item).dataMap)
        }
    }
}

/** Kacheln und Komplikationen neu zeichnen lassen. */
object Refresh {
    fun all(context: Context) {
        tiles(context)
        complications(context)
    }

    fun tiles(context: Context) {
        val updater = TileService.getUpdater(context)
        updater.requestUpdate(ChoresTileService::class.java)
        updater.requestUpdate(ShoppingTileService::class.java)
        updater.requestUpdate(MealsTileService::class.java)
    }

    fun complications(context: Context) {
        for (cls in listOf(
            ChoresComplicationService::class.java,
            ShoppingComplicationService::class.java,
            MealsComplicationService::class.java,
        )) {
            ComplicationDataSourceUpdateRequester
                .create(context, ComponentName(context, cls))
                .requestUpdateAll()
        }
    }
}
