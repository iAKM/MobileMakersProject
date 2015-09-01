//
//  Tag.h
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 31/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * lastSeenLat;
@property (nonatomic, retain) NSNumber * lastSeenLon;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * proximity;

@end
