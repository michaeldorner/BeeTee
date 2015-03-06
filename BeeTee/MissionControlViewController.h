//
//  MissionControlViewController.h
//  BeeTee
//
//  Created by Michael Dorner on 03.01.15.
//  Copyright (c) 2015 Michael Dorner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDBluetoothManager.h"

@interface MissionControlViewController : UITableViewController<MDBluetoothObserverProtocol>

- (void)receivedBluetoothNotification:(MDBluetoothNotification)bluetoothNotification;

@end
