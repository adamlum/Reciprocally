//
//  AddURLViewController.h
//  Reciprocally
//
//  Created by Adam Lum on 1/30/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddURLViewControllerDelegate.h"

@interface AddURLViewController : QuickDialogController

@property (nonatomic, strong) id<AddURLViewControllerDelegate> addURLViewControllerDelegate;

@end
