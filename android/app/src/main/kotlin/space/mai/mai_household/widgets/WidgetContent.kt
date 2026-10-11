package space.mai.mai_household.widgets

import android.content.Context
import android.content.Intent
import android.net.Uri
import org.json.JSONArray
import org.json.JSONObject
import space.mai.mai_household.R
import java.time.LocalDate

/** Die drei Homescreen-Widgets. */
enum class WidgetKind(val icon: Int, val label: Int, val openLink: String) {
    CHORES(R.drawable.ic_widget_chores, R.string.widget_chores_label, WidgetLinks.CHORES),
    SHOPPING(R.drawable.ic_widget_shopping, R.string.widget_shopping_label, WidgetLinks.SHOPPING),
    MEALS(R.drawable.ic_widget_meals, R.string.widget_meals_label, WidgetLinks.KITCHEN),
}

/** Ziele in der App (ausgewertet in `lib/home_widgets/home_widgets.dart`). */
object WidgetLinks {
    const val SCHEME = "maihh-widget"
    const val CHORES = "$SCHEME://open/chores"
    const val SHOPPING = "$SCHEME://open/shopping"
    const val SHOPPING_ADD = "$SCHEME://open/shopping/add"
    const val SHOPPING_VOICE = "$SCHEME://open/shopping/voice"
    const val KITCHEN = "$SCHEME://open/kitchen"

    fun recipe(id: String, servings: Int?): String {
        val base = "$SCHEME://open/recipe/" + Uri.encode(id)
        return if (servings == null) base else "$base?servings=$servings"
    }
}

/** Eine Listenzeile. [toggleId] gesetzt = abhakbar, sonst [link] öffnen. */
data class WidgetRow(
    val key: String,
    val title: String,
    val subtitle: String?,
    val meta: String?,
    val checked: Boolean,
    val toggleId: String?,
    val link: String?,
    val showChevron: Boolean = false,
) {
    val stableId: Long get() = key.hashCode().toLong()

    fun fillIn(kind: WidgetKind): Intent = Intent().apply {
        if (toggleId != null) {
            putExtra(HouseholdWidgets.EXTRA_KIND, kind.name)
            putExtra(HouseholdWidgets.EXTRA_ID, toggleId)
        } else if (link != null) {
            data = Uri.parse(link)
        }
    }
}

/** Was ein Widget gerade zeigt — unabhängig von der Größe. */
data class WidgetModel(
    val title: String,
    val count: Int?,
    val banner: String?,
    val rows: List<WidgetRow>,
    val empty: String,
    /** Kurzform für die kleine Größe. */
    val line: String,
    /** Erste offene Zeile (Häkchen in der kleinen Größe). */
    val firstOpen: WidgetRow?,
    /** Ziel beim Tippen auf die kleine Größe. */
    val stripLink: String,
    /** Überschrift der kleinen Größe. */
    val stripTitle: String = title,
)

/**
 * Baut aus dem App-Stand den Inhalt. „Heute“ bestimmt das Gerät beim
 * Zeichnen, damit nach Mitternacht das Richtige erscheint, auch wenn die App
 * nicht lief.
 */
object WidgetContent {
    fun build(context: Context, kind: WidgetKind, today: LocalDate = LocalDate.now()): WidgetModel {
        val snapshot = WidgetStore.snapshot(context)
            ?: return setup(context, kind)
        val labels = snapshot.optJSONObject("labels") ?: JSONObject()
        return when (kind) {
            WidgetKind.CHORES -> chores(context, snapshot, labels, today)
            WidgetKind.SHOPPING -> shopping(context, snapshot, labels)
            WidgetKind.MEALS -> meals(snapshot, labels, today)
        }
    }

    private fun setup(context: Context, kind: WidgetKind): WidgetModel {
        val text = context.getString(R.string.widget_setup)
        return WidgetModel(
            title = context.getString(kind.label),
            count = null,
            banner = null,
            rows = emptyList(),
            empty = text,
            line = text,
            firstOpen = null,
            stripLink = kind.openLink,
        )
    }

    private fun chores(
        context: Context,
        snapshot: JSONObject,
        labels: JSONObject,
        today: LocalDate,
    ): WidgetModel {
        val todayKey = today.toString()
        val checked = WidgetStore.pendingIds(context, WidgetStore.KIND_CHORE)
        val rows = ArrayList<WidgetRow>()
        for (c in objects(snapshot.optJSONArray("chores"))) {
            val id = c.optString("id")
            val due = c.optString("due")
            if (id.isEmpty() || due > todayKey) continue
            val overdue = due < todayKey
            val subtitle = listOfNotNull(
                if (overdue) labels.optString("overdue") else null,
                c.text("area"),
                if (c.optBoolean("mine")) null else c.text("assignee"),
            ).filter { it.isNotEmpty() }.joinToString(" · ")
            rows.add(
                WidgetRow(
                    key = "chore:$id",
                    title = c.optString("name"),
                    subtitle = subtitle.ifEmpty { null },
                    meta = c.optInt("minutes").takeIf { it > 0 }?.let { "$it min" },
                    checked = id in checked,
                    toggleId = id,
                    link = null,
                ),
            )
        }
        val banner = waste(snapshot, labels, today)
        val open = rows.count { !it.checked }
        val firstOpen = rows.firstOrNull { !it.checked }
        val title = labels.optString("chores")
        return WidgetModel(
            title = title,
            count = open.takeIf { it > 0 },
            banner = banner,
            rows = rows,
            empty = labels.optString("choresEmpty"),
            line = firstOpen?.title ?: banner ?: labels.optString("choresEmpty"),
            firstOpen = firstOpen,
            stripLink = WidgetLinks.CHORES,
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

    private fun shopping(context: Context, snapshot: JSONObject, labels: JSONObject): WidgetModel {
        val checked = WidgetStore.pendingIds(context, WidgetStore.KIND_SHOP)
        val rows = ArrayList<WidgetRow>()
        for (i in objects(snapshot.optJSONArray("shopping"))) {
            val id = i.optString("id")
            if (id.isEmpty()) continue
            val subtitle = listOfNotNull(
                if (i.optBoolean("notFound")) labels.optString("notFound") else null,
                i.text("detail"),
            ).filter { it.isNotEmpty() }.joinToString(" · ")
            rows.add(
                WidgetRow(
                    key = "shop:$id",
                    title = i.optString("name"),
                    subtitle = subtitle.ifEmpty { null },
                    meta = i.text("department"),
                    checked = id in checked,
                    toggleId = id,
                    link = null,
                ),
            )
        }
        val total = snapshot.optInt("shoppingCount", rows.size)
        val open = (total - rows.count { it.checked }).coerceAtLeast(0)
        val names = rows.filter { !it.checked }.take(5).joinToString(", ") { it.title }
        return WidgetModel(
            title = labels.optString("shopping"),
            count = open.takeIf { it > 0 },
            banner = null,
            rows = rows,
            empty = labels.optString("shoppingEmpty"),
            line = names.ifEmpty { labels.optString("shoppingEmpty") },
            firstOpen = rows.firstOrNull { !it.checked },
            stripLink = WidgetLinks.SHOPPING,
        )
    }

    private fun meals(snapshot: JSONObject, labels: JSONObject, today: LocalDate): WidgetModel {
        val todayKey = today.toString()
        val tomorrowKey = today.plusDays(1).toString()
        val weekdays = labels.optJSONArray("weekdays")
        val rows = ArrayList<WidgetRow>()
        val todayMeals = ArrayList<JSONObject>()
        val tomorrowMeals = ArrayList<JSONObject>()
        for (m in objects(snapshot.optJSONArray("meals"))) {
            val day = m.optString("day")
            if (day < todayKey) continue
            val dayLabel = when (day) {
                todayKey -> labels.optString("today")
                tomorrowKey -> labels.optString("tomorrow")
                else -> weekdayOf(day, weekdays) ?: day
            }
            if (day == todayKey) todayMeals.add(m)
            if (day == tomorrowKey) tomorrowMeals.add(m)
            val recipeId = m.text("recipeId")
            rows.add(
                WidgetRow(
                    key = "meal:$day:" + m.optString("title") + ":" + rows.size,
                    title = m.optString("title"),
                    subtitle = null,
                    meta = dayLabel,
                    checked = false,
                    toggleId = null,
                    link = mealLink(m),
                    showChevron = recipeId != null,
                ),
            )
        }
        val line = when {
            todayMeals.isNotEmpty() -> todayMeals.joinToString(" · ") { it.optString("title") }
            tomorrowMeals.isNotEmpty() ->
                labels.optString("tomorrow") + ": " +
                    tomorrowMeals.joinToString(" · ") { it.optString("title") }
            else -> labels.optString("mealsEmpty")
        }
        val stripTitle = if (todayMeals.isNotEmpty()) labels.optString("today") else labels.optString("meals")
        return WidgetModel(
            title = labels.optString("meals"),
            count = null,
            banner = null,
            rows = rows,
            empty = labels.optString("mealsEmpty"),
            line = line,
            firstOpen = null,
            stripLink = (todayMeals.firstOrNull() ?: tomorrowMeals.firstOrNull())
                ?.let { mealLink(it) } ?: WidgetLinks.KITCHEN,
            stripTitle = stripTitle,
        )
    }

    private fun mealLink(m: JSONObject): String {
        val recipeId = m.text("recipeId") ?: return WidgetLinks.KITCHEN
        val servings = if (m.isNull("servings")) null else m.optInt("servings")
        return WidgetLinks.recipe(recipeId, servings)
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
