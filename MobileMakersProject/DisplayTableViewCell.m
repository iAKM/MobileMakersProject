//
//  DisplayTableViewCell.m
//  MobileMakersProject
//
//  Created by Stephen Cary on 8/22/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "DisplayTableViewCell.h"

@implementation DisplayTableViewCell

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

    self.imageView.frame = CGRectMake( 215, 22, 85, 85 ); // image positioning here
    self.textLabel.frame = CGRectMake(15, 0, 370, 131);
}

@end
