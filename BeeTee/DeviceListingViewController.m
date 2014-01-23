//
//  DeviceListingViewController.m
//  BluetoothScanner
//
//  Created by Michael Dorner on 12.10.13.
//  Copyright (c) 2013 Michael Dorner. All rights reserved.
//

#import "DeviceListingViewController.h"
#import "DeviceDetailViewController.h"
#import <BluetoothManager/BluetoothDevice.h>

@interface DeviceListingViewController ()

@property (retain, nonatomic) NSMutableDictionary *currentAvailableDevices;
@property (retain, nonatomic) BluetoothScanner *bluetoothScanner;

@end



@implementation DeviceListingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bluetoothScanner = [[BluetoothScanner alloc] initWithDelegate:(id)self];
    self.currentAvailableDevices = [[NSMutableDictionary alloc] init];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - delegate methods

- (void)addBluetoothDevice:(BluetoothDevice *)bluetoothDevice
{
    [self.currentAvailableDevices setObject:bluetoothDevice forKey:bluetoothDevice.address];
    [self.tableView reloadData];
}

- (void)removeBluetoothDevice:(BluetoothDevice *)bluetoothDevice
{
    [self.currentAvailableDevices removeObjectForKey:bluetoothDevice.address];
    [self.tableView reloadData];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.currentAvailableDevices allKeys] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BluetoothDevice *bluetoothDevice = (BluetoothDevice*)[self.currentAvailableDevices allValues][indexPath.row];
    
    cell.textLabel.text = bluetoothDevice.name;
    cell.detailTextLabel.text = bluetoothDevice.address;
    
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    UITableViewCell *cell =  (UITableViewCell *)sender;
    BluetoothDevice *bluetoothDevice = (BluetoothDevice *)[self.currentAvailableDevices objectForKey:cell.detailTextLabel.text]; // MAC address as key
    
    DeviceDetailViewController *deviceDetailViewController = [segue destinationViewController];
    [deviceDetailViewController setBluetoothDevices:bluetoothDevice];
  
}


@end
