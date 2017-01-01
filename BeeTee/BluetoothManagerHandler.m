/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

#import "BluetoothManagerHandler.h"
#import "BluetoothManager.h"

static BluetoothManager *_bluetoothManager = nil;
static BluetoothManagerHandler *_handler = nil;

@implementation BluetoothManagerHandler


+ (BluetoothManagerHandler*) sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/BluetoothManager.framework"];
        if (![b load]) {
            NSLog(@"Error"); // maybe throw an exception
        } else {
            _bluetoothManager = [NSClassFromString(@"BluetoothManager") valueForKey:@"sharedInstance"];
            _handler = [[BluetoothManagerHandler alloc] init];
        }
    });
    return _handler;
}


- (bool) powered {
    return [_bluetoothManager powered];
}


- (void) setPower: (bool)powerStatus {
    [_bluetoothManager setPowered:powerStatus];
}


- (void) startScan {
    [_bluetoothManager setDeviceScanningEnabled: true];
    [_bluetoothManager scanForServices: 0xFFFFFFFF];
}


- (void) stopScan {
    [_bluetoothManager setDeviceScanningEnabled: false];
}


- (bool)isScanning {
    return [_bluetoothManager deviceScanningEnabled];
}


- (bool)enabled {
    return [_bluetoothManager enabled];
}

- (void)disable {
    [_bluetoothManager setEnabled:false];
}

- (void)enable {
    [_bluetoothManager setEnabled:true];
}

@end
