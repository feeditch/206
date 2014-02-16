//
//  VenueViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Social/Social.h>
#import <MapKit/MapKit.h>
#import "VenueViewController.h"
#import "PostComposer_Stage1.h"
#import "AppDelegate.h"
#import "InnerPostViewController.h"

AppDelegate *appDelegate;
@implementation VenueViewController

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    [self setTitle:self.venueName];
    
    self.venueFeed = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    self.venueFeed.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    self.venueFeed.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.venueFeed.delegate = self;
    self.venueFeed.dataSource = self;
    
    self.venueFeedData = [[NSMutableArray alloc] init];
    
    feedDidFinishDownloading = NO;
    
    // Get the user's current location & save it.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    header.image = [[UIImage imageNamed:@"venue_header"] stretchableImageWithLeftCapWidth:320 topCapHeight:5];
    header.opaque = YES;
    header.userInteractionEnabled = YES;
    
    phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.backgroundColor = [UIColor clearColor];
    [phoneButton addTarget:self action:@selector(callVenue) forControlEvents:UIControlEventTouchUpInside];
    phoneButton.opaque = YES;
    phoneButton.frame = CGRectMake(10, 20, 150, 20);
    phoneButton.showsTouchWhenHighlighted = YES;
    phoneButton.enabled = NO;
    
    twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twitterButton.backgroundColor = [UIColor clearColor];
    [twitterButton addTarget:self action:@selector(openVenueTwitter) forControlEvents:UIControlEventTouchUpInside];
    twitterButton.opaque = YES;
    twitterButton.frame = CGRectMake(10, 60, 150, 20);
    twitterButton.showsTouchWhenHighlighted = YES;
    twitterButton.enabled = NO;
    
    mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.backgroundColor = [UIColor clearColor];
    [mapButton addTarget:self action:@selector(showVenueOnMap) forControlEvents:UIControlEventTouchUpInside];
    mapButton.opaque = YES;
    mapButton.frame = CGRectMake(160, 20, 150, 20);
    mapButton.showsTouchWhenHighlighted = YES;
    mapButton.enabled = NO;
    
    checkinsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkinsButton.backgroundColor = [UIColor clearColor];
    //[checkinsButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    checkinsButton.opaque = YES;
    checkinsButton.frame = CGRectMake(160, 60, 150, 20);
    checkinsButton.showsTouchWhenHighlighted = YES;
    checkinsButton.enabled = NO;
    
    fanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fanButton.backgroundColor = [UIColor clearColor];
    [fanButton addTarget:self action:@selector(becomeFan) forControlEvents:UIControlEventTouchUpInside];
    [fanButton setBackgroundImage:[[UIImage imageNamed:@"follow_button_small"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    fanButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    fanButton.titleLabel.shadowColor = [UIColor colorWithRed:37.0/255.0 green:78.0/255.0 blue:163.0/255.0 alpha:0.5];
    fanButton.titleLabel.textColor = [UIColor whiteColor];
    fanButton.titleLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    
    fanButton.opaque = YES;
    fanButton.frame = appDelegate.isArabic ? CGRectMake(10, 110, 160, 30) : CGRectMake(160, 110, 160, 30);
    
    if ( self.userFanOfVenue )
    {
        [fanButton setTitle:NSLocalizedString(@"Fan", nil) forState:UIControlStateNormal];
    }
    else
    {
        [fanButton setTitle:NSLocalizedString(@"Become a Fan", nil) forState:UIControlStateNormal];
    }
    
    newPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newPostButton.backgroundColor = [UIColor clearColor];
    [newPostButton addTarget:self action:@selector(newPostForVenue) forControlEvents:UIControlEventTouchUpInside];
    [newPostButton setBackgroundImage:[[UIImage imageNamed:@"follow_button_small"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    newPostButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    newPostButton.titleLabel.shadowColor = [UIColor colorWithRed:37.0/255.0 green:78.0/255.0 blue:163.0/255.0 alpha:0.5];
    newPostButton.titleLabel.textColor = [UIColor whiteColor];
    newPostButton.titleLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    [newPostButton setTitle:NSLocalizedString(@"Add Picture", nil) forState:UIControlStateNormal];
    newPostButton.opaque = YES;
    newPostButton.frame = appDelegate.isArabic ? CGRectMake(10, 160, 160, 30) : CGRectMake(160, 160, 160, 30);
    
    phoneButtonLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 20)];
    phoneButtonLabel.opaque = YES;
    phoneButtonLabel.backgroundColor = [UIColor clearColor];
    phoneButtonLabel.shadowOffset = CGSizeMake(0, 1);
    phoneButtonLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    phoneButtonLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    phoneButtonLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    phoneButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:SECONDARY_FONT_SIZE];
    phoneButtonLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    phoneButtonLabel.numberOfLines = 1;
    phoneButtonLabel.adjustsFontSizeToFitWidth = YES;
    phoneButtonLabel.text = @"-";
    
    twitterButtonLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 20)];
    twitterButtonLabel.opaque = YES;
    twitterButtonLabel.backgroundColor = [UIColor clearColor];
    twitterButtonLabel.shadowOffset = CGSizeMake(0, 1);
    twitterButtonLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    twitterButtonLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    twitterButtonLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    twitterButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:SECONDARY_FONT_SIZE];
    twitterButtonLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    twitterButtonLabel.numberOfLines = 1;
    twitterButtonLabel.adjustsFontSizeToFitWidth = YES;
    twitterButtonLabel.text = @"-";
    
    mapButtonLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 20)];
    mapButtonLabel.opaque = YES;
    mapButtonLabel.backgroundColor = [UIColor clearColor];
    mapButtonLabel.shadowOffset = CGSizeMake(0, 1);
    mapButtonLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    mapButtonLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    mapButtonLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    mapButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:SECONDARY_FONT_SIZE];
    mapButtonLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    mapButtonLabel.numberOfLines = 1;
    mapButtonLabel.adjustsFontSizeToFitWidth = YES;
    mapButtonLabel.text = NSLocalizedString(@"Open in Maps", nil);
    
    checkinsButtonLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 20)];
    checkinsButtonLabel.opaque = YES;
    checkinsButtonLabel.backgroundColor = [UIColor clearColor];
    checkinsButtonLabel.shadowOffset = CGSizeMake(0, 1);
    checkinsButtonLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    checkinsButtonLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    checkinsButtonLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    checkinsButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
    checkinsButtonLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    checkinsButtonLabel.numberOfLines = 1;
    checkinsButtonLabel.adjustsFontSizeToFitWidth = YES;
    checkinsButtonLabel.text = @"-";
    
    fansLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 290, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(35, 120, 290, 20)];
    fansLabel.opaque = YES;
    fansLabel.backgroundColor = [UIColor clearColor];
    fansLabel.shadowOffset = CGSizeMake(0, 1);
    fansLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    fansLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    fansLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    fansLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:SECONDARY_FONT_SIZE];
    fansLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    fansLabel.numberOfLines = 1;
    fansLabel.adjustsFontSizeToFitWidth = YES;
    fansLabel.text = appDelegate.isArabic ? [NSString stringWithFormat:@"عدد المعجبين: %@", self.fanCount] : [NSString stringWithFormat:@"%@ fans", self.fanCount];
    
    postsLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 167, 290, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(35, 167, 290, 20)];
    postsLabel.opaque = YES;
    postsLabel.backgroundColor = [UIColor clearColor];
    postsLabel.shadowOffset = CGSizeMake(0, 1);
    postsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    postsLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    postsLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    postsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:SECONDARY_FONT_SIZE];
    postsLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    postsLabel.numberOfLines = 1;
    postsLabel.adjustsFontSizeToFitWidth = YES;
    postsLabel.text = appDelegate.isArabic ? [NSString stringWithFormat:@"%@ صورة", self.postCount] : [NSString stringWithFormat:@"%@ post%@", self.postCount, ([self.postCount isEqualToString:@"1" ] ? @"": @"s")];
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venue_phone"]];
    phoneIcon.frame = appDelegate.isArabic ? CGRectMake(140, 3, 12, 13) : CGRectMake(0, 3, 12, 13);
    phoneIcon.opaque = YES;
    
    UIImageView *twitterIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venue_twitter"]];
    twitterIcon.frame = appDelegate.isArabic ? CGRectMake(140, 1, 17, 15) : CGRectMake(0, 1, 17, 15);
    twitterIcon.opaque = YES;
    
    UIImageView *mapsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venue_map"]];
    mapsIcon.frame = appDelegate.isArabic ? CGRectMake(140, 2, 13, 14) : CGRectMake(0, 2, 13, 14);
    mapsIcon.opaque = YES;
    
    UIImageView *checkinsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venue_checkins"]];
    checkinsIcon.frame = appDelegate.isArabic ? CGRectMake(140, 2, 11, 14) : CGRectMake(0, 2, 11, 14);
    checkinsIcon.opaque = YES;
    
    UIImageView *fansIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venue_fans"]];
    fansIcon.frame = appDelegate.isArabic ? CGRectMake(300, 120, 13, 14) : CGRectMake(10, 120, 13, 14);
    fansIcon.opaque = YES;
    
    UIImageView *postsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venue_posts"]];
    postsIcon.frame = appDelegate.isArabic ? CGRectMake(295, 170, 20, 14) : CGRectMake(10, 170, 20, 14);
    postsIcon.opaque = YES;
    
    CALayer *dotted_line_red_1 = [CALayer layer];
    dotted_line_red_1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red_1.frame = CGRectMake(0, 100, 320, 3);
    dotted_line_red_1.opaque = YES;
    [dotted_line_red_1 setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    CALayer *dotted_line_red_2 = [CALayer layer];
    dotted_line_red_2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red_2.frame = CGRectMake(0, 150, 320, 3);
    dotted_line_red_2.opaque = YES;
    [dotted_line_red_2 setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    
    [phoneButton addSubview:phoneIcon];
    [phoneButton addSubview:phoneButtonLabel];
    [twitterButton addSubview:twitterIcon];
    [twitterButton addSubview:twitterButtonLabel];
    [mapButton addSubview:mapsIcon];
    [mapButton addSubview:mapButtonLabel];
    [checkinsButton addSubview:checkinsIcon];
    [checkinsButton addSubview:checkinsButtonLabel];
    [tableHeader addSubview:header];
    [tableHeader addSubview:phoneButton];
    [tableHeader addSubview:twitterButton];
    [tableHeader addSubview:mapButton];
    [tableHeader addSubview:checkinsButton];
    [tableHeader addSubview:fanButton];
    [tableHeader addSubview:newPostButton];
    [tableHeader addSubview:fansIcon];
    [tableHeader addSubview:fansLabel];
    [tableHeader addSubview:postsIcon];
    [tableHeader addSubview:postsLabel];
    [tableHeader.layer addSublayer:dotted_line_red_1];
    [tableHeader.layer addSublayer:dotted_line_red_2];
    [self.view addSubview:self.venueFeed];
    
    self.venueFeed.tableHeaderView = tableHeader;
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 35)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
    
    [super viewDidLoad];
}

- (void)showPostComposer
{
    PostComposer_Stage1 *postComposer = [[PostComposer_Stage1 alloc] init];
    UINavigationController *postComposerNavigationController = [[UINavigationController alloc] initWithRootViewController:postComposer];
    
    [self.view.window.rootViewController presentViewController:postComposerNavigationController animated:YES completion:NULL];
}

- (void)callVenue
{
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", venuePhoneNumber]]] )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                                    initWithTitle:nil
                                    message:venuePhoneNumber delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    otherButtonTitles:NSLocalizedString(@"Call", nil), nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error", nil)
                              message:NSLocalizedString(@"Your device doesn't support making phone calls", nil) delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:NSLocalizedString(@"Close", nil), nil];
        [alert show];
    }
}

- (void)openVenueTwitter
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", venueTwitter]];
    NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", venueTwitter]];
    
    if ( ![[UIApplication sharedApplication] openURL:appUrl] ) // Try the native Twitter app.
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)showVenueOnMap
{
    Class mapItemClass = [MKMapItem class];
    
    if ( mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)] )
    {
        double latitude = [venueLat doubleValue];
        double longitude = [venueLong doubleValue];
        
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:self.venueName];
        
        // Pass the map item to the Maps app
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}

- (void)becomeFan
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [Flurry logEvent:@"I am a Fan button tapped"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/like-venue", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:self.venueID forKey:@"venue_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        int count = [self.fanCount intValue];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            NSString *HUDImageName;
            
            if ( self.userFanOfVenue )
            {
                self.userFanOfVenue = NO;
                count--;
                
                HUDImageName = @"cross_white.png";
                [fanButton setTitle:NSLocalizedString(@"Become a Fan", nil) forState:UIControlStateNormal];
            }
            else
            {
                self.userFanOfVenue = YES;
                count++;
                
                HUDImageName = @"check_white.png";
                HUD.labelText = NSLocalizedString(@"You Became a Fan!", nil);
                [fanButton setTitle:NSLocalizedString(@"Fan", nil) forState:UIControlStateNormal];
            }
            
            NSString *countString = [NSString stringWithFormat:@"%d", count];
            
            self.fanCount = countString;
            fansLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ fans", nil), self.fanCount];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:HUDImageName]];
            HUD.mode = MBProgressHUDModeCustomView; // Set custom view mode.
            HUD.dimBackground = YES;
            HUD.delegate = self;
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:2];
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

- (void)newPostForVenue
{
    PostComposer_Stage1 *postComposer = [[PostComposer_Stage1 alloc] init];
    UINavigationController *postComposerNavigationController = [[UINavigationController alloc] initWithRootViewController:postComposer];
    
    [self.view.window.rootViewController presentViewController:postComposerNavigationController animated:YES completion:NULL];
    
    [postComposer.postChunk setObject:self.fsqVenueID forKey:@"fsq_venue_id"];
    [postComposer.postChunk setObject:self.venueName forKey:@"fsq_venue_name"];
    [postComposer.postChunk setObject:@"0" forKey:@"current_location_lat"];
    [postComposer.postChunk setObject:@"0" forKey:@"a"];
}

- (void)getVenueInfo
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?", self.fsqVenueID]; // 4sq requires this first param as v=yyyymmdd.
    
    // Put it together.
    urlString = [urlString stringByAppendingFormat:@"&client_id=ZHK22TFDORRHHDKGN4L40EQKGUBJEXM3F2FPGS14JCM1MKPE"];
    urlString = [urlString stringByAppendingFormat:@"&client_secret=PMQDW1TFREX5P2UJU2G0C42IIT01SQBR52YOHFN2TCW3S2RK"];
    urlString = [urlString stringByAppendingFormat:@"&v=20130228"];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setRequestMethod:@"GET"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        NSDictionary *venue = [[responseData objectForKey:@"response"] objectForKey:@"venue"];
        
        venueFormattedPhoneNumber = [[venue objectForKey:@"contact"] objectForKey:@"formattedPhone"];
        venuePhoneNumber = [[venue objectForKey:@"contact"] objectForKey:@"phone"];
        venueTwitter = [[venue objectForKey:@"contact"] objectForKey:@"twitter"];
        venueLat = [[venue objectForKey:@"location"] objectForKey:@"lat"];
        venueLong = [[venue objectForKey:@"location"] objectForKey:@"lng"];
        venueCheckinCount = [NSString stringWithFormat:@"%@", [[venue objectForKey:@"stats"] objectForKey:@"checkinsCount"] ];
        
        if ( venuePhoneNumber )
        {
            phoneButtonLabel.text = venueFormattedPhoneNumber;
            phoneButton.enabled = YES;
        }
        
        if ( venueTwitter )
        {
            twitterButtonLabel.text = [NSString stringWithFormat:@"@%@", venueTwitter];
            twitterButton.enabled = YES;
        }
        
        mapButton.enabled = YES;
        
        checkinsButtonLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ people were here", nil), venueCheckinCount];
        
        self.batchNo = 0;
        [self downloadFeedForBatch:self.batchNo];
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        
        // Set custom view mode.
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = @"Could not connect!";
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [wrequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)downloadFeedForBatch:(int)batch
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    feedDidFinishDownloading = NO;
    [self.venueFeed reloadData];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/get-posts-by-venue", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[NSNumber numberWithInt:batch] forKey:@"batch"];
    [wrequest setPostValue:[NSNumber numberWithFloat:appDelegate.currentLocation.latitude] forKey:@"location_lat"];
    [wrequest setPostValue:[NSNumber numberWithFloat:appDelegate.currentLocation.longitude] forKey:@"location_long"];
    [wrequest setPostValue:self.venueID forKey:@"venue_id"];
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
                    [self.venueFeedData removeAllObjects];
                }
                
                for ( NSMutableDictionary *post in response )
                {
                    [self.venueFeedData addObject:[post mutableCopy]];  // IMPORTANT: MAKE A MUTABLE COPY!!! Spent an hour trying to figure this shit out. :@
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
                [self.venueFeed reloadData];
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
        [self.venueFeed reloadData];
        
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
    innerPostView.postChunk = [self.venueFeedData objectAtIndex:indexPath.row];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"picture", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:innerPostView animated:YES];
	innerPostView = nil;
}

- (void)itchPost:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *itchButton = (UIButton *)sender;
    FeedItemCell *targetCell = (FeedItemCell *)[[[[itchButton superview] superview] superview] superview];
    NSMutableDictionary *entryData = [self.venueFeedData objectAtIndex:targetCell.rowNumber];
    int itchCount = [[entryData objectForKey:@"liker_count"] intValue];
    
    if ( ![[NSNull null] isEqual:[entryData objectForKey:@"viewer_likes_post"]] )
    {
        itchCount--;
        [[self.venueFeedData objectAtIndex:targetCell.rowNumber] setObject:[NSNull null] forKey:@"viewer_likes_post"];
        targetCell.itchCountLabel.textColor = [UIColor whiteColor];
        [targetCell.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button"] forState:UIControlStateNormal];
    }
    else
    {
        itchCount++;
        [[self.venueFeedData objectAtIndex:targetCell.rowNumber] setObject:@"1" forKey:@"viewer_likes_post"];
        targetCell.itchCountLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        [targetCell.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button_itched"] forState:UIControlStateNormal];
    }
    
    [[self.venueFeedData objectAtIndex:targetCell.rowNumber] setObject:[NSNumber numberWithInt:itchCount] forKey:@"liker_count"];
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
    int userid = [[[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
    
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

- (void)showPostDeletionOptions:(id)sender
{
    UIButton *button = (UIButton *)sender;
    FeedItemCell *targetCell = (FeedItemCell *)[[[[button superview] superview] superview] superview];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:targetCell.rowNumber inSection:0];
    
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
    int userid = [[[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
    
    if ( buttonIndex == 0 ) // Email.
    {
        [Flurry logEvent:@"Share via Email"];
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        int postid = [[[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        NSString *fullName = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        NSString *dishName = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
        NSString *venueName = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
        NSString *gender = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"sex"];
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
            int postid = [[[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
            NSString *dishName = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
            NSString *venueName = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
            
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
            int postid = [[[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
            NSString *dishName = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"dish_name"];
            NSString *venueName = [[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"fsq_venue_name"];
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
        [self showPostDeletionOptions:nil];
    }
}

- (void)handlePostDeletionAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/delete-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[[self.venueFeedData objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"post_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            [self.venueFeedData removeObjectAtIndex:indexPath.row];
            [self.venueFeed deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.venueFeed reloadData];
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
        
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.currentLocation = newLocation.coordinate;
    
    [locationManager stopUpdatingLocation];
    [self getVenueInfo];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( status != kCLAuthorizationStatusAuthorized || ![CLLocationManager locationServicesEnabled] )
    {
        appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    }
    
    [self getVenueInfo];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    
    [self getVenueInfo];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.venueFeedData.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *assembledCell;
    int lastIndex = [self.venueFeedData count] - 1;
    
    if ( indexPath.row == [self.venueFeedData count] ) // Cell for loading more.
    {
        static NSString *cellIdentifier = @"LoadingCell";
        feedItemCell = (FeedItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ( assembledCell == nil )
        {
            feedItemCell = [[FeedItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            feedItemCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
            feedItemCell.textLabel.textColor = [UIColor whiteColor];
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
        
        NSMutableDictionary *itemData = [self.venueFeedData objectAtIndex:indexPath.row];
        
        [feedItemCell populateCellWithContent:itemData];
        
        assembledCell = feedItemCell;
    }
    
    return assembledCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [self.venueFeedData count] ) // Cell for loading more.
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
    int lastIndex = [self.venueFeedData count] - 1;
    
    if ( [self.venueFeedData count] > 0 && indexPath.row <= lastIndex )
    {
        [self gotoPostAtIndexPath:indexPath];
    }
    else if ( indexPath.row == [self.venueFeedData count] )
    {
        if ( !endOfFeed && feedDidFinishDownloading )
        {
            [self downloadFeedForBatch:++self.batchNo];
        }
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 0 ) // Call venue
    {
        if ( buttonIndex == 1 )
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", venuePhoneNumber]]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
