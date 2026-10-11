package space.mai.mai_household.widgets

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService

/**
 * Listeninhalt bis Android 11. Ab Android 12 übergibt das Widget die Zeilen
 * direkt (`RemoteCollectionItems`) und braucht diesen Dienst nicht.
 */
class WidgetListService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        val kind = WidgetKind.entries.firstOrNull {
            it.name == intent.getStringExtra(HouseholdWidgets.EXTRA_KIND)
        } ?: WidgetKind.SHOPPING
        return Factory(applicationContext, kind, intent.getBooleanExtra(HouseholdWidgets.EXTRA_WIDE, false))
    }

    private class Factory(
        private val context: Context,
        private val kind: WidgetKind,
        private val wide: Boolean,
    ) : RemoteViewsFactory {
        private var rows: List<WidgetRow> = emptyList()

        override fun onCreate() {}

        override fun onDataSetChanged() {
            rows = WidgetContent.build(context, kind).rows
        }

        override fun onDestroy() {
            rows = emptyList()
        }

        override fun getCount(): Int = rows.size

        override fun getViewAt(position: Int): RemoteViews {
            // Liste kann sich zwischen getCount() und hier geändert haben.
            val row = rows.getOrNull(position)
                ?: return RemoteViews(context.packageName, android.R.layout.simple_list_item_1)
            return HouseholdWidgets.row(context, kind, row, wide)
        }

        override fun getLoadingView(): RemoteViews? = null

        override fun getViewTypeCount(): Int = 3

        override fun getItemId(position: Int): Long = rows.getOrNull(position)?.stableId ?: position.toLong()

        override fun hasStableIds(): Boolean = true
    }
}
