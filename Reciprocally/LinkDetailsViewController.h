//
//  LinkDetailsViewController.h
//  Reciprocally
//
//  Created by Adam Lum on 1/31/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReciprocalLink.h"
#import "LinkDetailsViewControllerDelegeate.h"

@interface LinkDetailsViewController : QuickDialogController

@property (nonatomic, strong) id<LinkDetailsViewControllerDelegeate> linkDetailsViewControllerDelegate;
@property (nonatomic, strong) ReciprocalLink *reciprocalLink;

@end
