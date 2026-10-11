package space.mai.mai_household.wear

import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate

/** Die drei Ansichten der Uhr — wie die Homescreen-Widgets. */
enum class Section(
    /** Art in der Warteliste (`chore`/`shop`); Essen ist nicht abhakbar. */
    val kind: String?,
) {
    CHORES(KIND_CHORE),
    SHOPPING(KIND_SHOP),
    MEALS(null),
    ;

    companion object {
        fun of(name: String?): Section = entries.firstOrNull { it.name == name } ?: CHORES
    }
}

const val KIND_CHORE = "chore"
const val KIND_SHOP = "shop"

/** Eine Zeile. Bei Essen ist [subtitle] der Tag. */
data class Row(
    val id: String,
    val title: String,
    val subtitle: String?,
    val checked: Boolean,
)

/** Was eine Ansicht gerade zeigt (Kachel, Komplikation, Liste). */
data class SectionModel(
    val section: Section,
    val title: String,
    val rows: List<Row>,
    /** Offene Einträge insgesamt (Einkauf: auch über die Liste hinaus). */
    val open: Int,
    val empty: String,
    /** Müllabfuhr heute/morgen (nur Aufgaben). */
    val banner: String?,
    /** Kurzform (Komplikation „lang“). */
    val line: String,
)

/**
 * Baut aus dem Widget-Stand des Telefons (`lib/home_widgets/widget_snapshot.dart`)
 * den Inhalt — dieselben Regeln wie `WidgetContent` der Homescreen-Widgets.
 * „Heute“ bestimmt die Uhr selbst, damit nach Mitternacht das Richtige
 * erscheint, auch ohne neuen Stand.
 */
object WatchContent {
    fun build(
        snapshot: JSONObject,
        section: Section,
        today: LocalDate,
        checked: (kind: String, id: String) -> Boolean,
    ): SectionModel {
        val labels = snapshot.optJSONObject("labels") ?: JSONObject()
        return when (section) {
            Section.CHORES -> chores(snapshot, labels, today, checked)
            Section.SHOPPING -> shopping(snapshot, labels, checked)
            Section.MEALS -> meals(snapshot, labels, today)
        }
    }

    /** Alle abhakbaren Einträge des Stands als `kind|id`. */
    fun keys(snapshot: JSONObject): Set<String> {
        val out = HashSet<String>()
        for (c in objects(snapshot.optJSONArray("chores"))) out.add(key(KIND_CHORE, c.optString("id")))
        for (i in objects(snapshot.optJSONArray("shopping"))) out.add(key(KIND_SHOP, i.optString("id")))
        return out
    }

    fun key(kind: String, id: String) = "$kind|$id"

    private fun chores(
        snapshot: JSONObject,
        labels: JSONObject,
        today: LocalDate,
        checked: (String, String) -> Boolean,
    ): SectionModel {
        val todayKey = today.toString()
        val rows = ArrayList<Row>()
        for (c in objects(snapshot.optJSONArray("chores"))) {
            val id = c.optString("id")
            val due = c.optString("due")
            if (id.isEmpty() || due > todayKey) continue
            val subtitle = listOfNotNull(
                if (due < todayKey) labels.optString("overdue") else null,
                c.text("area"),
                if (c.optBoolean("mine")) null else c.text("assignee"),
            ).filter { it.isNotEmpty() }.joinToString(" · ")
            rows.add(Row(id, c.optString("name"), subtitle.ifEmpty { null }, checked(KIND_CHORE, id)))
        }
        val banner = waste(snapshot, labels, today)
        val first = rows.firstOrNull { !it.checked }
        return SectionModel(
            section = Section.CHORES,
            title = labels.optString("chores"),
            rows = rows,
            open = rows.count { !it.checked },
            empty = labels.optString("choresEmpty"),
            banner = banner,
            line = first?.title ?: banner ?: labels.optString("choresEmpty"),
        )
    }

    /** „Heute wird abgeholt: Papier“ bzw. für morgen. */
    private fun waste(snapshot: JSONObject, labels: JSONObject, today: LocalDate): String? {
        val all = objects(snapshot.optJSONArray("waste"))
        fun on(day: LocalDate) = all.filter { it.optString("day") == day.toString() }
            .map { it.optString("name") }
            .distinct()
        val now = on(today)
        if (now.isNotEmpty()) return labels.optString("wasteToday") + ": " + now.joinToString(", ")
        val next = on(today.plusDays(1))
        if (next.isNotEmpty()) return labels.optString("wasteTomorrow") + ": " + next.joinToString(", ")
        return null
    }

    private fun shopping(
        snapshot: JSONObject,
        labels: JSONObject,
        checked: (String, String) -> Boolean,
    ): SectionModel {
        val rows = ArrayList<Row>()
        for (i in objects(snapshot.optJSONArray("shopping"))) {
            val id = i.optString("id")
            if (id.isEmpty()) continue
            val subtitle = listOfNotNull(
                if (i.optBoolean("notFound")) labels.optString("notFound") else null,
                i.text("detail"),
            ).filter { it.isNotEmpty() }.joinToString(" · ")
            rows.add(Row(id, i.optString("name"), subtitle.ifEmpty { null }, checked(KIND_SHOP, id)))
        }
        val total = snapshot.optInt("shoppingCount", rows.size)
        val open = (total - rows.count { it.checked }).coerceAtLeast(0)
        val names = rows.filter { !it.checked }.take(5).joinToString(", ") { it.title }
        return SectionModel(
            section = Section.SHOPPING,
            title = labels.optString("shopping"),
            rows = rows,
            open = open,
            empty = labels.optString("shoppingEmpty"),
            banner = null,
            line = names.ifEmpty { labels.optString("shoppingEmpty") },
        )
    }

    private fun meals(snapshot: JSONObject, labels: JSONObject, today: LocalDate): SectionModel {
        val todayKey = today.toString()
        val tomorrowKey = today.plusDays(1).toString()
        val weekdays = labels.optJSONArray("weekdays")
        val rows = ArrayList<Row>()
        val todayMeals = ArrayList<String>()
        val tomorrowMeals = ArrayList<String>()
        for (m in objects(snapshot.optJSONArray("meals"))) {
            val day = m.optString("day")
            if (day < todayKey) continue
            val title = m.optString("title")
            val dayLabel = when (day) {
                todayKey -> labels.optString("today")
                tomorrowKey -> labels.optString("tomorrow")
                else -> weekdayOf(day, weekdays) ?: day
            }
            if (day == todayKey) todayMeals.add(title)
            if (day == tomorrowKey) tomorrowMeals.add(title)
            rows.add(Row("$day:${rows.size}", title, dayLabel, checked = false))
        }
        val line = when {
            todayMeals.isNotEmpty() -> todayMeals.joinToString(" · ")
            tomorrowMeals.isNotEmpty() ->
                labels.optString("tomorrow") + ": " + tomorrowMeals.joinToString(" · ")
            else -> labels.optString("mealsEmpty")
        }
        return SectionModel(
            section = Section.MEALS,
            title = labels.optString("meals"),
            rows = rows,
            open = todayMeals.size,
            empty = labels.optString("mealsEmpty"),
            banner = null,
            line = line,
        )
    }

    /** Wochentag (Mo = 0) in der App-Sprache. */
    private fun weekdayOf(day: String, weekdays: JSONArray?): String? {
        if (weekdays == null || weekdays.length() < 7) return null
        return try {
            weekdays.optString(LocalDate.parse(day).dayOfWeek.value - 1)
        } catch (_: Exception) {
            null
        }
    }

    private fun objects(array: JSONArray?): List<JSONObject> {
        if (array == null) return emptyList()
        val out = ArrayList<JSONObject>(array.length())
        for (i in 0 until array.length()) array.optJSONObject(i)?.let { out.add(it) }
        return out
    }

    /** Text oder `null` (JSON-null, fehlend, leer). */
    private fun JSONObject.text(key: String): String? =
        if (isNull(key)) null else optString(key).takeIf { it.isNotEmpty() }
}

/** Auf der Uhr gesetzte Markierung (abgehakt bzw. zurückgenommen). */
data class WatchAction(val kind: String, val id: String, val checked: Boolean, val at: Long) {
    val key: String get() = WatchContent.key(kind, id)
}

/**
 * Ausgang der Uhr: Markierungen, die das Telefon noch nicht bestätigt hat.
 * Liegt als Datenobjekt `/household/watch` in der Datenschicht, die es
 * zustellt, sobald das Telefon erreichbar ist. Je Zeile zählt nur der
 * letzte Stand.
 */
object Outbox {
    /** Einträge, die das Telefon nie bestätigt, verfallen nach einem Tag. */
    const val MAX_AGE_MS = 24L * 60 * 60 * 1000

    fun parse(json: String?): List<WatchAction> {
        if (json.isNullOrEmpty()) return emptyList()
        val array = try {
            JSONArray(json)
        } catch (_: Exception) {
            return emptyList()
        }
        val out = ArrayList<WatchAction>()
        for (i in 0 until array.length()) {
            val e = array.optJSONObject(i) ?: continue
            val kind = e.optString("kind")
            val id = e.optString("id")
            val at = e.optLong("at")
            if (kind.isEmpty() || id.isEmpty() || at <= 0) continue
            out.add(WatchAction(kind, id, e.optBoolean("checked"), at))
        }
        return out
    }

    fun encode(list: List<WatchAction>): String {
        val array = JSONArray()
        for (a in list) {
            array.put(
                JSONObject()
                    .put("kind", a.kind)
                    .put("id", a.id)
                    .put("checked", a.checked)
                    .put("at", a.at),
            )
        }
        return array.toString()
    }

    /** Neuer Wunsch für eine Zeile; ersetzt einen älteren. */
    fun put(list: List<WatchAction>, action: WatchAction): List<WatchAction> =
        list.filter { it.key != action.key } + action

    /**
     * Entfernt, was das Telefon bestätigt hat ([acks]: `kind|id` → letzter
     * übernommener Zeitstempel), was es im Stand nicht mehr gibt
     * ([present], z. B. in der App erledigt) und Verfallenes.
     */
    fun prune(
        list: List<WatchAction>,
        acks: Map<String, Long>,
        present: Set<String>?,
        now: Long,
    ): List<WatchAction> = list.filter { a ->
        val acked = (acks[a.key] ?: 0L) >= a.at
        val gone = present != null && a.key !in present
        !acked && !gone && now - a.at < MAX_AGE_MS
    }

    fun parseAcks(json: String?): Map<String, Long> {
        if (json.isNullOrEmpty()) return emptyMap()
        val obj = try {
            JSONObject(json)
        } catch (_: Exception) {
            return emptyMap()
        }
        val out = HashMap<String, Long>()
        for (k in obj.keys()) out[k] = obj.optLong(k)
        return out
    }
}
