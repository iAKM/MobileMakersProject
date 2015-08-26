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

    self.imageView.frame = CGRectMake(8, 25, 87, 80); // image positioning here
   // self.textLabel.frame = CGRectMake(15, 0, 370, 131);
   // self.detailTextLabel.frame = CGRectMake(16, 69, 150, 14);
    

    self.imageView.layer.cornerRadius = 10.0f;
    self.imageView.clipsToBounds = YES;

    self.imageView.layer.borderWidth = 3.0f;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;


}

@end
