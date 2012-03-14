//
//  HomeTableViewController.m
//  Reciprocally
//
//  Created by Adam Lum on 1/30/12.
//  Copyright (c) 2012 Adam Lum. All rights reserved.
//

#import <iAd/iAD.h>
#import "HomeTableViewController.h"
#import "ReciprocalLink+Create.h"
#import "AddURLViewController.h"
#import "GDataXMLNode.h"
#import "LinkDetailsViewController.h"
#import "Reachability.h"

@interface HomeTableViewController()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *add;
@property (strong, nonatomic) UIManagedDocument *reciprocalLinksDatabase;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;

- (void)useDocument;

@end

@implementation HomeTableViewController

@synthesize refresh = _refresh;
@synthesize add = _add;
@synthesize reciprocalLinksDatabase = _reciprocalLinksDatabase;
@synthesize adBanner = _adBanner;

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ReciprocalLink"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.reciprocalLinksDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)setReciprocalLinksDatabase:(UIManagedDocument *)reciprocalLinksDatabase
{
    if (reciprocalLinksDatabase != _reciprocalLinksDatabase)
    {
        _reciprocalLinksDatabase = reciprocalLinksDatabase;
    }
    
    [self useDocument];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
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
    [self setRefresh:nil];
    [self setAdd:nil];
    [self setAdBanner:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.reciprocalLinksDatabase)
    {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"reciprocalLinkDatabase"];
        self.reciprocalLinksDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    else
    {
        [self useDocument];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HomeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ReciprocalLink *reciprocalLink = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = reciprocalLink.linkDescription;
    cell.detailTextLabel.text = reciprocalLink.linkLocation;
    
    if (reciprocalLink.isLinked == [NSNumber numberWithInt:1])
    {
        cell.imageView.image = [UIImage imageNamed:@"checkmark.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"ximage.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:cell.detailTextLabel.font.fontName size:10];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSTimeZoneNameStyleShortStandard];
    
    ReciprocalLink *link = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"View Reciprocal Link";
    root.controllerName = @"LinkDetailsViewController";
    root.grouped = YES;
    
    QSection *detailsSection = [[QSection alloc] initWithTitle:@"Link Details"];
    QSection *viewSiteButtonSection = [[QSection alloc] init];
    QSection *deleteButtonSection = [[QSection alloc] init];
    
    QLabelElement *description = [[QLabelElement alloc] initWithTitle:@"Description" Value:link.linkDescription];
    QLabelElement *url = [[QLabelElement alloc] initWithTitle:@"Link URL" Value:link.linkURL];
    QLabelElement *location = [[QLabelElement alloc] initWithTitle:@"Location" Value:link.linkLocation];
    location.key = @"locationKey";
    QLabelElement *created = [[QLabelElement alloc] initWithTitle:@"Created" Value:[formatter stringFromDate:link.createdDate]];
    QLabelElement *lastUpdated = [[QLabelElement alloc] initWithTitle:@"Updated" Value:[formatter stringFromDate:link.lastUpdated]];
    NSString *s = (link.isLinked == [NSNumber numberWithInt:1]) ? [NSString stringWithString:@"Yes"] : [NSString stringWithString:@"NO"];
    QLabelElement *isLinked = [[QLabelElement alloc] initWithTitle:@"Is Linked" Value:s];
    [detailsSection addElement:description];
    [detailsSection addElement:url];
    [detailsSection addElement:location];
    [detailsSection addElement:created];
    [detailsSection addElement:lastUpdated];
    [detailsSection addElement:isLinked];
    
    QButtonElement *viewSite = [[QButtonElement alloc] initWithTitle:@"View Website"];
    viewSite.controllerAction = @"viewWebsitePressed";
    viewSite.key = link.linkLocation;
    [viewSiteButtonSection addElement:viewSite];
    
    QButtonElement *delete = [[QButtonElement alloc] initWithTitle:@"Delete Link"];
    delete.controllerAction = @"deletePressed";
    [deleteButtonSection addElement:delete];
    
    [root addSection:detailsSection];
    [root addSection:viewSiteButtonSection];
    [root addSection:deleteButtonSection];
    
    LinkDetailsViewController *ldvc = [[LinkDetailsViewController alloc] initWithRoot:root];
    ldvc.linkDetailsViewControllerDelegate = self;
    ldvc.reciprocalLink = link;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ldvc];
    [self presentModalViewController:nav animated:YES];
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.reciprocalLinksDatabase.fileURL path]])
    {
        [self.reciprocalLinksDatabase saveToURL:self.reciprocalLinksDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler: ^(BOOL success){
            [self setupFetchedResultsController];
        }];
    }
    else if (self.reciprocalLinksDatabase.documentState == UIDocumentStateClosed)
    {
        [self.reciprocalLinksDatabase openWithCompletionHandler:^(BOOL success){
            [self setupFetchedResultsController];
        }];
    }
    else if (self.reciprocalLinksDatabase.documentState == UIDocumentStateNormal)
    {
        [self.reciprocalLinksDatabase openWithCompletionHandler:^(BOOL success){
            [self setupFetchedResultsController];
        }];
    }
}

- (IBAction)addPressed:(id)sender
{
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Add Reciprocal Link";
    root.controllerName = @"AddURLViewController";
    root.grouped = YES;
    
    QSection *section = [[QSection alloc] initWithTitle:@"Link Details"];
    QSection *buttonSection = [[QSection alloc] init];
    
    QEntryElement *linkDescription = [[QEntryElement alloc] initWithTitle:@"Description" Value:@"" Placeholder:@"Link Description"];
    linkDescription.key = @"linkDescription";
    linkDescription.autocapitalizationType = FALSE;
    linkDescription.autocorrectionType = FALSE;
    QEntryElement *linkURL = [[QEntryElement alloc] initWithTitle:@"Link URL" Value:@"" Placeholder:@"Your URL"];
    linkURL.key = @"linkURL";
    linkURL.autocapitalizationType = FALSE;
    linkURL.autocorrectionType = FALSE;
    linkURL.keyboardType = UIKeyboardTypeURL;
    QEntryElement *linkLocation = [[QEntryElement alloc] initWithTitle:@"Location" Value:@"" Placeholder:@"Their Website"];
    linkLocation.key = @"linkLocation";
    linkLocation.autocorrectionType = FALSE;
    linkLocation.autocapitalizationType = FALSE;
    linkLocation.keyboardType = UIKeyboardTypeURL;
    QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
    saveButton.controllerAction = @"savePressed";
    
    [section addElement:linkDescription];
    [section addElement:linkURL];
    [section addElement:linkLocation];
    [buttonSection addElement:saveButton];
    
    [root addSection:section];
    [root addSection:buttonSection];
    
    AddURLViewController *auvc = [[AddURLViewController alloc] initWithRoot:root];
    auvc.addURLViewControllerDelegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:auvc];
    [self presentModalViewController:nav animated:YES];
}

- (IBAction)refreshPressed:(id)sender
{
    Reachability *reach = [Reachability reachabilityWithHostname:@"google.com"];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    UIView *tempView = [[UIView alloc] initWithFrame:self.view.frame];
    tempView.backgroundColor = [UIColor grayColor];
    tempView.alpha = 0.65;
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = spinnerButton;
    [self.view addSubview:tempView];
    
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ReciprocalLink"];
            request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]];
            NSError *error = nil;
            NSArray *matches = [self.reciprocalLinksDatabase.managedObjectContext executeFetchRequest:request error:&error];
            
            for (ReciprocalLink *r in matches)
            {
                r.isLinked = [NSNumber numberWithBool:NO];
                
                NSString *compareString = [r.linkURL lowercaseString];
                if ([compareString characterAtIndex:[compareString length] - 1] == '/')
                {
                    compareString = [compareString substringToIndex:[compareString length] - 1];
                }
                
                NSURL *url;
                if ([r.linkLocation rangeOfString:@"http"].location == NSNotFound)
                {
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", r.linkLocation]];
                }
                else
                {
                    url = [NSURL URLWithString:r.linkLocation];
                }
                
                GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithHTMLData:[NSData dataWithContentsOfURL:url] options:0 error:NULL];
                NSArray *links = [doc nodesForXPath:@"//a" error:nil];
                
                for (GDataXMLElement *e in links)
                {
                    NSString *linkString = [[e attributeForName:@"href"].stringValue lowercaseString];
                    if ([linkString length] > 1)
                    {
                        if ([linkString characterAtIndex:[linkString length] - 1] == '/')
                        {
                            linkString = [linkString substringToIndex:[linkString length] - 1];
                        }
                        
                        if ([linkString isEqualToString:compareString])
                        {
                            r.isLinked = [NSNumber numberWithBool:YES];
                            r.linkText = e.stringValue;
                            break;
                        }
                        else
                        {
                            // Try removing http(s):// from the linkString
                            NSRegularExpression *removeHTTPFromDescription = [[NSRegularExpression alloc] initWithPattern:@"^http(s*)://" options:NSRegularExpressionCaseInsensitive error:nil];
                            linkString = [removeHTTPFromDescription stringByReplacingMatchesInString:linkString options:0 range:NSMakeRange(0, [linkString length]) withTemplate:@""];
                            
                            if ([linkString isEqualToString:compareString])
                            {
                                r.isLinked = [NSNumber numberWithBool:YES];
                                r.linkText = e.stringValue;
                                break;
                            }
                        }
                    }
                }
                r.lastUpdated = [NSDate date];
            }
            
            [self.reciprocalLinksDatabase saveToURL:self.reciprocalLinksDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                [self.view setNeedsDisplay];
            }];
            [self.reciprocalLinksDatabase.managedObjectContext save:nil];
            
            [reachability stopNotifier];
            
            [tempView removeFromSuperview];
            self.navigationItem.rightBarButtonItem = self.refresh;
        });
    };
    
    reach.unreachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Connection Failed"
                                  message: @"Unable to connect to the internet to check the links."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [tempView removeFromSuperview];
            self.navigationItem.rightBarButtonItem = self.refresh;
            
            [reachability stopNotifier];
        });
    };
    
    [reach startNotifier];
}

- (void)cancelPressed:(QuickDialogController *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)savePressedWithDescription:(NSString *)description URL:(NSString *)url location:(NSString *)location
{
    [ReciprocalLink reciprocalLinkWith:description url:url location:location inManagedContext:self.reciprocalLinksDatabase.managedObjectContext];
    [self.reciprocalLinksDatabase saveToURL:self.reciprocalLinksDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        [self.view setNeedsDisplay];
    }];
    [self.reciprocalLinksDatabase.managedObjectContext save:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)deletePressedFor:(ReciprocalLink *)link fromSender:(LinkDetailsViewController *)sender
{
    [self.reciprocalLinksDatabase.managedObjectContext deleteObject:link];
    [self.reciprocalLinksDatabase saveToURL:self.reciprocalLinksDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        [self.view setNeedsDisplay];
    }];
    [self.reciprocalLinksDatabase.managedObjectContext save:nil];
    [self dismissModalViewControllerAnimated:YES];
}

@end
