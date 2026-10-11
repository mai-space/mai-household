package space.mai.mai_household

import android.content.Context
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null

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

    override fun onDestroy() {
        try {
            multicastLock?.takeIf { it.isHeld }?.release()
        } catch (_: Exception) {
        }
        super.onDestroy()
    }
}
