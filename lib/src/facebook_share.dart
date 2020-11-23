import 'package:flutter/services.dart';

class FacebookShare {
  FacebookShare._internal(); // private constructor for singletons
  final MethodChannel _channel = MethodChannel('co.yodelit.yodel/fb');
  static FacebookShare _instance = FacebookShare._internal();

  static FacebookShare get instance =>
      _instance; // return the same instance of FacebookAuth

  Future<bool> get isFacebookInstalled async {
    final result = await _channel.invokeMethod("isFacebookInstalled");
    if (result != null) {
      return result;
    }
    return false;
  }

  Future<FacebookShareResult> shareFaceBookLink(String url, String quote,
      {String hashTag}) async {
    var data = Map<String, dynamic>();
    data.putIfAbsent("url", () => url);
    data.putIfAbsent("quote", () => quote);
    if (hashTag != null) data.putIfAbsent("hashTag", () => hashTag);
    final result = await _channel.invokeMethod("shareFaceBookLink", data);
    if (result != null) {
      return FacebookShareResult(result["error"], result["message"]);
    }
    return FacebookShareResult(true, "Unknown error occured");
  }

  Future<FacebookShareResult> shareFaceBookImage() async {
    final result = await _channel.invokeMethod("shareFaceBookImage");
    if (result != null) {
      return FacebookShareResult(result["error"], result["message"]);
    }
    return FacebookShareResult(true, "Unknown error occured");
  }
}

class FacebookShareResult {
  final bool error;
  final String message;

  FacebookShareResult(this.error, this.message);
}
