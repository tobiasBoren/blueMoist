//
//  BleDiscovery.m
//  BlueFlower
//
//  Created by student on 11/3/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import "BleDiscovery.h"

@interface BleDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *centralManager;
}
@end

@implementation BleDiscovery

@synthesize foundPeripherals;
@synthesize connectedServices;

+ (id) sharedInstance
{
	static BleDiscovery	*this	= nil;
    
	if (!this)
		this = [[BleDiscovery alloc] init];
    
	return this;
}

//#####################################################################################################

- (id) init
{
    self = [super init];
    if (self) {
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        foundPeripherals = [[NSMutableArray alloc] init];
        connectedServices = [[NSMutableArray alloc] init];
	}
    return self;
}

//#####################################################################################################

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"didretrieveconnper");
	CBPeripheral	*peripheral;
	
	/* Add to list. */
	for (peripheral in peripherals) {
		[central connectPeripheral:peripheral options:nil];
	}
	//[discoveryDelegate discoveryDidRefresh];
}

//#####################################################################################################

- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didretrieveper");
	[central connectPeripheral:peripheral options:nil];
	//[discoveryDelegate discoveryDidRefresh];
}

//#####################################################################################################

- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
    NSLog(@"failedToRetrieve");
	/* Nuke from plist. */
	//[self removeSavedDevice:UUID];
}

//#####################################################################################################

- (void) startScanningForUUIDString:(NSString *)uuidString
{
    NSLog(@"startScan");
	NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

//#####################################################################################################

- (void) stopScanning
{
    NSLog(@"stopScan");
	[centralManager stopScan];
}

//#####################################################################################################


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"did discover ONE!");
    NSLog(@"%@",peripheral.name);
    NSLog(@"%@",peripheral.UUID);
    
    
    //Legger alle som oppdages i en liste
    if (![foundPeripherals containsObject:peripheral]) {
		[foundPeripherals addObject:peripheral];
        NSLog(@"added to list");
	}
    
    if(foundPeripherals.count==2){
    
        if (![peripheral isConnected] && [peripheral.name isEqualToString:@"SOILSENS2"]) {
        
            NSLog(@"Trying to connect");
            [centralManager stopScan];
            for(CBPeripheral *per in foundPeripherals){
                [central connectPeripheral:per options:nil];
            }
        }
    }
    
    
}

//#####################################################################################################

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected");
    BleFlowerService *service	= nil;
    service = [[BleFlowerService alloc] initWithPeripheral:peripheral];
	[service start];
    
    if (![connectedServices containsObject:service])
		[connectedServices addObject:service];
    
	if (![foundPeripherals containsObject:peripheral])
		[foundPeripherals addObject:peripheral];
}

//#####################################################################################################

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect");
    
}
//#####################################################################################################


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            


			break;
		}
            
        case CBCentralManagerStateUnsupported:
		{
            

			break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
            
		case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
            NSLog(@"power ON!");

			//[centralManager retrieveConnectedPeripherals];

			break;
		}
            
		case CBCentralManagerStateResetting:
		{


			break;
		}
	}
    
    previousState = [centralManager state];
}


@end
