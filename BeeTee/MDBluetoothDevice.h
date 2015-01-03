//
//  MDBluetoothDevice.h
//  BeeTee
//
//  Created by Michael Dorner on 02.01.15.
//  Copyright (c) 2015 Michael Dorner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDBluetoothDevice.h"


@interface MDBluetoothDevice : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *address;
@property (assign, nonatomic, readonly) NSUInteger majorClass;
@property (assign, nonatomic, readonly) NSUInteger minorClass;
@property (assign, nonatomic, readonly) NSInteger type;
@property (assign, nonatomic, readonly) BOOL supportsBatteryLevel;

- (instancetype)init __unavailable;
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
