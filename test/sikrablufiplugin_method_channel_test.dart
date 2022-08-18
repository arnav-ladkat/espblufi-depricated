import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikrablufiplugin/sikrablufiplugin_method_channel.dart';

void main() {
  MethodChannelSikrablufiplugin platform = MethodChannelSikrablufiplugin();
  const MethodChannel channel = MethodChannel('sikrablufiplugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
