//
//  FriendInviter.m
//  Feeditch
//
//  Created by MachOSX on 5/3/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendInviter.h"
#import "AppDelegate.h"

@implementation FriendInviter

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    [self setTitle:NSLocalizedString(@"Invite Friends", nil)];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dismissInviter)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"إادعو" style:UIBarButtonItemStyleDone target:self action:@selector(inviteAll)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = inviteButton;
    
    friendsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    friendsList.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    friendsList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    friendsList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    friendsList.delegate = self;
    friendsList.dataSource = self;
    
    listData = [[NSMutableArray alloc] init];
    selectedListItems = [[NSMutableArray alloc] init];
    
    if ( !self.accountStore )
    {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    ACAccountType *facebookTypeAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookTypeAccount];
    ACAccount *facebookAccount = [accounts lastObject];
    NSString *acessToken = [NSString stringWithFormat:@"%@", facebookAccount.credential.oauthToken];
    NSDictionary *parameters = @{@"access_token": acessToken};
    
    NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
    
    SLRequest *feedRequest = [SLRequest
                              requestForServiceType:SLServiceTypeFacebook
                              requestMethod:SLRequestMethodGET
                              URL:feedURL
                              parameters:parameters];
    
    feedRequest.account = facebookAccount;
    [feedRequest performRequestWithHandler:^(NSData *response,
                                             NSHTTPURLResponse *urlResponse, NSError *error){
        responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"resp data: %@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        NSDictionary *data = [responseData objectForKey:@"data"];
        
        for ( NSMutableDictionary *friend in data )
        {
            [listData addObject:[friend mutableCopy]];  // IMPORTANT: MAKE A MUTABLE COPY!!!
        }
        
        NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [listData sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
        
        long double delayInSeconds = 0.3;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [friendsList reloadData];
        });
     }];
    
    [self.view addSubview:friendsList];
    
    [super viewDidLoad];
}

- (void)dismissInviter
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)inviteAll
{
    if ( selectedListItems.count > -1 )
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"email", @"user_about_me", @"user_location"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          
                                      }];
        
        NSMutableArray *FBUserEntries = [[NSMutableArray alloc] init];
        NSMutableArray *FBIDList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < selectedListItems.count; i++)
        {
            NSString *row = [NSString stringWithFormat:@"%@", [selectedListItems objectAtIndex:i]];
            NSLog(@"%@", row);
            [FBUserEntries addObject:[listData objectAtIndex:[row intValue]]];
        }
        
        for ( NSDictionary *user in FBUserEntries )
        {
            [FBIDList addObject:[user objectForKey:@"id"]];
        }
        
        FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
        p.friends = FBIDList;
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"(127100148,100000316269754)"/*[NSString stringWithFormat:@"%@", FBIDList]*/, @"to", nil];//[NSMutableDictionary dictionaryWithObjectsAndKeys: FBIDList, @"to", nil];
        NSLog(@"params %@", params);
        
        [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                      message:@"Join me on Feeditch!"
                                                        title:nil
                                                   parameters:nil
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
                                                          if ( error )
                                                          {
                                                              // Case A: Error launching the dialog or sending request.
                                                              NSLog(@"Error sending request.");
                                                          }
                                                          else
                                                          {
                                                              if ( result == FBWebDialogResultDialogNotCompleted )
                                                              {
                                                                  // Case B: User clicked the "x" icon
                                                                  NSLog(@"User canceled request.");
                                                              }
                                                              else
                                                              {
                                                                  NSLog(@"Request Sent.");
                                                              }
                                                          }
                                                      }];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ItemCell";
    UITableViewCell *assembledCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( assembledCell == nil )
    {
        assembledCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        assembledCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
        assembledCell.selectionStyle = UITableViewCellSelectionStyleGray;
       // assembledCell.textLabel.textColor = [UIColor whiteColor];
    }
    
    NSMutableDictionary *itemData = [listData objectAtIndex:indexPath.row];
    
    assembledCell.textLabel.text = [itemData objectForKey:@"name"];
    
    NSLog(@"----> %@", [itemData objectForKey:@"name"]);
    
    if ( [selectedListItems containsObject:[NSNumber numberWithInteger:indexPath.row]] )
    {
        assembledCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        assembledCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return assembledCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *targetCell = [friendsList cellForRowAtIndexPath:indexPath];
    
    if ( [selectedListItems containsObject:[NSNumber numberWithInteger:indexPath.row]] ) // Check if the cell is already selected.
    {
        targetCell.accessoryType = UITableViewCellAccessoryNone;
        
        [selectedListItems removeObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    else
    {
        targetCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [selectedListItems addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
