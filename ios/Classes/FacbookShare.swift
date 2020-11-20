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
    let controller:UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!;
    /*
     handle the platform channel
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // let args = call.arguments as? [String: Any]
        switch call.method{
        
        case "isFacebookInstalled":
            let installed = self.checkIfFacebookAppInstalled();
            result(installed)

        case "shareFaceBookLink":
            let content = getLinkSharingContent(url: "https://www.google.com.au", quote: "Hello World!")
            let shareDialog = ShareDialog(fromViewController: controller, content: content, delegate: nil)

            guard shareDialog.canShow else {
                print("Facebook Messenger must be installed in order to share to it")
                return
            }
            shareDialog.show()
        case "shareFaceBookImage":
            let content = getPhotoSharingContent()
            let shareDialog = ShareDialog(fromViewController: controller, content: content, delegate: nil)

            guard shareDialog.canShow else {
                print("Facebook Messenger must be installed in order to share to it")
                return
            }
            shareDialog.show()
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getPhotoSharingContent() -> SharingContent {
        let url = URL(string: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg")!
        let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

        let image = UIImage(data: data!)!
        let photo = SharePhoto(image: image, userGenerated: true)

        let photoContent = SharePhotoContent()
        photoContent.photos = [photo]
        
    // Optional:
        // photoContent.hashtag = Hashtag("#fooHashTag")
    
        return photoContent
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

