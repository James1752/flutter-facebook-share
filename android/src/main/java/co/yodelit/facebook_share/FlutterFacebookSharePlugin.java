package co.yodelit.facebook_share;

import androidx.annotation.NonNull;

import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import androidx.annotation.NonNull;


public class FlutterFacebookSharePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private static final String CHANNEL_NAME = "co.yodelit.yodel/fb";
    private FacebookShare facebookShare = new FacebookShare();
    private ActivityPluginBinding activityPluginBinding;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "isFacebookInstalled":
            facebookShare.isFacebookInstalled(this.activityPluginBinding.getActivity(), result);
                break;
            case "shareFaceBookLink":
              
                break;

            case "shareFaceBookImage":
              
                break;

            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
      channel.setMethodCallHandler(null);
    }

}
