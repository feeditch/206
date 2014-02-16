//
//  ProfileViewController.m
//  Feeditch
//
//  Created by MachOSX on 2/7/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Social/Social.h>
#import "ProfileViewController.h"
#import "PostComposer_Stage1.h"
#import "AppDelegate.h"
#import "UserListViewController.h"
#import "InnerPostViewController.h"
#import "PostListViewController.h"
#import "SettingsViewController.h"

@implementation ProfileViewController

AppDelegate *appDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self )
    {
        self.title = NSLocalizedString(NSLocalizedString(@"Profile", nil), @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_bar_icon_profile"];
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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 35)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;

    
    if ( self == [self.navigationController.viewControllers objectAtIndex:0] )
    {
        // Only show the settings button when in the root profile view.
        settingsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(gotoSettings)];
        self.navigationItem.leftBarButtonItem = settingsButton;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showPostComposer)]; // Don't want this hiding the back button!
    }
    
    self.profileFeed.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    
    self.profileFeedData = [[NSMutableArray alloc] init];
    
    feedDidFinishDownloading = NO;
    
    if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc]
                             initWithFrame:CGRectMake(0, 0 - self.profileFeed.bounds.size.height, self.view.frame.size.width, self.profileFeed.bounds.size.height)];
		refreshHeaderView.delegate = self;
		[self.profileFeed addSubview:refreshHeaderView];
        
	}
    
    // Get the user's current location & save it.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.allowsEditing = YES;
    photoPicker.delegate = self;
    
    userThumbnail = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    userThumbnail.layer.masksToBounds = YES;
    userThumbnail.layer.cornerRadius = 5.0;
    userThumbnail.layer.borderWidth = 0.5;
    userThumbnail.layer.borderColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0].CGColor;
    userThumbnail.opaque = YES;
    userThumbnail.placeholderImage = [UIImage imageNamed:@"user_placeholder_large"];
    
    globeIcon = appDelegate.isArabic ? [[UIImageView alloc] initWithFrame:CGRectMake(185, 42, 15, 16)] : [[UIImageView alloc] initWithFrame:CGRectMake(120, 42, 15, 16)];
    globeIcon.image = [UIImage imageNamed:@"globe_grey_light"];
    
    statsPanel = [[UIImageView alloc] initWithFrame:CGRectMake(10, 125, 301, 94)];
    statsPanel.image = [UIImage imageNamed:@"profile_stats_bg"];
    statsPanel.userInteractionEnabled = YES;
    
    userPostCountLabelLine_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 245, 310, 3)];
    userPostCountLabelLine_1.image = [[UIImage imageNamed:@"profile_header_line"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
    userPostCountLabelLine_2 = [[UIImageView alloc] initWithFrame:CGRectMake(310, 245, 10, 3)];
    userPostCountLabelLine_2.image = [[UIImage imageNamed:@"profile_header_line"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
    userNameLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 190, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 190, 20)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.textColor = [UIColor blackColor];
    userNameLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    userNameLabel.numberOfLines = 1;
    userNameLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
    userNameLabel.opaque = YES;
    
    userLocationLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 170, 16)] : [[UILabel alloc] initWithFrame:CGRectMake(140, 42, 170, 16)];
    userLocationLabel.backgroundColor = [UIColor clearColor];
    userLocationLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    userLocationLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    userLocationLabel.numberOfLines = 1;
    userLocationLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    userLocationLabel.adjustsFontSizeToFitWidth = YES;
    userLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    userLocationLabel.opaque = YES;
    
    userBioLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 16)];
    userBioLabel.backgroundColor = [UIColor clearColor];
    userBioLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    userBioLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    userBioLabel.numberOfLines = 0;
    userBioLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    userBioLabel.opaque = YES;
    
    userFollowingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 85, 16)];
    userFollowingCountLabel.backgroundColor = [UIColor clearColor];
    userFollowingCountLabel.shadowOffset = CGSizeMake(0, 1);
    userFollowingCountLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    userFollowingCountLabel.textColor = [UIColor whiteColor];
    userFollowingCountLabel.textAlignment = NSTextAlignmentCenter;
    userFollowingCountLabel.numberOfLines = 1;
    userFollowingCountLabel.minimumScaleFactor = 8.0/22;
    userFollowingCountLabel.adjustsFontSizeToFitWidth = YES;
    userFollowingCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    userFollowingCountLabel.opaque = YES;
    
    userFollowingCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 85, 13)];
    userFollowingCountTextLabel.backgroundColor = [UIColor clearColor];
    userFollowingCountTextLabel.shadowOffset = CGSizeMake(0, 1);
    userFollowingCountTextLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    userFollowingCountTextLabel.textColor = [UIColor whiteColor];
    userFollowingCountTextLabel.textAlignment = NSTextAlignmentCenter;
    userFollowingCountTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
    userFollowingCountTextLabel.opaque = YES;
    
    userFollowerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 100, 16)];
    userFollowerCountLabel.backgroundColor = [UIColor clearColor];
    userFollowerCountLabel.shadowOffset = CGSizeMake(0, 1);
    userFollowerCountLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    userFollowerCountLabel.textColor = [UIColor whiteColor];
    userFollowerCountLabel.textAlignment = NSTextAlignmentCenter;
    userFollowerCountLabel.numberOfLines = 1;
    userFollowerCountLabel.minimumScaleFactor = 8.0/22;
    userFollowerCountLabel.adjustsFontSizeToFitWidth = YES;
    userFollowerCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    userFollowerCountLabel.opaque = YES;
    
    userFollowerCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 100, 13)];
    userFollowerCountTextLabel.backgroundColor = [UIColor clearColor];
    userFollowerCountTextLabel.shadowOffset = CGSizeMake(0, 1);
    userFollowerCountTextLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    userFollowerCountTextLabel.textColor = [UIColor whiteColor];
    userFollowerCountTextLabel.textAlignment = NSTextAlignmentCenter;
    userFollowerCountTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
    userFollowerCountTextLabel.opaque = YES;
    
    userItchCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 85, 16)];
    userItchCountLabel.backgroundColor = [UIColor clearColor];
    userItchCountLabel.shadowOffset = CGSizeMake(0, 1);
    userItchCountLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    userItchCountLabel.textColor = [UIColor whiteColor];
    userItchCountLabel.textAlignment = NSTextAlignmentCenter;
    userItchCountLabel.numberOfLines = 1;
    userItchCountLabel.minimumScaleFactor = 8.0/22;
    userItchCountLabel.adjustsFontSizeToFitWidth = YES;
    userItchCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    userItchCountLabel.opaque = YES;
    
    userItchCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 85, 13)];
    userItchCountTextLabel.backgroundColor = [UIColor clearColor];
    userItchCountTextLabel.shadowOffset = CGSizeMake(0, 1);
    userItchCountTextLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    userItchCountTextLabel.textColor = [UIColor whiteColor];
    userItchCountTextLabel.textAlignment = NSTextAlignmentCenter;
    userItchCountTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
    userItchCountTextLabel.opaque = YES;
    
    userPostCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 257, 80, 16)];
    userPostCountLabel.backgroundColor = [UIColor clearColor];
    userPostCountLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    userPostCountLabel.textAlignment = NSTextAlignmentRight;
    userPostCountLabel.numberOfLines = 1;
    userPostCountLabel.minimumScaleFactor = 8.0/22;
    userPostCountLabel.adjustsFontSizeToFitWidth = YES;
    userPostCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    userPostCountLabel.opaque = YES;
    
    userPostCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 260, 50, 13)];
    userPostCountTextLabel.backgroundColor = [UIColor clearColor];
    userPostCountTextLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    userPostCountTextLabel.textAlignment = NSTextAlignmentRight;
    userPostCountTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
    userPostCountTextLabel.opaque = YES;
    
    // This button brings up the profile picture options.
    DPButton = [UIButton buttonWithType:UIButtonTypeCustom];
    DPButton.backgroundColor = [UIColor clearColor];
    [DPButton addTarget:self action:@selector(showDPOptions) forControlEvents:UIControlEventTouchUpInside];
    DPButton.opaque = YES;
    DPButton.frame = appDelegate.isArabic ? CGRectMake(210, 10, 100, 100) : CGRectMake(10, 10, 100, 100) ;
    
    followingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followingButton.backgroundColor = [UIColor clearColor];
    [followingButton addTarget:self action:@selector(gotoFollowing) forControlEvents:UIControlEventTouchUpInside];
    followingButton.opaque = YES;
    followingButton.frame = CGRectMake(0, 0, 93, 90);
    followingButton.enabled = NO;
    
    followersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followersButton.backgroundColor = [UIColor clearColor];
    [followersButton addTarget:self action:@selector(gotoFollowers) forControlEvents:UIControlEventTouchUpInside];
    followersButton.opaque = YES;
    followersButton.frame = CGRectMake(95, 0, 110, 90);
    followersButton.enabled = NO;
    
    itchesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itchesButton.backgroundColor = [UIColor clearColor];
    [itchesButton addTarget:self action:@selector(gotoItches) forControlEvents:UIControlEventTouchUpInside];
    itchesButton.opaque = YES;
    itchesButton.frame = CGRectMake(207, 0, 93, 90);
    itchesButton.enabled = NO;
    
    followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.backgroundColor = [UIColor clearColor];
    [followButton setBackgroundImage:[[UIImage imageNamed:@"follow_button_big"] stretchableImageWithLeftCapWidth:17.0 topCapHeight:21.0] forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
    followButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    followButton.titleLabel.shadowColor = [UIColor colorWithRed:37.0/255.0 green:78.0/255.0 blue:163.0/255.0 alpha:0.5];
    followButton.titleLabel.textColor = [UIColor whiteColor];
    followButton.titleLabel.font = [UIFont boldSystemFontOfSize:MIN_MAIN_FONT_SIZE];
    [followButton setTitle:NSLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
    followButton.opaque = YES;
    followButton.frame = appDelegate.isArabic ? CGRectMake(10, 73, 190, 39) : CGRectMake(120, 73, 190, 39);
    followButton.hidden = YES;
    
    tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
    
    [statsPanel addSubview:followingButton];
    [statsPanel addSubview:followersButton];
    [statsPanel addSubview:itchesButton];
    [followingButton addSubview:userFollowingCountLabel];
    [followingButton addSubview:userFollowingCountTextLabel];
    [followersButton addSubview:userFollowerCountLabel];
    [followersButton addSubview:userFollowerCountTextLabel];
    [itchesButton addSubview:userItchCountLabel];
    [itchesButton addSubview:userItchCountTextLabel];
    [DPButton addSubview:userThumbnail];
    [tableHeader addSubview:userNameLabel];
    [tableHeader addSubview:userLocationLabel];
    [tableHeader addSubview:userBioLabel];
    [tableHeader addSubview:userPostCountLabel];
    [tableHeader addSubview:userPostCountTextLabel];
    [tableHeader addSubview:DPButton];
    [tableHeader addSubview:followButton];
    [tableHeader addSubview:globeIcon];
    [tableHeader addSubview:statsPanel];
    [tableHeader addSubview:userPostCountLabelLine_1];
    [tableHeader addSubview:userPostCountLabelLine_2];
    
    self.profileFeed.tableHeaderView = tableHeader;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
}

- (void)showPostComposer
{
    PostComposer_Stage1 *postComposer = [[PostComposer_Stage1 alloc] init];
    UINavigationController *postComposerNavigationController = [[UINavigationController alloc] initWithRootViewController:postComposer];
    
    [self.view.window.rootViewController presentViewController:postComposerNavigationController animated:YES completion:NULL];
}

- (void)gotoSettings
{
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    //settings.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:settings animated:YES];
	settings = nil;
}

- (void)gotoFollowing
{
    UserListViewController *followingListView = [[UserListViewController alloc] init];
    followingListView.listType = @"following";
    followingListView.title = @"Following List";
    followingListView.targetID = self.profileOwnerUserid;
    followingListView.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:followingListView animated:YES];
	followingListView = nil;
}

- (void)gotoFollowers
{
    UserListViewController *followersListView = [[UserListViewController alloc] init];
    followersListView.listType = @"followers";
    followersListView.title = @"Followers List";
    followersListView.targetID = self.profileOwnerUserid;
    followersListView.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:followersListView animated:YES];
	followersListView = nil;
}

- (void)gotoItches
{
    PostListViewController *itchesListView = [[PostListViewController alloc] init];
    itchesListView.listType = @"itches";
    itchesListView.title = @"Itches List";
    itchesListView.targetUserid = self.profileOwnerUserid;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:itchesListView animated:YES];
	itchesListView = nil;
}

- (void)gotoPostAtIndexPath:(NSIndexPath *)indexPath
{
    InnerPostViewController *innerPostView = [[InnerPostViewController alloc] initWithNibName:@"InnerPostViewController" bundle:[NSBundle mainBundle]];
    innerPostView.hidesBottomBarWhenPushed = YES;
    
    innerPostView.postChunk = [self.profileFeedData objectAtIndex:indexPath.row];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:innerPostView animated:YES];
	innerPostView = nil;
}

- (void)getUserInfoForID:(int)userid
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/user-profile", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[NSNumber numberWithInt:userid] forKey:@"user_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        
        if ( ![[NSNull null] isEqual:wrequest.responseString] && wrequest.responseString )
        {
            responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
            NSLog(@"resp:%@", responseData);
            
            if ( [[responseData objectForKey:@"error"] intValue] == 0 && wrequest.responseString.length > 0 )
            {
                NSDictionary *response = [responseData objectForKey:@"response"];
                
                self.profileOwnerUserid = [[response objectForKey:@"id"] intValue];
                self.profileOwnerName = [response objectForKey:@"full_name"];
                self.profileOwnerGender = [response objectForKey:@"sex"];
                self.profileOwnerEmail = [response objectForKey:@"email"];
                self.profileOwnerHash = [response objectForKey:@"user_pic_hash"];
                self.profileOwnerBio = [response objectForKey:@"bio"];
                self.profileOwnerCountry = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:[appDelegate.countryList indexOfObject:[NSString stringWithFormat:@"%@", [response objectForKey:@"country"]]]];
                
                
                profileOwnerItchCount = [[response objectForKey:@"post_like_count"] intValue];
                profileOwnerPostCount = [[response objectForKey:@"post_count"] intValue];
                profileOwnerFollowerCount = [[response objectForKey:@"users_followers_count"] intValue];
                profileOwnerFollowingCount = [[response objectForKey:@"users_follows_count"] intValue];
                
                if ( ![[NSNull null] isEqual:[response objectForKey:@"viewer_following_user"]] )
                {
                    followingProfileOwner = [[response objectForKey:@"viewer_following_user"] boolValue];
                }
                
                if ( ![[NSNull null] isEqual:[response objectForKey:@"user_following_viewer"]] )
                {
                    profileOwnerFollowsYou = [[response objectForKey:@"user_following_viewer"] boolValue];
                }
                
                if ( [[appDelegate.global readProperty:@"userid"] intValue] == -1 || self.profileOwnerUserid == [[appDelegate.global readProperty:@"userid"] intValue] )
                {
                    self.isCurrentUser = YES;
                }
                else
                {
                    self.isCurrentUser = NO;
                }
                
                if ( self.isCurrentUser )
                {
                    [appDelegate.global writeValue:[NSString stringWithFormat:@"%d", self.profileOwnerUserid] forProperty:@"userid"];
                    [appDelegate.global writeValue:self.profileOwnerName forProperty:@"name"];
                    [appDelegate.global writeValue:self.profileOwnerGender forProperty:@"gender"];
                    [appDelegate.global writeValue:self.profileOwnerEmail forProperty:@"email"];
                    [appDelegate.global writeValue:self.profileOwnerHash forProperty:@"userPicHash"];
                    
                    if ( ![[NSNull null] isEqual:self.profileOwnerCountry] )
                    {
                        [appDelegate.global writeValue:self.profileOwnerCountry forProperty:@"country"];
                    }
                    
                    if ( ![[NSNull null] isEqual:self.profileOwnerBio] )
                    {
                        [appDelegate.global writeValue:self.profileOwnerBio forProperty:@"bio"];
                    }
                }
                
                self.batchNo = 0;
                [self redrawContents];
                [self downloadFeedForBatch:self.batchNo];
            }
        }
        else
        {
            [self getUserInfoForID:self.profileOwnerUserid];
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
        
        [self performSelector:@selector(doneLoadingTableViewData)];
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)redrawContents
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( self.isCurrentUser )
    {
        self.profileOwnerName = [appDelegate.global readProperty:@"name"];
        self.profileOwnerGender = [appDelegate.global readProperty:@"gender"];
        self.profileOwnerEmail = [appDelegate.global readProperty:@"email"];
        self.profileOwnerBio = [appDelegate.global readProperty:@"bio"];
        self.profileOwnerCountry = [appDelegate.global readProperty:@"country"];
    }
    
    [self setTitle:self.profileOwnerName];
    
    userThumbnail.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/userphotos/%d/profile/m_%@.jpg", FI_DOMAIN, self.profileOwnerUserid, self.profileOwnerHash]];
    userNameLabel.text = self.profileOwnerName;
    
    
    if ( ![[NSNull null] isEqual:self.profileOwnerCountry] )
    {
        userLocationLabel.text = self.profileOwnerCountry;
    }
    
    if ( ![[NSNull null] isEqual:self.profileOwnerBio] )
    {
        userBioLabel.text = self.profileOwnerBio;
    }
    
    userFollowerCountLabel.text = [NSString stringWithFormat:@"%d", profileOwnerFollowerCount];
    userFollowingCountLabel.text = [NSString stringWithFormat:@"%d", profileOwnerFollowingCount];
    userItchCountLabel.text = [NSString stringWithFormat:@"%d", profileOwnerItchCount];
    userPostCountLabel.text = [NSString stringWithFormat:@"%d", profileOwnerPostCount];
    userFollowerCountTextLabel.text = NSLocalizedString(@"Followers_taste", nil);
    userFollowingCountTextLabel.text = NSLocalizedString(@"Following_taste", nil);
    userItchCountTextLabel.text = NSLocalizedString(@"Itches", nil);
    
    if ( profileOwnerFollowingCount > 0 )
    {
        followingButton.enabled = YES;
    }
    else
    {
        followingButton.enabled = NO;
    }
    
    if ( profileOwnerFollowerCount > 0 )
    {
        followersButton.enabled = YES;
    }
    else
    {
        followersButton.enabled = NO;
    }
    
    if ( profileOwnerItchCount > 0 )
    {
        itchesButton.enabled = YES;
    }
    else
    {
        itchesButton.enabled = NO;
    }
    
    if ( profileOwnerPostCount == 1 )
    {
        userPostCountTextLabel.text = NSLocalizedString(@"picture", nil);
    }
    else
    {
        userPostCountTextLabel.text = NSLocalizedString(@"pictures", nil);
    }
    
    if ( self.isCurrentUser ) // Hide the follow button if it's the current user's profile.
    {
        followButton.hidden = YES;
    }
    else
    {
        followButton.hidden = NO;
        
        if ( followingProfileOwner )
        {
            [followButton setTitle:NSLocalizedString(@"Following_taste", nil) forState:UIControlStateNormal];
        }
        else
        {
            [followButton setTitle:NSLocalizedString(@"+ Follow", nil) forState:UIControlStateNormal];
        }
    }
    
    CGSize bioSize = [userBioLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize postCountSize = [userPostCountLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    userBioLabel.frame = CGRectMake(10, 120, 300, bioSize.height);
    statsPanel.frame = CGRectMake(10, 125 + bioSize.height, 301, 94);
    userPostCountLabelLine_1.frame = appDelegate.isArabic ? CGRectMake(0, 245 + bioSize.height, 310 - postCountSize.width - 40, 3):
                                                            CGRectMake(-30, 245 + bioSize.height, 310 - postCountSize.width - 40, 3)  ;
    userPostCountLabelLine_2.frame = CGRectMake(310, 245 + bioSize.height, 10, 3);
    userPostCountLabel.frame = appDelegate.isArabic ? CGRectMake(305 - postCountSize.width, 238 + bioSize.height, postCountSize.width, 17) :
                                                        CGRectMake(247 - postCountSize.width, 238 + bioSize.height, postCountSize.width, 17) ;
    userPostCountTextLabel.frame = appDelegate.isArabic ? CGRectMake(250 - postCountSize.width, 238 + bioSize.height, 50, 13) :
                                                            CGRectMake(253, 240 + bioSize.height, 50, 13) ;

    
    CGRect tableHeaderFrame = self.profileFeed.tableHeaderView.frame;
	tableHeaderFrame.size.height = bioSize.height + 260;
	self.profileFeed.tableHeaderView.frame = tableHeaderFrame;
	self.profileFeed.tableHeaderView = tableHeader;
}

- (void)followUser
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    followButton.enabled = NO; // Disable the follow button to prevent interruptions.
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/follow-user", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[NSNumber numberWithInt:self.profileOwnerUserid] forKey:@"follow_target_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            NSString *HUDImageName;
            
            if ( followingProfileOwner )
            {
                followingProfileOwner = NO;
                
                HUDImageName = @"cross_white.png";
                HUD.labelText = NSLocalizedString(@"Not following", nil);
                [followButton setTitle:NSLocalizedString(@"+ Follow", nil) forState:UIControlStateNormal];
            }
            else
            {
                followingProfileOwner = YES;
                
                HUDImageName = @"check_white.png";
                HUD.labelText = NSLocalizedString(@"Following_taste", nil);
                [followButton setTitle:NSLocalizedString(@"Following_taste", nil) forState:UIControlStateNormal];
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

- (void)deleteDP
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/delete-profile-pic", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            [appDelegate.global writeValue:@"" forProperty:@"userPicHash"];
            self.profileOwnerHash = @"";
            userThumbnail.imageURL = nil;
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
        
        [self performSelector:@selector(doneLoadingTableViewData)];
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)downloadFeedForBatch:(int)batch
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [dataRequest clearDelegatesAndCancel]; // Cancel any previously running requests.
    feedDidFinishDownloading = NO;
    [self.profileFeed reloadData];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/get-posts-by-user", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[NSNumber numberWithInt:self.profileOwnerUserid] forKey:@"user_id"];
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
                    [self.profileFeedData removeAllObjects];
                }
                
                for ( NSMutableDictionary *post in response )
                {
                    [self.profileFeedData addObject:[post mutableCopy]];  // IMPORTANT: MAKE A MUTABLE COPY!!! Spent an hour trying to figure this shit out. :@
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
                [self.profileFeed reloadData];
                
                if ( self.hasNewPost ) // Open the inner view of the new post.
                {
                    [self gotoPostAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    self.hasNewPost = NO; // Reset this so it doesn't open the 1st post every time it loads the feed.
                }
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
        [self.profileFeed reloadData];
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)itchPost:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *itchButton = (UIButton *)sender;
    FeedItemCell *targetCell = (FeedItemCell *)[[[[itchButton superview] superview] superview] superview];
    NSMutableDictionary *entryData = [self.profileFeedData objectAtIndex:targetCell.rowNumber];
    int itchCount = [[entryData objectForKey:@"liker_count"] intValue];
    
    if ( ![[NSNull null] isEqual:[entryData objectForKey:@"viewer_likes_post"]] )
    {
        itchCount--;
        [[self.profileFeedData objectAtIndex:targetCell.rowNumber] setObject:[NSNull null] forKey:@"viewer_likes_post"];
        targetCell.itchCountLabel.textColor = [UIColor whiteColor];
        [targetCell.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button"] forState:UIControlStateNormal];
    }
    else
    {
        itchCount++;
        [[self.profileFeedData objectAtIndex:targetCell.rowNumber] setObject:@"1" forKey:@"viewer_likes_post"];
        targetCell.itchCountLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        [targetCell.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button_itched"] forState:UIControlStateNormal];
    }
    
    [[self.profileFeedData objectAtIndex:targetCell.rowNumber] setObject:[NSNumber numberWithInt:itchCount] forKey:@"liker_count"];
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

- (void)showDPOptions
{
    if ( self.isCurrentUser ) // These options only appear for the current user.
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIActionSheet *DPOptions;
        
        // Run checks for iOS devices with no cameras!
        // If the device has no camera, we won't show the "Take Photo" button, so watch out!
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            DPOptions = [[UIActionSheet alloc]
                         initWithTitle:NSLocalizedString(@"Change Profile Picture", nil)
                         delegate:self
                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                         destructiveButtonTitle:NSLocalizedString(@"Delete Current Picture", nil)
                         otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Existing Picture", nil), nil];
        } else {
            DPOptions = [[UIActionSheet alloc]
                         initWithTitle:NSLocalizedString(@"Change Profile Picture", nil)
                         delegate:self
                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                         destructiveButtonTitle:NSLocalizedString(@"Delete Current Picture", nil)
                         otherButtonTitles:NSLocalizedString(@"Existing Picture", nil), nil];
        }
        
        DPOptions.tag = 99;
        DPOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [DPOptions showFromTabBar:appDelegate.tabBarController.tabBar];
    }
}

- (void)showPostSharingOptions:(id)sender
{
    UIButton *button = (UIButton *)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FeedItemCell *targetCell = (FeedItemCell *)[[[[button superview] superview] superview] superview];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:targetCell.rowNumber inSection:0];
    int userid = [[[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
    
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
                      destructiveButtonTitle:NSLocalizedString(@"Delete Post", nil)
                      otherButtonTitles:nil];
    
    sharingOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    sharingOptions.tag = 101;
    sharingOptions.indexPath = indexPath;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharingOptions showFromTabBar:appDelegate.tabBarController.tabBar];
}

- (void)handlePostSharingAtIndexPath:(NSIndexPath *)indexPath forButtonAtIndex:(int)buttonIndex
{
    if ( buttonIndex == 0 ) // Email.
    {
        [Flurry logEvent:@"Share via Email"];
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        int postid = [[[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        NSString *fullName = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        NSString *dishName = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
        NSString *venueName = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
        NSString *gender = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"sex"];
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
            int postid = [[[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
            NSString *dishName = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
            NSString *venueName = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
            
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
            int postid = [[[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
            NSString *dishName = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
            NSString *venueName = [[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
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
    else if ( buttonIndex == 3 && self.isCurrentUser ) // Delete post.
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
    [wrequest setPostValue:[[self.profileFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"post_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            [self.profileFeedData removeObjectAtIndex:indexPath.row];
            [self.profileFeed deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.profileFeed reloadData];
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
    
    if ( targetActionSheet.tag == 99 )     // DP options
    {
        if ( buttonIndex == 0 )
        {
            [self deleteDP];
        }
        else if ( buttonIndex == 1 )
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:photoPicker animated:YES completion:NULL];
            } else {
                photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:photoPicker animated:YES completion:NULL];
            }
        }
        else if ( buttonIndex == 2 )
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:photoPicker animated:YES completion:NULL];
            }
        }
    }
    else if ( targetActionSheet.tag == 100 )     // Sharing options
    {
        [self handlePostSharingAtIndexPath:targetActionSheet.indexPath forButtonAtIndex:buttonIndex];
    }
    else if ( targetActionSheet.tag == 101 ) // Deletion options
    {
        if ( buttonIndex == 0 )
        {
            [self handlePostDeletionAtIndexPath:targetActionSheet.indexPath];
        }
        
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    selectedDPImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    // Get Image
    NSData *imageData = UIImageJPEGRepresentation(selectedDPImage, 0.5);
    
    if ( imageData != nil )
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/update-profile-pic", FI_DOMAIN]];
        
        dataRequest = [ASIFormDataRequest requestWithURL:url];
        __weak ASIFormDataRequest *wrequest = dataRequest;
        
        [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
        [wrequest setData:imageData withFileName:@"image_file.jpg" andContentType:@"image/jpeg" forKey:@"image_file"];
        [wrequest setCompletionBlock:^{
            NSError *jsonError;
            responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
            
            if ( [[responseData objectForKey:@"error"] intValue] == 0 )
            {
                [HUD hide:YES];
                [appDelegate.global writeValue:[responseData objectForKey:@"response"] forProperty:@"userPicHash"];
                self.profileOwnerHash = [appDelegate.global readProperty:@"userPicHash"];
                [self redrawContents];
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
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.currentLocation = newLocation.coordinate;
    
    if ( self == [self.navigationController.viewControllers objectAtIndex:0] ) // Current user's profile.
    {
        self.profileOwnerUserid = [[appDelegate.global readProperty:@"userid"] intValue];
    }
    
    [locationManager stopUpdatingLocation];
    
    self.batchNo = 0;
    
    [self getUserInfoForID:self.profileOwnerUserid];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( status != kCLAuthorizationStatusAuthorized || ![CLLocationManager locationServicesEnabled] )
    {
        appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    }
    
    if ( self == [self.navigationController.viewControllers objectAtIndex:0] ) // Current user's profile.
    {
        self.profileOwnerUserid = [[appDelegate.global readProperty:@"userid"] intValue];
    }
    
    self.batchNo = 0;
    
    [self getUserInfoForID:self.profileOwnerUserid];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    
    if ( self == [self.navigationController.viewControllers objectAtIndex:0] ) // Current user's profile.
    {
        self.profileOwnerUserid = [[appDelegate.global readProperty:@"userid"] intValue];
    }
    
    self.batchNo = 0;
    
    [self getUserInfoForID:self.profileOwnerUserid];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profileFeedData.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *assembledCell;
    int lastIndex = [self.profileFeedData count] - 1;
    
    if ( indexPath.row == [self.profileFeedData count] ) // Cell for loading more.
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
        
        NSMutableDictionary *itemData = [self.profileFeedData objectAtIndex:indexPath.row];
        
        [feedItemCell populateCellWithContent:itemData];
        
        assembledCell = feedItemCell;
    }
    
    return assembledCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [self.profileFeedData count] ) // Cell for loading more.
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
    int lastIndex = [self.profileFeedData count] - 1;
    
    if ( [self.profileFeedData count] > 0 && indexPath.row <= lastIndex )
    {
        [self gotoPostAtIndexPath:indexPath];
    }
    else if ( indexPath.row == [self.profileFeedData count] )
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
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( self == [self.navigationController.viewControllers objectAtIndex:0] ) // Current user's profile.
    {
        self.profileOwnerUserid = [[appDelegate.global readProperty:@"userid"] intValue];
    }
    
    self.batchNo = 0;
    
    reloading = YES;
    
    [self getUserInfoForID:self.profileOwnerUserid];
}

- (void)doneLoadingTableViewData
{
	//  Model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.profileFeed];
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
