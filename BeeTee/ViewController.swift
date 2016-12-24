/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import UIKit


class Demo: BeeTeeDelegate {
    let beeTee = BeeTee()
    
    func demo() {
        beeTee.delegate = self
        beeTee.turnBluetoothOn()
        beeTee.startScanForDevices()
    }
    
    func receivedBeeTeeNotification(notification: BeeTeeNotification) {
        switch notification {
        case .DeviceDiscovered:
            for device in beeTee.availableDevices {
                print(device)
            }
        default:
            print(notification)
        }
    }
}

class ViewController: UIViewController, BeeTeeDelegate {
    let beeTee = BeeTee()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        beeTee.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressOn(_ sender: UIButton) {
        beeTee.turnBluetoothOn()
        
    }

    @IBAction func pressOff(_ sender: UIButton) {
        beeTee.turnBluetoothOff()
    }
    @IBAction func pressStatus(_ sender: UIButton) {
        print(beeTee.bluetoothIsOn() )
        beeTee.startScanForDevices()
    }
    
    func receivedBeeTeeNotification(notification: BeeTeeNotification) {
        if notification == .DeviceDiscovered {
            let a = beeTee.availableDevices;
            for d in a {
                print(d)
            }
        }
    }
}

