//
//  NearbyViewController.m
//  Feeditch
//
//  Created by MachOSX on 2/7/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Social/Social.h>
#import "NearbyViewController.h"
#import "PostComposer_Stage1.h"
#import "AppDelegate.h"
#import "InnerPostViewController.h"

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self )
    {
        self.title = NSLocalizedString(@"Nearby", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"tab_bar_icon_nearby"];
    }
    
    return self;
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}
							
- (void)viewDidLoad
{
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 35)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
    
    navBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showPostComposer)];
    
    self.nearbyFeed.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    
    self.nearbyFeedData = [[NSMutableArray alloc] init];
    
    feedDidFinishDownloading = NO;
    
    if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc]
                             initWithFrame:CGRectMake(0, 0 - self.nearbyFeed.bounds.size.height, self.view.frame.size.width, self.nearbyFeed.bounds.size.height)];
		refreshHeaderView.delegate = self;
		[self.nearbyFeed addSubview:refreshHeaderView];
	}
    
    // Get the user's current location & save it.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    locationErrorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error_big"]];
    locationErrorIcon.frame = CGRectMake(120, 100, 81, 67);
    locationErrorIcon.opaque = YES;
    locationErrorIcon.hidden = YES;
    
    locationErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 280, 35)];
    locationErrorLabel.backgroundColor = [UIColor clearColor];
    locationErrorLabel.textColor = [UIColor colorWithRed:123.0/255.0 green:123.0/255.0 blue:123.0/255.0 alpha:1.0];
    locationErrorLabel.textAlignment = NSTextAlignmentCenter;
    locationErrorLabel.numberOfLines = 0;
    locationErrorLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    locationErrorLabel.opaque = YES;
    locationErrorLabel.text = NSLocalizedString(@"Couldn't get your location. Please enable location services in your phone settings.", nil);
    locationErrorLabel.hidden = YES;
    
    [self.view addSubview:locationErrorIcon];
    [self.view addSubview:locationErrorLabel];
    
    //self.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
}

- (void)showPostComposer
{
    
    PostComposer_Stage1 *postComposer = [[PostComposer_Stage1 alloc] init];
    UINavigationController *postComposerNavigationController = [[UINavigationController alloc] initWithRootViewController:postComposer];
    
    [self.view.window.rootViewController presentViewController:postComposerNavigationController animated:YES completion:NULL];
    /*AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 102;
    
    [actionSheet showFromTabBar:appDelegate.tabBarController.tabBar];*/
    
}

- (void)downloadFeedForBatch:(int)batch
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    feedDidFinishDownloading = NO;
    [self.nearbyFeed reloadData];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/get-posts-by-distance", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    NSLog(@"Token:%@", appDelegate.FIToken);
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[NSNumber numberWithInt:batch] forKey:@"batch"];
    [wrequest setPostValue:[NSNumber numberWithFloat:appDelegate.currentLocation.latitude] forKey:@"current_location_lat"];
    [wrequest setPostValue:[NSNumber numberWithFloat:appDelegate.currentLocation.longitude] forKey:@"current_location_long"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        
        if ( ![[NSNull null] isEqual:wrequest.responseString] && wrequest.responseString )
        {
            responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
            
            if ( [[responseData objectForKey:@"error"] intValue] == 0 )
            {
                NSDictionary *response = [responseData objectForKey:@"response"];
                
                if ( self.batchNo == 0 )
                {
                    [self.nearbyFeedData removeAllObjects];
                }
                
                for ( NSMutableDictionary *post in response )
                {
                    [self.nearbyFeedData addObject:[post mutableCopy]];  // IMPORTANT: MAKE A MUTABLE COPY!!! Spent an hour trying to figure this shit out. :@
                }
                
                if ( response.count < BATCH_SIZE )
                {
                    endOfFeed = YES;
                }
                else
                {
                    endOfFeed = NO;
                }
                
                feedDidFinishDownloading = YES;
                [self performSelector:@selector(doneLoadingTableViewData)];
                [self.nearbyFeed reloadData];
                
                locationErrorIcon.hidden = YES;
                locationErrorLabel.hidden = YES;
            }
        }
        else
        {
            [self downloadFeedForBatch:self.batchNo];
        }
        
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        
        // Set custom view mode.
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"Communication Error", nil);
        
        feedDidFinishDownloading = YES;
        [self performSelector:@selector(doneLoadingTableViewData)];
        [self.nearbyFeed reloadData];
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)gotoPostAtIndexPath:(NSIndexPath *)indexPath
{
    InnerPostViewController *innerPostView = [[InnerPostViewController alloc] initWithNibName:@"InnerPostViewController" bundle:[NSBundle mainBundle]];
    innerPostView.hidesBottomBarWhenPushed = YES;
    innerPostView.postChunk = [self.nearbyFeedData objectAtIndex:indexPath.row];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Nearby", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:innerPostView animated:YES];
	innerPostView = nil;
}

- (void)itchPost:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *itchButton = (UIButton *)sender;
    FeedItemCell *targetCell = (FeedItemCell *)[[[[itchButton superview] superview] superview] superview];
    
    NSLog(@">>> %@", [targetCell superview]);

    NSMutableDictionary *entryData = [self.nearbyFeedData objectAtIndex:targetCell.rowNumber];
    int itchCount = [[entryData objectForKey:@"liker_count"] intValue];
    
    if ( ![[NSNull null] isEqual:[entryData objectForKey:@"viewer_likes_post"]] )
    {
        itchCount--;
        [[self.nearbyFeedData objectAtIndex:targetCell.rowNumber] setObject:[NSNull null] forKey:@"viewer_likes_post"];
        targetCell.itchCountLabel.textColor = [UIColor whiteColor];
        [targetCell.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button"] forState:UIControlStateNormal];
    }
    else
    {
        itchCount++;
        [[self.nearbyFeedData objectAtIndex:targetCell.rowNumber] setObject:@"1" forKey:@"viewer_likes_post"];
        targetCell.itchCountLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        [targetCell.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button_itched"] forState:UIControlStateNormal];
    }
    
    [[self.nearbyFeedData objectAtIndex:targetCell.rowNumber] setObject:[NSNumber numberWithInt:itchCount] forKey:@"liker_count"];
    targetCell.itchCountLabel.text = [NSString stringWithFormat:@"%d", itchCount];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/like-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[entryData objectForKey:@"id"] forKey:@"post_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            
        }
        else
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
            
            // Set custom view mode.
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.dimBackground = YES;
            HUD.delegate = self;
            HUD.labelText = NSLocalizedString(@"An error happened :(", nil);
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
        }
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        
        // Set custom view mode.
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"Communication Error", nil);
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)showPostSharingOptions:(id)sender
{
    UIButton *button = (UIButton *)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FeedItemCell *targetCell = (FeedItemCell *)[[[[button superview] superview] superview] superview];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:targetCell.rowNumber inSection:0];
    int userid = [[[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
    
    if ( userid == [[appDelegate.global readProperty:@"userid"] intValue] || [[appDelegate.global readProperty:@"userid"] intValue] == 1 ) // Superuser is id = 1.
    {
        sharingOptions = [[UITableViewActionSheet alloc]
                          initWithTitle:NSLocalizedString(@"Share this", nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          destructiveButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Email   ", nil), NSLocalizedString(@"Facebook", nil), NSLocalizedString(@"Twitter", nil), NSLocalizedString(@"Delete this picture", nil), nil];
    }
    else
    {
        sharingOptions = [[UITableViewActionSheet alloc]
                          initWithTitle:NSLocalizedString(@"Share this", nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          destructiveButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Email   ", nil), NSLocalizedString(@"Facebook", nil), NSLocalizedString(@"Twitter", nil), nil];
    }
    
    sharingOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    sharingOptions.tag = 100;
    sharingOptions.indexPath = indexPath;
    [sharingOptions showFromTabBar:appDelegate.tabBarController.tabBar];
}

- (void)showPostDeletionOptionsAtIndexPath:(NSIndexPath *)indexPath
{
    sharingOptions = [[UITableViewActionSheet alloc]
                      initWithTitle:NSLocalizedString(@"Delete picture", nil)
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                      destructiveButtonTitle:NSLocalizedString(@"Delete Picture", nil)
                      otherButtonTitles:nil];
    
    sharingOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    sharingOptions.tag = 101;
    sharingOptions.indexPath = indexPath;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharingOptions showFromTabBar:appDelegate.tabBarController.tabBar];
}

- (void)handlePostSharingAtIndexPath:(NSIndexPath *)indexPath forButtonAtIndex:(int)buttonIndex
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int userid = [[[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
    
    if ( buttonIndex == 0 ) // Email.
    {
        [Flurry logEvent:@"Share via Email"];
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        int postid = [[[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        NSString *fullName = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        NSString *dishName = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
        NSString *venueName = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
        NSString *gender = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"sex"];
        NSString *verb = @"";
        
        if ( [gender isEqualToString:@"male"] ) {
            verb = NSLocalizedString(@"Recommends_male", nil);
        }
        else
        {
            verb = NSLocalizedString(@"Recommends_female", nil);
        }
        
        NSString *emailBody = [NSString stringWithFormat:@"<div dir='%@' style='color:#919191;'><strong style='color:#000;'>%@</strong> %@ <strong style='color:#000;'>%@</strong> %@ <strong style='color:#00a9a3;'>%@</strong></div>"
                               @"<br />"
                               @"<a dir='%@' href='http://%@/index/sighting?id=%d'>%@</a><br /><br />%@",
                               appDelegate.isArabic ? @"rtl" : @"ltr", fullName, verb, dishName, NSLocalizedString(@"at", nil), venueName, appDelegate.isArabic ? @"rtl" : @"ltr", FI_DOMAIN, postid, NSLocalizedString(@"View Post", nil), NSLocalizedString(@"Sent via Feeditch", nil)]; // Fill out the email body text.
        [picker setSubject:NSLocalizedString(@"Feeditch_mail_subject", nil)];
        [picker setMessageBody:emailBody isHTML:YES]; // Depends. Mostly YES, unless you want to send it as plain text (boring).
        
        [self.view.window.rootViewController presentViewController:picker animated:YES completion:NULL];
    }
    else if ( buttonIndex == 1 ) // Facebook.
    {
        [Flurry logEvent:@"Share via Facebook"];
        
        if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] )
        {
            SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            int postid = [[[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
            NSString *dishName = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
            NSString *venueName = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
            
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result) {
                [fbController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result) {
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled!");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted!");
                    }
                        break;
                }};
            
            [fbController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"I recommend %@ at %@", nil), dishName, venueName]];
            [fbController addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index/sighting?id=%d", FI_DOMAIN, postid]]];
            [fbController setCompletionHandler:completionHandler];
            [self.view.window.rootViewController presentViewController:fbController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"fb_no_account", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ( buttonIndex == 2 ) // Twitter.
    {
        [Flurry logEvent:@"Share via Twitter"];
        
        if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] )
        {
            SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            int postid = [[[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
            NSString *dishName = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
            NSString *venueName = [[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
            NSString *previewText = [NSString stringWithFormat:NSLocalizedString(@"%@ at %@", nil), dishName, venueName];
            
            if (previewText.length > 69) {
                previewText = [NSString stringWithFormat:@"%@", [previewText substringToIndex:68]];
            } else {
                previewText = [NSString stringWithFormat:@"%@", previewText];
            }
            
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result) {
                [twitterController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result) {
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled!");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted!");
                    }
                        break;
                }};
            
            [twitterController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"I recommend %@ at %@", nil), dishName, venueName]];
            [twitterController addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index/sighting?id=%d", FI_DOMAIN, postid]]];
            [twitterController setCompletionHandler:completionHandler];
            [self.view.window.rootViewController presentViewController:twitterController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"لا يوجد حساب تويتر على جهازك. الرجاء إدخال بيانات حسابك في إعدادات الجهاز." delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ( buttonIndex == 3 && (userid == [[appDelegate.global readProperty:@"userid"] intValue] || [[appDelegate.global readProperty:@"userid"] intValue] == 1) ) // Delete post.
    {
        [self showPostDeletionOptionsAtIndexPath:indexPath];
    }
}

- (void)handlePostDeletionAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/delete-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[[self.nearbyFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"post_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            [self.nearbyFeedData removeObjectAtIndex:indexPath.row];
            [self.nearbyFeed deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.nearbyFeed reloadData];
        }
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        
        // Set custom view mode.
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"Communication Error", nil);
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Status" message:@"Sending Failed - Unknown Error"
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles: nil];
            [alert show];
        }
            
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITableViewActionSheet *targetActionSheet = (UITableViewActionSheet *)actionSheet;
    
    if ( targetActionSheet.tag == 100 )     // Sharing options
    {
        [self handlePostSharingAtIndexPath:targetActionSheet.indexPath forButtonAtIndex:buttonIndex];
    }
    else if ( targetActionSheet.tag == 101 ) // Deletion options
    {
        if ( buttonIndex == 0 )
        {
            [self handlePostDeletionAtIndexPath:targetActionSheet.indexPath];
        }
        
    }else if(targetActionSheet.tag == 102){
        PostComposer_Stage1 *postComposer = [[PostComposer_Stage1 alloc] init];
        UINavigationController *postComposerNavigationController = [[UINavigationController alloc] initWithRootViewController:postComposer];
        
        [self.view.window.rootViewController presentViewController:postComposerNavigationController animated:YES completion:NULL];
        [postComposer hidePhotoOptions];
        
        if(buttonIndex == 0){
         //   [postComposer showCamera];
        }else if(buttonIndex == 1){
          //  [postComposer showPhotoLibrary];
        }
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Hide the location error.
    locationErrorIcon.hidden = YES;
    locationErrorLabel.hidden = YES;
    
    appDelegate.currentLocation = newLocation.coordinate;
    
    [locationManager stopUpdatingLocation];
    
    self.batchNo = 0;
    
    [self downloadFeedForBatch:self.batchNo];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( status != kCLAuthorizationStatusAuthorized || ![CLLocationManager locationServicesEnabled] )
    {
        // Show the location error.
        locationErrorIcon.hidden = NO;
        locationErrorLabel.hidden = NO;
        appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    }
    
    [locationManager stopUpdatingLocation];
    
    [self.nearbyFeedData removeAllObjects];
    feedDidFinishDownloading = YES;
    [self performSelector:@selector(doneLoadingTableViewData)];
    [self.nearbyFeed reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    // Show the location error.
    locationErrorIcon.hidden = NO;
    locationErrorLabel.hidden = NO;
    
    [locationManager stopUpdatingLocation];
    
    [self.nearbyFeedData removeAllObjects];
    feedDidFinishDownloading = YES;
    [self performSelector:@selector(doneLoadingTableViewData)];
    [self.nearbyFeed reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyFeedData.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *assembledCell;
    int lastIndex = [self.nearbyFeedData count] - 1;
    
    if ( indexPath.row == [self.nearbyFeedData count] ) // Cell for loading more.
    {
        static NSString *cellIdentifier = @"LoadingCell";
        feedItemCell = (FeedItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ( assembledCell == nil )
        {
            feedItemCell = [[FeedItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            feedItemCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
            feedItemCell.textLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
            feedItemCell.textLabel.textAlignment = NSTextAlignmentCenter;
            feedItemCell.cardBG.hidden = YES;
        }
        
        if ( !feedDidFinishDownloading )
        {
            feedItemCell.textLabel.text = NSLocalizedString(@"Please wait...", nil);
            feedItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            if ( !endOfFeed )
            {
                feedItemCell.textLabel.text = NSLocalizedString(@"Load more", nil);
                feedItemCell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            else
            {
                feedItemCell.textLabel.text = @"";
                feedItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
        assembledCell = feedItemCell;
    }
    else if ( indexPath.row <= lastIndex )
    {
        static NSString *cellIdentifier = @"ItemCell";
        feedItemCell = (FeedItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ( assembledCell == nil )
        {
            feedItemCell = [[FeedItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            feedItemCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
            feedItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            feedItemCell.rowNumber = indexPath.row;
            
            [feedItemCell.itchButton addTarget:self action:@selector(itchPost:) forControlEvents:UIControlEventTouchUpInside];
            [feedItemCell.shareButton addTarget:self action:@selector(showPostSharingOptions:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSMutableDictionary *itemData = [self.nearbyFeedData objectAtIndex:indexPath.row];
        
        [feedItemCell populateCellWithContent:itemData];
        
        assembledCell = feedItemCell;
    }
    
    return assembledCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [self.nearbyFeedData count] ) // Cell for loading more.
    {
        return 44;
    }
    else
    {
        return 327;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int lastIndex = [self.nearbyFeedData count] - 1;
    
    if ( [self.nearbyFeedData count] > 0 && indexPath.row <= lastIndex )
    {
        [self gotoPostAtIndexPath:indexPath];
    }
    else if ( indexPath.row == [self.nearbyFeedData count] )
    {
        if ( !endOfFeed && feedDidFinishDownloading )
        {
            [self downloadFeedForBatch:++self.batchNo];
        }
    }
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
    reloading = YES;
    [locationManager startUpdatingLocation];
}

- (void)doneLoadingTableViewData
{
	//  Model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.nearbyFeed];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
	return reloading; // should return if data source model is reloading
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
