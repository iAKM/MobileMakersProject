//
//  AddTagViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "AddTagViewController.h"
#import "MobileCoreServices/MobileCoreServices.h" //this will not auto complete.
#import "AppDelegate.h"
#import "Tag.h"
#import "Photo.h"

@interface AddTagViewController ()

@property NSManagedObjectContext *moc;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, copy) NSArray *photos;

@end

@implementation AddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.photos = [NSArray new];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;


//    [self loadPhotos];


}

- (IBAction)onActivateButtonPressed:(UIButton *)sender {

    UIImage *image = self.imageView.image; //image
    NSData *imageData = UIImagePNGRepresentation(image); //image

    self.photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"inManagedObjectContext:self.moc];
    self.photo.imageData = imageData; //image

    NSLog(@"inserting data");

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.moc];

    [object setValue:self.nameTxtFld.text forKey:@"name"];
    [object setValue:self.uuidTxtFld.text forKey:@"uuid"];
    [object setValue:[NSNumber numberWithInteger:[self.majorTxtFld.text integerValue]] forKey:@"major"];
    [object setValue:[NSNumber numberWithInteger:[self.minorTxtFld.text integerValue]] forKey:@"minor"];

    [self.moc save:nil];

    NSLog(@"moc is %@", self.moc);
    
}

- (void)loadPhotos {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Photo"];
    self.photos = [self.moc executeFetchRequest:request error:nil];
    NSLog(@"you have %li photos", self.photos.count);

    for (Photo *photo in self.photos)
    {
        NSData *data = photo.imageData;
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

        if (self.newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }
}

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










@end
