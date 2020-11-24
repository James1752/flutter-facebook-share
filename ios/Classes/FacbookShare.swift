import Flutter
import FBSDKCoreKit
import Foundation
import FBSDKShareKit
import UIKit

enum FacebookShareError: Error {
    case invalidUrl(message: String)
}

class FacebookShare: NSObject {
    let shareDelegater =  ShareDelegater()
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
                let hashTag = args?["hashTag"] as? String
                if (url ?? "").isEmpty || (quote ?? "").isEmpty{
                    result(["error": true, "message": "Parameters are invalid"])
                    return
                }
                shareDelegater.setResult(res: result)
                let content = try getLinkSharingContent(url: url ?? "", quote: quote ?? "", hashTag: hashTag ?? "")
                let shareDialog = ShareDialog(fromViewController: controller, content: content, delegate:  shareDelegater)

                guard shareDialog.canShow else {
                    result(["error": true, "message": "Facebook Messenger must be installed in order to share to it"])
                    return
                }
                shareDialog.show()
                
            }
            catch {
                result(["error": true, "message": "Unexpected error has occured, please try again later"])
                return  
            }
        default:
            result(FlutterMethodNotImplemented)
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

class ShareDelegater: NSObject, SharingDelegate{
    var res: FlutterResult?
    
    func setResult(res: @escaping FlutterResult){
        self.res = res
    }
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if res != nil {
            self.res!(["error": false, "message": "Successful Post"])
        }
    }

    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
      print("didFailWithError: \(error.localizedDescription)")
    }

    func sharerDidCancel(_ sharer: Sharing) {
        if res != nil {
            self.res!(["error": true, "message": "User cancelled sharing"])
        }

    }
}
