
import 'sikrablufiplugin_platform_interface.dart';

class Sikrablufiplugin {
  Future<String?> getPlatformVersion() {
    return SikrablufipluginPlatform.instance.getPlatformVersion();
  }
}
