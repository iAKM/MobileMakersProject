//
//  ActivateViewController.m
//  MobileMakersProject
//
//  Created by Stephen Cary on 8/28/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ActivateViewController.h"
#import "AppDelegate.h"
#import "AddTagViewController.h"
#import "Tag.h"

@interface ActivateViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *activateButton;
@property NSManagedObjectContext *moc;
@property CLLocationManager *locationManager;
@property NSMutableArray *beacons;
@property NSMutableArray *tags;
@property (strong, nonatomic) IBOutlet UILabel *actLabel;

@property Tag *tag;

@property (strong, nonatomic) IBOutlet UITextField *minorTxtFld;

@property CLProximity lastProximity;


@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  self.continueButton.enabled = false;

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.locationManager = delegate.locationManager;
    self.moc = delegate.managedObjectContext;

    [self rangeBeacons];

    self.actLabel.hidden = YES;

}

- (void)rangeBeacons {
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF525"];
    NSString *regionIdentifier = @"ibeaconModuleUS";

    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:beaconUUID identifier:regionIdentifier];
    NSLog(@"beacon reghionnn %@", beaconRegion.minor);

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

- (IBAction)onActivateButtonPressed:(id)sender {

    [NSThread sleepForTimeInterval:3.00];
    self.minor = self.minorTxtFld.text;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];

    self.tags = [self.moc executeFetchRequest:request error:nil].mutableCopy;

    BOOL tagExists = NO;

    for (Tag *tag in self.tags)
    {
        if ([self.minorTxtFld.text isEqualToString:[tag.minor stringValue]]) {
            tagExists = YES;
        }
    }

    if(tagExists)
    {
        self.actLabel.hidden = NO;
        self.actLabel.text = @"Activation Failed. Try again with another beacon.";


        self.continueButton.enabled = false;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You already activated this beacon:" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.continueButton setTitleColor:[UIColor redColor] forState:normal];

    }
    else
    {
        self.actLabel.hidden = NO;
        self.actLabel.text = @"Activated Successfully";

        self.continueButton.enabled = true;
        [NSThread sleepForTimeInterval:2.00];
        [self.continueButton setTitleColor:[UIColor greenColor] forState:normal];

    }


   }


- (IBAction)onContinueButtonPressed:(UIButton *)sender {

    

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddTagViewController *atvc = segue.destinationViewController;
    atvc.minor = self.minor;
    
}
#pragma mark Loc Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{

}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{

    self.beacons = [beacons mutableCopy];
    if(beacons.count > 0)
    {

        CLBeacon *nearestBeacon = beacons.firstObject;
        self.minorTxtFld.text = [NSString stringWithFormat:@"%@", nearestBeacon.minor];
    }

}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    
}


@end
