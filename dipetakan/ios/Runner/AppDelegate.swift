import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseAppCheck

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Initialize Firebase
    FirebaseApp.configure()

    // Initialize App Check
    let providerFactory = AppAttestProviderFactory(app: FirebaseApp.app()!)
    AppCheck.setAppCheckProviderFactory(providerFactory)
    
    GMSServices.provideAPIKey("AIzaSyBVPLKGswhbkuZR8ezUKNKqhFUoW-KDOA8")


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}