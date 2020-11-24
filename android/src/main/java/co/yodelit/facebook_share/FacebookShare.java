package co.yodelit.facebook_share;

import android.app.Activity;
import com.facebook.share.model.ShareHashtag;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.webkit.URLUtil;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;


public class FacebookShare {

    void isFacebookInstalled(Activity activity, MethodChannel.Result result) {
        final boolean isFbInstalled = isPackageInstalled(activity);
        result.success(isFbInstalled);
    }

    void shareLinkFacebook(String url, String quote, String hashTag,  MethodChannel.Result result, Activity activity){
        ShareLinkContent.Builder contentBuilder;
        ShareDialog shareDialog = new ShareDialog(activity);
        if(url != null && !url.trim().isEmpty() && URLUtil.isValidUrl(url)) {
            contentBuilder = new ShareLinkContent.Builder().setContentUrl(Uri.parse(url));
        } else {
            Map<String, Object> data = new HashMap<String, Object>() {{
                put("error", true);
                put("message", "Invalid Url");
            }};
            result.success(data);
            return;
        }
        if(quote != null && !quote.trim().isEmpty()) {
            contentBuilder.setQuote(quote);
        }
        if(hashTag != null && !hashTag.trim().isEmpty()) {
            contentBuilder.setShareHashtag(new ShareHashtag.Builder().setHashtag(hashTag).build());
        }
        ShareLinkContent content = contentBuilder.build();

        if (ShareDialog.canShow(ShareLinkContent.class)) {
            shareDialog.show(content);
            return;
        }
        Map<String, Object> data = new HashMap<String, Object>() {{
            put("error", true);
            put("message", "Unexpected error has occurred");
        }};
        result.success(data);
    }

    private static boolean isPackageInstalled(Activity c) {
        PackageManager pm = c.getPackageManager();
        try {
            PackageInfo info = pm.getPackageInfo("com.facebook.katana", PackageManager.GET_META_DATA);
        } catch (NameNotFoundException e) {
            return false;
        }
        return true;
    }

}

