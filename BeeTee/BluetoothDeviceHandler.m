/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

#import "BluetoothDeviceHandler.h"
#import "BluetoothDevice.h"


@interface BluetoothDeviceHandler ()

@property (strong, nonatomic, readwrite) NSString* name;
@property (strong, nonatomic, readwrite) NSString* address;
@property (assign, nonatomic, readwrite) NSUInteger majorClass;
@property (assign, nonatomic, readwrite) NSUInteger minorClass;
@property (assign, nonatomic, readwrite) NSInteger type;
@property (assign, nonatomic, readwrite) BOOL supportsBatteryLevel;

@end


@implementation BluetoothDeviceHandler

- (instancetype)initWithNotification:(NSNotification*) notification {
    BluetoothDevice *bluetoothDevice = [notification object];
    
    self = [super init];
    if (self) {
        self.name = bluetoothDevice.name;
        self.address = bluetoothDevice.address;
        self.majorClass = bluetoothDevice.majorClass;
        self.minorClass = bluetoothDevice.minorClass;
        self.type = bluetoothDevice.type;
        self.supportsBatteryLevel = bluetoothDevice.supportsBatteryLevel;
    }
    return self;
}

@end
