package co.yodelit.facebook_share;

import android.app.Activity;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareHashtag;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.webkit.URLUtil;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;


public class FacebookShare {

    void isFacebookInstalled(Activity activity, MethodChannel.Result result) {
        final boolean isFbInstalled = isPackageInstalled(activity);
        result.success(isFbInstalled);
    }

    void shareLinkFacebook(ShareLinkData data, final MethodChannel.Result res, Activity activity, CallbackManager callbackManager) {

        ShareDialog shareDialog = new ShareDialog(activity);
        shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                replyResult(false, "Successful Post", res);
            }

            @Override
            public void onCancel() {
                replyResult(true, "User cancelled sharing", res);
            }

            @Override
            public void onError(FacebookException error) {

            }
        });
        ShareLinkContent content = createLinkContent(data.getUrl(), data.getQuote(), data.getHashTag(), res);

        if (ShareDialog.canShow(ShareLinkContent.class)) {
            shareDialog.show(content);
            return;
        }
        //Fall back error
        replyResult(true, "Unexpected error has occurred", res);
    }

    private ShareLinkContent createLinkContent(String url, String quote, String hashTag, MethodChannel.Result res) {
        ShareLinkContent.Builder contentBuilder;

        if (url != null && !url.trim().isEmpty() && URLUtil.isValidUrl(url)) {
            contentBuilder = new ShareLinkContent.Builder().setContentUrl(Uri.parse(url));
        } else {
            replyResult(true, "Invalid Url", res);
            return null;
        }

        if (quote != null && !quote.trim().isEmpty()) {
            contentBuilder.setQuote(quote);
        }

        if (hashTag != null && !hashTag.trim().isEmpty()) {
            contentBuilder.setShareHashtag(new ShareHashtag.Builder().setHashtag(hashTag).build());
        }
        return contentBuilder.build();
    }


    private void replyResult(final boolean wasError, final String message, MethodChannel.Result res) {
        res.success(new HashMap<String, Object>() {{
            put("error", wasError);
            put("message", message);
        }});
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

