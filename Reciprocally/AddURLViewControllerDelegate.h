//
//  AddURLViewControllerDelegate.h
//  Reciprocally
//
//  Created by Adam Lum on 1/31/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddURLViewController;

@protocol AddURLViewControllerDelegate

- (void)cancelPressed: (QuickDialogController *)sender;
- (void)savePressedWithDescription: (NSString *)description URL: (NSString *)url location: (NSString *)location;

@end
