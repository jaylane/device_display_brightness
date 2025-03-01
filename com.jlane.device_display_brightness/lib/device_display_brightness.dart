import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A Flutter plugin to control display brightness and keep the screen on.
class DeviceDisplayBrightness {
  static const MethodChannel _channel =
      const MethodChannel('device_display_brightness');

  /// Get the current brightness level of the device.
  ///
  /// Returns a value between 0.0 and 1.0, where 0.0 is the minimum
  /// brightness and 1.0 is the maximum brightness.
  static Future<double> get brightness async {
    final double brightness = await _channel.invokeMethod('getBrightness');
    return brightness;
  }

  /// Set the brightness level of the device.
  ///
  /// [brightness] should be a value between 0.0 and 1.0, where 0.0 is the minimum
  /// brightness and 1.0 is the maximum brightness.
  static Future<void> setBrightness(double brightness) async {
    assert(brightness >= 0.0 && brightness <= 1.0);
    await _channel.invokeMethod('setBrightness', {'brightness': brightness});
  }

  /// Keep the screen on (prevent it from turning off due to inactivity).
  ///
  /// [on] determines whether to keep the screen on (true) or allow it to turn off (false).
  static Future<void> keepOn(bool on) async {
    await _channel.invokeMethod('keepOn', {'on': on});
  }

  /// Check if the device has permission to change the brightness.
  ///
  /// Returns true if the app has permission to change the brightness,
  /// or false otherwise. On iOS, this always returns true as no special
  /// permission is required.
  static Future<bool> get hasPermission async {
    if (Platform.isIOS) {
      return true;
    }
    final bool hasPermission = await _channel.invokeMethod('hasPermission');
    return hasPermission;
  }

  /// Request permission to change the screen brightness.
  ///
  /// On Android, this will prompt the user to grant the WRITE_SETTINGS permission.
  /// On iOS, this does nothing and returns true immediately as no special
  /// permission is required.
  ///
  /// Returns true if the permission was granted, false otherwise.
  static Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      return true;
    }
    final bool granted = await _channel.invokeMethod('requestPermission');
    return granted;
  }

  /// Get the current version of the plugin.
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
