//
//  FeedItemCell.m
//  Feeditch
//
//  Created by MachOSX on 3/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "FeedItemCell.h"
#import "AppDelegate.h"

@implementation FeedItemCell

AppDelegate *appDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        self.opaque = YES;
        
        self.cardBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"feed_card"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:5.0]];
        self.cardBG.opaque = YES;
        self.cardBG.userInteractionEnabled = YES;
        
        cardBottom = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"feed_card_bottom"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:25.0]];
        cardBottom.opaque = YES;
        
        imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 280, 209)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.opaque = YES;
        
        userThumbnailView = [appDelegate isArabic] ? [[EGOImageView alloc] initWithFrame:CGRectMake(250, 227, 40, 40)]:
                            [[EGOImageView alloc] initWithFrame:CGRectMake(10, 227, 40, 40)];;
        userThumbnailView.opaque = YES;
        userThumbnailView.placeholderImage = [UIImage imageNamed:@"user_placeholder_large"];
        
        bottomHorizontalSeparator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"horizontal_separator"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:3.0]];
        bottomHorizontalSeparator.opaque = YES;
        
        bottomVerticalSeparator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"vertical_separator"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0]];
        bottomVerticalSeparator.opaque = YES;
        
        clockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_grey"]];
        clockIcon.frame = CGRectMake(277, 280, 13, 14);
        clockIcon.opaque = YES;
        
        distanceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_post_grey"]];
        distanceIcon.frame = CGRectMake(130, 280, 14, 14);
        distanceIcon.opaque = YES;
        
        captionContainer = [CALayer layer];
        captionContainer.opaque = YES;
        
        captionLabel_name = [[UILabel alloc] init];
        captionLabel_name.opaque = YES;
        captionLabel_name.backgroundColor = [UIColor clearColor];
        captionLabel_name.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        captionLabel_name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
        captionLabel_name.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
        captionLabel_name.numberOfLines = 1;
        captionLabel_name.adjustsFontSizeToFitWidth = YES;
        
        captionLabel_verb = [[UILabel alloc] init];
        captionLabel_verb.opaque = YES;
        captionLabel_verb.backgroundColor = [UIColor clearColor];
        captionLabel_verb.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        captionLabel_verb.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        captionLabel_verb.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
        
        captionLabel_dish = [[UILabel alloc] init];
        captionLabel_dish.opaque = YES;
        captionLabel_dish.backgroundColor = [UIColor clearColor];
        captionLabel_dish.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        captionLabel_dish.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
        captionLabel_dish.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
        captionLabel_dish.numberOfLines = 1;
        captionLabel_dish.adjustsFontSizeToFitWidth = YES;
        
        captionLabel_at = [[UILabel alloc] init];
        captionLabel_at.opaque = YES;
        captionLabel_at.backgroundColor = [UIColor clearColor];
        captionLabel_at.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        captionLabel_at.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        captionLabel_at.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
        
        captionLabel_venue = [[UILabel alloc] init];
        captionLabel_venue.opaque = YES;
        captionLabel_venue.backgroundColor = [UIColor clearColor];
        captionLabel_venue.textColor = appDelegate.MAIN_COLOR;//[UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        captionLabel_venue.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        captionLabel_venue.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
        captionLabel_venue.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
        captionLabel_venue.numberOfLines = 1;
        captionLabel_venue.adjustsFontSizeToFitWidth = YES;
        
        timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 275, 115, 25)];
        timestampLabel.opaque = YES;
        timestampLabel.backgroundColor = [UIColor clearColor];
        timestampLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        timestampLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentCenter;
        timestampLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
        timestampLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
        timestampLabel.numberOfLines = 1;
        timestampLabel.adjustsFontSizeToFitWidth = YES;
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 275, 115, 25)];
        distanceLabel.opaque = YES;
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        distanceLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentCenter;
        distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE];
        distanceLabel.minimumScaleFactor = 8.0/SECONDARY_FONT_SIZE;
        distanceLabel.numberOfLines = 1;
        distanceLabel.adjustsFontSizeToFitWidth = YES;
        
        self.itchCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 6, 28, 29)];
        self.itchCountLabel.opaque = YES;
        self.itchCountLabel.backgroundColor = [UIColor clearColor];
        self.itchCountLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        self.itchCountLabel.textAlignment = NSTextAlignmentCenter;
        self.itchCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_SECONDARY_FONT_SIZE];
        self.itchCountLabel.minimumScaleFactor = 8.0/MIN_SECONDARY_FONT_SIZE;
        self.itchCountLabel.numberOfLines = 1;
        self.itchCountLabel.adjustsFontSizeToFitWidth = YES;
        
        self.itchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.itchButton.backgroundColor = [UIColor clearColor];
        [self.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button"] forState:UIControlStateNormal];
        self.itchButton.opaque = YES;
        self.itchButton.frame = CGRectMake(245, -1, 34, 42);
        self.itchButton.showsTouchWhenHighlighted = YES;
        
        /*self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.backgroundColor = [UIColor clearColor];
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"feed_share_button"] forState:UIControlStateNormal];
        self.shareButton.opaque = YES;
        self.shareButton.frame = CGRectMake(20, -1, 34, 42);
        */
        
        [self.cardBG addSubview:imageView];
        [self.cardBG addSubview:userThumbnailView];
        [self.cardBG addSubview:cardBottom];
        [self.cardBG addSubview:bottomVerticalSeparator];
        [self.cardBG addSubview:bottomHorizontalSeparator];
        [self.cardBG addSubview:clockIcon];
        [self.cardBG addSubview:distanceIcon];
        [self.cardBG addSubview:timestampLabel];
        [self.cardBG addSubview:distanceLabel];
        [self.cardBG addSubview:self.itchButton];
        //[self.cardBG addSubview:self.shareButton];
        [self.cardBG.layer addSublayer:captionContainer];
        [captionContainer addSublayer:captionLabel_name.layer];
        [captionContainer addSublayer:captionLabel_verb.layer];
        [captionContainer addSublayer:captionLabel_dish.layer];
        [captionContainer addSublayer:captionLabel_at.layer];
        [captionContainer addSublayer:captionLabel_venue.layer];
        [self.itchButton addSubview:self.itchCountLabel];
        [self.contentView addSubview:self.cardBG];
	}
    
    return self;
}

- (void)populateCellWithContent:(NSMutableDictionary *)data
{
    int itemUserid = [[data objectForKey:@"user_id"] intValue];
    NSString *fullName = [data objectForKey:@"full_name"];
    NSString *dishName = [data objectForKey:@"dish_name"];
    NSString *venueName = [data objectForKey:@"fsq_venue_name"];
    NSString *picHash = [data objectForKey:@"post_pic_hash"];
    NSString *userPicHash = [data objectForKey:@"user_pic_hash"];
    NSString *gender = [data objectForKey:@"sex"];
    NSString *timestamp = appDelegate.isArabic ? [data objectForKey:@"relative_time_arabic"]:
                                                    [data objectForKey:@"relative_time"] ;
    NSString *distance = [[data objectForKey:@"km"] stringValue];
    NSString *itchCount = [[data objectForKey:@"liker_count"] stringValue];
    BOOL userItchedPost = NO;
    
    distance = [NSString stringWithFormat:@"%.1f%@", [distance floatValue], NSLocalizedString(@" kilometers away", nil)];//[distance stringByAppendingFormat:NSLocalizedString(@" kilometers away", nil)];
    
    captionLabel_name.text = fullName;
    captionLabel_dish.text = dishName;
    captionLabel_at.text = NSLocalizedString(@"at", nil);
    captionLabel_venue.text = venueName;
    timestampLabel.text = timestamp;
    distanceLabel.text = (appDelegate.currentLocation.latitude == 9999.0 && appDelegate.currentLocation.longitude == 9999.0)  ?  NSLocalizedString(@"Location Disabled", nil)  : distance;
    self.itchCountLabel.text = itchCount;
    
    if ([gender isEqualToString:@"male"])
    {
        captionLabel_verb.text = NSLocalizedString(@"Recommends_male", nil);
    }
    else
    {
        captionLabel_verb.text = NSLocalizedString(@"Recommends_female", nil);
    }
    
    if ( ![[NSNull null] isEqual:[data objectForKey:@"viewer_likes_post"]] )
    {
        userItchedPost = YES;
        self.itchCountLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
        [self.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button_itched"] forState:UIControlStateNormal];
    }
    else
    {
        userItchedPost = NO;
        self.itchCountLabel.textColor = [UIColor whiteColor];
        [self.itchButton setBackgroundImage:[UIImage imageNamed:@"feed_itches_button"] forState:UIControlStateNormal];
    }
    
    CGSize textSize_name = [fullName sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE] constrainedToSize:CGSizeMake(80, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize_verb = [captionLabel_verb.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE] constrainedToSize:CGSizeMake(100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize_dish = [dishName sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE] constrainedToSize:CGSizeMake(80, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize_at = [captionLabel_at.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:SECONDARY_FONT_SIZE] constrainedToSize:CGSizeMake(100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize_venue = [venueName sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE] constrainedToSize:CGSizeMake(150, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/userphotos/%d/post/m_%@.jpg", FI_DOMAIN, itemUserid, picHash]];
    userThumbnailView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/userphotos/%d/profile/m_%@.jpg", FI_DOMAIN, itemUserid, userPicHash]];
    NSLog(@"^^^^^^^^^^^^^^^^^^^^^ %@", [NSString stringWithFormat:@"http://%@/userphotos/%d/post/m_%@.jpg", FI_DOMAIN, itemUserid, picHash]);
    
    // DO NOT use the CGSize .height. The labels are set to shrink the text to fit their width so the heights will be wrong.
    
    captionContainer.frame = CGRectMake(10, 227, 234, 0);
    if([appDelegate isArabic]){
        captionLabel_name.frame = CGRectMake(captionContainer.frame.size.width - textSize_name.width, 0, textSize_name.width, 20);
        captionLabel_verb.frame = CGRectMake(captionLabel_name.frame.origin.x - textSize_verb.width - 5, 0, textSize_verb.width, 20);
        captionLabel_dish.frame = CGRectMake(captionLabel_verb.frame.origin.x - textSize_dish.width - 5, 0, textSize_dish.width, 20);
    }else{
        captionLabel_name.frame = CGRectMake(userThumbnailView.frame.size.width + 5, 0, textSize_name.width, 20);
        captionLabel_verb.frame = CGRectMake(captionLabel_name.frame.origin.x + textSize_name.width + 4, 2, textSize_verb.width, 20);
        captionLabel_dish.frame = CGRectMake(captionLabel_verb.frame.origin.x + textSize_verb.width + 2, 0, textSize_dish.width, 20);
    }
    
    float width_verb = textSize_name.width + textSize_verb.width;
    float width_at = width_verb + textSize_dish.width + textSize_at.width + 10;
    
    if([appDelegate isArabic]){
        if ( captionContainer.frame.size.width - width_verb < textSize_at.width )
        {
            captionLabel_at.frame = CGRectMake(captionContainer.frame.size.width - textSize_name.width, textSize_name.height + 5, textSize_at.width, 20);
            captionLabel_venue.frame = CGRectMake(captionLabel_at.frame.origin.x - textSize_venue.width - 5, textSize_name.height + 5, textSize_venue.width, 20);
        }
        else
        {
            captionLabel_at.frame = CGRectMake(captionLabel_dish.frame.origin.x - textSize_at.width - 5, 1, textSize_at.width, 20);
            
            if ( captionContainer.frame.size.width - width_at < textSize_venue.width )
            {
                captionLabel_venue.frame = CGRectMake(captionContainer.frame.size.width - textSize_venue.width, 20, textSize_venue.width, 20);
            }
            else
            {
                captionLabel_venue.frame = CGRectMake(captionLabel_at.frame.origin.x - textSize_venue.width - 5, 2, textSize_venue.width, 20);
            }
        }
    }else{
        if ( captionContainer.frame.size.width - captionLabel_dish.frame.origin.x + textSize_dish.width +  20 < textSize_at.width )
        {
            captionLabel_at.frame = CGRectMake(userThumbnailView.frame.size.width + 5, 20, textSize_at.width, 20)   ;
            captionLabel_venue.frame = CGRectMake(captionLabel_at.frame.origin.x + textSize_at.width + 5, 20, textSize_venue.width, 20);
        }
        else
        {
            captionLabel_at.frame = CGRectMake(captionLabel_dish.frame.origin.x + captionLabel_dish.frame.size.width + 5, 1, textSize_at.width, 20);
            
            if ( captionContainer.frame.size.width - (captionLabel_at.frame.size.width + captionLabel_at.frame.origin.x) < textSize_venue.width )
            {
                captionLabel_venue.frame = CGRectMake(userThumbnailView.frame.size.width + 5, 20, textSize_venue.width, 20);
            }
            else
            {
                captionLabel_venue.frame = CGRectMake(captionLabel_at.frame.origin.x + captionLabel_at.frame.size.width + 5, 0, textSize_venue.width, 20);
            }
        }
    }

    
    captionContainer.frame = CGRectMake(10, 227, 234, captionLabel_at.frame.origin.y + 20);
    
    self.cardBG.frame = CGRectMake(10, 15, 300, 285 + captionContainer.frame.size.height);
    cardBottom.frame = CGRectMake(3, self.cardBG.frame.size.height - 30, 294, 25);
    bottomHorizontalSeparator.frame = CGRectMake(3, self.cardBG.frame.size.height - 31, 294, 3);
    bottomVerticalSeparator.frame = CGRectMake(150, self.cardBG.frame.size.height - 31, 3, 26);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
