//
//  FacebookAuth.swift
//  FBSDKCoreKit
//
//  Created by Darwin Morocho on 11/10/20.
//

import Flutter
import FBSDKCoreKit
import Foundation
import FBSDKShareKit
import UIKit

class FacebookShare: NSObject {
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    /*
     handle the platform channel
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // let args = call.arguments as? [String: Any]
        switch call.method{
        
        case "isFacebookInstalled":
            let installed = self.checkIfFacebookAppInstalled();
            result(installed)

        case "shareFaceBook":
            let content = getLinkSharingContent(url: "https://www.google.com.au", quote: "Hello World!")
            let shareDialog = ShareDialog(fromViewController: viewController, content: content, delegate: nil)

            guard shareDialog.canShow else {
                print("Facebook Messenger must be installed in order to share to it")
                return
            }
            shareDialog.show()

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

