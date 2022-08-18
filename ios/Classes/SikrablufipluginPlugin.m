#import "SikrablufipluginPlugin.h"
#import "BlufiLibrary/BlufiClient.h"
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@interface SikrablufipluginPlugin() <CBCentralManagerDelegate, CBPeripheralDelegate, BlufiDelegate>
@property(strong, nonatomic)BlufiClient *blufiClient;
@property(assign, atomic)BOOL connected;
@property(nonatomic, retain) SikrablufipluginPluginStreamHandler *stateStreamHandler;
@end

@implementation SikrablufipluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sikrablufiplugin"
            binaryMessenger:[registrar messenger]];
    

  SikrablufipluginPlugin* instance = [[SikrablufipluginPlugin alloc] init];

  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else {
    result(FlutterMethodNotImplemented);
  }
}



- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
}


- (void)connect:(NSString*) device_uuid {
    if (_blufiClient) {
        [_blufiClient close];
        _blufiClient = nil;
    }
    
    _blufiClient = [[BlufiClient alloc] init];
    _blufiClient.centralManagerDelete = self;
    _blufiClient.peripheralDelegate = self;
    _blufiClient.blufiDelegate = self;
    [_blufiClient connect:device_uuid];
}


-(void)configWifiParams:(FlutterMethodCall*)call {
    BlufiConfigureParams *params = [[BlufiConfigureParams alloc] init];
    params.opMode = 1;
    params.staSsid=call.arguments[@"name"];
    params.staPassword=call.arguments[@"pass"];
    [ _blufiClient configure:params];
    NSLog(@"Config sent");
}



@end
