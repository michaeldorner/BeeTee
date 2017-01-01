/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import UIKit

class DeviceListingViewController: UITableViewController, BeeTeeDelegate {
    let beeTeeModel = BeeTeeModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beeTeeModel.subscribe(subscriber: self)
    }
    
    func receivedBeeTeeNotification(notification: BeeTeeNotification) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beeTeeModel.availableDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beeTeeDevice = beeTeeModel.availableDevices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCellIdentifier")!
        cell.textLabel?.text = beeTeeDevice.name
        cell.detailTextLabel?.text = beeTeeDevice.address
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let selectedDevice = beeTeeModel.availableDevices[indexPath.row]

        let deviceDetailViewController: DeviceDetailViewController = segue.destination as! DeviceDetailViewController
        deviceDetailViewController.device = selectedDevice
    }
}
