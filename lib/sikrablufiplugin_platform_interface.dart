import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sikrablufiplugin_method_channel.dart';

abstract class SikrablufipluginPlatform extends PlatformInterface {
  /// Constructs a SikrablufipluginPlatform.
  SikrablufipluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SikrablufipluginPlatform _instance = MethodChannelSikrablufiplugin();

  /// The default instance of [SikrablufipluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSikrablufiplugin].
  static SikrablufipluginPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SikrablufipluginPlatform] when
  /// they register themselves.
  static set instance(SikrablufipluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
