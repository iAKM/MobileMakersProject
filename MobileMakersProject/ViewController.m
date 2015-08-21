//
//  ViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 17/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <CBCentralManagerDelegate>
@property CBCentralManager *bluetoothManager;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)startBluetoothStatusMonitoring {

    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {

    if ([central state] == CBCentralManagerStatePoweredOn) {
        self.continueButton.enabled = YES;
    }

    else {
        self.continueButton.enabled = NO;
    }
}

@end
