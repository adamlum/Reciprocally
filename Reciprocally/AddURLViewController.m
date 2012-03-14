//
//  AddURLViewController.m
//  Reciprocally
//
//  Created by Adam Lum on 1/30/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import "AddURLViewController.h"

@implementation AddURLViewController

@synthesize addURLViewControllerDelegate = _addURLViewControllerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) cancelPressed
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)savePressed
{
    QEntryElement *description = (QEntryElement *)[self.root elementWithKey:@"linkDescription"];
    QEntryElement *url = (QEntryElement *)[self.root elementWithKey:@"linkURL"];
    QEntryElement *location = (QEntryElement *)[self.root elementWithKey:@"linkLocation"];
    
    [self.addURLViewControllerDelegate savePressedWithDescription:[description.textValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] URL:[url.textValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] location:[location.textValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

@end
