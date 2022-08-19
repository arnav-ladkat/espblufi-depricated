import 'dart:typed_data';

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
