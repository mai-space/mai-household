package space.mai.mai_household.wear

import android.app.Activity
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Paint
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView

/**
 * Ganze Liste auf der Uhr (aus Kachel oder Komplikation). Oben drei Symbole
 * zum Wechseln, darunter die Einträge; Tippen hakt ab. Einfache Views statt
 * Compose — hält die Uhr-App klein.
 */
class WatchActivity : Activity() {
    companion object {
        const val EXTRA_SECTION = "section"

        private val PRIMARY = 0xFF95D5AE.toInt()
        private val ON_SURFACE = 0xFFE1E3DF.toInt()
        private val VARIANT = 0xFFA9B3AB.toInt()
        private val CHIP = 0xFF1F2A23.toInt()
        private val CHIP_DONE = 0xFF141A16.toInt()
    }

    private var section = Section.CHORES
    private lateinit var scroll: ScrollView
    private lateinit var list: LinearLayout

    // Feld, weil SharedPreferences Listener nur schwach hält.
    private val listener = SharedPreferences.OnSharedPreferenceChangeListener { _, _ -> render() }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        section = Section.of(intent.getStringExtra(EXTRA_SECTION))
        val metrics = resources.displayMetrics
        list = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            // Runde Uhren: Rand seitlich, oben und unten.
            val side = (metrics.widthPixels * 0.1f).toInt()
            setPadding(side, (metrics.heightPixels * 0.12f).toInt(), side, (metrics.heightPixels * 0.25f).toInt())
        }
        scroll = ScrollView(this).apply {
            isVerticalScrollBarEnabled = true
            // Drehkrone/Lünette scrollt nur mit Fokus.
            isFocusable = true
            isFocusableInTouchMode = true
            addView(list)
        }
        setContentView(scroll)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        section = Section.of(intent.getStringExtra(EXTRA_SECTION))
        render()
        scroll.scrollTo(0, 0)
    }

    override fun onResume() {
        super.onResume()
        WatchStore.prefs(this).registerOnSharedPreferenceChangeListener(listener)
        PhoneLink.refresh(this, minIntervalMs = 10_000L)
        render()
        scroll.requestFocus()
    }

    override fun onPause() {
        WatchStore.prefs(this).unregisterOnSharedPreferenceChangeListener(listener)
        super.onPause()
    }

    private fun render() {
        list.removeAllViews()
        list.addView(tabs())
        val model = WatchStore.model(this, section)
        val title = when {
            model == null -> getString(titleRes(section))
            model.open > 0 && section != Section.MEALS -> model.title + " · " + model.open
            else -> model.title
        }
        list.addView(text(title, 16f, PRIMARY, bold = true, center = true))
        if (model == null) {
            list.addView(text(getString(R.string.setup), 14f, VARIANT, center = true))
            return
        }
        model.banner?.let { list.addView(text(it, 13f, PRIMARY, center = true)) }
        if (model.rows.isEmpty()) {
            list.addView(text(model.empty, 14f, VARIANT, center = true))
            return
        }
        for (row in model.rows) {
            list.addView(if (section == Section.MEALS) mealRow(row) else checkRow(row))
        }
    }

    private fun titleRes(section: Section) = when (section) {
        Section.CHORES -> R.string.tile_chores
        Section.SHOPPING -> R.string.tile_shopping
        Section.MEALS -> R.string.tile_meals
    }

    /** Drei Symbole: Aufgaben, Einkauf, Essen. */
    private fun tabs(): View {
        val row = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
        }
        for ((target, icon) in listOf(
            Section.CHORES to R.drawable.ic_chores,
            Section.SHOPPING to R.drawable.ic_shopping,
            Section.MEALS to R.drawable.ic_meals,
        )) {
            row.addView(
                ImageView(this).apply {
                    setImageResource(icon)
                    setColorFilter(if (target == section) PRIMARY else VARIANT)
                    alpha = if (target == section) 1f else 0.6f
                    contentDescription = getString(titleRes(target))
                    val pad = dp(8)
                    setPadding(pad, pad, pad, pad)
                    setOnClickListener {
                        section = target
                        render()
                    }
                },
                LinearLayout.LayoutParams(dp(40), dp(40)),
            )
        }
        return row
    }

    private fun checkRow(row: Row): View {
        val kind = section.kind ?: KIND_CHORE
        val item = chip(if (row.checked) CHIP_DONE else CHIP)
        item.orientation = LinearLayout.HORIZONTAL
        item.gravity = Gravity.CENTER_VERTICAL
        item.addView(
            ImageView(this).apply {
                setImageResource(if (row.checked) R.drawable.ic_check_on else R.drawable.ic_check_off)
                setColorFilter(if (row.checked) VARIANT else PRIMARY)
            },
            LinearLayout.LayoutParams(dp(20), dp(20)).apply { marginEnd = dp(8) },
        )
        val texts = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL }
        texts.addView(
            text(row.title, 15f, if (row.checked) VARIANT else ON_SURFACE, maxLines = 2).apply {
                if (row.checked) paintFlags = paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
            },
        )
        row.subtitle?.let { texts.addView(text(it, 12f, VARIANT, maxLines = 1)) }
        item.addView(texts, LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f))
        item.contentDescription = row.title + ", " +
            getString(if (row.checked) R.string.done else R.string.open)
        item.setOnClickListener {
            WatchStore.toggle(this, kind, row.id, System.currentTimeMillis())
            PhoneLink.sendOutbox(this)
            Refresh.all(this)
            render()
        }
        return item
    }

    private fun mealRow(row: Row): View {
        val item = chip(CHIP)
        item.orientation = LinearLayout.VERTICAL
        item.addView(text(row.subtitle ?: "", 12f, PRIMARY, maxLines = 1))
        item.addView(text(row.title, 15f, ON_SURFACE, maxLines = 2))
        return item
    }

    private fun chip(color: Int) = LinearLayout(this).apply {
        background = GradientDrawable().apply {
            setColor(color)
            cornerRadius = dp(20).toFloat()
        }
        setPadding(dp(12), dp(8), dp(12), dp(8))
        layoutParams = LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT,
        ).apply { topMargin = dp(6) }
    }

    private fun text(
        value: String,
        size: Float,
        color: Int,
        bold: Boolean = false,
        center: Boolean = false,
        maxLines: Int = 3,
    ) = TextView(this).apply {
        text = value
        setTextSize(TypedValue.COMPLEX_UNIT_SP, size)
        setTextColor(color)
        this.maxLines = maxLines
        ellipsize = android.text.TextUtils.TruncateAt.END
        if (bold) paint.isFakeBoldText = true
        if (center) {
            gravity = Gravity.CENTER_HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT,
            ).apply { topMargin = dp(4) }
        }
    }

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()
}
