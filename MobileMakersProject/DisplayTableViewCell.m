//
//  DisplayTableViewCell.m
//  MobileMakersProject
//
//  Created by Stephen Cary on 8/22/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "DisplayTableViewCell.h"

@implementation DisplayTableViewCell

@dynamic imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
   // [self cardViewSetup];
    [self imageSetup];


}

//-(void)cardViewSetup
//{
//    [self.cardView setAlpha:1];
//    self.cardView.layer.masksToBounds = NO;
//    self.cardView.layer.cornerRadius = 1;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
//    self.cardView.layer.shadowPath = path.CGPath;
//    self.cardView.layer.shadowOpacity = 0.2;
//
//}


-(void)imageSetup
{
    self.imageView.frame = CGRectMake(8, 25, 75, 75); // image positioning here
    self.imageView.layer.cornerRadius = 10.0f;
    self.imageView.clipsToBounds = YES;

    self.imageView.layer.borderWidth = 3.0f;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
