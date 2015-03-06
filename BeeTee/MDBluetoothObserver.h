//
//  MDBluetoothObserver.h
//  BeeTee
//
//  Created by Michael Dorner on 03.01.15.
//  Copyright (c) 2015 Michael Dorner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MDBluetoothNotification : NSUInteger {
    MDBluetoothPowerChangedNotification,
    MDBluetoothAvailabilityChangedNotification,
    MDBluetoothDeviceDiscoveredNotification,
    MDBluetoothDeviceRemovedNotification,
    MDBluetoothConnectabilityChangedNotification,
    MDBluetoothDeviceUpdatedNotification,
    MDBluetoothDiscoveryStateChangedNotification,
    MDBluetoothDeviceConnectSuccessNotification,
    MDBluetoothConnectionStatusChangedNotification,
    MDBluetoothDeviceDisconnectSuccessNotification
} MDBluetoothNotification;

@protocol MDBluetoothObserverProtocol <NSObject>

@required
- (void)receivedBluetoothNotification:
        (MDBluetoothNotification)bluetoothNotification;

@end
