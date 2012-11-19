//
//  ViewController.m
//  BlueFlower
//
//  Created by student on 11/3/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleDiscovery.h"
#import "BleFlowerService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BleDiscovery sharedInstance] startScanningForUUIDString:humidityUUID];
    
    //Funksjonalitet for å plukke ut en peripheral fra lista og tilkoble
    /*
    CBPeripheral	*peripheral;
	NSArray			*devices;
    devices = [[BleDiscovery sharedInstance] foundPeripherals];
    peripheral = (CBPeripheral*)[devices objectAtIndex:0];
    [[BleDiscovery sharedInstance] connectPeripheral:peripheral];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [_button release];
    [super dealloc];
}

//Laget en dummy knapp for å teste å hente verdi fra SIOLSENSE
- (IBAction)buttonFunc:(id)sender {
    NSArray			*services;
    services = [[BleDiscovery sharedInstance] connectedServices];
    NSLog(@"%u",services.count);
    for(BleFlowerService *service in services)
    {
        [service updateValue];
    };
    
    
}
@end
