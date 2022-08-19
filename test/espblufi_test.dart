import 'dart:typed_data';

import 'package:espblufi/models/wifi_devices.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:espblufi/espblufi.dart';
import 'package:espblufi/espblufi_platform_interface.dart';
import 'package:espblufi/espblufi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockespblufiPlatform
    with MockPlatformInterfaceMixin
    implements EspblufiPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> sendCustomData(Uint8List data) {
    // TODO: implement sendCustomData
    throw UnimplementedError();
  }

  @override
  Future<void> configureWifi(String name, String pass) {
    // TODO: implement configureWifi
    throw UnimplementedError();
  }

  @override
  Future<void> requestConnection(String deviceID) {
    // TODO: implement requestConnection
    throw UnimplementedError();
  }

  @override
  Future<void> scanWifi() {
    // TODO: implement scanWifi
    throw UnimplementedError();
  }

  @override
  // TODO: implement wifiDevices
  Stream<List<WifiDevices>> get wifiDevices => throw UnimplementedError();
}

void main() {
  final EspblufiPlatform initialPlatform = EspblufiPlatform.instance;

  test('$MethodChannelespblufi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelespblufi>());
  });

  test('getPlatformVersion', () async {
    Espblufi espblufiPlugin = Espblufi();
    MockespblufiPlatform fakePlatform = MockespblufiPlatform();
    EspblufiPlatform.instance = fakePlatform;

    expect(await espblufiPlugin.getPlatformVersion(), '42');
  });
}
