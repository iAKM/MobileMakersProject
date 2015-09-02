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

@property Tag *tag;

@property (strong, nonatomic) IBOutlet UITextField *minorTxtFld;

@property CLProximity lastProximity;


@property (nonatomic, readonly)   Jaalee_Audio_State      audioState;

@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  self.continueButton.enabled = false;

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.locationManager = delegate.locationManager;
    self.moc = delegate.managedObjectContext;

    [self rangeBeacons];

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

    self.minor = self.minorTxtFld.text;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];

    self.tags = [self.moc executeFetchRequest:request error:nil].mutableCopy;

    for (Tag *tag in self.tags)
    {
        if ([self.minorTxtFld.text isEqualToString:[tag.minor stringValue]])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You already activated this beacon:" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

          //  self.continueButton.enabled = false;

            
        }
    else
    {
       // self.continueButton.enabled = true;
        [NSThread sleepForTimeInterval:3.00];
        self.continueButton.enabled = true;

        //[self.continueButton setTitleColor:[UIColor colorWithRed:232/255.0 green:208/255.0 blue:96/255.0 alpha:1] forState:normal];



    }


//    if (self.activateButton.enabled == NO)
//    {
//            self.continueButton.enabled = false;
//
//    }
//    else
//    {

//
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    }
}
}

- (IBAction)onContinueButtonPressed:(UIButton *)sender {

    


}
//
//    if ([self.minorTxtFld.text isEqualToString:[self.tag.minor stringValue]])
//    {
//        NSLog(@"You already activated");
//
//    }
//    else
//    {
//        NSLog(@"New");
//
//    }
//



//    for (Tag *tag in self.tags)
//    {
//        if ([self.minorTxtFld.text isEqual:tag.minor])
//        {
//            NSLog(@"You activated if already");
//        }
//    }



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
