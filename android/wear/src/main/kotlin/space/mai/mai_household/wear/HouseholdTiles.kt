package space.mai.mai_household.wear

import android.content.Context
import androidx.concurrent.futures.ResolvableFuture
import androidx.wear.protolayout.ActionBuilders
import androidx.wear.protolayout.ColorBuilders.argb
import androidx.wear.protolayout.DeviceParametersBuilders
import androidx.wear.protolayout.DimensionBuilders.dp
import androidx.wear.protolayout.DimensionBuilders.expand
import androidx.wear.protolayout.DimensionBuilders.sp
import androidx.wear.protolayout.DimensionBuilders.wrap
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ModifiersBuilders
import androidx.wear.protolayout.ResourceBuilders
import androidx.wear.protolayout.TimelineBuilders
import androidx.wear.tiles.RequestBuilders
import androidx.wear.tiles.TileBuilders
import androidx.wear.tiles.TileService
import com.google.common.util.concurrent.ListenableFuture
import java.time.LocalDate
import java.time.ZoneId

/** Aufgaben heute. */
class ChoresTileService : HouseholdTileService(Section.CHORES)

/** Einkaufsliste. */
class ShoppingTileService : HouseholdTileService(Section.SHOPPING)

/** Essensplan. */
class MealsTileService : HouseholdTileService(Section.MEALS)

/**
 * Kachel: Überschrift mit Anzahl, darunter die ersten Einträge. Tippen auf
 * eine Zeile hakt ab (bzw. nimmt den Haken zurück), Tippen auf die
 * Überschrift öffnet die ganze Liste auf der Uhr.
 */
abstract class HouseholdTileService(private val section: Section) : TileService() {
    override fun onTileRequest(
        requestParams: RequestBuilders.TileRequest,
    ): ListenableFuture<TileBuilders.Tile> {
        handleClick(requestParams.currentState.lastClickableId)
        val model = WatchStore.model(this, section)
        if (model == null) PhoneLink.refresh(this)
        val layout = TileLayout.build(
            this,
            section,
            model,
            requestParams.deviceConfiguration,
            nonce = java.lang.Long.toString(System.currentTimeMillis(), 36),
        )
        val tile = TileBuilders.Tile.Builder()
            .setResourcesVersion(RESOURCES_VERSION)
            // Spätestens kurz nach Mitternacht neu („heute“ wechselt).
            .setFreshnessIntervalMillis(untilMidnight())
            .setTileTimeline(TimelineBuilders.Timeline.fromLayoutElement(layout))
            .build()
        return done(tile)
    }

    override fun onTileResourcesRequest(
        requestParams: RequestBuilders.ResourcesRequest,
    ): ListenableFuture<ResourceBuilders.Resources> {
        val resources = ResourceBuilders.Resources.Builder()
            .setVersion(RESOURCES_VERSION)
            .addIdToImageMapping(TileLayout.IMG_CHECK_ON, image(R.drawable.ic_check_on))
            .addIdToImageMapping(TileLayout.IMG_CHECK_OFF, image(R.drawable.ic_check_off))
            .build()
        return done(resources)
    }

    /** Tipp auf eine Zeile: `t|<art>|<id>|<nonce>`. */
    private fun handleClick(clickId: String) {
        if (!clickId.startsWith(TileLayout.CLICK_TOGGLE)) return
        val parts = clickId.split('|')
        if (parts.size < 4) return
        if (!WatchStore.takeClick(this, clickId)) return
        val kind = parts[1]
        val id = parts.subList(2, parts.size - 1).joinToString("|")
        if (kind != KIND_CHORE && kind != KIND_SHOP || id.isEmpty()) return
        WatchStore.toggle(this, kind, id, System.currentTimeMillis())
        PhoneLink.sendOutbox(this)
        Refresh.complications(this)
    }

    private fun image(res: Int) = ResourceBuilders.ImageResource.Builder()
        .setAndroidResourceByResId(
            ResourceBuilders.AndroidImageResourceByResId.Builder().setResourceId(res).build(),
        )
        .build()

    private fun untilMidnight(): Long {
        val next = LocalDate.now().plusDays(1)
            .atStartOfDay(ZoneId.systemDefault())
            .toInstant()
            .toEpochMilli() + 60_000L
        return (next - System.currentTimeMillis()).coerceAtLeast(60_000L)
    }

    private fun <T> done(value: T): ListenableFuture<T> =
        ResolvableFuture.create<T>().apply { set(value) }

    private companion object {
        const val RESOURCES_VERSION = "1"
    }
}

/** Aufbau der Kachel (ProtoLayout). */
object TileLayout {
    const val IMG_CHECK_ON = "check_on"
    const val IMG_CHECK_OFF = "check_off"
    const val CLICK_TOGGLE = "t|"

    // Dunkel wie die Uhr, Akzent aus dem App-Grün.
    private val PRIMARY = 0xFF95D5AE.toInt()
    private val ON_SURFACE = 0xFFE1E3DF.toInt()
    private val VARIANT = 0xFFA9B3AB.toInt()
    private val CHIP = 0xFF1F2A23.toInt()
    private val CHIP_DONE = 0xFF141A16.toInt()

    fun build(
        context: Context,
        section: Section,
        model: SectionModel?,
        device: DeviceParametersBuilders.DeviceParameters,
        nonce: String,
    ): LayoutElementBuilders.LayoutElement {
        val width = device.screenWidthDp.toFloat()
        val height = device.screenHeightDp.toFloat()
        val maxRows = if (height >= 220f) 4 else 3
        val open = openList(context, section)
        val column = LayoutElementBuilders.Column.Builder()
            .setWidth(expand())
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)

        val title = when {
            model == null -> context.getString(titleRes(section))
            model.open > 0 && section != Section.MEALS -> model.title + " · " + model.open
            else -> model.title
        }
        column.addContent(
            box(
                text(title, 15f, PRIMARY, bold = true),
                ModifiersBuilders.Modifiers.Builder()
                    .setClickable(clickable("open", open))
                    .build(),
                center = true,
            ),
        )
        column.addContent(spacer(6f))

        if (model == null) {
            column.addContent(text(context.getString(R.string.setup), 13f, VARIANT, maxLines = 3, center = true))
        } else {
            model.banner?.let {
                column.addContent(text(it, 12f, PRIMARY, maxLines = 1, center = true))
                column.addContent(spacer(4f))
            }
            val rows = model.rows.take(maxRows)
            if (rows.isEmpty()) {
                column.addContent(text(model.empty, 13f, VARIANT, maxLines = 2, center = true))
            }
            for (row in rows) {
                column.addContent(
                    if (section == Section.MEALS) mealRow(row, open) else checkRow(section, row, nonce),
                )
                column.addContent(spacer(4f))
            }
            val more = model.rows.size - rows.size
            if (more > 0) {
                column.addContent(
                    box(
                        text(context.getString(R.string.more, more), 12f, VARIANT, center = true),
                        ModifiersBuilders.Modifiers.Builder()
                            .setClickable(clickable("more", open))
                            .build(),
                        center = true,
                    ),
                )
            }
        }

        return LayoutElementBuilders.Box.Builder()
            .setWidth(expand())
            .setHeight(expand())
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
            .setVerticalAlignment(LayoutElementBuilders.VERTICAL_ALIGN_CENTER)
            .setModifiers(
                ModifiersBuilders.Modifiers.Builder()
                    .setPadding(
                        // Runde Uhren: seitlich und oben/unten Rand lassen.
                        ModifiersBuilders.Padding.Builder()
                            .setStart(dp(width * 0.12f))
                            .setEnd(dp(width * 0.12f))
                            .setTop(dp(height * 0.1f))
                            .setBottom(dp(height * 0.1f))
                            .build(),
                    )
                    .build(),
            )
            .addContent(column.build())
            .build()
    }

    private fun titleRes(section: Section) = when (section) {
        Section.CHORES -> R.string.tile_chores
        Section.SHOPPING -> R.string.tile_shopping
        Section.MEALS -> R.string.tile_meals
    }

    /** Abhakbare Zeile. */
    private fun checkRow(section: Section, row: Row, nonce: String): LayoutElementBuilders.LayoutElement {
        val kind = section.kind ?: KIND_CHORE
        val icon = LayoutElementBuilders.Image.Builder()
            .setResourceId(if (row.checked) IMG_CHECK_ON else IMG_CHECK_OFF)
            .setWidth(dp(18f))
            .setHeight(dp(18f))
            .setColorFilter(
                LayoutElementBuilders.ColorFilter.Builder()
                    .setTint(argb(if (row.checked) VARIANT else PRIMARY))
                    .build(),
            )
            .build()
        val content = LayoutElementBuilders.Row.Builder()
            .setWidth(expand())
            .setVerticalAlignment(LayoutElementBuilders.VERTICAL_ALIGN_CENTER)
            .addContent(icon)
            .addContent(LayoutElementBuilders.Spacer.Builder().setWidth(dp(8f)).build())
            .addContent(
                LayoutElementBuilders.Box.Builder()
                    .setWidth(expand())
                    .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_START)
                    .addContent(text(row.title, 14f, if (row.checked) VARIANT else ON_SURFACE))
                    .build(),
            )
            .build()
        val click = ModifiersBuilders.Clickable.Builder()
            .setId("$CLICK_TOGGLE$kind|${row.id}|$nonce")
            .setOnClick(ActionBuilders.LoadAction.Builder().build())
            .build()
        return chip(content, click, if (row.checked) CHIP_DONE else CHIP, row.title)
    }

    /** Gericht mit Tag; Tippen öffnet die Liste auf der Uhr. */
    private fun mealRow(row: Row, open: ActionBuilders.Action): LayoutElementBuilders.LayoutElement {
        val content = LayoutElementBuilders.Column.Builder()
            .setWidth(expand())
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_START)
            .addContent(text(row.subtitle ?: "", 11f, PRIMARY))
            .addContent(text(row.title, 14f, ON_SURFACE))
            .build()
        return chip(content, clickable("meal:${row.id}", open), CHIP, row.title)
    }

    private fun chip(
        content: LayoutElementBuilders.LayoutElement,
        click: ModifiersBuilders.Clickable,
        color: Int,
        description: String,
    ): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Box.Builder()
            .setWidth(expand())
            .setHeight(wrap())
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_START)
            .setModifiers(
                ModifiersBuilders.Modifiers.Builder()
                    .setClickable(click)
                    .setSemantics(
                        ModifiersBuilders.Semantics.Builder().setContentDescription(description).build(),
                    )
                    .setBackground(
                        ModifiersBuilders.Background.Builder()
                            .setColor(argb(color))
                            .setCorner(ModifiersBuilders.Corner.Builder().setRadius(dp(16f)).build())
                            .build(),
                    )
                    .setPadding(
                        ModifiersBuilders.Padding.Builder()
                            .setStart(dp(10f))
                            .setEnd(dp(10f))
                            .setTop(dp(6f))
                            .setBottom(dp(6f))
                            .build(),
                    )
                    .build(),
            )
            .addContent(content)
            .build()

    private fun box(
        content: LayoutElementBuilders.LayoutElement,
        modifiers: ModifiersBuilders.Modifiers,
        center: Boolean,
    ): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Box.Builder()
            .setWidth(expand())
            .setHorizontalAlignment(
                if (center) LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER else LayoutElementBuilders.HORIZONTAL_ALIGN_START,
            )
            .setModifiers(modifiers)
            .addContent(content)
            .build()

    private fun text(
        value: String,
        size: Float,
        color: Int,
        bold: Boolean = false,
        maxLines: Int = 1,
        center: Boolean = false,
    ): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Text.Builder()
            .setText(value)
            .setMaxLines(maxLines)
            .setOverflow(LayoutElementBuilders.TEXT_OVERFLOW_ELLIPSIZE_END)
            .setMultilineAlignment(
                if (center) LayoutElementBuilders.TEXT_ALIGN_CENTER else LayoutElementBuilders.TEXT_ALIGN_START,
            )
            .setFontStyle(
                LayoutElementBuilders.FontStyle.Builder()
                    .setSize(sp(size))
                    .setColor(argb(color))
                    .setWeight(
                        if (bold) LayoutElementBuilders.FONT_WEIGHT_BOLD else LayoutElementBuilders.FONT_WEIGHT_NORMAL,
                    )
                    .build(),
            )
            .build()

    private fun spacer(height: Float): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Spacer.Builder().setHeight(dp(height)).build()

    private fun clickable(id: String, action: ActionBuilders.Action) =
        ModifiersBuilders.Clickable.Builder().setId(id).setOnClick(action).build()

    /** Öffnet die Liste dieser Ansicht auf der Uhr. */
    private fun openList(context: Context, section: Section): ActionBuilders.Action =
        ActionBuilders.LaunchAction.Builder()
            .setAndroidActivity(
                ActionBuilders.AndroidActivity.Builder()
                    .setPackageName(context.packageName)
                    .setClassName(WatchActivity::class.java.name)
                    .addKeyToExtraMapping(
                        WatchActivity.EXTRA_SECTION,
                        ActionBuilders.AndroidStringExtra.Builder().setValue(section.name).build(),
                    )
                    .build(),
            )
            .build()
}
