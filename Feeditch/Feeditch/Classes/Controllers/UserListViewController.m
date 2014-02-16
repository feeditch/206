//
//  UserListViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/23/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "UserListViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

@implementation UserListViewController
AppDelegate *appDelegate;

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    self.listData = [[NSMutableArray alloc] init];
    batchNo = 0;
    endOfFeed = NO;
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    self.listTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    [self.view addSubview:self.listTableView];
    
    [self downloadListForBatch:batchNo];
    [super viewDidLoad];
}

- (void)gotoUserAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileViewController *profileView = [[ProfileViewController alloc] init];
    profileView.profileOwnerUserid = [[[self.listData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:profileView animated:YES];
	profileView = nil;
}

- (void)downloadListForBatch:(int)batch
{
    
    feedDidFinishDownloading = NO;
    [self.listTableView reloadData];
    
    NSString *methodName;
    NSString *key;
    
    if ( [self.listType isEqualToString:@"followers"] )
    {
        methodName = @"get-users-followers";
        key = @"user_id";
    }
    else if ( [self.listType isEqualToString:@"following"] )
    {
        methodName = @"get-users-follows";
        key = @"user_id";
    }
    else if ( [self.listType isEqualToString:@"recommendations"] )
    {
        methodName = @"get-users-by-post-reccomends";
        key = @"post_id";
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/%@", FI_DOMAIN, methodName]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[NSNumber numberWithInt:self.targetID] forKey:key];
    [wrequest setPostValue:[NSNumber numberWithInt:batch] forKey:@"batch"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            NSDictionary *response = [responseData objectForKey:@"response"];
            
            if ( batchNo == 0 )
            {
                [self.listData removeAllObjects];
            }
            
            for ( NSMutableDictionary *post in response )
            {
                [self.listData addObject:[post mutableCopy]];  // IMPORTANT: MAKE A MUTABLE COPY!!! Spent an hour trying to figure this shit out. :@
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
            [self.listTableView reloadData];
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
        [self.listTableView reloadData];
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)followUser:(id)sender
{
    UIButton *followButton = (UIButton *)sender;
    FeedUserItemCell *targetCell = (FeedUserItemCell *)[[[[followButton superview] superview] superview] superview];
    NSMutableDictionary *entryData = [self.listData objectAtIndex:targetCell.rowNumber];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL followingUser = '\0';
    
    followButton.enabled = NO; // Disable the follow button to prevent interruptions.
    
    if ( ![[NSNull null] isEqual:[entryData objectForKey:@"viewer_following_user"]] )
    {
        followingUser = [[entryData objectForKey:@"viewer_following_user"] boolValue];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/follow-user", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[NSNumber numberWithInt:[[entryData objectForKey:@"id"] intValue]] forKey:@"follow_target_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            NSString *HUDImageName;
            
            if (followingUser) {
                [[self.listData objectAtIndex:targetCell.rowNumber] setObject:@"0" forKey:@"viewer_following_user"];
                
                HUDImageName = @"cross_white.png";
                HUD.labelText = NSLocalizedString(@"Not following", nil);
                targetCell.followButtonLabel.text = NSLocalizedString(@"+ Follow", nil);
            } else {
                [[self.listData objectAtIndex:targetCell.rowNumber] setObject:@"1" forKey:@"viewer_following_user"];
                
                HUDImageName = @"check_white.png";
                HUD.labelText = NSLocalizedString(@"Following_taste", nil);
                targetCell.followButtonLabel.text = NSLocalizedString(@"Following_taste", nil);
            }
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:HUDImageName]];
            HUD.mode = MBProgressHUDModeCustomView; // Set custom view mode.
            HUD.dimBackground = YES;
            HUD.delegate = self;
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:2];
            
            followButton.enabled = YES; // Re-enable the button.
        }
    }];
    [wrequest setFailedBlock:^{
        followButton.enabled = YES; // Re-enable the button.
        
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
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *assembledCell;
    int lastIndex = [self.listData count] - 1;
    
    if ( indexPath.row == [self.listData count] ) // Cell for adding a venue.
    {
        static NSString *cellIdentifier = @"LoadingCell";
        feedItemCell = (FeedUserItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ( assembledCell == nil )
        {
            feedItemCell = [[FeedUserItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
            }
        }
        
        assembledCell = feedItemCell;
    }
    else if ( indexPath.row <= lastIndex )
    {
        static NSString *cellIdentifier = @"ItemCell";
        feedItemCell = (FeedUserItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ( assembledCell == nil )
        {
            feedItemCell = [[FeedUserItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            feedItemCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
            feedItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            feedItemCell.rowNumber = indexPath.row;
            
            [feedItemCell.followButton addTarget:self action:@selector(followUser:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSMutableDictionary *itemData = [self.listData objectAtIndex:indexPath.row];
        
        [feedItemCell populateCellWithContent:itemData];
        
        assembledCell = feedItemCell;
    }
    
    return assembledCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [self.listData count] ) // Cell for loading more.
    {
        return 44;
    }
    else
    {
        return 120;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int lastIndex = [self.listData count] - 1;
    
    if ( [self.listData count] > 0 && indexPath.row <= lastIndex )
    {
        [self gotoUserAtIndexPath:indexPath];
    }
    else if ( indexPath.row == [self.listData count] )
    {
        if ( !endOfFeed && feedDidFinishDownloading )
        {
            [self downloadListForBatch:++batchNo];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
