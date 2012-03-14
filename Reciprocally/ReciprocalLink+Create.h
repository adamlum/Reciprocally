//
//  ReciprocalLink+Create.h
//  Reciprocally
//
//  Created by Adam Lum on 1/31/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import "ReciprocalLink.h"

@interface ReciprocalLink (Create)

+ (ReciprocalLink *)reciprocalLinkWith: (NSString *)description url:(NSString *)url location:(NSString *)location inManagedContext: (NSManagedObjectContext *)context;

@end
