//
//  AddTagViewController.h
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddTagViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *minorTxtFld;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;





@property BOOL newMedia;

- (IBAction)useCameraRoll:(id)sender;
- (IBAction)useCamera:(id)sender;



@end
