import 'package:flutter_test/flutter_test.dart';
import 'package:espblufi/espblufi.dart';
import 'package:espblufi/espblufi_platform_interface.dart';
import 'package:espblufi/espblufi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockespblufiPlatform
    with MockPlatformInterfaceMixin
    implements espblufiPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final espblufiPlatform initialPlatform = espblufiPlatform.instance;

  test('$MethodChannelespblufi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelespblufi>());
  });

  test('getPlatformVersion', () async {
    espblufi espblufiPlugin = espblufi();
    MockespblufiPlatform fakePlatform = MockespblufiPlatform();
    espblufiPlatform.instance = fakePlatform;

    expect(await espblufiPlugin.getPlatformVersion(), '42');
  });
}
