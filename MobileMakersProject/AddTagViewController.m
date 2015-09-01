//
//  AddTagViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "AddTagViewController.h"
#import "MobileCoreServices/MobileCoreServices.h" //this will not auto complete.
#import "AppDelegate.h"
#import "Tag.h"
#import "DisplayViewController.h"

@interface AddTagViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;
@property NSManagedObjectContext *moc;
@property (nonatomic, copy) NSArray *photos;
@property CLLocationManager *locationManager;
@property NSMutableArray *beacons;
@property NSMutableArray *tags;


@property CLProximity lastProximity;



@end

@implementation AddTagViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.photos = [NSArray new];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.locationManager = delegate.locationManager;
    self.moc = delegate.managedObjectContext;

    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //

    self.cameraImage.layer.cornerRadius = 10.0f;
    self.cameraImage.clipsToBounds = YES;

    self.cameraImage.layer.borderWidth = 3.0f;
    self.cameraImage.layer.borderColor = [UIColor whiteColor].CGColor;


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

- (IBAction)onContinueButtonPressed:(UIButton *)sender {

    UIImage *image = self.imageView.image; //image
    NSData *imageData = UIImagePNGRepresentation(image); //image

  //  NSLog(@"inserting data");

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.moc = delegate.managedObjectContext;



    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.moc];
    
    [newObject setValue:self.nameTxtFld.text forKey:@"name"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [newObject setValue:[f numberFromString:self.minorTxtFld.text] forKey:@"minor"];
    [newObject setValue:imageData forKey:@"image"];

    [self.moc save:nil];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    self.tags = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    NSLog(@"self.tags is %@", newObject);


}

#pragma mark Loc Delegate Methods

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

  //  NSString *message = @"";
    self.beacons = [beacons mutableCopy];
    if(beacons.count > 0)
    {

        CLBeacon *nearestBeacon = beacons.firstObject;
        self.minorTxtFld.text = [NSString stringWithFormat:@"%@", nearestBeacon.minor];
    }
//    [self.tableView reloadData];

//    NSLog(@"Beaconssss %@", beacons);


//    if(beacons.count > 0)
//    {
//
//        CLBeacon *nearestBeacon = beacons.firstObject;
//        self.minorTxtFld.text = [NSString stringWithFormat:@"%@", nearestBeacon.minor];
//        if(nearestBeacon.proximity == self.lastProximity || nearestBeacon.proximity == CLProximityUnknown)
//        {
//
//            return;
//        }
//        self.lastProximity = nearestBeacon.proximity;
//
//        switch(nearestBeacon.proximity) {
//            case CLProximityFar:
//                message = @"You are far away from the beacon";
//
//                break;
//            case CLProximityNear:
//                message = @"You are near the beacon";
//                break;
//            case CLProximityImmediate:
//                message = @"You are in the immediate proximity of the beacon";
//
//                break;
//            case CLProximityUnknown:
//                break; //check
//            default: message = @"No beacons are nearby";
//        }
//    }
//    
//    NSLog(@"%@", message);
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    //    Tag *tag = self.tags.firstObject;
    //    tag.lastSeenLat = [NSNumber numberWithDouble:self.mapView.userLocation.coordinate.latitude];
    //    tag.lastSeenLon = [NSNumber numberWithDouble:self.mapView.userLocation.coordinate.latitude];
    //    [self.locationManager stopUpdatingLocation];
    
}














- (void)loadPhotos {

    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tag"];
    self.photos = [self.moc executeFetchRequest:request error:nil];
   // NSLog(@"you have %li photos", self.photos.count);

    for (Tag *photo in self.photos)
    {
        NSData *data = photo.image;
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }
}

- (void) useCameraRoll:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString*) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        self.newMedia = NO;
    }
}

- (void) useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        self.newMedia = YES;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];

    [self dismissViewControllerAnimated:YES completion:nil];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = image;

//        NSString *fileName = [NSString stringWithFormat:@"%@.png", [self sha1]];
//
//        [self saveImageFile:image withName:fileName];

        if (self.newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);

    }
}

//- (NSString*)sha1
//{
//    NSString *input = [[NSDate new] description];
//
//    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:input.length];
//
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//
//    CC_SHA1(data.bytes, (int)data.length, digest);
//
//    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//    
//    return output;
//}
//
//-(void)saveImageFile:(UIImage *)image withName:(NSString *)name
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"directory -- %@", documentsDirectory);
//    
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:name];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [imageData writeToFile:savedImagePath atomically:NO];
//}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}



@end
