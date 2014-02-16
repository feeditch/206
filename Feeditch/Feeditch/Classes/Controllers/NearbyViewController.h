//
//  NearbyViewController.h
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

@interface NearbyViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    CLLocationManager *locationManager;
    FeedItemCell *feedItemCell;
    MBProgressHUD *HUD;
    EGORefreshTableHeaderView *refreshHeaderView;
    UITableViewActionSheet *sharingOptions;
    UIImageView *locationErrorIcon;
    UILabel *locationErrorLabel;
    BOOL feedDidFinishDownloading;
    BOOL reloading;
    BOOL endOfFeed;
}

@property (strong, nonatomic) IBOutlet UITableView *nearbyFeed;
@property (strong, nonatomic) NSMutableArray *nearbyFeedData;
@property (nonatomic) int batchNo;

- (void)showPostComposer;
- (void)downloadFeedForBatch:(int)batch;
- (void)gotoPostAtIndexPath:(NSIndexPath *)indexPath;
- (void)itchPost:(id)sender;
- (void)showPostSharingOptions:(id)sender;
- (void)showPostDeletionOptionsAtIndexPath:(NSIndexPath *)indexPath;
- (void)handlePostSharingAtIndexPath:(NSIndexPath *)indexPath forButtonAtIndex:(int)buttonIndex;
- (void)handlePostDeletionAtIndexPath:(NSIndexPath *)indexPath;

@end
