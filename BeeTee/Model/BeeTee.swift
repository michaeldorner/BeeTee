/*
		This file is part of the project `BeeTee`.

		It is subject to the license terms in the LICENSE file
	found in the top-level directory of this distribution and
	at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE.
	No part of BeeTee Project, including this file, may be copied,
	modified, propagated, or distributed except according to the
	terms contained in the LICENSE file.
*/

import Foundation

class BeeTee {
	var delegate: BeeTeeDelegate? = nil
	var availableDevices: [BeeTeeDevice] {
		get {
				return Array(_availableDevices)
		}
	}
	
	private let bluetoothManagerHandler = BluetoothManagerHandler.sharedInstance()!
	private var _availableDevices = Set<BeeTeeDevice>()
	private var tokenCache = [BeeTeeNotification: NSObjectProtocol]()
	
	public init() {
		for beeTeeNotification in BeeTeeNotification.allNotifications {
			print("Registered \(beeTeeNotification)")
		
			let notification = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: beeTeeNotification.rawValue),
																																object: nil,
																																queue: OperationQueue.main) { [unowned self] (notification) in
				let beeTeeNotification = BeeTeeNotification.init(rawValue: notification.name.rawValue)!
				switch beeTeeNotification {
				case .DeviceDiscovered:
						let beeTeeDevice = self.extractBeeTeeDevice(from: notification)
						self._availableDevices.insert(beeTeeDevice)
				case .DeviceRemoved:
						let beeTeeDevice = self.extractBeeTeeDevice(from: notification)
						self._availableDevices.remove(beeTeeDevice)
				default:
						break
				}
				if (self.delegate != nil) {
						self.delegate?.receivedBeeTeeNotification(notification: beeTeeNotification)
				}
			}
			self.tokenCache[beeTeeNotification] = notification
		}
	}
	
	deinit {
		for key in tokenCache.keys {
			NotificationCenter.default.removeObserver(tokenCache[key]!)
		}
	}
	
	public func enableBluetooth() {
		bluetoothManagerHandler.enable()
	}
	
	public func disableBluetooth() {
		bluetoothManagerHandler.disable()
	}

	public func bluetoothIsEnabled() -> Bool {
			return bluetoothManagerHandler.enabled()
	}
	
	public func startScanForDevices() {
		bluetoothManagerHandler.startScan()
	}
	
	public func stopScan() {
		bluetoothManagerHandler.stopScan()
		resetAvailableDevices()
	}
	
	public func isScanning() -> Bool {
		return bluetoothManagerHandler.isScanning()
	}
	
	public static func debugLowLevel() {
		// credits to http://stackoverflow.com/a/3738387/1864294
		print("This is a dirty C hack. Only for demonstration/debugging; not for production.")
	
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil,
																		{ (_, observer, name, _, _) in
																			guard let name = name
																				else {
																					return
																				}
																			
																			// notice only notification they are associated with the BluetoothManager.framework
																			if String(name.rawValue).hasPrefix("B") {
																				print("Received notification: \(name)")
																			}
																		},
																		nil, nil, .deliverImmediately)
	}
	
	private func resetAvailableDevices() {
		_availableDevices.removeAll()
	}
	
	private func extractBeeTeeDevice(from notification: Notification) -> BeeTeeDevice {
		let bluetoothDevice = BluetoothDeviceHandler(notification: notification)!
		let beeTeeDevice = BeeTeeDevice(name: bluetoothDevice.name,
																		address: bluetoothDevice.address,
																		majorClass: bluetoothDevice.majorClass,
																		minorClass: bluetoothDevice.minorClass,
																		type: bluetoothDevice.type,
																		supportsBatteryLevel: bluetoothDevice.supportsBatteryLevel,
																		detectingDate: Date())
		
		return beeTeeDevice
	}
}

