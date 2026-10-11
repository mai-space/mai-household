package space.mai.mai_household.widgets

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Paint
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.SizeF
import android.view.View
import android.widget.RemoteViews
import space.mai.mai_household.MainActivity
import space.mai.mai_household.R
import space.mai.mai_household.wear.WearBridge
import java.time.LocalDate
import java.time.ZoneId

/** Aufgaben heute. */
class ChoresWidgetProvider : HouseholdWidgetProvider(WidgetKind.CHORES)

/** Einkaufsliste. */
class ShoppingWidgetProvider : HouseholdWidgetProvider(WidgetKind.SHOPPING)

/** Essensplan. */
class MealsWidgetProvider : HouseholdWidgetProvider(WidgetKind.MEALS)

/**
 * Gemeinsame Logik der Widgets. Größe frei wählbar; ab Android 12 liefert
 * das Widget mehrere Layouts, der Launcher wählt beim Skalieren selbst das
 * passende (ohne Flackern). Darunter wird bei jeder Größenänderung neu
 * gezeichnet.
 */
abstract class HouseholdWidgetProvider(private val kind: WidgetKind) : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) HouseholdWidgets.draw(context, manager, kind, id)
        HouseholdWidgets.scheduleMidnight(context)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        manager: AppWidgetManager,
        id: Int,
        newOptions: Bundle,
    ) {
        HouseholdWidgets.draw(context, manager, kind, id)
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            HouseholdWidgets.ACTION_TOGGLE -> {
                val kindName = intent.getStringExtra(HouseholdWidgets.EXTRA_KIND)
                val id = intent.getStringExtra(HouseholdWidgets.EXTRA_ID)
                val target = WidgetKind.entries.firstOrNull { it.name == kindName }
                if (target != null && id != null && target != WidgetKind.MEALS) {
                    val store = if (target == WidgetKind.CHORES) WidgetStore.KIND_CHORE else WidgetStore.KIND_SHOP
                    WidgetStore.toggle(context, store, id, System.currentTimeMillis())
                    HouseholdWidgets.refresh(context, target)
                    // Auch auf der Uhr als abgehakt zeigen.
                    val result = goAsync()
                    WearBridge.publish(context) { result.finish() }
                }
            }
            HouseholdWidgets.ACTION_REFRESH -> HouseholdWidgets.refreshAll(context)
            else -> super.onReceive(context, intent)
        }
    }
}

object HouseholdWidgets {
    const val ACTION_TOGGLE = "space.mai.mai_household.widget.TOGGLE"
    const val ACTION_REFRESH = "space.mai.mai_household.widget.REFRESH"
    const val EXTRA_KIND = "kind"
    const val EXTRA_ID = "id"

    const val EXTRA_WIDGET_ID = "widgetId"
    const val EXTRA_WIDE = "wide"

    /** Größenstufen (dp). Gewählt wird die größte, die passt. */
    private enum class Size(val width: Float, val height: Float) {
        /** Eine Zeile hoch oder eine Spalte breit: nur das Wichtigste. */
        TINY(40f, 40f),

        /** Breite Zeile: dazu Häkchen bzw. Schnellaktionen. */
        STRIP(180f, 40f),

        /** Ab etwa 2×2: Liste. */
        LIST(110f, 100f),

        /** Breite Liste: zusätzliche Angaben rechts (Abteilung, Dauer). */
        LIST_WIDE(250f, 100f),
    }

    private fun providerOf(kind: WidgetKind): Class<out HouseholdWidgetProvider> = when (kind) {
        WidgetKind.CHORES -> ChoresWidgetProvider::class.java
        WidgetKind.SHOPPING -> ShoppingWidgetProvider::class.java
        WidgetKind.MEALS -> MealsWidgetProvider::class.java
    }

    /** Neuer Stand aus der App oder Datumswechsel: alles neu zeichnen. */
    fun refreshAll(context: Context) {
        for (kind in WidgetKind.entries) refresh(context, kind)
        scheduleMidnight(context)
    }

    fun refresh(context: Context, kind: WidgetKind) {
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(ComponentName(context, providerOf(kind)))
        for (id in ids) draw(context, manager, kind, id)
    }

    fun draw(context: Context, manager: AppWidgetManager, kind: WidgetKind, id: Int) {
        val model = WidgetContent.build(context, kind)
        val views = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            RemoteViews(Size.entries.associate { size -> SizeF(size.width, size.height) to views(context, kind, model, id, size) })
        } else {
            val options = manager.getAppWidgetOptions(id)
            // Hochformat: kleinste Breite, größte Höhe.
            val w = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH).toFloat()
            val h = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT).toFloat()
            views(context, kind, model, id, pick(w, h))
        }
        manager.updateAppWidget(id, views)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            @Suppress("DEPRECATION")
            manager.notifyAppWidgetViewDataChanged(id, R.id.widget_list)
        }
    }

    /** Wie das System ab Android 12: größte Stufe, die passt, sonst die kleinste. */
    private fun pick(width: Float, height: Float): Size {
        if (width <= 0f || height <= 0f) return Size.LIST
        return Size.entries
            .filter { it.width <= width && it.height <= height }
            .maxByOrNull { it.width * it.height }
            ?: Size.TINY
    }

    private fun views(context: Context, kind: WidgetKind, model: WidgetModel, id: Int, size: Size): RemoteViews =
        when (size) {
            Size.TINY -> strip(context, kind, model, compact = true)
            Size.STRIP -> strip(context, kind, model, compact = false)
            Size.LIST -> list(context, kind, model, id, wide = false)
            Size.LIST_WIDE -> list(context, kind, model, id, wide = true)
        }

    private fun strip(context: Context, kind: WidgetKind, model: WidgetModel, compact: Boolean): RemoteViews {
        val v = RemoteViews(context.packageName, R.layout.widget_strip)
        v.setImageViewResource(R.id.widget_icon, kind.icon)
        val count = model.count?.let { " · $it" } ?: ""
        v.setTextViewText(R.id.widget_title, model.stripTitle + count)
        v.setTextViewText(R.id.widget_line, model.line)
        v.setOnClickPendingIntent(android.R.id.background, open(context, model.stripLink))
        v.setOnClickPendingIntent(R.id.widget_header, open(context, model.stripLink))
        if (!compact) {
            val first = model.firstOpen
            if (kind == WidgetKind.CHORES && first?.toggleId != null) {
                v.setViewVisibility(R.id.widget_check, View.VISIBLE)
                v.setOnClickPendingIntent(R.id.widget_check, toggle(context, kind, first.toggleId))
            }
            if (kind == WidgetKind.SHOPPING) actions(context, v)
        }
        return v
    }

    private fun list(context: Context, kind: WidgetKind, model: WidgetModel, id: Int, wide: Boolean): RemoteViews {
        val v = RemoteViews(context.packageName, R.layout.widget_list)
        v.setImageViewResource(R.id.widget_icon, kind.icon)
        v.setTextViewText(R.id.widget_title, model.title)
        v.setTextViewText(R.id.widget_count, model.count?.toString() ?: "")
        v.setViewVisibility(R.id.widget_count, if (model.count == null) View.GONE else View.VISIBLE)
        v.setOnClickPendingIntent(R.id.widget_header, open(context, kind.openLink))
        if (model.banner != null) {
            v.setViewVisibility(R.id.widget_banner, View.VISIBLE)
            v.setTextViewText(R.id.widget_banner, model.banner)
        }
        if (kind == WidgetKind.SHOPPING) actions(context, v)

        v.setTextViewText(R.id.widget_empty, model.empty)
        v.setEmptyView(R.id.widget_list, R.id.widget_empty)
        v.setOnClickPendingIntent(R.id.widget_empty, open(context, kind.openLink))
        v.setPendingIntentTemplate(R.id.widget_list, template(context, kind, id))

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val items = RemoteViews.RemoteCollectionItems.Builder()
                .setHasStableIds(true)
                .setViewTypeCount(2)
            for (row in model.rows) items.addItem(row.stableId, row(context, kind, row, wide))
            v.setRemoteAdapter(R.id.widget_list, items.build())
        } else {
            val intent = Intent(context, WidgetListService::class.java)
                .putExtra(EXTRA_WIDGET_ID, id)
                .putExtra(EXTRA_KIND, kind.name)
                .putExtra(EXTRA_WIDE, wide)
            // Eindeutig je Widget und Größe, sonst teilt Android die Liste.
            intent.data = Uri.parse("${WidgetLinks.SCHEME}://list/${kind.name}/$id/$wide")
            @Suppress("DEPRECATION")
            v.setRemoteAdapter(R.id.widget_list, intent)
        }
        return v
    }

    /** „+“ und Mikrofon im Einkaufs-Widget. */
    private fun actions(context: Context, v: RemoteViews) {
        v.setViewVisibility(R.id.widget_action_1, View.VISIBLE)
        v.setImageViewResource(R.id.widget_action_1, R.drawable.ic_widget_add)
        v.setContentDescription(R.id.widget_action_1, context.getString(R.string.widget_add))
        v.setOnClickPendingIntent(R.id.widget_action_1, open(context, WidgetLinks.SHOPPING_ADD))
        v.setViewVisibility(R.id.widget_action_2, View.VISIBLE)
        v.setImageViewResource(R.id.widget_action_2, R.drawable.ic_widget_mic)
        v.setContentDescription(R.id.widget_action_2, context.getString(R.string.widget_voice))
        v.setOnClickPendingIntent(R.id.widget_action_2, open(context, WidgetLinks.SHOPPING_VOICE))
    }

    /** Eine Listenzeile (auch für den Listen-Dienst bis Android 11). */
    fun row(context: Context, kind: WidgetKind, row: WidgetRow, wide: Boolean): RemoteViews {
        if (kind == WidgetKind.MEALS) {
            val v = RemoteViews(context.packageName, R.layout.widget_row_meal)
            v.setTextViewText(R.id.row_meta, row.meta ?: "")
            v.setTextViewText(R.id.row_title, row.title)
            v.setViewVisibility(R.id.row_check, if (row.showChevron) View.VISIBLE else View.GONE)
            v.setOnClickFillInIntent(R.id.row_root, row.fillIn(kind))
            return v
        }
        val v = RemoteViews(context.packageName, R.layout.widget_row_check)
        v.setTextViewText(R.id.row_title, row.title)
        // Abgehakt: durchgestrichen, bis die App es übernommen hat.
        val flags = Paint.ANTI_ALIAS_FLAG or if (row.checked) Paint.STRIKE_THRU_TEXT_FLAG else 0
        v.setInt(R.id.row_title, "setPaintFlags", flags)
        v.setImageViewResource(
            R.id.row_check,
            if (row.checked) R.drawable.ic_widget_check_on else R.drawable.ic_widget_check_off,
        )
        v.setContentDescription(R.id.row_root, row.title)
        if (row.subtitle != null) {
            v.setViewVisibility(R.id.row_subtitle, View.VISIBLE)
            v.setTextViewText(R.id.row_subtitle, row.subtitle)
        } else {
            v.setViewVisibility(R.id.row_subtitle, View.GONE)
        }
        val meta = if (wide) row.meta else null
        v.setViewVisibility(R.id.row_meta, if (meta == null) View.GONE else View.VISIBLE)
        v.setTextViewText(R.id.row_meta, meta ?: "")
        v.setOnClickFillInIntent(R.id.row_root, row.fillIn(kind))
        return v
    }

    private val mutable =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0

    /** Öffnet die App an der passenden Stelle. */
    private fun open(context: Context, link: String): PendingIntent {
        val intent = Intent(context, MainActivity::class.java)
            .setAction(Intent.ACTION_VIEW)
            .setData(Uri.parse(link))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        return PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun toggle(context: Context, kind: WidgetKind, id: String): PendingIntent {
        val intent = Intent(context, providerOf(kind))
            .setAction(ACTION_TOGGLE)
            .setData(Uri.parse("${WidgetLinks.SCHEME}://toggle/${kind.name}/" + Uri.encode(id)))
            .putExtra(EXTRA_KIND, kind.name)
            .putExtra(EXTRA_ID, id)
        return PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    /** Vorlage für Tipps in der Liste: abhaken bzw. Rezept öffnen. */
    private fun template(context: Context, kind: WidgetKind, id: Int): PendingIntent {
        if (kind == WidgetKind.MEALS) {
            val intent = Intent(context, MainActivity::class.java)
                .setAction(Intent.ACTION_VIEW)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            return PendingIntent.getActivity(
                context,
                id,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or mutable,
            )
        }
        val intent = Intent(context, providerOf(kind)).setAction(ACTION_TOGGLE)
        return PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or mutable,
        )
    }

    /**
     * Kurz nach Mitternacht neu zeichnen („heute“ wechselt). Ungenauer
     * Wecker: braucht keine Berechtigung und weckt das Gerät nicht.
     */
    fun scheduleMidnight(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val any = WidgetKind.entries.any {
            manager.getAppWidgetIds(ComponentName(context, providerOf(it))).isNotEmpty()
        }
        val alarms = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ChoresWidgetProvider::class.java).setAction(ACTION_REFRESH)
        val pending = PendingIntent.getBroadcast(
            context,
            1,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        if (!any) {
            alarms.cancel(pending)
            return
        }
        val next = LocalDate.now().plusDays(1)
            .atStartOfDay(ZoneId.systemDefault())
            .toInstant()
            .toEpochMilli() + 60_000L
        alarms.set(AlarmManager.RTC, next, pending)
    }
}
