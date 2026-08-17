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

        let status = locationManager.authorizationStatus

        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }

        call.resolve()
    }

    @objc func stop(_ call: CAPPluginCall) {

        locationManager.stopUpdatingLocation()

        notifyListeners("gpsDebug", data: [
            "message": "GPS: gestoppt"
        ])

        call.resolve()
    }

    public func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {

        let status = manager.authorizationStatus

        notifyListeners("gpsDebug", data: [
            "message": "GPS Berechtigung: \(status.rawValue)"
        ])

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()

            notifyListeners("gpsDebug", data: [
                "message": "GPS: Standortaktualisierung gestartet"
            ])
        }
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let location = locations.last else {
            return
        }

        let speed = location.speed >= 0 ? location.speed : 0
        let courseValid = location.course >= 0
        let course = courseValid ? location.course : 0

        notifyListeners("gpsData", data: [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "speed": speed,
            "course": course,
            "courseValid": courseValid,
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
