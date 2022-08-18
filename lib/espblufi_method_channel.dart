import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'espblufi_platform_interface.dart';

/// An implementation of [espblufiPlatform] that uses method channels.
class MethodChannelespblufi extends espblufiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('espblufi');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // uint8list datatype to allow for only protobuf encoded streams
  Future<void> sendCustomData(Uint8List data) async {
    final String? result =
        await methodChannel.invokeMethod('sendCustomData', {'data', data});
    debugPrint(result);
  }
}
