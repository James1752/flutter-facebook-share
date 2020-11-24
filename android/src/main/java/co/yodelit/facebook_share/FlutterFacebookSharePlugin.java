package co.yodelit.facebook_share;

import android.app.Activity;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterFacebookSharePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String CHANNEL_NAME = "co.yodelit.yodel/fb";
    private final FacebookShare facebookShare = new FacebookShare();
    private Activity activity;

    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        activity = null;
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "isFacebookInstalled":
                facebookShare.isFacebookInstalled(activity, result);
                break;
            case "shareFaceBookLink":
                final Map<String, Object> args = call.arguments();
                String url = (String) args.get("url");
                String quote = (String) args.get("quote");
                String hashTag = (String) args.get("hashTag");
                facebookShare.shareLinkFacebook(url, quote, hashTag, result, activity);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {

    }
}
