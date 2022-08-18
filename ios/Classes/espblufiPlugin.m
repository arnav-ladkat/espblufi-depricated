#import "espblufiPlugin.h"
#import "BlufiLibrary/BlufiClient.h"
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@interface espblufiPlugin() <CBCentralManagerDelegate, CBPeripheralDelegate, BlufiDelegate>
@property(strong, nonatomic)BlufiClient *blufiClient;
@property(assign, atomic)BOOL connected;
@property(strong, nonatomic)FlutterMethodChannel *channel;
@property(nonatomic, retain) espblufiPluginStreamHandler *stateStreamHandler;
@end

@implementation espblufiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"espblufi"
            binaryMessenger:[registrar messenger]];
    

  espblufiPlugin* instance = [[espblufiPlugin alloc] init];
    instance->_channel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else if([@"tryConnecting" isEqualToString:call.method]){
      /**
       general setup of blufi object, not setting device here.
       Ideally, postPackcageLengthLImit should be in a build config file/ option.
       Delegates have been moved to one single class : BlufiHelper for ease of use.
       */
      self->_blufiClient = [[BlufiClient alloc] init];
      self->_blufiClient.blufiDelegate = self;
      self->_blufiClient.centralManagerDelete = self;
      self->_blufiClient.peripheralDelegate = self;
      self->_blufiClient.postPackageLengthLimit = 128;
      [self connect:call.arguments[@"deviceId"]];
      result(nil);
  }
  else if ([@"scanAccessPoints" isEqualToString:call.method]){
      NSLog(@"Requesting Scan");
      [self->_blufiClient requestDeviceScan];
      NSLog(@"Requested Scan");
      result(nil);
  }
  
  else if([@"configure" isEqualToString:call.method]){
      NSLog(@"Configuring Params");
      [self configWifiParams:call];
      result(nil);
  }
  else if([@"sendCustomData" isEqualToString:call.method]){
      NSLog(@"Sending Custom Data");
      // data is uint8list on flutter side, and FlutterStandardTypedData on ios side.
      [self->_blufiClient
       postCustomData: [FlutterStandardTypedData
                        typedDataWithBytes:
                            [call.arguments[@"data"] data]]
          .data];
      result(nil);
  }
  else {
      NSLog(@"Not implemented");
      result(nil);
  }{
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


- (void)blufi:(BlufiClient *)client didReceiveDeviceScanResponse:(nullable NSArray<BlufiScanResponse *> *)scanResults status:(BlufiStatusCode)status {
   // status is the result: "0" - successful, otherwise - failed.
   
   if (status == StatusSuccess) {
       NSString* res = @"Recieved Wifi Scan results \n";
       for (BlufiScanResponse *response in scanResults) {
           res = [res stringByAppendingFormat:@"ssid: %@, rssi: %i \n", response.ssid, response.rssi];
       }
       NSLog(@"%@", res);
       [_channel invokeMethod:@"Recievedwifi" arguments:res];
   }
   else {
       [_channel invokeMethod:@"Recievedwifi" arguments:@"Device scan result error"];
       NSLog(@"Device scan result error");
   }
}

- (void)updateMessage:(NSString *)message {
    NSLog(@"%@", message);
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self updateMessage:@"Connected device"];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self updateMessage:@"Connet device failed"];
    self.connected = NO;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self onDisconnected];
    [self updateMessage:@"Disconnected device"];
    _connected = NO;
}

- (void)blufi:(BlufiClient *)client gattPrepared:(BlufiStatusCode)status service:(CBService *)service writeChar:(CBCharacteristic *)writeChar notifyChar:(CBCharacteristic *)notifyChar {
    NSLog(@"Blufi gattPrepared status:%d", status);
    if (status == StatusSuccess) {
        [_channel invokeMethod:@"onConnect" arguments:@""];
        self.connected = YES;
        [self updateMessage:@"BluFi connection has prepared"];
    } else {
        [self onDisconnected];
        if (!service) {
            [self updateMessage:@"Discover service failed"];
        } else if (!writeChar) {
            [self updateMessage:@"Discover write char failed"];
        } else if (!notifyChar) {
            [self updateMessage:@"Discover notify char failed"];
        }
    }
}

- (void)blufi:(BlufiClient *)client didNegotiateSecurity:(BlufiStatusCode)status {
    NSLog(@"Blufi didNegotiateSecurity %d", status);
    if (status == StatusSuccess) {
        [self updateMessage:@"Negotiate security complete"];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Negotiate security failed: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didReceiveDeviceVersionResponse:(BlufiVersionResponse *)response status:(BlufiStatusCode)status {
    if (status == StatusSuccess) {
        [self updateMessage:[NSString stringWithFormat:@"Receive device version: %@", response.getVersionString]];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Receive device version error: %d", status]];
    }
}
 
- (void)blufi:(BlufiClient *)client didPostConfigureParams:(BlufiStatusCode)status {
    if (status == StatusSuccess) {
        [_channel invokeMethod:@"configParamsComplete" arguments:@""];
        [self updateMessage:@"Post configure params complete"];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Post configure params failed: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didReceiveDeviceStatusResponse:(BlufiStatusResponse *)response status:(BlufiStatusCode)status {
    if (status == StatusSuccess) {
        [self updateMessage:[NSString stringWithFormat:@"Receive device status:\n%@", response.getStatusInfo]];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Receive device status error: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didReceiveCustomData:(nonnull NSData *)data status:(BlufiStatusCode)status{
    NSString *customString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self updateMessage:[NSString stringWithFormat:@"Receive device custom data: %@", customString]];
    
    [_channel invokeMethod:@"recievedCustomData" arguments:customString];
}

- (void)onDisconnected {
    if (_blufiClient) {
        [_blufiClient close];
    }
    [_channel invokeMethod:@"onDisconnect" arguments:@"Disconnected" ];
}

@end
