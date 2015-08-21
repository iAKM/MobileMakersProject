//
//  AddTagViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "AddTagViewController.h"
#import "AppDelegate.h"
#import "Tag.h"

@interface AddTagViewController ()

@property NSManagedObjectContext *moc;

@end

@implementation AddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (IBAction)onActivateButtonPressed:(UIButton *)sender {

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


@end
