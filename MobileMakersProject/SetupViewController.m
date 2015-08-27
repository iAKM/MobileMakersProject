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

@property (weak, nonatomic) IBOutlet UILabel *goLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
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
        self.goLabel.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(225/255.0) blue:(167/255.0) alpha:1];
        self.stopLabel.backgroundColor = [UIColor colorWithRed:(96/255.0) green:(102/255.0) blue:(232/255.0) alpha:1];

    } else if(central.state == CBCentralManagerStatePoweredOff) {
        self.continueButton.enabled = NO;
        self.stopLabel.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(107/255.0) blue:(105/255.0) alpha:1];
        self.goLabel.backgroundColor = [UIColor colorWithRed:(96/255.0) green:(102/255.0) blue:(232/255.0) alpha:1];

        //Bluetooth is disabled. ios pops-up an alert automatically
    }
}

@end
