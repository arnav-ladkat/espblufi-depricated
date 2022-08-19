import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'espblufi_platform_interface.dart';
import 'models/wifi_devices.dart';

/// An implementation of [EspblufiPlatform] that uses method channels.
class MethodChannelespblufi implements EspblufiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('espblufi');
  final logger = Logger('MethodChannelespblufi');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // uint8list datatype to allow for only protobuf encoded streams
  @override
  Future<void> sendCustomData(Uint8List data) async {
    final String? result =
        await methodChannel.invokeMethod('sendCustomData', {'data', data});
    logger.info(result);
  }

  @override
  Future<void> requestConnection(String deviceID) async {
    final String? result = await methodChannel
        .invokeMethod('tryConnecting', {'deviceId': deviceID});
    logger.info('Device ID is :$deviceID');
    logger.info(result.toString());
  }

  @override
  Future<void> scanWifi() async {
    final String? result = await methodChannel.invokeMethod('scanAccessPoints');
    logger.info(result.toString());
  }

  @override
  Future<void> configureWifi(String name, String pass) async {
    final String? result = await methodChannel
        .invokeMethod('configure', {'name': name, 'pass': pass});
    logger.info(result.toString());
  }

  @override
  // TODO: implement wifiDevices
  Stream<List<WifiDevices>> get wifiDevices => throw UnimplementedError();
}
