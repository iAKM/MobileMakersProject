//
//  BeaconsViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 31/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "BeaconsViewController.h"
#import "DisplayTableViewCell.h"
#import "AppDelegate.h"
#import "BeaconHelper.h"

@interface BeaconsViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSArray *beacons;
@property NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation BeaconsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;



    if (self.locationManager)
    {
        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];

        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];

        self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:[[NSUUID alloc]initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF525"] identifier:@"My stuff"];

        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

        [self.locationManager startUpdatingLocation];

        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;



    }


    
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSArray *nearbyBeacons = [BeaconHelper beaconsNearbyForBeacons:beacons];

    self.beacons = nearbyBeacons;
    [self.tableView reloadData];
    
    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    NSManagedObject *Tag = (NSManagedObject *) [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.moc];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Tag valueForKey:@"name"]];

    for (CLBeacon *beacon in self.beacons)
    {
        int minor = [[Tag valueForKey:@"minor"] intValue];

        if ([beacon.minor intValue] == minor)
        {
            cell.textLabel.text =[BeaconHelper proximityStringForBeacon:beacon];

            NSLog(@"cell.tafefeg %@", cell.textLabel.text);

        }

        cell.textLabel.text = @"not found";

    }



    return cell;
    
}







@end
