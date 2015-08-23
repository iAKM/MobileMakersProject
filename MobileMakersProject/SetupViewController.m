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
@interface SetupViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@property CLLocationManager *locationManager;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
}

}
@end
