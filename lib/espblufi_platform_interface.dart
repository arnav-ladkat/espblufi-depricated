import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'espblufi_method_channel.dart';

abstract class EspblufiPlatform extends PlatformInterface {
  /// Constructs a espblufiPlatform.
  EspblufiPlatform() : super(token: _token);

  static final Object _token = Object();

  static EspblufiPlatform _instance = MethodChannelespblufi();

  /// The default instance of [EspblufiPlatform] to use.
  ///
  /// Defaults to [MethodChannelespblufi].
  static EspblufiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EspblufiPlatform] when
  /// they register themselves.
  static set instance(EspblufiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> sendCustomData(Uint8List data) {
    throw UnimplementedError('sendCustomData() has not been implemented.');
  }
}
