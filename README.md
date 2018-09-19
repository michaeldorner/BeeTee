![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)
[![Build Status](https://travis-ci.org/michaeldorner/BeeTee.svg?branch=master)](https://travis-ci.org/michaeldorner/BeeTee)
[![codebeat badge](https://codebeat.co/badges/65bf4b44-cbbc-4807-a9e9-b3cd68c4378d)](https://codebeat.co/projects/github-com-michaeldorner-beetee)
[![DUB](https://img.shields.io/dub/l/vibe-d.svg)]()
[![codecov](https://codecov.io/gh/michaeldorner/BeeTee/branch/master/graph/badge.svg)](https://codecov.io/gh/michaeldorner/BeeTee)


# BeeTee

> BeeTee is an easy to use Swift framework, that allows simple access to the Bluetooth classic in iOS for turning on/off and scanning for Bluetooth devices. 

Besides BeeTee demonstrates how to access the private `BluetoothManager.framework` in iOS. 


## Table of Contents

- [Limitations](#limitations)
- [Installation](#installation)
- [Usage](#usage)
- [API](#api)
- [Known Issues](#known-issues)
- [Contributions](#contributions)
- [Versions](#versions)
- [License](#license)


## Limitations

Based on the [AppStore guideline §2.5](https://developer.apple.com/appstore/resources/approval/guidelines.html) on private (undocumented) functions it is not possible to publish apps with the _BeeTee_ and `BluetoothManager.framework` in the AppStore. 

You need a valid membership of the [iOS Developer Program](https://developer.apple.com/programs/ios/), because the _BeeTee_ does not work in the iOS simulator.

Connecting to devices is not possible in most cases and, therefore, not yet supported. 

There are currently no known limitations on iOS versions. 


## Installation

Copy all files in the _BeeTee_ folder to your project and done. That means there are 9 files to copy:

* `BluetoothDevice.h`
* `BluetoothManager.h`
* `BluetoothDeviceHandler.h`
* `BluetoothDeviceHandler.m`
* `BluetoothManagerHandler.h`
* `BluetoothManagerHandler.m`
* `BeeTee-Bridge-Header.h`
* `BeeTee.swift`
* `BeeTeeDevice.swift`


## Usage

Here is a small code snippet, how easily you can use _BeeTee_:

	class Demo: BeeTeeDelegate {
	    let beeTee = BeeTee()
	    
	   init() {
	        beeTee.delegate = self
	        beeTee.enableBluetooth()
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


## API

### BeeTee

The API is based on the other hardware managers, such as [`CLLocationManager`](https://developer.apple.com/reference/corelocation/cllocationmanager) or the underlaying `BluetoothManager.framework`. 

I focused on a clear distinction between the different layers, also by using different programming languages:

![Layer architecture of BeeTee](landingPage/BeeTeeLayer.png)

#### `BeeTeeNotification`

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
	    
	    static let allNotifications: [BeeTeeNotification]
	}

So all known notification from `BluetoothManager.framework` are passed through (see next section). I used only `PowerChanged`, `DeviceDiscovered`, `DeviceRemoved` in my demo application.

#### `BeeTeeDelegate`

	public protocol BeeTeeDelegate {
	    func receivedBeeTeeNotification(notification: BeeTeeNotification)
	}

#### `BeeTee`

	public class BeeTee {
		public var delegate: BeeTeeDelegate?
		public var availableDevices: [BeeTeeDevice]
		convenience init(delegate: BeeTeeDelegate)
		public func enableBluetooth()
		public func disableBluetooth()
		public func bluetoothIsEnabled() -> Bool
		public func startScanForDevices()
		public func stopScan()
		public func isScanning() -> Bool
		public static func debugLowLevel() // see section BluetoothManager.framework/Available Notification
	}


### `BluetoothManager.framework`

If you want to dive deeper into `BluetoothManager.framework` this section is interesting for you. 

#### Available Notifications

I found the following notification regarding Bluetooth

    BluetoothAvailabilityChangedNotification
    BluetoothDiscoveryStateChangedNotification
    BluetoothDeviceDiscoveredNotification
    BluetoothDeviceRemovedNotification
    BluetoothPowerChangedNotification
    BluetoothConnectabilityChangedNotification
    BluetoothDeviceUpdatedNotification
    BluetoothDeviceConnectSuccessNotification
    BluetoothConnectionStatusChangedNotification
    BluetoothDeviceDisconnectSuccessNotification
    
Maybe the list is not complete. You can look for them yourself using

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
or with in `BeeTee`:

	BeeTee.debugLowLevel()


## Known Issues

* Actually I wanted to encapsulate BeeTee in a formal framework. But it seems that [Swift does not allow framework-internal (protected) Objective-C code](http://stackoverflow.com/questions/41303716/objective-c-code-swift-framework-internal). 

* Some notifications are sent multiple times ([issue](https://github.com/michaeldorner/BeeTee/issues/13)). I am not sure how to deal with it. 

If you have problems make this project running have a look at [Stackoverflow](http://stackoverflow.com/search?q=beetee). If you have other questions or suggestions, feel free to contact me here in GitHub or somehow else. :-)


## Contributions

Help is welcome! If you do not know what to do, just pick one item and send me a pull request.

- [ ] Fix issue with multiple notifications
- [ ] Restructure BeeTee in a framework (`BeeTee.framework`, see [discussion on stackoverflow](http://stackoverflow.com/questions/41303716/objective-c-code-swift-framework-internal))
- [ ] Write test cases
- [ ] Support Cocoapods
- [ ] Improve documentation, especially inline documentation
- [ ] Add pull-to-refresh functionality for renewing the Available Devices list
- [x] Provide app icons
- [x] Support Travis support


## Versions

### 3.0
* Rewritten in Swift 3
* New API
* Clear separation of Objective-C and Swift code
* Dynamically loading of `Bluetooth.framework` (so no more header and import trouble)
* Released now under MIT license 

### 2.0
* Wrapper classes `MDBluetoothManager` and `MDBluetoothDevice` introduced 
* Updated to ARC
* Extented GUI

### 1.0
* Initial Commit as demo project for `BluetoothManager.framework`, Non-ARC


## License 

BeeTee is released under the MIT license. See [LICENSE](LICENSE) for more details.
The list icon was created by Aya Sofya (thenounproject.com).
