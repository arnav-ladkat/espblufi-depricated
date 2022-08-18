import 'espblufi_platform_interface.dart';

class espblufi {
  Future<String?> getPlatformVersion() {
    return espblufiPlatform.instance.getPlatformVersion();
  }
}
