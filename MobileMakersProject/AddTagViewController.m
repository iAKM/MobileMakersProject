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

@interface AddTagViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;
@property NSManagedObjectContext *moc;
@property (nonatomic, copy) NSArray *photos;

@end

@implementation AddTagViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.photos = [NSArray new];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //

    self.cameraImage.layer.cornerRadius = 10.0f;
    self.cameraImage.clipsToBounds = YES;

    self.cameraImage.layer.borderWidth = 3.0f;
    self.cameraImage.layer.borderColor = [UIColor whiteColor].CGColor;

}


- (IBAction)onContinueButtonPressed:(UIButton *)sender {

    UIImage *image = self.imageView.image; //image
    NSData *imageData = UIImagePNGRepresentation(image); //image


    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.moc = delegate.managedObjectContext;


    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.moc];
    
    [newObject setValue:self.nameTxtFld.text forKey:@"name"];
    [newObject setValue:imageData forKey:@"image"];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [newObject setValue:[f numberFromString:self.minor] forKey:@"minor"];

     [self.moc save:nil];


}


- (void)loadPhotos {

    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tag"];
    self.photos = [self.moc executeFetchRequest:request error:nil];

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
