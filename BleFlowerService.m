//
//  BleFlowerService.m
//  BlueFlower
//
//  Created by student on 11/16/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import "BleFlowerService.h"
#import "BleDiscovery.h"

NSString *humidityUUID = @"2012";
NSString *humidityCharacteristicUUID = @"2a19";
NSString *batteryUUID = @"XXXX";

@interface BleFlowerService() <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    CBService			*humidityService;
    CBCharacteristic    *humidityCharacteristic;
    
}
@end


@implementation BleFlowerService


//#####################################################################################################

- (id) initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        
        servicePeripheral = [peripheral retain];
        [servicePeripheral setDelegate:self];
		      
	}
    return self;
}


//#####################################################################################################

- (void) start
{
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:humidityUUID];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    NSLog(@"start");
    [servicePeripheral discoverServices:serviceArray];
}

//#####################################################################################################

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSLog(@"did discover service");
    NSArray		*services	= nil;
	NSArray		*uuids	= [NSArray arrayWithObjects:humidityUUID, nil];
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
		return ;
	}
    
	services = [peripheral services];
	if (!services || ![services count]) {
		return ;
	}
    
	humidityService = nil;
    
	for (CBService *service in services) {
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:humidityUUID]]) {
			humidityService = service;
			break;
		}
	}
    
	if (humidityService) {
        NSLog(@"discover char!!");
		[peripheral discoverCharacteristics:nil forService:humidityService];
	}
}

//#####################################################################################################

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
	NSLog(@"did discover char");
    NSArray		*characteristics	= [service characteristics];
	CBCharacteristic *characteristic;
    if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service != humidityService) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
	for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        NSLog(@"Reading humidity level...");
        humidityCharacteristic = [characteristic retain];
        [peripheral readValueForCharacteristic:characteristic];
        
		/*if ([[characteristic UUID] isEqual:humidityCharacteristicUUID]) {
            NSLog(@"Reading humidity level...");
			humidityCharacteristic = [characteristic retain];
			[peripheral readValueForCharacteristic:characteristic];
		
        }
         */
         
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%@",characteristic.value);
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong peripheral\n");
		return ;
	}
    
    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
}

- (void) updateValue
{
    [servicePeripheral readValueForCharacteristic:humidityCharacteristic];
}

@end
