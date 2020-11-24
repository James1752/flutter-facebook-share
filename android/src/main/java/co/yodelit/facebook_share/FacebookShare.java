package co.yodelit.facebook_share;

import android.app.Activity;
import android.os.Bundle;

import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;


public class FacebookShare {

 FacebookShare() {

    }

    void isFacebookInstalled(Activity activity, MethodChannel.Result result) {
        final boolean isFbInstalled = isPackageInstalled(activity, "com.facebook.katana");
       if(isFbInstalled){
           result.success(null);
           return;
       }
       result.error("FAILED", "Facebook Messenger must be installed in order to share to it", null);
    }

    public static boolean isPackageInstalled(Activity c, String targetPackage) {
        PackageManager pm = c.getPackageManager();
        try {
            PackageInfo info = pm.getPackageInfo(targetPackage, PackageManager.GET_META_DATA);
        } catch (NameNotFoundException e) {
            return false;
        }
        return true;
    }



    // /**
    //  * Check Login Status
    //  *
    //  * @param result flutter method channel result to send the response to the client
    //  */
    // public void isLogged(MethodChannel.Result result) {
    //     AccessToken accessToken = AccessToken.getCurrentAccessToken();
    //     boolean isLoggedIn = accessToken != null && !accessToken.isExpired();
    //     if (isLoggedIn) {
    //         HashMap<String, Object> data = getAccessToken(AccessToken.getCurrentAccessToken());
    //         result.success(data);
    //     } else {
    //         result.success(null);
    //     }
    // }

    // /**
    //  * close the current facebook session
    //  *
    //  * @param result flutter method channel result to send the response to the client
    //  */
    // void logOut(MethodChannel.Result result) {
    //     loginManager.logOut();
    //     result.success(null);
    // }

    // /**
    //  * Enable Express Login
    //  *
    //  * @param activity
    //  * @param result   flutter method channel result to send the response to the client
    //  */
    // void expressLogin(Activity activity, final MethodChannel.Result result) {
    //     LoginManager.getInstance().retrieveLoginStatus(activity, new LoginStatusCallback() {
    //         @Override
    //         public void onCompleted(AccessToken accessToken) {
    //             // User was previously logged in, can log them in directly here.
    //             // If this callback is called, a popup notification appears that says
    //             // "Logged in as <User Name>"
    //             HashMap<String, Object> data = getAccessToken(accessToken);
    //             result.success(data);
    //         }

    //         @Override
    //         public void onFailure() {
    //             // No access token could be retrieved for the user
    //             result.error("CANCELLED", "User has cancelled login with facebook", null);
    //         }

    //         @Override
    //         public void onError(Exception e) {
    //             // An error occurred
    //             result.error("FAILED", e.getMessage(), null);
    //         }
    //     });
    // }


    // /**
    //  * Get the facebook user data
    //  *
    //  * @param fields string of fields like "name,email,picture"
    //  * @param result flutter method channel result to send the response to the client
    //  */
    // public void getUserData(String fields, final MethodChannel.Result result) {
    //     GraphRequest request = GraphRequest.newMeRequest(
    //             AccessToken.getCurrentAccessToken(),
    //             new GraphRequest.GraphJSONObjectCallback() {
    //                 @Override
    //                 public void onCompleted(JSONObject object, GraphResponse response) {
    //                     try {
    //                         result.success(object.toString());
    //                     } catch (Exception e) {
    //                         result.error("FAILED", e.getMessage(), null);
    //                     }

    //                 }
    //             });
    //     Bundle parameters = new Bundle();
    //     parameters.putString("fields", fields);
    //     request.setParameters(parameters);
    //     request.executeAsync();
    // }


    // /**
    //  * @param accessToken a instance of Facebook SDK AccessToken
    //  * @return a HashMap data
    //  */
    // static HashMap<String, Object> getAccessToken(final AccessToken accessToken) {
    //     return new HashMap<String, Object>() {{
    //         put("token", accessToken.getToken());
    //         put("userId", accessToken.getUserId());
    //         put("expires", accessToken.getExpires().getTime());
    //         put("applicationId", accessToken.getApplicationId());
    //         put("lastRefresh", accessToken.getLastRefresh().getTime());
    //         put("graphDomain", accessToken.getGraphDomain());
    //         put("isExpired", accessToken.isExpired());
    //         put("grantedPermissions", new ArrayList<>(accessToken.getPermissions()));
    //         put("declinedPermissions", new ArrayList<>(accessToken.getDeclinedPermissions()));
    //     }};
    // }
}

