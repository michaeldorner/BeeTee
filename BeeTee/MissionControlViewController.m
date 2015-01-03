//
//  MissionControlViewController.m
//  BeeTee
//
//  Created by Michael Dorner on 03.01.15.
//  Copyright (c) 2015 Michael Dorner. All rights reserved.
//

#import "MissionControlViewController.h"
#import "MDBluetoothManager.h"

@interface MissionControlViewController ()

@property (retain, nonatomic) IBOutlet UISwitch *bluetoothSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *scanModeSwitch;

- (IBAction)toggleBluetooth:(UISwitch *)sender;
- (IBAction)toggleScanMode:(UISwitch *)sender;

@end



@implementation MissionControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[MDBluetoothManager sharedInstance] registerObserver:self];
    
    [self.bluetoothSwitch setOn:[[MDBluetoothManager sharedInstance] bluetoothIsPowered]];
    [self.scanModeSwitch setOn:[[MDBluetoothManager sharedInstance] isScanning]];
}


- (void)dealloc {
    [_bluetoothSwitch release];
    [_scanModeSwitch release];
    [super dealloc];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)receivedBluetoothNotification:(MDBluetoothNotification)bluetoothNotification
{
    BOOL isPowered = [[MDBluetoothManager sharedInstance] bluetoothIsPowered];
    switch (bluetoothNotification) {
        case MDBluetoothAvailabilityChangedNotification:
            [self.bluetoothSwitch setOn:isPowered];
            break;
        case MDBluetoothPowerChangedNotification:
            [self.bluetoothSwitch setOn:isPowered];
            break;
        default:
            break;
    }
}


- (IBAction)toggleBluetooth:(UISwitch *)sender {
    [sender isOn] ? [[MDBluetoothManager sharedInstance] turnBluetoothOn] : [[MDBluetoothManager sharedInstance] turnBluetoothOff];
}


- (IBAction)toggleScanMode:(UISwitch *)sender {
    [sender isOn] ? [[MDBluetoothManager sharedInstance] startScan] : [[MDBluetoothManager sharedInstance] endScan];
}
@end
