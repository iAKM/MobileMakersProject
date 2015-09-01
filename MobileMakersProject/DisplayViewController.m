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

@interface DisplayViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIApplicationDelegate, CBCentralManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *locLabel;
@property (strong, nonatomic) CLLocation *location;
@property NSArray *array;
@property NSManagedObjectContext *moc;
@property NSMutableArray *tags;
@property CLLocationManager *locationManager;
@property CLBeaconRegion *beaconRegion;
@property MKPointAnnotation *mmAnnot;
@property CBCentralManager *bluetoothManager;
@property NSMutableArray *uuids;
@property CLGeocoder *geocoder;
@property CLPlacemark *placemark;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UILabel *addLabel;


@property BOOL isUpdated;
@property BOOL isHidden;

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

    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    self.mmAnnot = [MKPointAnnotation new];



    self.mapView.showsUserLocation = YES;
    [self getCurrentLocation];
    [self getBeacons];

    if (self.beacons == 0) {

        self.tableView.hidden = true;
        self.mapView.hidden = true;
        self.arrow.hidden = false;
        self.addLabel.hidden = false;
        self.addLabel.text = @"add a tag to get started";
    }

    

}

-(void)viewWillAppear:(BOOL)animated
{

    if (self.beacons == 0) {

        self.tableView.hidden = true;
        self.mapView.hidden = true;
        self.arrow.hidden = false;
        
    }

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;


    [[self navigationController] setNavigationBarHidden:YES animated:YES]; // this hides the navigation bar.

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadPhotos];
}


-(void)getBeacons
{
   NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF525"];

    
    NSString *regionIdentifier = @"ibeaconModuleUS";


    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    self.tags = (NSMutableArray *) [self.moc executeFetchRequest:request error:nil];

    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:beaconUUID
                                                                     identifier:regionIdentifier];



    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;

    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];


    [self.locationManager startUpdatingLocation];
    beaconRegion.notifyEntryStateOnDisplay = NO;
    beaconRegion.notifyOnExit = YES;
    beaconRegion.notifyOnEntry = YES;

}

-(void)getCurrentLocation
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isEqual:mapView.userLocation])
    {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    if ([annotation isEqual:self.mmAnnot])
    {
        pin.image = [UIImage imageNamed:@"pinDog"];

    }

    pin.canShowCallout = NO;


    return pin;

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(!self.isUpdated) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 15000, 15000);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:NO];
        
        self.isUpdated = true;
    }
}

#pragma mark CLLoc Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // CLLocation *location = [locations lastObject];
   // NSLog(@"location - %f", location.coordinate.latitude);

   // NSLog(@"locations.count == %li", locations.count);
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"region is --------- - - - - - - %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{

    NSMutableArray *filteredBeacons = [NSMutableArray new];

    for (CLBeacon *beacon in beacons)
    {
        for (Tag *tag in self.tags)
        {
            if ([beacon.minor isEqualToNumber:tag.minor])
            {
                NSInteger tagPosition = [self.tags indexOfObject:tag];
                NSLog(@"position of beacon -is ------ >>>> %ld", (long)tagPosition);

                [filteredBeacons addObject:beacon];

            }
        }
    }

    self.beacons = filteredBeacons;
    
    
    [self.tableView reloadData];
    

}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
//    Tag *tag = self.tags.firstObject;
//    tag.lastSeenLat = [NSNumber numberWithDouble:self.mapView.userLocation.coordinate.latitude];
//    tag.lastSeenLon = [NSNumber numberWithDouble:self.mapView.userLocation.coordinate.latitude];
//    [self.locationManager stopUpdatingLocation];

}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if(central.state == CBCentralManagerStatePoweredOff) {

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Bluettoth is Off" message:@"Please turn on the bluetooth by pulling up control center" delegate:self cancelButtonTitle:@"Got It" otherButtonTitles:nil, nil];
        [alertView show];
        [self.tableView reloadData];

    }
    else if (central.state == CBCentralManagerStatePoweredOn)
    {
        [self.tableView reloadData];
        
    }
}

-(void)geoCodeLoction
{
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];




    [geo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];

        NSLog(@"Placemark ---- %@", placemark);

        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];


        NSLog(@"placemark -- %@", placemark.region);
        NSLog(@"placemark -- %@", placemark.country);
        NSLog(@"placemark -- %@", placemark.locality);
        NSLog(@"location -- %@", placemark.name);
        NSLog(@"location -- %@", placemark.postalCode);
        NSLog(@"location -- %@", placemark.subLocality);

        NSLog(@"location >>>> %@", placemark.location);

        NSLog(@"You are at: %@:", locatedAt);


       // NSString *loc = [NSString stringWithFormat:@"You are at: %@, %@, %@", placemark.subLocality, placemark.locality, placemark.country];

        self.locLabel.text = locatedAt;
    }];

}


#pragma mark UITableView Datasource & Delegate Methods

//- (Tag *)getTagForBeacon:(CLBeacon *)beacon {
//    for(Tag *t in self.tags) {
//        if ([t.minor isEqualToNumber:beacon.minor]) {
//            return t;
//        }
//    }
//
//    return nil;
//}

- (CLBeacon *)getBeaconForTag:(Tag *)tag {
    for(CLBeacon *b in self.beacons) {
        if([b.minor isEqualToNumber:tag.minor]) {
            return b;
        }
    }

    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
//    CLBeacon *beacon = [self.beacons objectAtIndex:indexPath.row];
    Tag *tag = [self.tags objectAtIndex:indexPath.row];
    CLBeacon *beacon = [self getBeaconForTag:tag];

    if (beacon != nil) {

        NSData *data = tag.image;
        UIImage *image = [UIImage imageWithData:data];
        cell.imageView.image = image;
        int minor = [[tag valueForKey:@"minor"] intValue];

        cell.nameLabel.text = [NSString stringWithFormat:@"%@[%d]",tag.name, minor];
    } else {
        cell.imageView.image = nil;
        cell.nameLabel.text = [NSString stringWithFormat:@"OUT OF RANGE: %@", tag.name];
        NSLog(@"tag not found!");
    }

    self.arrow.hidden = true;
    self.addLabel.hidden = true;

    NSString *proximityLabel = @"";
    switch (beacon.proximity) {
        case CLProximityFar:
            proximityLabel = [NSString stringWithFormat:@"Your %@ is Far", tag.name];
            cell.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(107/255.0) blue:(105/255.0) alpha:1];
            break;

        case CLProximityNear:
            proximityLabel = [NSString stringWithFormat:@"Your %@ is Near", tag.name];
            cell.backgroundColor = [UIColor colorWithRed:(96/255.0) green:(102/255.0) blue:(232/255.0) alpha:1];

            break;
        case CLProximityImmediate:
            proximityLabel = [NSString stringWithFormat:@"Your %@ is Close", tag.name];
                cell.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(225/255.0) blue:(167/255.0) alpha:1];
            break;

            case CLProximityUnknown:
            proximityLabel = @"Fetching Location";
            cell.backgroundColor = [UIColor whiteColor];
            break;
        }





        cell.nameLabel.text = tag.name;


    NSString *detailLabel = [NSString stringWithFormat:@"%@, Dist: %0.001f", proximityLabel, beacon.accuracy];

    cell.proxLabel.text = detailLabel;

    self.tableView.hidden = false;
    self.mapView.hidden = false;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.mapView.showsUserLocation = YES;

    [self geoCodeLoction];
    

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];


    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.locLabel.hidden = true;
    cell.accessoryView.hidden = YES;
    self.mapView.showsUserLocation = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self.moc deleteObject:self.tags[indexPath.row]];

        [self.tableView beginUpdates];

        id tmp = [self.tags mutableCopy];
        [tmp removeObjectAtIndex:indexPath.row];
        self.tags = [tmp copy];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];


            self.tableView.hidden = true;
            self.mapView.hidden = true;
            self.arrow.hidden = false;
            self.addLabel.hidden = false;
            self.addLabel.text = @"Add a tag to get started again";


        [self.tableView endUpdates];

        [self.moc save:nil];
    }
}

-(void)loadPhotos {
    NSFetchRequest *requestPhotos = [[NSFetchRequest alloc]initWithEntityName:@"Tag"];
    [requestPhotos setReturnsObjectsAsFaults:NO];
    [requestPhotos setRelationshipKeyPathsForPrefetching:@[@"comments"]];
    self.tags = [[self.moc executeFetchRequest:requestPhotos error:nil] mutableCopy];
    NSLog(@"you have %li photos", self.tags.count);

    [self.tableView reloadData];
}

-(void)loadTags
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    self.tags = (NSMutableArray *)[self.moc executeFetchRequest:request error:nil];
    NSLog(@"self.tags --------- --------- %@", self.tags);
    
//    [self.tableView reloadData];
}


@end
