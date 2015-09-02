//
//  ActivateViewController.h
//  MobileMakersProject
//
//  Created by Stephen Cary on 8/28/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivateViewController : UIViewController

@property NSString *minor;


typedef NS_ENUM(NSInteger, Jaalee_Audio_State) {
//    BEACON_AUDIO_STATE_ENABLE = 0,
//    BEACON_AUDIO_STATE_ENABLE_WHEN_START,
    BEACON_AUDIO_STATE_ENABLE_WHEN_TAP,
//    BEACON_AUDIO_STATE_DISABLE,
//    BEACON_AUDIO_STATE_UNKNOWN
};

@end
