//
//  MDBluetoothDevice.m
//  BeeTee
//
//  Created by Michael Dorner on 02.01.15.
//  Copyright (c) 2015 Michael Dorner. All rights reserved.
//

#import "MDBluetoothDevice.h"
#import <BluetoothManager/BluetoothDevice.h>

@interface MDBluetoothDevice ()

@property (strong, nonatomic, readwrite) NSString* name;
@property (strong, nonatomic, readwrite) NSString* address;
@property (assign, nonatomic, readwrite) NSUInteger majorClass;
@property (assign, nonatomic, readwrite) NSUInteger minorClass;
@property (assign, nonatomic, readwrite) NSInteger type;
@property (assign, nonatomic, readwrite) BOOL supportsBatteryLebel;
@property (strong, nonatomic, readwrite) NSDate* detectingDate;

- (instancetype)initWithBluetoothDevice:(BluetoothDevice*)bluetoothDevice;

@end

@implementation MDBluetoothDevice

- (instancetype)initWithBluetoothDevice:(BluetoothDevice*)bluetoothDevice
{
    self = [super init];
    _name = bluetoothDevice.name;
    _address = bluetoothDevice.address;
    _majorClass = bluetoothDevice.majorClass;
    _minorClass = bluetoothDevice.minorClass;
    _type = bluetoothDevice.type;
    _supportsBatteryLevel = bluetoothDevice.supportsBatteryLevel;
    _detectingDate = [[NSDate alloc] init];

    return self;
}

- (BOOL)isEqualToBluetoothDevice:(MDBluetoothDevice*)bluetoothDevice
{
    if (!bluetoothDevice) {
        return NO;
    }
    return [self.address isEqualToString:bluetoothDevice.address];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[MDBluetoothDevice class]]) {
        return NO;
    }
    return [self isEqualToBluetoothDevice:object];
}

- (NSUInteger)hash
{
    return [self.address hash];
}

@end
