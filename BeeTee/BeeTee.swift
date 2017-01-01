/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import Foundation


public enum BeeTeeNotification: String {
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
    
    public static let allNotifications: [BeeTeeNotification] = [.PowerChanged, .AvailabilityChanged, .DeviceDiscovered, .DeviceRemoved, .ConnectabilityChanged, .DeviceUpdated, .DiscoveryStateChanged, .DeviceConnectSuccess, .ConnectionStatusChanged, .DeviceDisconnectSuccess]
}



public protocol BeeTeeDelegate {
    func receivedBeeTeeNotification(notification: BeeTeeNotification)
}



public class BeeTee {
    
    public var delegate: BeeTeeDelegate? = nil
    public var availableDevices: [BeeTeeDevice] {
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
            
            let notification = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: beeTeeNotification.rawValue), object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
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
        print("This is a dirty C hack and only for demonstration and deep debugging, but not for production.") // credits to http://stackoverflow.com/a/3738387/1864294
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        nil,
                                        { (_, observer, name, _, _) in
                                            let n = name?.rawValue as! String
                                            if n.hasPrefix("B") { // notice only notification they are associated with the BluetoothManager.framework
                                               print("Received notification: \(name)")
                                            }
                                        },
                                        nil,
                                        nil,
                                        .deliverImmediately)
    }
    
    private func resetAvailableDevices() {
        _availableDevices.removeAll()
    }
    
    private func extractBeeTeeDevice(from notification: Notification) -> BeeTeeDevice {
        let bluetoothDevice = BluetoothDeviceHandler(notification: notification)!
        let beeTeeDevice = BeeTeeDevice(name: bluetoothDevice.name, address: bluetoothDevice.address, majorClass: bluetoothDevice.majorClass, minorClass: bluetoothDevice.minorClass, type: bluetoothDevice.type, supportsBatteryLevel: bluetoothDevice.supportsBatteryLevel, detectingDate: Date())
        return beeTeeDevice
    }
}

