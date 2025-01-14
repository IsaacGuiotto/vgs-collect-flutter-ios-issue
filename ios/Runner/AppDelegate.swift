import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)

    FlutterTokenizeCardDataCollectViewPlugin.register(with: registrar(forPlugin: "FlutterTokenizeCardDataCollectPlugin")!)
    
    FlutterCustomCardDataCollectViewPlugin.register(with: registrar(forPlugin: "FlutterCustomCardDataCollectPlugin")!)

    FlutterCardDataCollectViewPlugin.register(with: registrar(forPlugin: "FlutterCardDataCollectViewPlugin")!)

    FlutterShowViewPlugin.register(with: registrar(forPlugin: "FlutterShowViewPlugin")!)
    
    ActivateCardPlugin.register(with: registrar(forPlugin: "ActivateCardPlugin")!)

		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
