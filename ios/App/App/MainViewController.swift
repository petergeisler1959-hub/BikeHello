import Capacitor

class MainViewController: CAPBridgeViewController {

    override func capacitorDidLoad() {
        bridge?.registerPluginInstance(MagnetometerPlugin())
        bridge?.registerPluginInstance(GPSPlugin())
    }
}
