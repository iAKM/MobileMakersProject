//
//  DisplayViewController.h
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddTagViewController.h"

@interface DisplayViewController : UIViewController <CLLocationManagerDelegate>

@property (strong) NSArray *beacons;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property CLProximity lastProximity;

@property NSString *minor;


-(void)loadPhotos;

//-(void)getBeaconsWithString:(NSString *)uuid;

@end
