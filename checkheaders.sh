#!/bin/bash
if [ -f "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/PrivateFrameworks/BluetoothManager.framework/Headers/BluetoothDevice.h" ] && [ -f "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/PrivateFrameworks/BluetoothManager.framework/Headers/BluetoothManager.h" ]
then
	echo "Ok. Headers are placed correctly found."
else
	echo "Error. Headers are not placed correctly found."
fi