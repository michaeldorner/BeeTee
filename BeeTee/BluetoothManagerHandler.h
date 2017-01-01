/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

#import <Foundation/Foundation.h>


@interface BluetoothManagerHandler : NSObject

+ (BluetoothManagerHandler*) sharedInstance;

- (bool) powered;
- (void) setPower: (bool)powerStatus;
- (void) startScan;
- (void) stopScan;
- (bool) isScanning;
- (bool) enabled;
- (void) disable;
- (void) enable;

@end
