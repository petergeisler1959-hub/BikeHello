import Foundation
import Capacitor
import CoreMotion

@objc(MagnetometerPlugin)
public class MagnetometerPlugin: CAPPlugin, CAPBridgedPlugin {

public let identifier = "MagnetometerPlugin"
public let jsName = "Magnetometer"

public let pluginMethods: [CAPPluginMethod] = [
CAPPluginMethod(name: "start", returnType: CAPPluginReturnNone),
CAPPluginMethod(name: "stop", returnType: CAPPluginReturnNone)
]

private let motionManager = CMMotionManager()

@objc func start(_ call: CAPPluginCall) {

guard motionManager.isMagnetometerAvailable else {
call.reject("Magnetometer is not available")
return
}

motionManager.magnetometerUpdateInterval = 0.05

motionManager.startMagnetometerUpdates(to: OperationQueue.main) { [weak self] data, error in

if let error = error {
print("Magnetometer error: \(error.localizedDescription)")
return
}

guard let magneticField = data?.magneticField else {
return
}

self?.notifyListeners("magnetometerData", data: [
"x": magneticField.x,
"y": magneticField.y,
"z": magneticField.z
])
}

call.resolve()
}

@objc func stop(_ call: CAPPluginCall) {
motionManager.stopMagnetometerUpdates()
call.resolve()
}
}