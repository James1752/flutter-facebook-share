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
enum FacebookShareError: Error {
    case invalidUrl(message: String)
    case insufficientFunds(coinsNeeded: Int)
}
class FacebookShare: NSObject {
    let controller:UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!;
    /*
     handle the platform channel
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method{
        
        case "isFacebookInstalled":
            let installed = self.checkIfFacebookAppInstalled();
            result(installed)

        case "shareFaceBookLink":
                let content = getLinkSharingContent(url: "htps://www.google.com.au", quote: "Hello World!",hashTag: "")
                let shareDialog = ShareDialog(fromViewController: controller, content: content, delegate: nil)

                guard shareDialog.canShow else {
                    print("Facebook Messenger must be installed in order to share to it")
                    return
                }
                shareDialog.show()
            
        case "shareFaceBookImage":
            do {
                let content = try getPhotoSharingContent(imageUrl: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper", hashTag: "" )
                let shareDialog = ShareDialog(fromViewController: controller, content: content as! SharingContent, delegate: nil)

                guard shareDialog.canShow else {
                    print("Facebook Messenger must be installed in order to share to it")
                    return
                }
                shareDialog.show()
            }
            catch FacebookShareError.invalidUrl(let message) {
                print("HERRE222222")
                result(["error": true, "message": message])
                return
            }
            catch {
                print("HERRE555555")
                result(["error": true, "message": "AHHHHHHH"])
                return  
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getPhotoSharingContent(imageUrl:String, hashTag:String ) throws -> SharingContent {
        do {
            let url = URL(string: imageUrl)!
            let data = try? Data(contentsOf: url)
            if data == nil {
                print("HERER")
                throw FacebookShareError.invalidUrl(message: "Invalid Url")
            }
            let image = UIImage(data: data!)!
            let photo = SharePhoto(image: image, userGenerated: true)

            let photoContent = SharePhotoContent()
            photoContent.photos = [photo]
            if !hashTag.isEmpty {
                photoContent.hashtag = Hashtag(hashTag)
            }
        return photoContent
        } catch {
            print("HERRE555555")
            throw FacebookShareError.invalidUrl(message: "Invalid Url")
        }
    }

    private func getLinkSharingContent(url:String, quote:String, hashTag:String ) -> SharingContent {
        let shareLinkContent = ShareLinkContent()
        shareLinkContent.contentURL = URL(string: url)!
        shareLinkContent.quote = quote
        if  !hashTag.isEmpty {
            shareLinkContent.hashtag = Hashtag(hashTag)
        }
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

