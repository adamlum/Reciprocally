//
//  ReciprocalLink.h
//  Reciprocally
//
//  Created by Adam Lum on 1/30/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReciprocalLink : NSManagedObject

@property (nonatomic, retain) NSString * linkDescription;
@property (nonatomic, retain) NSString * linkURL;
@property (nonatomic, retain) NSString * linkLocation;
@property (nonatomic, retain) NSString * linkText;
@property (nonatomic, retain) NSNumber * isLinked;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSDate * createdDate;

@end
