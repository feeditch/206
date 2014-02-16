//
//  ProfileViewController.h
//  Feeditch
//
//  Created by MachOSX on 2/7/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "FeedItemCell.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "UITableViewActionSheet.h"

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate, EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    CLLocationManager *locationManager;
    FeedItemCell *feedItemCell;
    MBProgressHUD *HUD;
    UIBarButtonItem *settingsButton;
    EGORefreshTableHeaderView *refreshHeaderView;
    UITableViewActionSheet *sharingOptions;
    EGOImageView *userThumbnail;
    UIImagePickerController *photoPicker;
    UIImage *selectedDPImage;
    UIView *tableHeader;
    UILabel *userNameLabel;
    UILabel *userBioLabel;
    UILabel *userLocationLabel;
    UILabel *userItchCountLabel;
    UILabel *userItchCountTextLabel;
    UILabel *userFollowerCountLabel;
    UILabel *userFollowerCountTextLabel;
    UILabel *userFollowingCountLabel;
    UILabel *userFollowingCountTextLabel;
    UILabel *userPostCountLabel;
    UILabel *userPostCountTextLabel;
    UIButton *DPButton;
    UIButton *followersButton;
    UIButton *followingButton;
    UIButton *itchesButton;
    UIButton *followButton;
    UIImageView *globeIcon;
    UIImageView *statsPanel;
    UIImageView *userPostCountLabelLine_1;
    UIImageView *userPostCountLabelLine_2;
    BOOL feedDidFinishDownloading;
    BOOL reloading;
    BOOL endOfFeed;
    int profileOwnerItchCount;
    int profileOwnerPostCount;
    int profileOwnerFollowerCount;
    int profileOwnerFollowingCount;
    BOOL followingProfileOwner;
    BOOL profileOwnerFollowsYou;
}

@property (strong, nonatomic) IBOutlet UITableView *profileFeed;
@property (strong, nonatomic) NSMutableArray *profileFeedData;
@property (nonatomic) BOOL hasNewPost;
@property (nonatomic) BOOL isCurrentUser;
@property (nonatomic) int batchNo;
@property (nonatomic) int profileOwnerUserid;
@property (nonatomic, retain) NSString *profileOwnerName;
@property (nonatomic, retain) NSString *profileOwnerGender;
@property (nonatomic, retain) NSString *profileOwnerEmail;
@property (nonatomic, retain) NSString *profileOwnerHash;
@property (nonatomic, retain) NSString *profileOwnerCountry;
@property (nonatomic, retain) NSString *profileOwnerBio;

- (void)showPostComposer;
- (void)gotoSettings;
- (void)gotoFollowing;
- (void)gotoFollowers;
- (void)gotoItches;
- (void)gotoPostAtIndexPath:(NSIndexPath *)indexPath;
- (void)getUserInfoForID:(int)userid;
- (void)redrawContents;
- (void)followUser;
- (void)deleteDP;
- (void)downloadFeedForBatch:(int)batch;
- (void)itchPost:(id)sender;
- (void)showDPOptions;
- (void)showPostSharingOptions:(id)sender;
- (void)showPostDeletionOptionsAtIndexPath:(NSIndexPath *)indexPath;
- (void)handlePostSharingAtIndexPath:(NSIndexPath *)indexPath forButtonAtIndex:(int)buttonIndex;
- (void)handlePostDeletionAtIndexPath:(NSIndexPath *)indexPath;

@end
