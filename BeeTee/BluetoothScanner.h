//
//  BluetoothScanner.h
//  BluetoothScanner
//
//  Created by Michael Dorner on 12.10.13.
//  Copyright (c) 2013 Michael Dorner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BluetoothDevice;


@protocol BluetoothScannerProtocol <NSObject>

- (void)addBluetoothDevice:(BluetoothDevice *)bluetoothDevice;
- (void)removeBluetoothDevice:(BluetoothDevice *)bluetoothDevice;

@end



@interface BluetoothScanner : NSObject

@property (assign, nonatomic, readonly) BOOL isScanning;

- (id)initWithDelegate:(id<BluetoothScannerProtocol>)delegate;

@end
