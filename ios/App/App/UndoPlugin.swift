import UIKit
import Capacitor

@objc(UndoPlugin)
public class UndoPlugin: CAPPlugin, CAPBridgedPlugin {

    public let identifier = "UndoPlugin"
    public let jsName = "Undo"

    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(
            name: "getUndoState",
            returnType: CAPPluginReturnPromise
        ),
        CAPPluginMethod(
            name: "clearUndo",
            returnType: CAPPluginReturnNone
        )
    ]

    @objc func clearUndo(_ call: CAPPluginCall) {

        guard let webView = bridge?.webView else {
            call.reject("WebView nicht verfügbar")
            return
        }

        DispatchQueue.main.async {

            webView.undoManager?.removeAllActions()

            call.resolve()
        }
    }

    @objc func getUndoState(_ call: CAPPluginCall) {

        guard let webView = bridge?.webView else {
            call.reject("WebView nicht verfügbar")
            return
        }

        DispatchQueue.main.async {

            let undoManager =
                webView.undoManager

            call.resolve([
                "canUndo": undoManager?.canUndo ?? false,
                "canRedo": undoManager?.canRedo ?? false
            ])
        }
    }
}