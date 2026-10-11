package space.mai.mai_household.wear

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate

/**
 * Speicher der Uhr (nur lokal, SharedPreferences):
 *
 * - `snapshot`/`pending`: letzter Stand vom Telefon (Widget-Stand und dort
 *   abgehakte, noch nicht eingetragene Einträge).
 * - `outbox`: auf der Uhr Abgehaktes, siehe [Outbox].
 */
object WatchStore {
    private const val PREFS = "mai_household_watch"
    private const val KEY_SNAPSHOT = "snapshot"
    private const val KEY_PENDING = "pending"
    private const val KEY_OUTBOX = "outbox"
    private const val KEY_LAST_CLICK = "lastClick"
    private const val KEY_LAST_REFRESH = "lastRefresh"

    fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    /** Letzter Stand oder `null` (Telefon-App noch nie geöffnet/verbunden). */
    fun snapshot(context: Context): JSONObject? {
        val raw = prefs(context).getString(KEY_SNAPSHOT, null) ?: return null
        if (raw.isEmpty()) return null
        return try {
            JSONObject(raw)
        } catch (_: Exception) {
            null
        }
    }

    fun model(context: Context, section: Section, today: LocalDate = LocalDate.now()): SectionModel? {
        val snapshot = snapshot(context) ?: return null
        return WatchContent.build(snapshot, section, today, checker(context))
    }

    /** Abgehakt? Eigene Markierung vor der des Telefons. */
    private fun checker(context: Context): (String, String) -> Boolean {
        val pending = pendingKeys(context)
        val outbox = Outbox.parse(prefs(context).getString(KEY_OUTBOX, null))
            .associateBy { it.key }
        return { kind, id ->
            val key = WatchContent.key(kind, id)
            outbox[key]?.checked ?: (key in pending)
        }
    }

    private fun pendingKeys(context: Context): Set<String> {
        val out = HashSet<String>()
        val list = try {
            JSONArray(prefs(context).getString(KEY_PENDING, null) ?: "[]")
        } catch (_: Exception) {
            return out
        }
        for (i in 0 until list.length()) {
            val e = list.optJSONObject(i) ?: continue
            out.add(WatchContent.key(e.optString("kind"), e.optString("id")))
        }
        return out
    }

    fun outboxJson(context: Context): String =
        prefs(context).getString(KEY_OUTBOX, null) ?: "[]"

    /**
     * Neuer Stand vom Telefon. Liefert `true`, wenn sich dadurch der Ausgang
     * verkleinert hat (dann an das Telefon zurückgeben).
     */
    @Synchronized
    fun saveState(context: Context, snapshot: String?, pending: String?, acks: String?): Boolean {
        val present = try {
            if (snapshot.isNullOrEmpty()) null else WatchContent.keys(JSONObject(snapshot))
        } catch (_: Exception) {
            null
        }
        val before = Outbox.parse(outboxJson(context))
        val after = Outbox.prune(before, Outbox.parseAcks(acks), present, System.currentTimeMillis())
        prefs(context).edit()
            .putString(KEY_SNAPSHOT, snapshot ?: "")
            .putString(KEY_PENDING, pending ?: "[]")
            .putString(KEY_OUTBOX, Outbox.encode(after))
            .apply()
        return after.size != before.size
    }

    /** Abhaken bzw. Haken zurücknehmen. */
    @Synchronized
    fun toggle(context: Context, kind: String, id: String, now: Long) {
        val checked = checker(context)(kind, id)
        val list = Outbox.put(Outbox.parse(outboxJson(context)), WatchAction(kind, id, !checked, now))
        prefs(context).edit().putString(KEY_OUTBOX, Outbox.encode(list)).apply()
    }

    /**
     * `true`, wenn dieser Tipp auf eine Kachel neu ist. Kacheln melden den
     * zuletzt getippten Eintrag mit; doppelt gemeldet zählt er nur einmal.
     */
    @Synchronized
    fun takeClick(context: Context, clickId: String): Boolean {
        if (prefs(context).getString(KEY_LAST_CLICK, null) == clickId) return false
        prefs(context).edit().putString(KEY_LAST_CLICK, clickId).apply()
        return true
    }

    /** Höchstens alle [minIntervalMs] beim Telefon nachfragen. */
    @Synchronized
    fun claimRefresh(context: Context, now: Long, minIntervalMs: Long): Boolean {
        val last = prefs(context).getLong(KEY_LAST_REFRESH, 0L)
        if (now - last in 0 until minIntervalMs) return false
        prefs(context).edit().putLong(KEY_LAST_REFRESH, now).apply()
        return true
    }
}
