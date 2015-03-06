//
//  DeviceListingViewController.h
//  BluetoothScanner
//
//  Created by Michael Dorner on 12.10.13.
//  Copyright (c) 2013 Michael Dorner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDBluetoothManager.h"

@interface DeviceListingViewController : UITableViewController<MDBluetoothObserverProtocol>

- (void)receivedBluetoothNotification:(MDBluetoothNotification)bluetoothNotification;

@end
