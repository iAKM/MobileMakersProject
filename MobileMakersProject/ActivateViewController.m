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

@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.continueButton.enabled = false;

}




@end
