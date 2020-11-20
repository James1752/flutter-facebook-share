import Flutter
import UIKit

import FBSDKCoreKit


public class SwiftFlutterFacebookSharePlugin: NSObject, FlutterPlugin {
    let facebookShare = FacebookShare()
    var controller: UIViewController! 
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "co.yodelit.yodel/fb", binaryMessenger: registrar.messenger())
        self.controller = (UIApplication.shared.delegate?.window??.rootViewController)!;
        let instance = SwiftFlutterFacebookSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.facebookShare.handle(call, result: result, viewController: self.controller)
    }

    
    
    /// START ALLOW HANDLE NATIVE FACEBOOK APP
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        var options = [UIApplication.LaunchOptionsKey: Any]()
        for (k, value) in launchOptions {
            let key = k as! UIApplication.LaunchOptionsKey
            options[key] = value
        }
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: options)
        return true
    }
    
    public func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        let processed = ApplicationDelegate.shared.application(
            app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return processed;
    }
    /// END ALLOW HANDLE NATIVE FACEBOOK APP
}
