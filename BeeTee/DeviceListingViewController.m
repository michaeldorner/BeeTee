//
//  DeviceListingViewController.m
//  BluetoothScanner
//
//  Created by Michael Dorner on 12.10.13.
//  Copyright (c) 2013 Michael Dorner. All rights reserved.
//

#import "DeviceListingViewController.h"
#import "DeviceDetailViewController.h"

@interface DeviceListingViewController ()

@end

@implementation DeviceListingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[MDBluetoothManager sharedInstance] registerObserver:self];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate methods

- (void)receivedBluetoothNotification:(MDBluetoothNotification)bluetoothNotification
{
    // NSArray *detectedBluetoothDevices = [[MDBluetoothManager sharedInstance] discoveredBluetoothDevices];
    // MDBluetoothDevice *bluetoothDevice = [detectedBluetoothDevices lastObject];

    switch (bluetoothNotification) {
        case MDBluetoothDeviceDiscoveredNotification:
            [self.tableView reloadData];
            break;
        case MDBluetoothDeviceRemovedNotification:
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[[MDBluetoothManager sharedInstance] discoveredBluetoothDevices] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"DeviceCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSArray* detectedBluetoothDevices = [[MDBluetoothManager sharedInstance] discoveredBluetoothDevices];
    MDBluetoothDevice* bluetoothDevice = [detectedBluetoothDevices objectAtIndex:indexPath.row];

    cell.textLabel.text = bluetoothDevice.name;
    cell.detailTextLabel.text = bluetoothDevice.address;

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    UITableViewCell* cell = (UITableViewCell*)sender;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];

    NSArray* detectedBluetoothDevices = [[MDBluetoothManager sharedInstance] discoveredBluetoothDevices];
    MDBluetoothDevice* bluetoothDevice = [detectedBluetoothDevices objectAtIndex:indexPath.row];

    DeviceDetailViewController* deviceDetailViewController = [segue destinationViewController];
    [deviceDetailViewController setBluetoothDevices:bluetoothDevice];
}

@end
