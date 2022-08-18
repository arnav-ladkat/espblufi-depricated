import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sikrablufiplugin_platform_interface.dart';

/// An implementation of [SikrablufipluginPlatform] that uses method channels.
class MethodChannelSikrablufiplugin extends SikrablufipluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sikrablufiplugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
