//
//  BeaconHelper.h
//  BeaconCoreData
//
//  Created by Achyut Kumar Maddela on 24/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconHelper : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;



+(NSString *)proximityStringForBeacon:(CLBeacon *)beacon;
+(NSString *)stringForBeacon:(CLBeacon *)beacon;
+(NSArray *)beaconsNearbyForBeacons:(NSArray *)beacons;


@end
