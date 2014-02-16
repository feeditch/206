//
//  FeedUserItemCell.m
//  Feeditch
//
//  Created by MachOSX on 3/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "FeedUserItemCell.h"
#import "AppDelegate.h"

@implementation FeedUserItemCell

AppDelegate *appDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.opaque = YES;
        
        self.cardBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"feed_card"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:5.0]];
        self.cardBG.opaque = YES;
        self.cardBG.frame = CGRectMake(10, 15, 300, 100);
        self.cardBG.userInteractionEnabled = YES;
        
        cardBottom = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"feed_card_bottom"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:25.0]];
        cardBottom.opaque = YES;
        cardBottom.frame = CGRectMake(3, 70, 294, 25);
        
        userThumbnailView = appDelegate.isArabic ? [[EGOImageView alloc] initWithFrame:CGRectMake(250, 10, 40, 40)] : [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        userThumbnailView.opaque = YES;
        userThumbnailView.placeholderImage = [UIImage imageNamed:@"user_placeholder_large"];
        
        UIImageView *bottomHorizontalSeparator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"horizontal_separator"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:3.0]];
        bottomHorizontalSeparator.opaque = YES;
        bottomHorizontalSeparator.frame = CGRectMake(3, 69, 294, 3);
        
        UIImageView *bottomVerticalSeparator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"vertical_separator"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0]];
        bottomVerticalSeparator.opaque = YES;
        bottomVerticalSeparator.frame = CGRectMake(100, 69, 3, 26);
        
        UIImageView *globeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"globe_grey_light"]];
        globeIcon.frame = appDelegate.isArabic ? CGRectMake(225, 35, 15, 16) : CGRectMake(55, 35, 15, 16);
        globeIcon.opaque = YES;
        
        captionContainer = [CALayer layer];
        captionContainer.opaque = YES;
        
        nameLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 235, 18)] : [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 235, 18)];
        nameLabel.opaque = YES;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
        nameLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
        nameLabel.numberOfLines = 1;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        
        countryLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 215, 18)] : [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 215, 18)]    ;
        countryLabel.opaque = YES;
        countryLabel.backgroundColor = [UIColor clearColor];
        countryLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        countryLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
        countryLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
        countryLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
        countryLabel.numberOfLines = 1;
        countryLabel.adjustsFontSizeToFitWidth = YES;
        
        followerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 69, 90, 26)];
        followerCountLabel.opaque = YES;
        followerCountLabel.backgroundColor = [UIColor clearColor];
        followerCountLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        followerCountLabel.textAlignment = NSTextAlignmentCenter;
        followerCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
        followerCountLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
        followerCountLabel.numberOfLines = 1;
        followerCountLabel.adjustsFontSizeToFitWidth = YES;
        
        followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 69, 100, 26)];
        followingCountLabel.opaque = YES;
        followingCountLabel.backgroundColor = [UIColor clearColor];
        followingCountLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        followingCountLabel.textAlignment = NSTextAlignmentCenter;
        followingCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
        followingCountLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
        followingCountLabel.numberOfLines = 1;
        followingCountLabel.adjustsFontSizeToFitWidth = YES;
        
        self.followButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 97, 26)];
        self.followButtonLabel.opaque = YES;
        self.followButtonLabel.backgroundColor = [UIColor clearColor];
        self.followButtonLabel.textColor = [UIColor whiteColor];
        self.followButtonLabel.textAlignment = NSTextAlignmentCenter;
        self.followButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:SECONDARY_FONT_SIZE];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.backgroundColor = [UIColor clearColor];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"follow_button_small"] forState:UIControlStateNormal];
        self.followButton.opaque = YES;
        self.followButton.frame = CGRectMake(200, 69, 97, 26);
        
        [self.cardBG addSubview:userThumbnailView];
        [self.cardBG addSubview:cardBottom];
        [self.cardBG addSubview:bottomVerticalSeparator];
        [self.cardBG addSubview:bottomHorizontalSeparator];
        [self.cardBG addSubview:globeIcon];
        [self.cardBG addSubview:self.followButton];
        [self.cardBG.layer addSublayer:captionContainer];
        [captionContainer addSublayer:nameLabel.layer];
        [captionContainer addSublayer:countryLabel.layer];
        [captionContainer addSublayer:followerCountLabel.layer];
        [captionContainer addSublayer:followingCountLabel.layer];
        [self.followButton addSubview:self.followButtonLabel];
        [self.contentView addSubview:self.cardBG];
	}
    
    return self;
}

- (void)populateCellWithContent:(NSMutableDictionary *)data
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int itemUserid = [[data objectForKey:@"id"] intValue];
    NSString *fullName = [data objectForKey:@"full_name"];
    NSString *country = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:[appDelegate.countryList indexOfObject:[NSString stringWithFormat:@"%@", [data objectForKey:@"country"]]]];
    NSString *userPicHash = [data objectForKey:@"user_pic_hash"];
    NSNumber *followerCount = [NSNumber numberWithInt:[[data objectForKey:@"users_followers_count"] intValue]];
    NSNumber *followingCount = [NSNumber numberWithInt:[[data objectForKey:@"users_follows_count"] intValue]];
    BOOL followingUser = '\0';
    BOOL userFollowsYou = '\0';
    
    // Properly format the follow counts with comma separators for a big number.
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    
    NSString *followerCountString = [numberFormatter stringForObjectValue:followerCount];
    NSString *followingCountString = [numberFormatter stringForObjectValue:followingCount];
    
    if ( ![[NSNull null] isEqual:[data objectForKey:@"viewer_following_user"]] )
    {
        followingUser = [[data objectForKey:@"viewer_following_user"] boolValue];
    }
    
    if ( ![[NSNull null] isEqual:[data objectForKey:@"user_following_viewer"]] )
    {
        userFollowsYou = [[data objectForKey:@"user_following_viewer"] boolValue];
    }
    
    if ( [[appDelegate.global readProperty:@"userid"] intValue] == itemUserid )
    {
        self.followButton.enabled = NO;
        self.followButtonLabel.text = NSLocalizedString(@"You", nil);
    }
    else
    {
        if ( followingUser )
        {
            self.followButtonLabel.text = NSLocalizedString(@"Following_taste", nil);
        }
        else
        {
            self.followButtonLabel.text = NSLocalizedString(@"+ Follow", nil);
        }
    }
    
    nameLabel.text = fullName;
    countryLabel.text = country;
    followerCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ followers", nil), followerCountString];
    followingCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ following", nil), followingCountString];
    userThumbnailView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/userphotos/%d/profile/m_%@.jpg", FI_DOMAIN, itemUserid, userPicHash]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
