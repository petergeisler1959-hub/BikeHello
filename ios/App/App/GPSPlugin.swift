import Foundation
import Capacitor
import CoreLocation

@objc(GPSPlugin)
public class GPSPlugin: CAPPlugin, CAPBridgedPlugin, CLLocationManagerDelegate {

    public let identifier = "GPSPlugin"
    public let jsName = "GPS"

    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "start", returnType: CAPPluginReturnNone),
        CAPPluginMethod(name: "stop", returnType: CAPPluginReturnNone)
    ]

    private let locationManager = CLLocationManager()

    override public func load() {
        super.load()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }

    @objc func start(_ call: CAPPluginCall) {

        notifyListeners("gpsDebug", data: [
            "message": "GPS: start() erreicht"
        ])

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        call.resolve()
    }

    @objc func stop(_ call: CAPPluginCall) {

        locationManager.stopUpdatingLocation()

        notifyListeners("gpsDebug", data: [
            "message": "GPS: gestoppt"
        ])

        call.resolve()
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let location = locations.last else {
            return
        }

        let speed = location.speed >= 0 ? location.speed : 0
        let course = location.course >= 0 ? location.course : 0

        notifyListeners("gpsData", data: [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "speed": speed,
            "course": course,
            "horizontalAccuracy": location.horizontalAccuracy,
            "altitude": location.altitude,
            "verticalAccuracy": location.verticalAccuracy,
            "timestamp": location.timestamp.timeIntervalSince1970
        ])
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {

        notifyListeners("gpsDebug", data: [
            "message": "GPS Fehler: \(error.localizedDescription)"
        ])
    }
}
