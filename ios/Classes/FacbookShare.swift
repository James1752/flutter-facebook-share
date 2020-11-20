import Flutter
import FBSDKCoreKit
import Foundation
import FBSDKShareKit
import UIKit

enum FacebookShareError: Error {
    case invalidUrl(message: String)
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
            do {
                let url = args?["url"] as? String
                let quote = args?["quote"] as? String
                if !(url ?? "").isEmpty || !(quote ?? "").isEmpty{
                    result(["error": true, "message": "Parameters are invalid"])
                    return
                }
                let content = try getLinkSharingContent(url: url??"", quote: quote??"", hashTag: "")
                let shareDialog = ShareDialog(fromViewController: controller, content: content, delegate: nil)

                guard shareDialog.canShow else {
                    result(["error": true, "message": "Facebook Messenger must be installed in order to share to it"])
                    return
                }
                shareDialog.show()
            }            
            catch FacebookShareError.invalidUrl(let message) {
                result(["error": true, "message": message])
                return
            }
            catch {
                result(["error": true, "message": "Unexpected error has occured"])
                return  
            }
            
        case "shareFaceBookImage":
            do {
                let content = try getPhotoSharingContent(imageUrl: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper", hashTag: "" )
                let shareDialog = ShareDialog(fromViewController: controller, content: content as! SharingContent, delegate: nil)

                guard shareDialog.canShow else {
                    result(["error": true, "message": "Facebook Messenger must be installed in order to share to it"])
                    return
                }
                shareDialog.show()
            }
            catch FacebookShareError.invalidUrl(let message) {
                result(["error": true, "message": message])
                return
            }
            catch {
                result(["error": true, "message": "Unexpected error has occured"])
                return  
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getPhotoSharingContent(imageUrl:String, hashTag:String ) throws -> SharingContent {
        do {
            if !verifyUrl(urlString: imageUrl){
                throw FacebookShareError.invalidUrl(message: "Invalid Url")    
            }
            let url = URL(string: imageUrl)!
            let data = try? Data(contentsOf: url)
            if data == nil {
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
            throw FacebookShareError.invalidUrl(message: "Invalid Url")
        }
    }

    private func getLinkSharingContent(url:String, quote:String, hashTag:String ) throws -> SharingContent {
        do {
            if !verifyUrl(urlString: url){
                throw FacebookShareError.invalidUrl(message: "Invalid Url")    
            }
            let shareLinkContent = ShareLinkContent()
            shareLinkContent.contentURL = URL(string: url)!
            shareLinkContent.quote = quote
            if  !hashTag.isEmpty {
                shareLinkContent.hashtag = Hashtag(hashTag)
            }
            return shareLinkContent
        }catch {
            throw FacebookShareError.invalidUrl(message: "Invalid Url")
        }
    }
    
    private func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

    private func checkIfFacebookAppInstalled() -> Bool {
        let facebookAppUrl = URL(string: "fb://")!
        return UIApplication.shared.canOpenURL(facebookAppUrl)
    }      

    private func checkIfFacebookMessengerAppInstalled() -> Bool {
        let facebookMessengerAppUrl = URL(string: "fb-messenger://")!
        return UIApplication.shared.canOpenURL(facebookMessengerAppUrl)
    }

}

