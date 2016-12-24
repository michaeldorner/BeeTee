/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import Foundation


public enum BeeTeeNotification {
    case PowerChanged
    case AvailabilityChanged
    case DeviceDiscovered
    case DeviceRemoved
    case ConnectabilityChanged
    case DeviceUpdated
    case DiscoveryStateChanged
    case DeviceConnectSuccess
    case ConnectionStatusChanged
    case DeviceDisconnectSuccess
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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothPowerChangedNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothPowerChangedNotification")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothAvailabilityChangedNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothAvailabilityChangedNotification")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothDeviceDiscoveredNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothDeviceDiscoveredNotification")
            let bluetoothDevice = BluetoothDeviceHandler(notification: notification)!
            
            let beeTeeDevice = BeeTeeDevice(name: bluetoothDevice.name, address: bluetoothDevice.address, majorClass: bluetoothDevice.majorClass, minorClass: bluetoothDevice.minorClass, type: bluetoothDevice.type, supportsBatteryLevel: bluetoothDevice.supportsBatteryLevel, detectingDate: Date())
            self.devices.insert(beeTeeDevice)
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.DeviceDiscovered)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothDeviceRemovedNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothDeviceRemovedNotification")
            let bluetoothDevice = BluetoothDeviceHandler(notification: notification)!
            
            let beeTeeDevice = BeeTeeDevice(name: bluetoothDevice.name, address: bluetoothDevice.address, majorClass: bluetoothDevice.majorClass, minorClass: bluetoothDevice.minorClass, type: bluetoothDevice.type, supportsBatteryLevel: bluetoothDevice.supportsBatteryLevel, detectingDate: Date())
            self.devices.remove(beeTeeDevice)
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.DeviceRemoved)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothConnectabilityChangedNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothConnectabilityChangedNotification")
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.ConnectabilityChanged)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothDeviceUpdatedNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothDeviceUpdatedNotification")
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.DeviceUpdated)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothDiscoveryStateChangedNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothDiscoveryStateChangedNotification")
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.DiscoveryStateChanged)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothDeviceDiscoveredNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothDeviceDiscoveredNotification")
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.ConnectabilityChanged)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothDeviceConnectSuccessNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothDeviceConnectSuccessNotification")
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.DeviceConnectSuccess)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothConnectionStatusChangedNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothConnectionStatusChangedNotification")
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.ConnectionStatusChanged)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BluetoothDeviceDisconnectSuccessNotification"), object: nil, queue: OperationQueue.main) { (notification) in
            print("BluetoothDeviceDisconnectSuccessNotification")
            self.delegate?.receivedBeeTeeNotification(notification: BeeTeeNotification.DeviceDisconnectSuccess)
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
}
