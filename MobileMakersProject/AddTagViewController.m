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
#import "DisplayViewController.h"

@interface AddTagViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property NSManagedObjectContext *moc;
@property (nonatomic, copy) NSArray *photos;

@end

@implementation AddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.photos = [NSArray new];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //does not hide navigation bar

}

- (IBAction)onActivateButtonPressed:(UIButton *)sender {

    UIImage *image = self.imageView.image; //image
    NSData *imageData = UIImagePNGRepresentation(image); //image

//    self.photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"inManagedObjectContext:self.moc];

    NSLog(@"inserting data");

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.moc = delegate.managedObjectContext;

    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.moc];
    
    [newObject setValue:self.nameTxtFld.text forKey:@"name"];
    [newObject setValue:[NSNumber numberWithInteger:[self.majorTxtFld.text integerValue]] forKey:@"major"];
    [newObject setValue:[NSNumber numberWithInteger:[self.minorTxtFld.text integerValue]] forKey:@"minor"];
   // [newObject setValue:self.uuidTxtFld.text forKey:@"uuid"];
    [newObject setValue:imageData forKey:@"image"];

    

    [self.moc save:nil];

   // DisplayViewController *dvc = [DisplayViewController new];

  //  [dvc getBeaconsWithString:self.uuidTxtFld.text];
    
}


- (void)loadPhotos {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tag"];
    self.photos = [self.moc executeFetchRequest:request error:nil];
    NSLog(@"you have %li photos", self.photos.count);

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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}


@end
