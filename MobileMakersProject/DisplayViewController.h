//
//  DisplayViewController.h
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface DisplayViewController : UIViewController

@property (strong) NSArray *beacons;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(void)loadPhotos;

@end
