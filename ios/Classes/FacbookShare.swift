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
    /*
     handle the platform channel
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult, viewController: UIViewController) {
        // let args = call.arguments as? [String: Any]
        switch call.method{
        
        case "isFacebookInstalled":
            let installed = self.checkIfFacebookAppInstalled();
            result(installed)

        case "shareFaceBook":
            let content = getLinkSharingContent(url: "https://www.google.com.au", quote: "Hello World!")
            let shareDialog = ShareDialog(fromViewController: self.viewController, content: content, delegate: nil)

            guard shareDialog.canShow else {
                print("Facebook Messenger must be installed in order to share to it")
                return
            }
            shareDialog.show()

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getLinkSharingContent(url:String, quote:String ) -> SharingContent {
        let shareLinkContent = ShareLinkContent()
        shareLinkContent.contentURL = URL(string: url)!
        shareLinkContent.quote = quote
        
        return shareLinkContent
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

