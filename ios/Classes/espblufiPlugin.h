#if TARGET_OS_OSX
 #import <FlutterMacOS/FlutterMacOS.h>
#else
 #import <Flutter/Flutter.h>
#endif
#import <CoreBluetooth/CoreBluetooth.h>




#import <Flutter/Flutter.h>

@interface espblufiPlugin : NSObject<FlutterPlugin>
@end

@interface espblufiPluginStreamHandler : NSObject<FlutterStreamHandler>
@property FlutterEventSink sink;
@end
