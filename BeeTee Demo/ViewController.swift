//
//  ViewController.swift
//  BeeTee
//
//  Created by Michael Dorner on 22.12.16.
//  Copyright © 2016 Michael Dorner. All rights reserved.
//

import UIKit



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
        if beeTee.isScanning() {
            beeTee.stopScan()
        } else {
            beeTee.startScanForDevices()
        }
    }
    
    func receivedBeeTeeNotification(notification: BeeTeeNotification) {
        //print(notification)
    }
}

