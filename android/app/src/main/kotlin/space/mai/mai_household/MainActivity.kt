package space.mai.mai_household

import android.content.Context
import android.content.Intent
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import space.mai.mai_household.widgets.HouseholdWidgets
import space.mai.mai_household.widgets.WidgetLinks
import space.mai.mai_household.widgets.WidgetStore
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null
    private var widgetChannel: MethodChannel? = null
    private var initialLinkTaken = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // IANA-Zeitzone des Geräts (z. B. „Europe/Berlin“) für Erinnerungen.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mai/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "timeZone" -> result.success(TimeZone.getDefault().id)
                    else -> result.notImplemented()
                }
            }
        // Homescreen-Widgets: Stand aus der App, auf dem Homescreen
        // Abgehaktes, Link beim Öffnen über ein Widget.
        widgetChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mai/widgets").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "update" -> {
                        val json = call.arguments as? String
                        if (json != null) {
                            WidgetStore.saveSnapshot(applicationContext, json)
                            HouseholdWidgets.refreshAll(applicationContext)
                        }
                        result.success(null)
                    }
                    "pending" -> result.success(WidgetStore.pendingJson(applicationContext))
                    "clearPending" -> {
                        (call.arguments as? String)?.let {
                            WidgetStore.clearPending(applicationContext, it)
                        }
                        result.success(null)
                    }
                    "initialLink" -> {
                        val link = if (initialLinkTaken) null else widgetLink(intent)
                        initialLinkTaken = true
                        result.success(link)
                    }
                    else -> result.notImplemented()
                }
            }
        }
        // Geräte-Suche im WLAN: Viele Android-Geräte verwerfen UDP-Broadcasts,
        // solange die App keinen Multicast-Lock hält. Nur im Vordergrund aktiv.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mai/net")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "acquireMulticast" -> {
                        try {
                            if (multicastLock == null) {
                                val wifi = applicationContext
                                    .getSystemService(Context.WIFI_SERVICE) as WifiManager
                                multicastLock = wifi.createMulticastLock("mai-household-sync")
                                    .apply { setReferenceCounted(false) }
                            }
                            multicastLock?.acquire()
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    "releaseMulticast" -> {
                        try {
                            multicastLock?.takeIf { it.isHeld }?.release()
                        } catch (_: Exception) {
                        }
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        widgetLink(intent)?.let { widgetChannel?.invokeMethod("open", it) }
    }

    private fun widgetLink(intent: Intent?): String? =
        intent?.data?.takeIf { it.scheme == WidgetLinks.SCHEME }?.toString()

    override fun onDestroy() {
        try {
            multicastLock?.takeIf { it.isHeld }?.release()
        } catch (_: Exception) {
        }
        super.onDestroy()
    }
}
