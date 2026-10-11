package space.mai.mai_household.widgets

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

/**
 * Speicher der Homescreen-Widgets (nur lokal, SharedPreferences):
 *
 * - `snapshot`: Stand aus der App (JSON, siehe `lib/home_widgets/widget_snapshot.dart`).
 * - `pending`: auf dem Homescreen abgehakte Einträge, die die App beim
 *   nächsten Start einträgt. Erneutes Tippen nimmt eine Markierung zurück.
 */
object WidgetStore {
    private const val PREFS = "mai_household_widgets"
    private const val KEY_SNAPSHOT = "snapshot"
    private const val KEY_PENDING = "pending"

    const val KIND_SHOP = "shop"
    const val KIND_CHORE = "chore"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun saveSnapshot(context: Context, json: String) {
        prefs(context).edit().putString(KEY_SNAPSHOT, json).apply()
    }

    /** Letzter Stand der App oder `null` (App noch nie geöffnet/eingerichtet). */
    fun snapshot(context: Context): JSONObject? {
        val raw = prefs(context).getString(KEY_SNAPSHOT, null) ?: return null
        return try {
            JSONObject(raw)
        } catch (_: Exception) {
            null
        }
    }

    /** Abgehakte Einträge als JSON-Liste `[{kind, id, at}]`. */
    fun pendingJson(context: Context): String =
        prefs(context).getString(KEY_PENDING, null) ?: "[]"

    private fun pending(context: Context): JSONArray =
        try {
            JSONArray(pendingJson(context))
        } catch (_: Exception) {
            JSONArray()
        }

    /** IDs der abgehakten Einträge einer Art. */
    fun pendingIds(context: Context, kind: String): Set<String> {
        val list = pending(context)
        val out = HashSet<String>()
        for (i in 0 until list.length()) {
            val e = list.optJSONObject(i) ?: continue
            if (e.optString("kind") == kind) out.add(e.optString("id"))
        }
        return out
    }

    /** Abhaken bzw. Haken zurücknehmen. */
    @Synchronized
    fun toggle(context: Context, kind: String, id: String, now: Long) {
        val list = pending(context)
        val out = JSONArray()
        var removed = false
        for (i in 0 until list.length()) {
            val e = list.optJSONObject(i) ?: continue
            if (e.optString("kind") == kind && e.optString("id") == id) {
                removed = true
            } else {
                out.put(e)
            }
        }
        if (!removed) {
            out.put(JSONObject().put("kind", kind).put("id", id).put("at", now))
        }
        prefs(context).edit().putString(KEY_PENDING, out.toString()).apply()
    }

    /**
     * Entfernt die von der App übernommenen Einträge. Später Abgehaktes
     * (zwischen Lesen und Bestätigen) bleibt erhalten.
     */
    @Synchronized
    fun clearPending(context: Context, takenJson: String) {
        val taken = try {
            JSONArray(takenJson)
        } catch (_: Exception) {
            return
        }
        val keys = HashSet<String>()
        for (i in 0 until taken.length()) {
            val e = taken.optJSONObject(i) ?: continue
            keys.add(key(e))
        }
        val list = pending(context)
        val out = JSONArray()
        for (i in 0 until list.length()) {
            val e = list.optJSONObject(i) ?: continue
            if (key(e) !in keys) out.put(e)
        }
        prefs(context).edit().putString(KEY_PENDING, out.toString()).apply()
    }

    private fun key(e: JSONObject) =
        e.optString("kind") + "|" + e.optString("id") + "|" + e.optLong("at")
}
