//
//  BluetoothScanner.m
//  BluetoothScanner
//
//  Created by Michael Dorner on 12.10.13.
//  Copyright (c) 2013 Michael Dorner. All rights reserved.
//

#import "BluetoothScanner.h"
#import <BluetoothManager/BluetoothManager.h>
#import <BluetoothManager/BluetoothDevice.h>


@interface BluetoothScanner ()

@property (retain, nonatomic) BluetoothManager *bluetoothManager;
@property (assign, nonatomic, readwrite) BOOL isScanning;
@property (retain, nonatomic) NSMutableDictionary *currentDevices;
@property (retain, nonatomic) id<BluetoothScannerProtocol> delegate;

- (void)addNotification;

@end


@implementation BluetoothScanner

- (id)initWithDelegate:(id<BluetoothScannerProtocol>)delegate
{
    self = [super init];
    if (self) {
        _isScanning = NO;
        _currentDevices = [[NSMutableDictionary alloc] init];
        _bluetoothManager = [BluetoothManager sharedInstance]; //  necessary, do not remove this line, although it is a singleton
        self.delegate = delegate;
        [self addNotification];
    }
    return self;
}


- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothPowerChanged:) name:@"BluetoothPowerChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothAvailabilityChanged:) name:@"BluetoothAvailabilityChangedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceDiscovered:) name:@"BluetoothDeviceDiscoveredNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceRemoved:) name:@"BluetoothDeviceRemovedNotification" object:nil];


    // all available notifications belonging to BluetoothManager I could figure out - not used and therefore implemented in this demo app
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothPowerChanged:) name:@"BluetoothPowerChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothConnectabilityChanged:) name:@"BluetoothConnectabilityChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceUpdated:) name:@"BluetoothDeviceUpdatedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDiscoveryStateChanged:) name:@"BluetoothDiscoveryStateChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceDiscovered:) name:@"BluetoothDeviceDiscoveredNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceConnectSuccess:) name:@"BluetoothDeviceConnectSuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothConnectionStatusChanged:) name:@"BluetoothConnectionStatusChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceDisconnectSuccess:) name:@"BluetoothDeviceDisconnectSuccessNotification" object:nil];
    */
    
    
    // this helped me very much to figure out the methods mentioned the lines above
    /*
    // credits to http://stackoverflow.com/a/3738387/1864294 :
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),
                                    NULL,
                                    notificationCallback,
                                    NULL,
                                    NULL,  
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    */
}


void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    if ([(NSString*)name characterAtIndex:0] == 'B') { // notice only notification they are associated with the BluetoothManager.framework
        NSLog(@"Callback detected: \n\t name: %@ \n\t object:%@", name, object);
    }
}


- (void)bluetoothAvailabilityChanged:(NSNotification *)notification
{
    if (![self.bluetoothManager enabled]) {
        [self.bluetoothManager setEnabled:YES]; // automatically turn bluetooth on
    }
    else {
        [self.bluetoothManager setDeviceScanningEnabled:YES];
        [self.bluetoothManager scanForServices:0xFFFFFFFF];
    }
}


- (void)bluetoothPowerChanged:(NSNotification *)notification
{
    if ([self.bluetoothManager enabled]) {
        [self.bluetoothManager setDeviceScanningEnabled:YES];
        [self.bluetoothManager scanForServices:0xFFFFFFFF];
    }
}



- (void)bluetoothDeviceDiscovered:(NSNotification *)notification
{
    BluetoothDevice *device = (BluetoothDevice *)[notification object];
    [self.delegate addBluetoothDevice:[device copy]];
    
    // Log it
    //NSLog(@"Name: %@\nAddress: %@\nMajorClass: %u\nMinorClass:%u\nType:%d\nBatteryLevelSupport:%hhd", device.name, device.address, device.majorClass, device.minorClass, device.type, device.supportsBatteryLevel);
    
}


- (void)bluetoothDeviceRemoved:(NSNotification *)notification
{
    BluetoothDevice *device = (BluetoothDevice *)[notification object];
    [self.delegate removeBluetoothDevice:device];

}





@end
