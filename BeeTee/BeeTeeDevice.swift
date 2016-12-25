/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import Foundation


public class BeeTeeDevice: Hashable, CustomStringConvertible {
    let name: String
    let address: String
    let majorClass: UInt
    let minorCass: UInt
    let type: Int
    let supportsBatteryLevel: Bool
    let detectingDate: Date
    
    convenience init(notification: Notification) {
        let bluetoothDevice = BluetoothDeviceHandler(notification: notification)!
        self.init(name: bluetoothDevice.name, address: bluetoothDevice.address, majorClass: bluetoothDevice.majorClass, minorClass: bluetoothDevice.minorClass, type: bluetoothDevice.type, supportsBatteryLevel: bluetoothDevice.supportsBatteryLevel, detectingDate: Date())
    }
    
    init(name: String, address: String, majorClass: UInt, minorClass: UInt, type: Int, supportsBatteryLevel: Bool, detectingDate: Date) {
        self.name = name
        self.address = address
        self.majorClass = majorClass
        self.minorCass = minorClass
        self.type = type
        self.supportsBatteryLevel = supportsBatteryLevel
        self.detectingDate = detectingDate
    }
    
    public var description: String {
        return "\(name) (\(address)) @ \(detectingDate))"
    }
    
    public var hashValue: Int {
        return address.hashValue
    }
    
    public static func ==(lhs: BeeTeeDevice, rhs: BeeTeeDevice) -> Bool {
        return lhs.address == rhs.address
    }
}
