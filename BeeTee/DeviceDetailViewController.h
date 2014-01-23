//
//  DeviceDetailViewController.h
//  BluetoothScanner
//
//  Created by Michael Dorner on 12.10.13.
//  Copyright (c) 2013 Michael Dorner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BluetoothManager/BluetoothDevice.h>

@interface DeviceDetailViewController : UITableViewController

- (void)setBluetoothDevices:(BluetoothDevice *)device;

@end
