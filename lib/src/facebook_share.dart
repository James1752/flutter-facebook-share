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

  Future<void> get shareFaceBook async {
    await _channel.invokeMethod("shareFaceBook");
  }
}
