//
//  BeaconsViewController.h
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 31/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconsViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLBeaconRegion *beaconRegion;

@end
