package space.mai.mai_household.wear

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDate

class WatchContentTest {
    private val today = LocalDate.of(2026, 10, 12)

    // Frei erfundener Beispielhaushalt.
    private val snapshot = JSONObject(
        """
        {
          "v": 1,
          "labels": {
            "chores": "Aufgaben heute", "choresEmpty": "Nichts fällig",
            "overdue": "Überfällig", "shopping": "Einkauf",
            "shoppingEmpty": "Alles da", "notFound": "Nicht gefunden",
            "meals": "Essen", "mealsEmpty": "Nichts geplant",
            "today": "Heute", "tomorrow": "Morgen",
            "wasteToday": "Heute Müll", "wasteTomorrow": "Morgen Müll",
            "weekdays": ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"],
            "neu": "unbekannt"
          },
          "chores": [
            {"id": "c1", "name": "Staubsaugen", "due": "2026-10-11", "area": "Flur", "assignee": "Sam", "mine": false, "minutes": 15},
            {"id": "c2", "name": "Pflanzen gießen", "due": "2026-10-12", "area": null, "assignee": null, "mine": true, "minutes": 5},
            {"id": "c3", "name": "Fenster putzen", "due": "2026-10-14", "area": null, "assignee": null, "mine": true, "minutes": 30}
          ],
          "shopping": [
            {"id": "s1", "name": "Milch", "detail": "2 l", "department": "Kühlregal", "notFound": false},
            {"id": "s2", "name": "Brot", "detail": null, "department": null, "notFound": true}
          ],
          "shoppingCount": 7,
          "meals": [
            {"day": "2026-10-11", "title": "Gestern", "recipeId": null, "servings": null},
            {"day": "2026-10-12", "title": "Lasagne", "recipeId": "r1", "servings": 4},
            {"day": "2026-10-13", "title": "Tomatensuppe", "recipeId": null, "servings": null},
            {"day": "2026-10-15", "title": "Pizza", "recipeId": null, "servings": null}
          ],
          "waste": [{"day": "2026-10-13", "name": "Papier", "color": 1}]
        }
        """.trimIndent(),
    )

    private val none: (String, String) -> Boolean = { _, _ -> false }

    @Test
    fun choresDueTodayAndOverdue() {
        val m = WatchContent.build(snapshot, Section.CHORES, today, none)
        assertEquals(listOf("c1", "c2"), m.rows.map { it.id })
        assertEquals("Überfällig · Flur · Sam", m.rows[0].subtitle)
        assertNull(m.rows[1].subtitle)
        assertEquals(2, m.open)
        assertEquals("Morgen Müll: Papier", m.banner)
        assertEquals("Staubsaugen", m.line)
    }

    @Test
    fun checkedChoresDoNotCount() {
        val m = WatchContent.build(snapshot, Section.CHORES, today) { kind, id -> kind == KIND_CHORE && id == "c1" }
        assertTrue(m.rows[0].checked)
        assertEquals(1, m.open)
        assertEquals("Pflanzen gießen", m.line)
    }

    @Test
    fun choresFollowTheWatchDate() {
        // Ohne neuen Stand: zwei Tage später ist auch c3 fällig.
        val m = WatchContent.build(snapshot, Section.CHORES, today.plusDays(2), none)
        assertEquals(listOf("c1", "c2", "c3"), m.rows.map { it.id })
    }

    @Test
    fun shoppingCountsBeyondTheList() {
        val m = WatchContent.build(snapshot, Section.SHOPPING, today) { _, id -> id == "s1" }
        assertEquals(6, m.open)
        assertEquals("Nicht gefunden", m.rows[1].subtitle)
        assertEquals("Brot", m.line)
    }

    @Test
    fun mealsFromTodayWithDayLabels() {
        val m = WatchContent.build(snapshot, Section.MEALS, today, none)
        assertEquals(listOf("Lasagne", "Tomatensuppe", "Pizza"), m.rows.map { it.title })
        assertEquals(listOf("Heute", "Morgen", "Do"), m.rows.map { it.subtitle })
        assertEquals(1, m.open)
        assertEquals("Lasagne", m.line)
        assertFalse(m.rows.any { it.checked })
    }

    @Test
    fun emptySnapshotIsTolerated() {
        val m = WatchContent.build(JSONObject("{}"), Section.SHOPPING, today, none)
        assertTrue(m.rows.isEmpty())
        assertEquals(0, m.open)
    }

    @Test
    fun keysCoverCheckableRows() {
        assertEquals(
            setOf("chore|c1", "chore|c2", "chore|c3", "shop|s1", "shop|s2"),
            WatchContent.keys(snapshot),
        )
    }
}

class OutboxTest {
    private val now = 1_000_000_000L

    @Test
    fun roundTripAndLatestWins() {
        var list = Outbox.put(emptyList(), WatchAction(KIND_SHOP, "s1", true, now))
        list = Outbox.put(list, WatchAction(KIND_CHORE, "c1", true, now + 1))
        list = Outbox.put(list, WatchAction(KIND_SHOP, "s1", false, now + 2))
        val parsed = Outbox.parse(Outbox.encode(list))
        assertEquals(2, parsed.size)
        assertEquals(WatchAction(KIND_SHOP, "s1", false, now + 2), parsed.last())
    }

    @Test
    fun pruneDropsAckedGoneAndExpired() {
        val list = listOf(
            WatchAction(KIND_SHOP, "acked", true, now),
            WatchAction(KIND_SHOP, "newer", true, now + 5),
            WatchAction(KIND_SHOP, "gone", true, now),
            WatchAction(KIND_SHOP, "old", true, now - Outbox.MAX_AGE_MS - 1),
        )
        val acks = Outbox.parseAcks("""{"shop|acked": $now, "shop|newer": $now}""")
        val present = setOf("shop|acked", "shop|newer", "shop|old")
        val left = Outbox.prune(list, acks, present, now + 10)
        assertEquals(listOf("newer"), left.map { it.id })
    }

    @Test
    fun pruneWithoutSnapshotKeepsUnacked() {
        val list = listOf(WatchAction(KIND_CHORE, "c1", true, now))
        assertEquals(list, Outbox.prune(list, emptyMap(), null, now))
    }

    @Test
    fun brokenJsonIsIgnored() {
        assertTrue(Outbox.parse("kaputt").isEmpty())
        assertTrue(Outbox.parse("""[{"kind":"shop"}, 3]""").isEmpty())
        assertTrue(Outbox.parseAcks("[]").isEmpty())
    }
}
