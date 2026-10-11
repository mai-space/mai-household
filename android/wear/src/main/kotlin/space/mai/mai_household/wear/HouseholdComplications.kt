package space.mai.mai_household.wear

import android.app.PendingIntent
import android.content.Intent
import android.graphics.drawable.Icon
import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationType
import androidx.wear.watchface.complications.data.LongTextComplicationData
import androidx.wear.watchface.complications.data.MonochromaticImage
import androidx.wear.watchface.complications.data.PlainComplicationText
import androidx.wear.watchface.complications.data.ShortTextComplicationData
import androidx.wear.watchface.complications.datasource.ComplicationRequest
import androidx.wear.watchface.complications.datasource.SuspendingComplicationDataSourceService

/** Offene Aufgaben heute (Anzahl bzw. nächste Aufgabe). */
class ChoresComplicationService : HouseholdComplicationService(Section.CHORES)

/** Offene Einkäufe (Anzahl bzw. die ersten Artikel). */
class ShoppingComplicationService : HouseholdComplicationService(Section.SHOPPING)

/** Heutiges Essen. */
class MealsComplicationService : HouseholdComplicationService(Section.MEALS)

/** Komplikation fürs Zifferblatt; Tippen öffnet die Liste auf der Uhr. */
abstract class HouseholdComplicationService(private val section: Section) :
    SuspendingComplicationDataSourceService() {

    override suspend fun onComplicationRequest(request: ComplicationRequest): ComplicationData? {
        val model = WatchStore.model(this, section)
        if (model == null) PhoneLink.refresh(this)
        return data(request.complicationType, texts(model), tap())
    }

    override fun getPreviewData(type: ComplicationType): ComplicationData? {
        val preview = when (section) {
            Section.CHORES -> Texts("2", getString(R.string.short_chores), getString(R.string.tile_chores))
            Section.SHOPPING -> Texts("5", getString(R.string.short_shopping), getString(R.string.tile_shopping))
            Section.MEALS -> Texts(getString(R.string.short_meals), getString(R.string.short_meals), getString(R.string.tile_meals))
        }
        return data(type, preview, null)
    }

    /** Kurz (Zahl/Wort), Titel und lange Zeile. */
    private class Texts(val short: String, val title: String, val long: String)

    private fun texts(model: SectionModel?): Texts {
        val shortTitle = getString(
            when (section) {
                Section.CHORES -> R.string.short_chores
                Section.SHOPPING -> R.string.short_shopping
                Section.MEALS -> R.string.short_meals
            },
        )
        if (model == null) return Texts("–", shortTitle, getString(R.string.setup))
        return when (section) {
            Section.CHORES, Section.SHOPPING -> Texts(model.open.toString(), shortTitle, model.line)
            // Kurz: erstes Gericht von heute (das Zifferblatt kürzt selbst).
            Section.MEALS -> Texts(
                if (model.open > 0) model.rows.first().title else "–",
                shortTitle,
                model.line,
            )
        }
    }

    private fun data(type: ComplicationType, texts: Texts, tap: PendingIntent?): ComplicationData? {
        val description = plain(texts.title + ": " + texts.long)
        val icon = MonochromaticImage.Builder(Icon.createWithResource(this, iconRes())).build()
        return when (type) {
            ComplicationType.SHORT_TEXT ->
                ShortTextComplicationData.Builder(plain(texts.short), description)
                    .setTitle(plain(texts.title))
                    .setMonochromaticImage(icon)
                    .setTapAction(tap)
                    .build()
            ComplicationType.LONG_TEXT ->
                LongTextComplicationData.Builder(plain(texts.long), description)
                    .setTitle(plain(texts.title))
                    .setMonochromaticImage(icon)
                    .setTapAction(tap)
                    .build()
            else -> null
        }
    }

    private fun iconRes() = when (section) {
        Section.CHORES -> R.drawable.ic_chores
        Section.SHOPPING -> R.drawable.ic_shopping
        Section.MEALS -> R.drawable.ic_meals
    }

    private fun plain(text: String) = PlainComplicationText.Builder(text).build()

    private fun tap(): PendingIntent {
        val intent = Intent(this, WatchActivity::class.java)
            .putExtra(WatchActivity.EXTRA_SECTION, section.name)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        return PendingIntent.getActivity(
            this,
            section.ordinal,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }
}
