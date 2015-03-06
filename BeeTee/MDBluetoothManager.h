//
//  MDBluetoothManager.h
//  BeeTee
//
//  Created by Michael Dorner on 02.01.15.
//  Copyright (c) 2015 Michael Dorner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDBluetoothDevice.h"
#import "MDBluetoothObserver.h"

@interface MDBluetoothManager : NSObject

+ (MDBluetoothManager*)sharedInstance;

- (BOOL)bluetoothIsAvailable;

- (void)turnBluetoothOn;
- (BOOL)bluetoothIsPowered;
- (void)turnBluetoothOff;

- (void)startScan;
- (BOOL)isScanning;
- (void)endScan;
- (NSArray*)discoveredBluetoothDevices;

- (void)registerObserver:(id<MDBluetoothObserverProtocol>)observer;
- (void)unregisterObserver:(id<MDBluetoothObserverProtocol>)observer;

@end
