//
//  BleDiscovery.h
//  BlueFlower
//
//  Created by student on 11/3/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleFlowerService.h"

@interface BleDiscovery : NSObject

+ (id) sharedInstance;
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;
- (void) connectPeripheral:(CBPeripheral*)peripheral;

@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;

@end
