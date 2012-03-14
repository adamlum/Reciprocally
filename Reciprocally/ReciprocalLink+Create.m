//
//  ReciprocalLink+Create.m
//  Reciprocally
//
//  Created by Adam Lum on 1/31/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import "ReciprocalLink+Create.h"

@implementation ReciprocalLink (Create)

+ (ReciprocalLink *)reciprocalLinkWith:(NSString *)description url:(NSString *)url location:(NSString *)location inManagedContext:(NSManagedObjectContext *)context
{
    ReciprocalLink *reciprocalLink = [NSEntityDescription insertNewObjectForEntityForName:@"ReciprocalLink" inManagedObjectContext:context];
    reciprocalLink.linkDescription = description;
    reciprocalLink.linkURL = url;
    reciprocalLink.linkLocation = location;
    reciprocalLink.createdDate = [NSDate date];
    reciprocalLink.lastUpdated = nil;
    reciprocalLink.isLinked = [NSNumber numberWithBool:NO];
                                      
    return reciprocalLink;
}

@end