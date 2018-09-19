//
//  BeeTeeNotification.swift
//  BeeTee
//
//  Created by Can Sürmeli on 28.04.2018.
//  Copyright © 2018 Michael Dorner. All rights reserved.
//

// TODO: Conform this enum to `CaseIterable` when Swift 4.2 is released.
enum BeeTeeNotification: String {
	case PowerChanged               = "BluetoothPowerChangedNotification"
	case AvailabilityChanged        = "BluetoothAvailabilityChangedNotification"
	case DeviceDiscovered           = "BluetoothDeviceDiscoveredNotification"
	case DeviceRemoved              = "BluetoothDeviceRemovedNotification"
	case ConnectabilityChanged      = "BluetoothConnectabilityChangedNotification"
	case DeviceUpdated              = "BluetoothDeviceUpdatedNotification"
	case DiscoveryStateChanged      = "BluetoothDiscoveryStateChangedNotification"
	case DeviceConnectSuccess       = "BluetoothDeviceConnectSuccessNotification"
	case ConnectionStatusChanged    = "BluetoothConnectionStatusChangedNotification"
	case DeviceDisconnectSuccess    = "BluetoothDeviceDisconnectSuccessNotification"
	
	public static let allNotifications: [BeeTeeNotification] = [.PowerChanged,
																															.AvailabilityChanged,
																															.DeviceDiscovered,
																															.DeviceRemoved,
																															.ConnectabilityChanged,
																															.DeviceUpdated,
																															.DiscoveryStateChanged,
																															.DeviceConnectSuccess,
																															.ConnectionStatusChanged,
																															.DeviceDisconnectSuccess]
}
