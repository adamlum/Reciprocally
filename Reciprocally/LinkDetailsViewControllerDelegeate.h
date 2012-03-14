//
//  LinkDetailsViewControllerDelegeate.h
//  Reciprocally
//
//  Created by Adam Lum on 1/31/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LinkDetailsViewController;
@class ReciprocalLink;

@protocol LinkDetailsViewControllerDelegeate

- (void)cancelPressed: (QuickDialogController *)sender;
- (void)deletePressedFor: (ReciprocalLink *)link fromSender: (LinkDetailsViewController *)sender; 

@end
