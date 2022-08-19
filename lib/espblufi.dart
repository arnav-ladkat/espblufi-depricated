import 'dart:typed_data';

import 'espblufi_platform_interface.dart';

class Espblufi {
  Future<String?> getPlatformVersion() {
    return EspblufiPlatform.instance.getPlatformVersion();
  }

  Future<void> requestConnection(String deviceID) {
    return EspblufiPlatform.instance.requestConnection(deviceID);
  }

  Future<void> sendCustomData(Uint8List data) {
    return EspblufiPlatform.instance.sendCustomData(data);
  }
}
