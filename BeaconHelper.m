//
//  BeaconHelper.m
//  BeaconCoreData
//
//  Created by Achyut Kumar Maddela on 24/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "BeaconHelper.h"


@implementation BeaconHelper


+(NSString *)proximityStringForBeacon:(CLBeacon *)beacon;
{
    NSString *proximity;

    switch (beacon.proximity)
    {
        case CLProximityFar:
            proximity = @"Far";
            break;
        case CLProximityNear:
            proximity = @"Near";
            break;
        case CLProximityImmediate:
            proximity = @"Immediate";
            break;
        case CLProximityUnknown:
            proximity = @"Unknown";
            break;

    }

    return proximity;
}

+(NSString *)stringForBeacon:(CLBeacon *)beacon
{
    NSString *proximity = [self proximityStringForBeacon:beacon];

    return [NSString stringWithFormat:@"%@:%@:%@", beacon.major, beacon.minor, proximity];
    
}

+(NSArray *)beaconsNearbyForBeacons:(NSArray *)beacons;
{
    NSArray *nearbyBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity >= %d", CLProximityNear]];
    return [NSArray arrayWithArray:nearbyBeacons];
    
}







@end
