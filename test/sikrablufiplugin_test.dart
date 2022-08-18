import 'package:flutter_test/flutter_test.dart';
import 'package:sikrablufiplugin/sikrablufiplugin.dart';
import 'package:sikrablufiplugin/sikrablufiplugin_platform_interface.dart';
import 'package:sikrablufiplugin/sikrablufiplugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSikrablufipluginPlatform 
    with MockPlatformInterfaceMixin
    implements SikrablufipluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SikrablufipluginPlatform initialPlatform = SikrablufipluginPlatform.instance;

  test('$MethodChannelSikrablufiplugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSikrablufiplugin>());
  });

  test('getPlatformVersion', () async {
    Sikrablufiplugin sikrablufipluginPlugin = Sikrablufiplugin();
    MockSikrablufipluginPlatform fakePlatform = MockSikrablufipluginPlatform();
    SikrablufipluginPlatform.instance = fakePlatform;
  
    expect(await sikrablufipluginPlugin.getPlatformVersion(), '42');
  });
}
