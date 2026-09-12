import UIKit
import Capacitor

@objc(ScreenPlugin)
public class ScreenPlugin: CAPPlugin, CAPBridgedPlugin {

    public let identifier = "ScreenPlugin"
    public let jsName = "Screen"

    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(
            name: "setKeepScreenOn",
            returnType: CAPPluginReturnNone
        )
    ]

    override public func load() {
        super.load()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        // BikeHello startet im Vordergrund:
        // Bildschirm sofort wach halten.
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func setKeepScreenOn(_ call: CAPPluginCall) {

        // Diese Methode bleibt für die Kompatibilität
        // mit dem JavaScript-Plugin erhalten.
        call.resolve()
    }

    @objc private func appWillEnterForeground() {

        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }

    @objc private func appDidEnterBackground() {

        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
