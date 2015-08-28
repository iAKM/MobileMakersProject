//
//  ActivateViewController.m
//  MobileMakersProject
//
//  Created by Stephen Cary on 8/28/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "ActivateViewController.h"

@interface ActivateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *activateButton;

@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  self.continueButton.enabled = false;

}

- (IBAction)onActivateButtonPressed:(id)sender {

    if (self.activateButton.enabled == NO)
    {
            self.continueButton.enabled = false;
    }
    else
    {
        self.continueButton.enabled = true;
        [self.continueButton setTitleColor:[UIColor colorWithRed:232/255.0 green:208/255.0 blue:96/255.0 alpha:1] forState:normal];
    }

}

@end
