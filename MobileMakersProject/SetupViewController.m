//
//  ViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 17/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "SetupViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SetupViewController ()<CLLocationManagerDelegate, CBCentralManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property CLLocationManager *locationManager;
@property CBCentralManager *bluetoothManager;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];

    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        self.continueButton.enabled = YES;

    } else if(central.state == CBCentralManagerStatePoweredOff) {
        self.continueButton.enabled = NO;
        //Bluetooth is disabled. ios pops-up an alert automatically
    }
}

@end
