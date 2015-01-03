//
//  MDBluetoothManager.m
//  BeeTee
//
//  Created by Michael Dorner on 02.01.15.
//  Copyright (c) 2015 Michael Dorner. All rights reserved.
//

#import "MDBluetoothManager.h"
#import <BluetoothManager/BluetoothManager.h>
#import <BluetoothManager/BluetoothDevice.h>


@interface MDBluetoothManager ()

@property (strong, nonatomic) NSMutableArray *internalDiscoveredBluetoothDevices;
@property (strong, nonatomic) NSMutableArray *observers;
@property (retain, nonatomic) BluetoothManager *internalBluetoothManager;
@property (assign, nonatomic) BOOL scanRequested;
@property (assign, nonatomic, readwrite) BOOL isScanning;

- (void)bluetoothPowerChanged:(NSNotification*)notification;
- (void)bluetoothAvailabilityChanged:(NSNotification*)notification;
- (void)bluetoothDeviceDiscovered:(NSNotification*)notification;
- (void)bluetoothDeviceRemoved:(NSNotification*)notification;

- (instancetype)init;

@end



@implementation MDBluetoothManager


+ (MDBluetoothManager*)sharedInstance
{
    static MDBluetoothManager *bluetoothManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [BluetoothManager sharedInstance];
        bluetoothManager = [[MDBluetoothManager alloc] init];
    });
    return bluetoothManager;
}


- (instancetype)init
{
    if (self = [super init]) {
        _internalDiscoveredBluetoothDevices = [[NSMutableArray alloc] init];
        _observers = [[NSMutableArray alloc] init];
        _internalBluetoothManager = [BluetoothManager sharedInstance];
        _scanRequested = NO;
    }
    
    [self addNotification];
    
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
    if ([(__bridge NSString*)name characterAtIndex:0] == 'B') { // notice only notification they are associated with the BluetoothManager.framework
        NSLog(@"Callback detected: \n\t name: %@ \n\t object:%@", name, object);
    }
}


#pragma mark - class methods

- (BOOL)bluetoothIsAvailable
{
    return [[BluetoothManager sharedInstance] enabled];
}


- (void)turnBluetoothOn
{
    if (![self bluetoothIsPowered]) {
        [[BluetoothManager sharedInstance] setPowered:YES];
    }
}


- (BOOL)bluetoothIsPowered
{
    return [[BluetoothManager sharedInstance] powered];
}


- (void)turnBluetoothOff
{
    if ([self bluetoothIsPowered]) {
        [[BluetoothManager sharedInstance] setPowered:NO];
        [self.internalDiscoveredBluetoothDevices removeAllObjects];
    }
}


- (void)startScan
{
    if ([self bluetoothIsPowered]) {
        [[BluetoothManager sharedInstance] setDeviceScanningEnabled:YES];
        [[BluetoothManager sharedInstance] scanForServices:0xFFFFFFFF];
    }
}


- (BOOL)isScanning
{
    return [[BluetoothManager sharedInstance] deviceScanningEnabled];
}


- (void)endScan
{
    [[BluetoothManager sharedInstance] setDeviceScanningEnabled:NO];
    [self.internalDiscoveredBluetoothDevices removeAllObjects];
}


- (NSArray*)discoveredBluetoothDevices
{
    return [self.internalDiscoveredBluetoothDevices copy]; // make it immutable
}


#pragma mark - Observer methods

- (void)registerObserver:(id<MDBluetoothObserverProtocol>)observer
{
    [self.observers addObject:observer];
}


- (void)unregisterObserver:(id<MDBluetoothObserverProtocol>)observer
{
    [self.observers removeObject:observer];
}


#pragma mark - Bluetooth notifications

- (void)bluetoothPowerChanged:(NSNotification *)notification
{
    NSLog(@"bluetoothPowerChanged");

    for (id<MDBluetoothObserverProtocol> observer in self.observers) {
        [observer receivedBluetoothNotification:MDBluetoothPowerChangedNotification];
    }
}


- (void)bluetoothAvailabilityChanged:(NSNotification *)notification
{
    NSLog(@"bluetoothAvailabilityChanged");
    for (id<MDBluetoothObserverProtocol> observer in self.observers) {
        [observer receivedBluetoothNotification:MDBluetoothAvailabilityChangedNotification];
    }
}


- (void)bluetoothDeviceDiscovered:(NSNotification *)notification
{
    NSLog(@"bluetoothDeviceDiscovered");
    
    MDBluetoothDevice *bluetoothDevice = [[MDBluetoothDevice alloc] initWithBluetoothDevice:(BluetoothDevice *)[notification object]];
    [self.internalDiscoveredBluetoothDevices addObject:bluetoothDevice];
    
    for (id<MDBluetoothObserverProtocol> observer in self.observers) {
        [observer receivedBluetoothNotification:MDBluetoothDeviceDiscoveredNotification];
    }
}


- (void)bluetoothDeviceRemoved:(NSNotification *)notification
{
    NSLog(@"bluetoothDeviceRemoved");
    MDBluetoothDevice *bluetoothDevice = [[MDBluetoothDevice alloc] initWithBluetoothDevice:(BluetoothDevice *)[notification object]];
    [self.internalDiscoveredBluetoothDevices removeObject:bluetoothDevice];

    for (id<MDBluetoothObserverProtocol> observer in self.observers) {
        [observer receivedBluetoothNotification:MDBluetoothDeviceRemovedNotification];
    }
    
}



@end
