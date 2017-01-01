/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import UIKit


class DeviceDetailViewController: UITableViewController {
    
    var device: BeeTeeDevice? = nil
    let attributes = ["Name", "Address", "Major Class", "Minor Class", "Type", "Battery"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var value: String = ""
        if (device != nil) {
            switch indexPath.row {
            case 0:
                value = device!.name
            case 1:
                value = device!.address
            case 2:
                value = String(device!.majorClass)
            case 3:
                value = String(device!.minorCass)
            case 4:
                value = String(device!.type)
            case 5:
                value = device!.supportsBatteryLevel ? "Yes" : "No"
            default: break
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceDetailCellIdentifier")!
        cell.textLabel?.text = attributes[indexPath.row]
        cell.detailTextLabel?.text = value
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return (tableView.cellForRow(at: indexPath)?.detailTextLabel?.text) != nil
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            let cell = tableView.cellForRow(at: indexPath)
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell?.detailTextLabel?.text
        }
    }
    
    
    
}
