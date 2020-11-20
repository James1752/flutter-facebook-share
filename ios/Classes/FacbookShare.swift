//
//  FacebookAuth.swift
//  FBSDKCoreKit
//
//  Created by Darwin Morocho on 11/10/20.
//

import Flutter
import FBSDKCoreKit
import Foundation

class FacebookShare: NSObject {
    /*
     handle the platform channel
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method{
        
        case "isFacebookInstalled":
            let installed = self.checkIfFacebookAppInstalled();
            result(installed)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func checkIfFacebookAppInstalled() -> Bool {
        let facebookAppUrl = URL(string: "fb://")!
        return UIApplication.shared.canOpenURL(facebookAppUrl)
    }      

    func checkIfFacebookMessengerAppInstalled() -> Bool {
        let facebookMessengerAppUrl = URL(string: "fb-messenger://")!
        return UIApplication.shared.canOpenURL(facebookMessengerAppUrl)
    }

}

