//
//  InnerPostViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/23/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Social/Social.h>
#import "InnerPostViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "VenueViewController.h"
#import "UserListViewController.h"

@implementation InnerPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self )
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int itemUserid = [[self.postChunk objectForKey:@"user_id"] intValue];
    NSString *fullName = [self.postChunk objectForKey:@"full_name"];
    NSString *dishName = [self.postChunk objectForKey:@"dish_name"];
    NSString *dishType = [self.postChunk objectForKey:@"type"];
    NSString *period = [self.postChunk objectForKey:@"period"];
    NSString *cuisine = [self.postChunk objectForKey:@"cusine"];
    NSString *price = [self.postChunk objectForKey:@"price"];
    NSString *tip = [self.postChunk objectForKey:@"text"];
    NSString *venueName = [self.postChunk objectForKey:@"fsq_venue_name"];
    NSString *picHash = [self.postChunk objectForKey:@"post_pic_hash"];
    NSString *userPicHash = [self.postChunk objectForKey:@"user_pic_hash"];
    NSString *gender = [self.postChunk objectForKey:@"sex"];
    NSString *timestamp = appDelegate.isArabic ? [self.postChunk objectForKey:@"relative_time_arabic"]:
                                                    [self.postChunk objectForKey:@"relative_time"];
    NSString *distance = [[self.postChunk objectForKey:@"km"] stringValue];
    NSString *itchCount = [[self.postChunk objectForKey:@"liker_count"] stringValue];
    NSNumber *recommendCount = [NSNumber numberWithInt:[[self.postChunk objectForKey:@"reccomend_count"] intValue]];
    BOOL userItchedPost = NO;
    BOOL userRecommendsPost = NO;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenBounds.size.height;
    
    [self setTitle:NSLocalizedString(@"Details", nil)];
    
    preview = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 209)]; //209
    preview.contentMode = UIViewContentModeScaleAspectFill;
    preview.clipsToBounds = YES;
    preview.opaque = YES;
    
    userThumbnailView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    userThumbnailView.opaque = YES;
    userThumbnailView.placeholderImage = [UIImage imageNamed:@"user_placeholder_large"];
    
    itchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itchButton.backgroundColor = [UIColor clearColor];
    [itchButton setBackgroundImage:[UIImage imageNamed:@"inner_post_itch_button"] forState:UIControlStateNormal];
    [itchButton addTarget:self action:@selector(itchPost) forControlEvents:UIControlEventTouchUpInside];
    itchButton.opaque = YES;
    itchButton.frame = CGRectMake(140, 165, 40, 42);
    itchButton.showsTouchWhenHighlighted = YES;
    
    gotoUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoUserButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [gotoUserButton addTarget:self action:@selector(gotoUser) forControlEvents:UIControlEventTouchUpInside];
    gotoUserButton.opaque = YES;
    gotoUserButton.frame = appDelegate.isArabic ? CGRectMake(265, 227, 40, 40) : CGRectMake(15, 227, 40, 40) ;
    
    venueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    venueButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [venueButton addTarget:self action:@selector(gotoVenue) forControlEvents:UIControlEventTouchUpInside];
    venueButton.opaque = YES;
    venueButton.frame = CGRectMake(0, 280, 320, 50);
    
    recommendationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendationsButton.backgroundColor = [UIColor clearColor];
    [recommendationsButton addTarget:self action:@selector(gotoRecommendations) forControlEvents:UIControlEventTouchUpInside];
    recommendationsButton.opaque = YES;
    
    UIImageView *blackPane = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inner_post_pane"]];
    blackPane.frame = CGRectMake(0, 158, 320, 53);
    blackPane.userInteractionEnabled = YES;
    
    UIImageView *imagePreviewDisplayShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bar_shadow_down"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];
    imagePreviewDisplayShadow.frame = CGRectMake(0, preview.frame.size.height, 320, 20);
    imagePreviewDisplayShadow.opaque = YES;
    
    UIImageView *clockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_white"]];
    clockIcon.frame = CGRectMake(300, 30, 14, 15);
    clockIcon.opaque = YES;
    
    UIImageView *distanceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_post_white"]];
    distanceIcon.frame = CGRectMake(5, 30, 15, 15);
    distanceIcon.opaque = YES;
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_marker_small_white"]];
    locationIcon.frame = CGRectMake(269, 8, 32, 32);
    locationIcon.opaque = YES;
    
    CGSize textSize_name = [fullName sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize_tip = [tip sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:MIN_MAIN_FONT_SIZE] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 25, 115, 25)];
    timestampLabel.opaque = YES;
    timestampLabel.backgroundColor = [UIColor clearColor];
    timestampLabel.shadowOffset = CGSizeMake(0, 1);
    timestampLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    timestampLabel.textColor = [UIColor whiteColor];
    timestampLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentCenter;
    timestampLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
    timestampLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    timestampLabel.numberOfLines = 1;
    timestampLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 115, 25)];
    distanceLabel.opaque = YES;
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.shadowOffset = CGSizeMake(0, 1);
    distanceLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentCenter;
    distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
    distanceLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
    distanceLabel.numberOfLines = 1;
    distanceLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *postOwnerNameLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(260 - textSize_name.width, 220, textSize_name.width, 25)] :
                                                        [[UILabel alloc] initWithFrame:CGRectMake(65, 220, textSize_name.width, 25)];

    postOwnerNameLabel.opaque = YES;
    postOwnerNameLabel.backgroundColor = [UIColor clearColor];
    postOwnerNameLabel.textColor = [UIColor blackColor];
    postOwnerNameLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    postOwnerNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
    postOwnerNameLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    postOwnerNameLabel.numberOfLines = 1;
    postOwnerNameLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *postVerbLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(postOwnerNameLabel.frame.origin.x - 80, 220, 110, 25)] :
                                                    [[UILabel alloc] initWithFrame:CGRectMake(postOwnerNameLabel.frame.origin.x + postOwnerNameLabel.frame.size.width +2, 220, 100, 25)];
    postVerbLabel.opaque = YES;
    postVerbLabel.backgroundColor = [UIColor clearColor];
    postVerbLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    postVerbLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    postVerbLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    postVerbLabel.numberOfLines = 1;
    postVerbLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *dishNameLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 238, 25)] :
                                                    [[UILabel alloc] initWithFrame:CGRectMake(65, 240, 238, 25)] ;
    dishNameLabel.opaque = YES;
    dishNameLabel.backgroundColor = [UIColor clearColor];
    dishNameLabel.textColor = [UIColor blackColor];
    dishNameLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    dishNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
    dishNameLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    dishNameLabel.numberOfLines = 1;
    dishNameLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *venueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 250, 25)];
    venueNameLabel.opaque = YES;
    venueNameLabel.backgroundColor = [UIColor clearColor];
    venueNameLabel.textColor = appDelegate.MAIN_COLOR;//[UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
    venueNameLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    venueNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
    venueNameLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    venueNameLabel.numberOfLines = 1;
    venueNameLabel.adjustsFontSizeToFitWidth = YES;
    
    itchCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, 40, 41)];
    itchCountLabel.opaque = YES;
    itchCountLabel.backgroundColor = [UIColor clearColor];
    itchCountLabel.textAlignment = NSTextAlignmentCenter;
    itchCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MAIN_FONT_SIZE];
    itchCountLabel.minimumScaleFactor = 8.0/MAIN_FONT_SIZE;
    itchCountLabel.numberOfLines = 1;
    itchCountLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 340, 280, textSize_tip.height)];
    tipLabel.opaque = YES;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    tipLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:MIN_MAIN_FONT_SIZE];
    tipLabel.numberOfLines = 0;
    
    UILabel *priceLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(10, 353 + textSize_tip.height, 100, 16)] : [[UILabel alloc] initWithFrame:CGRectMake(28, 353 + textSize_tip.height, 100, 16)];
    priceLabel.opaque = YES;
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    priceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    priceLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    priceLabel.numberOfLines = 1;
    priceLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *cuisineLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(150, 353 + textSize_tip.height, 110, 16)] : [[UILabel alloc] initWithFrame:CGRectMake(180, 353 + textSize_tip.height, 110, 16)];
    cuisineLabel.opaque = YES;
    cuisineLabel.backgroundColor = [UIColor clearColor];
    cuisineLabel.textColor = [UIColor blackColor];
    cuisineLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    cuisineLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    cuisineLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    cuisineLabel.numberOfLines = 1;
    cuisineLabel.adjustsFontSizeToFitWidth = YES;
    
    recommendationsButton.frame = appDelegate.isArabic ? CGRectMake(150, 379 + textSize_tip.height, 155, 16) : CGRectMake(10, 379 + textSize_tip.height, 155, 16);
    
    recommendCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 16)];
    recommendCountLabel.opaque = YES;
    recommendCountLabel.backgroundColor = [UIColor clearColor];
    recommendCountLabel.textColor = appDelegate.MAIN_COLOR;//[UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
    recommendCountLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    recommendCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    recommendCountLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    recommendCountLabel.numberOfLines = 1;
    recommendCountLabel.adjustsFontSizeToFitWidth = YES;
    
    CALayer *dotted_line_red = [CALayer layer];
    dotted_line_red.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red.frame = CGRectMake(0, 341 + textSize_tip.height, 320, 3);
    dotted_line_red.opaque = YES;
    [dotted_line_red setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    UIImageView *priceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"price_white"]];
    priceIcon.opaque = YES;
    priceIcon.frame = appDelegate.isArabic ? CGRectMake(130, 350 + textSize_tip.height, 13, 22) : CGRectMake(10, 350 + textSize_tip.height, 13, 22);
    
    UIImageView *postTypeIcon = [[UIImageView alloc] init];
    postTypeIcon.opaque = YES;
    
    mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    mainView.contentSize = CGSizeMake(320, MAX(screenHeight - 108, 401 + textSize_tip.height));
    
    distance = [NSString stringWithFormat:@"%.1f%@", [distance floatValue], NSLocalizedString(@" kilometers away", nil)];//[distance stringByAppendingFormat:NSLocalizedString(@" kilometers away", nil)];
    
    if ( ![[NSNull null] isEqual:price] )
    {
        if ( [price isEqualToString:@"fair"] )
        {
            priceLabel.text = NSLocalizedString(@"Fair price", nil);
        }
        else
        {
            priceLabel.text = NSLocalizedString(@"Expensive", nil);
        }
    }
    else
    {
        priceIcon.hidden = YES;
    }
    
    if ( ![[NSNull null] isEqual:cuisine] )
    {
        cuisine = appDelegate.isArabic ? [appDelegate.cuisineList_ar objectAtIndex:[appDelegate.cuisineList_en indexOfObject:cuisine]]:
                                            [cuisine capitalizedString] ;
        cuisineLabel.text = cuisine;
    }
    else
    {
        if ([dishType isEqualToString:@"food"])
        {
            cuisineLabel.text = NSLocalizedString(@"Food", nil);
        }
        else
        {
            cuisineLabel.text = NSLocalizedString(@"Drink", nil);
        }
    }
    
    if ( ![[NSNull null] isEqual:tip] )
    {
        tipLabel.text = [NSString stringWithFormat:@"“%@”", tip];
    }
    
    postOwnerNameLabel.text = fullName;
    dishNameLabel.text = dishName;
    venueNameLabel.text = venueName;
    timestampLabel.text = timestamp;
    distanceLabel.text = distance;
    itchCountLabel.text = itchCount;
    
    // Properly format the recommendCount with comma separators for a big number.
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    
    NSString *recommendCountString = appDelegate.isArabic ? [NSString stringWithFormat:@"نصح به %@ مرة", [numberFormatter stringForObjectValue:recommendCount]] :
                                                                recommendCount.intValue == 1 ? @"Recommended once" : [NSString stringWithFormat:@"Recommended %@ times", [numberFormatter stringForObjectValue:recommendCount]]  ;
    
    recommendCountLabel.text = recommendCountString;
    
    if ( [period isEqualToString:@"breakfast"] )
    {
        period = NSLocalizedString(@"for breakfast", nil);
    }
    else if ([period isEqualToString:@"lunch"])
    {
        period = NSLocalizedString(@"for lunch", nil);
    }
    else if ([period isEqualToString:@"dinner"])
    {
        period = NSLocalizedString(@"for dinner", nil);
    }
    else if ([period isEqualToString:@"dessert"])
    {
        period = NSLocalizedString(@"for dessert", nil);
    }
    
    if ([gender isEqualToString:@"male"])
    {
        postVerbLabel.text = [NSString stringWithFormat:@"%@ %@:", NSLocalizedString(@"Recommends_male", nil), period];
    }
    else
    {
        postVerbLabel.text = [NSString stringWithFormat:@"%@ %@:", NSLocalizedString(@"Recommends_male", nil), period];
    }
    
    if ([dishType isEqualToString:@"food"])
    {
        postTypeIcon.image = [UIImage imageNamed:@"f&b_food"];
        postTypeIcon.frame = appDelegate.isArabic ? CGRectMake(268, 350 + textSize_tip.height, 23, 22) : CGRectMake(150, 350 + textSize_tip.height, 23, 22);
    }
    else
    {
        postTypeIcon.image = [UIImage imageNamed:@"f&b_drink"];
        postTypeIcon.frame = appDelegate.isArabic ? CGRectMake(278, 350 + textSize_tip.height, 13, 22) : CGRectMake(150, 350 + textSize_tip.height, 13, 22);
    }
    
    if ( ![[NSNull null] isEqual:[self.postChunk objectForKey:@"viewer_likes_post"]] )
    {
        userItchedPost = YES;
        itchCountLabel.textColor = [UIColor whiteColor];
        [itchButton setBackgroundImage:[UIImage imageNamed:@"inner_post_itch_button_itched"] forState:UIControlStateNormal];
    }
    else
    {
        userItchedPost = NO;
        itchCountLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        [itchButton setBackgroundImage:[UIImage imageNamed:@"inner_post_itch_button"] forState:UIControlStateNormal];
    }
    
    if ( ![[NSNull null] isEqual:[self.postChunk objectForKey:@"viewer_reccomends_post"]] )
    {
        userRecommendsPost = YES;
        recommendButton.image = [UIImage imageNamed:@"star_filled"];
    }
    else
    {
        userRecommendsPost = NO;
        recommendButton.image = [UIImage imageNamed:@"star_hollow"];
    }
    
    preview.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/userphotos/%d/post/m_%@.jpg", FI_DOMAIN, itemUserid, picHash]];
    NSLog(@")))%@", preview.imageURL);
    userThumbnailView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/userphotos/%d/profile/m_%@.jpg", FI_DOMAIN, itemUserid, userPicHash]];
    
    [blackPane addSubview:clockIcon];
    [blackPane addSubview:distanceIcon];
    [blackPane addSubview:timestampLabel];
    [blackPane addSubview:distanceLabel];
    [itchButton addSubview:itchCountLabel];
    [gotoUserButton addSubview:userThumbnailView];
    [venueButton addSubview:locationIcon];
    [venueButton addSubview:venueNameLabel];
    [recommendationsButton addSubview:recommendCountLabel];
    [mainView addSubview:postOwnerNameLabel];
    [mainView addSubview:postVerbLabel];
    [mainView addSubview:dishNameLabel];
    [mainView addSubview:preview];
    [mainView addSubview:imagePreviewDisplayShadow];
    [mainView addSubview:blackPane];
    [mainView addSubview:itchButton];
    [mainView addSubview:venueButton];
    [mainView addSubview:gotoUserButton];
    [mainView addSubview:tipLabel];
    [mainView.layer addSublayer:dotted_line_red];
    [mainView addSubview:priceIcon];
    [mainView addSubview:postTypeIcon];
    [mainView addSubview:priceLabel];
    [mainView addSubview:cuisineLabel];
    [mainView addSubview:recommendationsButton];
    [self.view addSubview:mainView];
    [super viewDidLoad];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 35)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
}

- (void)itchPost
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int itchCount = [[self.postChunk objectForKey:@"liker_count"] intValue];
    
    if ( ![[NSNull null] isEqual:[self.postChunk objectForKey:@"viewer_likes_post"]] )
    {
        itchCount--;
        [self.postChunk setObject:[NSNull null] forKey:@"viewer_likes_post"];
        itchCountLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        [itchButton setBackgroundImage:[UIImage imageNamed:@"inner_post_itch_button"] forState:UIControlStateNormal];
    }
    else
    {
        itchCount++;
        [self.postChunk setObject:@"1" forKey:@"viewer_likes_post"];
        itchCountLabel.textColor = [UIColor whiteColor];
        [itchButton setBackgroundImage:[UIImage imageNamed:@"inner_post_itch_button_itched"] forState:UIControlStateNormal];
    }
    
    [self.postChunk setObject:[NSNumber numberWithInt:itchCount] forKey:@"liker_count"];
    itchCountLabel.text = [NSString stringWithFormat:@"%d", itchCount];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/like-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"id"] forKey:@"post_id"];
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

- (void)gotoUser
{
    ProfileViewController *profileView = [[ProfileViewController alloc] init];
    profileView.profileOwnerUserid = [[self.postChunk objectForKey:@"user_id"] intValue];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Details", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:profileView animated:YES];
	profileView = nil;
}

- (void)gotoVenue
{
    VenueViewController *venueView = [[VenueViewController alloc] init];
    venueView.fsqVenueID = [self.postChunk objectForKey:@"fsq_venue_id"];
    venueView.venueID = [self.postChunk objectForKey:@"venue_id"];
    venueView.venueName = [self.postChunk objectForKey:@"fsq_venue_name"];
    venueView.postCount = [NSString stringWithFormat:@"%@", [self.postChunk objectForKey:@"venue_post_count"]];
    venueView.fanCount = [NSString stringWithFormat:@"%@", [self.postChunk objectForKey:@"venue_like_count"]];
    
    if ( ![[NSNull null] isEqual:[self.postChunk objectForKey:@"viewer_likes_venue"]] )
    {
        venueView.userFanOfVenue = YES;
    }
    else
    {
        venueView.userFanOfVenue = NO;
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Details", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:venueView animated:YES];
	venueView = nil;
}

- (void)gotoRecommendations
{
    UserListViewController *recommendationListView = [[UserListViewController alloc] init];
    recommendationListView.title = NSLocalizedString(@"Users", nil);
    recommendationListView.listType = @"recommendations";
    recommendationListView.targetID = [[self.postChunk objectForKey:@"id"] intValue];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Details", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationController pushViewController:recommendationListView animated:YES];
	recommendationListView = nil;
}

- (IBAction)recommendPost
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [Flurry logEvent:@"Recommend button tapped"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/reccomend-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"id"] forKey:@"post_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            NSString *HUDImageName;
            
            int recommendations = [[self.postChunk objectForKey:@"reccomend_count"] intValue];
            
            if ( ![[NSNull null] isEqual:[self.postChunk objectForKey:@"viewer_reccomends_post"]] )
            {
                recommendations--;
                [self.postChunk setObject:[NSNull null] forKey:@"viewer_reccomends_post"];
                recommendButton.image = [UIImage imageNamed:@"star_hollow"];
                HUDImageName = @"cross_white.png";
            }
            else
            {
                recommendations++;
                [self.postChunk setObject:@"1" forKey:@"viewer_reccomends_post"];
                recommendButton.image = [UIImage imageNamed:@"star_filled"];
                HUD.labelText = NSLocalizedString(@"Recommended!", nil);
                HUDImageName = @"check_white.png";
            }
            
            NSNumber *recommendCount = [NSNumber numberWithInt:recommendations];
            
            [self.postChunk setObject:recommendCount forKey:@"reccomend_count"];
            
            // Properly format the recommendCount with comma separators for a big number.
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [numberFormatter setGroupingSeparator:@","];
            
            NSString *recommendCountString = appDelegate.isArabic ? [NSString stringWithFormat:@"نصح به %@ مرة", [numberFormatter stringForObjectValue:recommendCount]] :
                                                                        recommendCount.intValue == 1 ? @"Recommended once" : [NSString stringWithFormat:@"Recommended %@ times", [numberFormatter stringForObjectValue:recommendCount]]  ;
            
            recommendCountLabel.text = recommendCountString;
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:HUDImageName]];
            HUD.mode = MBProgressHUDModeCustomView; // Set custom view mode.
            HUD.dimBackground = YES;
            HUD.delegate = self;
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:2];
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

- (IBAction)showSharingOptions
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int userid = [[self.postChunk objectForKey:@"user_id"] intValue];
    UIActionSheet *sharingOptions;
    
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
    [sharingOptions showFromTabBar:appDelegate.tabBarController.tabBar];
}

- (void)showDeletionOptions;
{
    UIActionSheet *sharingOptions = [[UITableViewActionSheet alloc]
                      initWithTitle:NSLocalizedString(@"Delete picture", nil)
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                      destructiveButtonTitle:NSLocalizedString(@"Delete Picture", nil)
                      otherButtonTitles:nil];
    
    sharingOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    sharingOptions.tag = 101;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharingOptions showFromTabBar:appDelegate.tabBarController.tabBar];
}

- (IBAction)showFlaggingOptions
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIActionSheet *flaggingOptions = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"Report", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:NSLocalizedString(@"Report irrelevant post", nil)
                                     otherButtonTitles:nil];
    
    flaggingOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    flaggingOptions.tag = 102;
    [flaggingOptions showFromTabBar:appDelegate.tabBarController.tabBar];
}

- (void)deletePost
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/delete-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"id"] forKey:@"post_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)flagInappropriate
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/report-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"id"] forKey:@"post_id"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_white.png"]];
            
            // Set custom view mode.
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.dimBackground = YES;
            HUD.delegate = self;
            HUD.labelText = NSLocalizedString(@"Reported!", nil);
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( actionSheet.tag == 100 )     // Sharing options
    {
        if ( buttonIndex == 0 ) // Email.
        {
            [Flurry logEvent:@"Share via Facebook"];
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            int postid = [[self.postChunk objectForKey:@"id"] intValue];
            NSString *fullName = [self.postChunk objectForKey:@"full_name"];
            NSString *dishName = [self.postChunk objectForKey:@"dish_name"];
            NSString *venueName = [self.postChunk objectForKey:@"fsq_venue_name"];
            NSString *gender = [self.postChunk objectForKey:@"sex"];
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
                int postid = [[self.postChunk objectForKey:@"id"] intValue];
                NSString *dishName = [self.postChunk objectForKey:@"dish_name"];
                NSString *venueName = [self.postChunk objectForKey:@"fsq_venue_name"];
                
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
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"http://%@/index/sighting?id=%d", FI_DOMAIN, postid] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                //[alert show];
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
                int postid = [[self.postChunk objectForKey:@"id"] intValue];
                NSString *dishName = [self.postChunk objectForKey:@"dish_name"];
                NSString *venueName = [self.postChunk objectForKey:@"fsq_venue_name"];
                NSString *previewText = [NSString stringWithFormat:NSLocalizedString(@"I recommend %@ at %@", nil), dishName, venueName];
                
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
                
                [twitterController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"%@ at %@", nil), dishName, venueName]];
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
        else if ( buttonIndex == 3 && ([[self.postChunk objectForKey:@"user_id"] intValue] == [[appDelegate.global readProperty:@"userid"] intValue] || [[appDelegate.global readProperty:@"userid"] intValue] == 1) ) // Delete post.
        {
            [self showDeletionOptions];
        }
    }
    else if ( actionSheet.tag == 101 ) // Delete
    {
        if ( buttonIndex == 0 )
        {
            [self deletePost];
        }
    }
    else if ( actionSheet.tag == 102 ) // Flag inappropriate
    {
        if ( buttonIndex == 0 )
        {
            [self flagInappropriate];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
