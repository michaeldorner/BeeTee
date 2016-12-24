/*
 This file is part of BeeTee Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/BeeTee/blob/master/LICENSE. No part of BeeTee Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

#import <Foundation/Foundation.h>

@interface BluetoothDeviceHandler : NSObject

@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) NSString* address;
@property (assign, nonatomic, readonly) NSUInteger majorClass;
@property (assign, nonatomic, readonly) NSUInteger minorClass;
@property (assign, nonatomic, readonly) NSInteger type;
@property (assign, nonatomic, readonly) BOOL supportsBatteryLevel;

- (instancetype)initWithNotification:(NSNotification*) notification;

@end
