//
//  HomeTableViewController.h
//  Reciprocally
//
//  Created by Adam Lum on 1/30/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "AddURLViewControllerDelegate.h"
#import "LinkDetailsViewControllerDelegeate.h"

@interface HomeTableViewController : CoreDataTableViewController <AddURLViewControllerDelegate, LinkDetailsViewControllerDelegeate>

@end
