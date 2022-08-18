import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'espblufi_method_channel.dart';

abstract class espblufiPlatform extends PlatformInterface {
  /// Constructs a espblufiPlatform.
  espblufiPlatform() : super(token: _token);

  static final Object _token = Object();

  static espblufiPlatform _instance = MethodChannelespblufi();

  /// The default instance of [espblufiPlatform] to use.
  ///
  /// Defaults to [MethodChannelespblufi].
  static espblufiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [espblufiPlatform] when
  /// they register themselves.
  static set instance(espblufiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
