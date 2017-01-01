/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import Foundation

class BeeTeeModel: BeeTeeDelegate {

    static let sharedInstance = BeeTeeModel()

    private let beeTee = BeeTee()
    private var subscribers = [BeeTeeDelegate]()
        
    public var availableDevices: [BeeTeeDevice] {
        get {
            return beeTee.availableDevices
        }
    }
    
    private init() {
        beeTee.delegate = self
    }
    
    func receivedBeeTeeNotification(notification: BeeTeeNotification) {
        for subscriber in subscribers {
            subscriber.receivedBeeTeeNotification(notification: notification)
        }
        print("BeeTeeNotification: " + String(describing: notification))
    }
    
    public func turnBluetoothOn() {
        beeTee.enableBluetooth()
        print("Bluetooth turned on")

    }
    
    public func turnBluetoothOff() {
        beeTee.disableBluetooth()
        print("Bluetooth turned off")

    }
    
    public func bluetoothIsOn() -> Bool {
        return beeTee.bluetoothIsEnabled()
    }
    
    public func startScanForDevices() {
        beeTee.startScanForDevices()
        print("Bluetooth started scanning for new devices")

    }
    
    public func stopScan() {
        beeTee.stopScan()
        print("Bluetooth stopped scanning")
    }
    
    public func isScanning() -> Bool {
        return beeTee.isScanning()
    }
    
    public func subscribe(subscriber: BeeTeeDelegate) {
        subscribers.append(subscriber)
    }
    
    public func unsubscribe(subscriber: BeeTeeDelegate) {
        //todo: add remove
    }
    
}
