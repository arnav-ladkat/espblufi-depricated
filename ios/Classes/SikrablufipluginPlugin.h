#if TARGET_OS_OSX
 #import <FlutterMacOS/FlutterMacOS.h>
#else
 #import <Flutter/Flutter.h>
#endif
#import <CoreBluetooth/CoreBluetooth.h>




#import <Flutter/Flutter.h>

@interface SikrablufipluginPlugin : NSObject<FlutterPlugin>
@end

@interface SikrablufipluginPluginStreamHandler : NSObject<FlutterStreamHandler>
@property FlutterEventSink sink;
@end