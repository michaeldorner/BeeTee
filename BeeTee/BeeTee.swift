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
    
    static let allNotifications: [BeeTeeNotification] = [.PowerChanged, .AvailabilityChanged, .DeviceDiscovered, .DeviceRemoved, .ConnectabilityChanged, .DeviceUpdated, .DiscoveryStateChanged, .DeviceConnectSuccess, .ConnectionStatusChanged, .DeviceDisconnectSuccess]
}


public protocol BeeTeeDelegate {
    func receivedBeeTeeNotification(notification: BeeTeeNotification)
}



public class BeeTee {
    
    private let bluetoothManagerHandler = BluetoothManagerHandler.sharedInstance()!
    private var devices = Set<BeeTeeDevice>()
    
    public var delegate: BeeTeeDelegate? = nil
    public var availableDevices: [BeeTeeDevice] {
        get {
            return Array(devices)
        }
    }
    
    convenience init(delegate: BeeTeeDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    init() {
        for beeTeeNotification in BeeTeeNotification.allNotifications {
            print("registered \(beeTeeNotification)")
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: beeTeeNotification.rawValue), object: nil, queue: OperationQueue.main) { (notification) in
                switch beeTeeNotification {
                case .DeviceDiscovered:
                    let bluetoothDevice = BluetoothDeviceHandler(notification: notification)!
                    let beeTeeDevice = BeeTeeDevice(name: bluetoothDevice.name, address: bluetoothDevice.address, majorClass: bluetoothDevice.majorClass, minorClass: bluetoothDevice.minorClass, type: bluetoothDevice.type, supportsBatteryLevel: bluetoothDevice.supportsBatteryLevel, detectingDate: Date())
                    self.devices.insert(beeTeeDevice)
                case .DeviceRemoved:
                    let bluetoothDevice = BluetoothDeviceHandler(notification: notification)!
                    let beeTeeDevice = BeeTeeDevice(name: bluetoothDevice.name, address: bluetoothDevice.address, majorClass: bluetoothDevice.majorClass, minorClass: bluetoothDevice.minorClass, type: bluetoothDevice.type, supportsBatteryLevel: bluetoothDevice.supportsBatteryLevel, detectingDate: Date())
                    self.devices.remove(beeTeeDevice)
                default:
                    break
                }
                print(beeTeeNotification)
                self.delegate?.receivedBeeTeeNotification(notification: beeTeeNotification)
            }
        }
    }
    
    public func turnBluetoothOn() {
        bluetoothManagerHandler.setPower(true)
    }
    
    public func turnBluetoothOff() {
        bluetoothManagerHandler.setPower(false)
    }

    public func bluetoothIsOn() -> Bool {
        return bluetoothManagerHandler.powered()
    }
    
    public func startScanForDevices() {
        bluetoothManagerHandler.startScan()
    }
    
    public func stopScan() {
        bluetoothManagerHandler.stopScan()
    }
    
    public func isScanning() -> Bool {
        return bluetoothManagerHandler.isScanning()
    }
    
    public func debugLowLevel() {
        NSLog("This is a dirty C hack and only for demonstration and deep debugging, but not for production.") // credits to http://stackoverflow.com/a/3738387/1864294
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
    
    deinit {
        //remove all observers
    }
}
