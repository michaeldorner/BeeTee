/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import UIKit


class MissionControlViewController: UITableViewController, BeeTeeDelegate {
    
    private let beeTeeModel = BeeTeeModel.sharedInstance
    
    @IBOutlet weak var bluetoothPowerSwitch: UISwitch!
    @IBOutlet weak var bluetoothScanSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beeTeeModel.subscribe(subscriber: self)
        bluetoothPowerSwitch.setOn(beeTeeModel.bluetoothIsOn(), animated: false)
        bluetoothScanSwitch.setOn(beeTeeModel.isScanning(), animated: false)
    }

    @IBAction func switchBluetoothPower() {
        if beeTeeModel.bluetoothIsOn() {
            beeTeeModel.turnBluetoothOff()
        } else {
            beeTeeModel.turnBluetoothOn()
        }
    }
    
    @IBAction func switchBluetoothScanStatus() {
        if beeTeeModel.isScanning() {
            beeTeeModel.stopScan()
        } else {
            beeTeeModel.startScanForDevices()
        }
    }
    
    func receivedBeeTeeNotification(notification: BeeTeeNotification) {
        tableView.reloadData()
        bluetoothPowerSwitch.setOn(beeTeeModel.bluetoothIsOn(), animated: true)
        bluetoothScanSwitch.setOn(beeTeeModel.isScanning(), animated: true)
    }
}
