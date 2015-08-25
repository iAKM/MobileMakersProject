//
//  DisplayViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "Tag.h"
#import "DisplayTableViewCell.h"

#import "BeaconHelper.h"
#import "AddTagViewController.h"

@interface DisplayViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIApplicationDelegate>
@property NSArray *array;
@property NSManagedObjectContext *moc;
@property NSMutableArray *tags;
@property NSArray *imagesFromCoreData;
@property CLLocationManager *locationManager;
@property CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) IBOutlet UILabel *testLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *mmAnnot;





@end

@implementation DisplayViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"self.beacons -- %@", self.beacons);


    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.locationManager = delegate.locationManager;
    self.moc = delegate.managedObjectContext;

    [[self navigationController] setNavigationBarHidden:YES animated:YES]; // this hides the navigation bar.

        self.locationManager.delegate = self;


    self.mapView.showsUserLocation = YES;
    //[self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
   // MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);

    //[self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation, span) animated:YES)];

}

-(void)getBeaconsWithString:(NSString *)uuid
{
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    NSString *regionIdentifier = @"us.iBeaconModules";
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:regionIdentifier];

    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    [self.locationManager startUpdatingLocation];

}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [self getBeaconsWithString:@"EBEFD083-70A2-47C8-9837-E7B5634DF524"];

    [self loadTags];
    [self loadPhotos];

    [[self navigationController] setNavigationBarHidden:YES animated:YES]; // this hides the navigation bar.


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadPhotos];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{

}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{

    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];



    NSString *message = @"";
    self.beacons = beacons;
    [self.tableView reloadData];


    NSLog(@"beaconsssss %@", beacons);


    if(beacons.count > 0)
    {
        CLBeacon *nearestBeacon = beacons.firstObject;
        if(nearestBeacon.proximity == self.lastProximity || nearestBeacon.proximity == CLProximityUnknown)
        {

            return;
        }
        self.lastProximity = nearestBeacon.proximity;

        switch(nearestBeacon.proximity) {
            case CLProximityFar:
                message = @"You are far away from the beacon";
                [delegate sendLocalNotificationWithMessage:message];
                break;
            case CLProximityNear:
                message = @"You are near the beacon";
                break;
            case CLProximityImmediate:
                message = @"You are in the immediate proximity of the beacon";
                [delegate sendLocalNotificationWithMessage:message];

                break;
            case CLProximityUnknown:
                break; //check
        }
    } else {
        message = @"No beacons are nearby";
    }

    NSLog(@"%@", message);
}

-(void)loadTags
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    self.tags = (NSMutableArray *)[self.moc executeFetchRequest:request error:nil];
    NSLog(@"self.tags --- %@", self.tags);

    NSLog(@"uuid from core data = %@",self.tags);

    [self.tableView reloadData];
}

//-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
//      [self.locationManager startMonitoringForRegion:(CLBeaconRegion *)region];
//    [self.locationManager startUpdatingLocation];
//
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//
//}
//
//-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
//    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
//
//    [self.locationManager stopUpdatingLocation];
//
//    NSLog(@"You exited the region.");
//}
//
//
#pragma mark UITableView Datasource & Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
    return self.beacons.count;
    return self.imagesFromCoreData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   DisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    Tag *tag = [self.tags objectAtIndex:indexPath.row];
    Photo *photo = self.imagesFromCoreData[indexPath.row];


    NSData *data = photo.imageData;
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;


//BEACONS

    CLBeacon *beacon = (CLBeacon*)[self.beacons objectAtIndex:indexPath.row];
    NSString *proximityLabel = @"";
    switch (beacon.proximity) {
        case CLProximityFar:
            proximityLabel = @"Oops..your dog is getting far";
          //  self.view.backgroundColor = [UIColor orangeColor];
            cell.backgroundColor = [UIColor orangeColor];

            break;
        case CLProximityNear:
            proximityLabel = @"Keep looking. You may find your dog nearby";
           // self.view.backgroundColor = [UIColor yellowColor];
            cell.backgroundColor = [UIColor yellowColor];

            break;
        case CLProximityImmediate:
            proximityLabel = @"look out. your dog mighr be next to you";
          //  self.view.backgroundColor = [UIColor blueColor];
            cell.backgroundColor = [UIColor greenColor];
            break;
        case CLProximityUnknown:
            proximityLabel = @"Unknown";
          //  self.view.backgroundColor = [UIColor redColor];
            cell.backgroundColor = [UIColor redColor];
            

            break;
    }

    cell.nameLabel.text = tag.name;

    //double accuracy = roundf(beacon.accuracy * 100.0)/100.0;

//    beacon.accuracy = roundf(beacon.accuracy *100.0)/100.0;

    NSString *detailLabel = [NSString stringWithFormat:@"%@, Dist: %0.001f", proximityLabel, beacon.accuracy];


   // NSString *detailLabel = [NSString stringWithFormat:@"Major: %d, Minor: %d, RSSI: %d, UUID: %@",beacon.major.intValue,
                         //    beacon.minor.intValue, (int)beacon.rssi, beacon.proximityUUID.UUIDString];

    cell.proxLabel.text = detailLabel;

    return cell;
}

-(void)loadPhotos {
    NSFetchRequest *requestPhotos = [[NSFetchRequest alloc]initWithEntityName:@"Photo"];
    [requestPhotos setReturnsObjectsAsFaults:NO];
    [requestPhotos setRelationshipKeyPathsForPrefetching:@[@"comments"]];
    self.imagesFromCoreData = [self.moc executeFetchRequest:requestPhotos error:nil];
    NSLog(@"you have %li photos", self.imagesFromCoreData.count);

    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];

        Photo *deletedPhoto = [self.imagesFromCoreData objectAtIndex:indexPath.row];
        [self.moc deleteObject:deletedPhoto];
        Tag *deletedTag = [self.tags objectAtIndex:indexPath.row];
        [self.moc deleteObject:deletedTag];

        [self.moc save:nil];
        [self imagesFromCoreData];
        [self tags];
        [self.tableView endUpdates];
    }
}

@end
