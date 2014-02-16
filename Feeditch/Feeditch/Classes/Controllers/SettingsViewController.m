//
//  SettingsViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/24/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "Settings_CorporateWebViewController.h"
#import "Settings_PasswordViewController.h"
#import "Settings_ProfileEditorViewController.h"
#import "FriendInviter.h"

@implementation SettingsViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self )
    {
        self.title = NSLocalizedString(NSLocalizedString(@"Settings", nil), @"Settings");
    }
    
    return self;
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

    
    NSArray *arrTemp1 = [[NSArray alloc]
                         initWithObjects:NSLocalizedString(@"Invite Friends", nil), nil];
    NSArray *arrTemp2 = [[NSArray alloc]
                         initWithObjects:NSLocalizedString(@"Edit Profile", nil), NSLocalizedString(@"Change Password", nil), nil];
	NSArray *arrTemp3 = [[NSArray alloc]
                         initWithObjects:NSLocalizedString(@"About Feeditch", nil), NSLocalizedString(@"Privacy Policy", nil), NSLocalizedString(@"Terms of Service", nil), nil];
    NSArray *arrTemp4 = [[NSArray alloc]
                         initWithObjects:NSLocalizedString(@"Rate us on the Appstore", nil), nil];
    NSArray *arrTemp5 = [[NSArray alloc]
                         initWithObjects:NSLocalizedString(@"Signout", nil), nil];
	NSDictionary *temp =[[NSDictionary alloc]
                         initWithObjectsAndKeys:arrTemp1, @"1", arrTemp2,
                         @"2", arrTemp3, @"3", arrTemp4, @"4", arrTemp5, @"5", nil];
    
	tableContents = temp;
	sortedKeys =[[tableContents allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sortedKeys count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	NSArray *listData =[tableContents objectForKey:[sortedKeys objectAtIndex:section]];
	return [listData count];
}

- (CGFloat)tableView:(UITableView *)table heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"SimpleTableIdentifier";
    
	NSArray *listData =[tableContents objectForKey:[sortedKeys objectAtIndex:[indexPath section]]];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // Set the accessory type.
	}
    
	cell.textLabel.text = [listData objectAtIndex:[indexPath row]];
    
    // Customization. We hide the accessory for the buttons that don't push new view controllers:
	if ( (indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 3 && indexPath.row == 0) || (indexPath.section == 4 && indexPath.row == 0) )
    {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( indexPath.section == 0 && indexPath.row == 0 )           // Invite friends.
    {
        UIActionSheet *invitationOptions = [[UIActionSheet alloc]
                             initWithTitle:NSLocalizedString(@"Invite Friends", nil)
                             delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                             destructiveButtonTitle:nil
                             otherButtonTitles:NSLocalizedString(@"Email", nil), NSLocalizedString(@"Facebook", nil), NSLocalizedString(@"Twitter", nil), nil];
        
        invitationOptions.tag = 1;
        invitationOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [invitationOptions showFromTabBar:appDelegate.tabBarController.tabBar];
    }
    else if ( indexPath.section == 1 && indexPath.row == 0 )      // Edit profile.
    {
        Settings_ProfileEditorViewController *profileEditor = [[Settings_ProfileEditorViewController alloc] init];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:profileEditor animated:YES];
        profileEditor = nil;
    }
    else if ( indexPath.section == 1 && indexPath.row == 1 )      // Change password.
    {
        Settings_PasswordViewController *passwordChanger = [[Settings_PasswordViewController alloc] init];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:passwordChanger animated:YES];
        passwordChanger = nil;
    }
    else if ( indexPath.section == 2 && indexPath.row == 0 )      // About us.
    {
        [Flurry logEvent:@"About page button tapped"];
        
        NSString *url = @"http://blog.feeditch.com/about/";
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
        
        Settings_CorporateWebViewController *webView = [[Settings_CorporateWebViewController alloc] initWithNibName:@"Settings_CorporateWebView" bundle:[NSBundle mainBundle]];
        webView.url = url;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
        [webView setTitle:NSLocalizedString(@"About Feeditch", nil)];
        [self.navigationController pushViewController:webView animated:YES];
        [webView.browser loadRequest:theRequest];
        webView = nil;
    }
    else if ( indexPath.section == 2 && indexPath.row == 1 )       // Privacy policy.
    {
        NSString *url = @"http://blog.feeditch.com/privacy/";
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
        
        Settings_CorporateWebViewController *webView = [[Settings_CorporateWebViewController alloc] initWithNibName:@"Settings_CorporateWebView" bundle:[NSBundle mainBundle]];
        webView.url = url;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
        [webView setTitle:NSLocalizedString(@"Privacy Policy", nil)];
        [self.navigationController pushViewController:webView animated:YES];
        
        [webView.browser loadRequest:theRequest];
        webView = nil;
    }
    else if ( indexPath.section == 2 && indexPath.row == 2 )       // TOS.
    {
        NSString *url = @"http://blog.feeditch.com/terms/";
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
        
        Settings_CorporateWebViewController *webView = [[Settings_CorporateWebViewController alloc] initWithNibName:@"Settings_CorporateWebView" bundle:[NSBundle mainBundle]];
        webView.url = url;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
        [webView setTitle:NSLocalizedString(@"Terms of Service", nil)];
        [self.navigationController pushViewController:webView animated:YES];
        [webView.browser loadRequest:theRequest];
        webView = nil;
    }
    else if ( indexPath.section == 3 && indexPath.row == 0 )       // Rate on iTunes.
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appDelegate.FIAppid]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if ( indexPath.section == 4 && indexPath.row == 0 )       // Logout.
    { 
        [Flurry logEvent:@"Logout button tapped"];
        
        UIAlertView *logoutAlert = [[UIAlertView alloc]
                                    initWithTitle:NSLocalizedString(@"Signout", nil)
                                    message:@"" delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    otherButtonTitles:NSLocalizedString(@"Signout", nil), nil];
        [logoutAlert show];
    }
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( buttonIndex == 1 )
    {
        [appDelegate logout];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) { // Friend invitation options.
        if (buttonIndex == 0) { // Invite via Email.
            [Flurry logEvent:@"Email friend invite"];
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            NSString *emailBody = [NSString stringWithFormat:NSLocalizedString(@"email_invite", nil)]; // Fill out the email body text.
            [picker setSubject:[NSString stringWithFormat:@"Feeditch"]];
            [picker setMessageBody:emailBody isHTML:YES]; // Depends. Mostly YES, unless you want to send it as plain text (boring).
            
            [self.view.window.rootViewController presentViewController:picker animated:YES completion:NULL];
        } else if (buttonIndex == 1) { // Invite via Facebook.
           /* if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
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
                
                [fbController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"facebook_invite", nil)]];
                [fbController addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", FI_DOMAIN]]];
                [fbController setCompletionHandler:completionHandler];
                [self.view.window.rootViewController presentViewController:fbController animated:YES completion:nil];
            }*/
            
/*            FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
            params.link = [NSURL URLWithString:@"https://apps.facebook.com/feeditch/"];
            params.description = @"Try-out feeditch!";
            params.caption = @"Feeditch invite";
            
            if([FBDialogs canPresentShareDialogWithParams:params]){
                [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error){
                if(error){
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                }
            }];
            }else{
                NSLog(@"ma fish");
                SLComposeViewController *fbComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [fbComposer setInitialText:NSLocalizedString(@"twitter_invite", nil)];
                [self presentViewController:fbComposer animated:YES completion:nil];
            }
            */
        
            /* */
            
            
            FriendInviter *friendInviter = [[FriendInviter alloc] init];
            UINavigationController *friendInviterNavigationController = [[UINavigationController alloc] initWithRootViewController:friendInviter];
 
            [self.view.window.rootViewController presentViewController:friendInviterNavigationController animated:YES completion:NULL];
          

            [Flurry logEvent:@"Facebook friend invite"];
            
           /* [FBSession openActiveSessionWithReadPermissions:@[@"email", @"user_about_me", @"user_location"]
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                              NSLog(@"%@", error);
                                          }];
            
            NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
            [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                          message:[NSString stringWithFormat:NSLocalizedString(@"twitter_invite", nil)]
                                                            title:nil
                                                       parameters:params
                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                              if (error) {
                                                                  // Case A: Error launching the dialog or sending request.
                                                                  NSLog(@"Error sending request.");
                                                              } else {
                                                                  if (result == FBWebDialogResultDialogNotCompleted) {
                                                                      // Case B: User clicked the "x" icon
                                                                      NSLog(@"User canceled request.");
                                                                  } else {
                                                                      NSLog(@"Request Sent.");
                                                                  }
                                                              }}];*/
        } else if (buttonIndex == 2) { // Invite via Twitter.
            [Flurry logEvent:@"Twitter friend invite"];
            
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
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
                
                [twitterController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"twitter_invite", nil)]];
                [twitterController addURL:[NSURL URLWithString:@"http://feeditch.com"]];
                [twitterController setCompletionHandler:completionHandler];
                [self.view.window.rootViewController presentViewController:twitterController animated:YES completion:nil];
            }
        }
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
