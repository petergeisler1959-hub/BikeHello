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
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func setKeepScreenOn(_ call: CAPPluginCall) {

        let enabled =
            call.getBool("enabled") ?? false

        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = enabled
            call.resolve()
        }
    }

    @objc private func appDidEnterBackground() {

        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}