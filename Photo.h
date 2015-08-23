//
//  Photo.h
//  MobileMakersProject
//
//  Created by Stephen Cary on 8/21/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * imageData;

@end
