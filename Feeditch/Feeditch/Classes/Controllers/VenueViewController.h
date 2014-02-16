//
//  VenueViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "FeedItemCell.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "UITableViewActionSheet.h"

@interface VenueViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    CLLocationManager *locationManager;
    FeedItemCell *feedItemCell;
    MBProgressHUD *HUD;
    UITableViewActionSheet *sharingOptions;
    BOOL feedDidFinishDownloading;
    BOOL reloading;
    BOOL endOfFeed;
    NSString *venueFormattedPhoneNumber;
    NSString *venuePhoneNumber;
    NSString *venueTwitter;
    NSString *venueLat;
    NSString *venueLong;
    NSString *venueCheckinCount;
    UIButton *phoneButton;
    UIButton *twitterButton;
    UIButton *mapButton;
    UIButton *checkinsButton;
    UIButton *fanButton;
    UIButton *newPostButton;
    UILabel *phoneButtonLabel;
    UILabel *twitterButtonLabel;
    UILabel *mapButtonLabel;
    UILabel *checkinsButtonLabel;
    UILabel *fansLabel;
    UILabel *postsLabel;
}

@property (strong, nonatomic) UITableView *venueFeed;
@property (strong, nonatomic) NSMutableArray *venueFeedData;
@property (nonatomic) int batchNo;
@property (nonatomic) NSString *fsqVenueID;
@property (nonatomic) NSString *venueID;
@property (nonatomic) NSString *venueName;
@property (nonatomic) NSString *postCount;
@property (nonatomic) NSString *fanCount;
@property (nonatomic) BOOL userFanOfVenue;

- (void)showPostComposer;
- (void)callVenue;
- (void)openVenueTwitter;
- (void)showVenueOnMap;
- (void)becomeFan;
- (void)newPostForVenue;
- (void)getVenueInfo;
- (void)downloadFeedForBatch:(int)batch;
- (void)gotoPostAtIndexPath:(NSIndexPath *)indexPath;
- (void)itchPost:(id)sender;
- (void)showPostSharingOptions:(id)sender;
- (void)showPostDeletionOptions:(id)sender;
- (void)handlePostSharingAtIndexPath:(NSIndexPath *)indexPath forButtonAtIndex:(int)buttonIndex;
- (void)handlePostDeletionAtIndexPath:(NSIndexPath *)indexPath;

@end
