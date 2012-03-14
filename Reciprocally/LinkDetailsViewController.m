//
//  LinkDetailsViewController.m
//  Reciprocally
//
//  Created by Adam Lum on 1/31/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import "LinkDetailsViewController.h"

@implementation LinkDetailsViewController

@synthesize reciprocalLink = _reciprocalLink;
@synthesize linkDetailsViewControllerDelegate = _linkDetailsViewControllerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)backPressed
{
    [self.linkDetailsViewControllerDelegate cancelPressed:self];
}

- (void)viewWebsitePressed
{
    NSRegularExpression *httpAtBeginning = [[NSRegularExpression alloc] initWithPattern:@"^http(s*)://" options:NSRegularExpressionCaseInsensitive error:nil];
    
    if ([httpAtBeginning matchesInString:self.reciprocalLink.linkLocation options:0 range:NSMakeRange(0, [self.reciprocalLink.linkLocation length])].count <= 0)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.reciprocalLink.linkLocation]];
        if (url != nil)
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Could Not Open Link"
                                  message: @"Invalid link URL, the website could not be accessed."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.reciprocalLink.linkLocation]];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 1: 
        {
            [self.linkDetailsViewControllerDelegate deletePressedFor:self.reciprocalLink fromSender:self];
        }
            break;
    }
}

- (void)deletePressed
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: @"Delete Reciprocal Link"
                          message: @"Are you sure you want to delete this reciprocal link?"
                          delegate: self
                          cancelButtonTitle: @"Cancel"
                          otherButtonTitles: @"Delete", nil];
    [alert show];
}

@end
