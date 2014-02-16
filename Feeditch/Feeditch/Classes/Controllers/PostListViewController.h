//
//  PostListViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/23/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "FeedItemCell.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "UITableViewActionSheet.h"

@interface PostListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    CLLocationManager *locationManager;
    MBProgressHUD *HUD;
    UITableViewActionSheet *sharingOptions;
    FeedItemCell *feedItemCell;
    BOOL feedDidFinishDownloading;
    BOOL reloading;
    BOOL endOfFeed;
}

@property (strong, nonatomic) UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (nonatomic, retain) NSString *listType;
@property (nonatomic) int targetUserid;
@property (nonatomic) int batchNo;

- (void)downloadFeedForBatch:(int)batch;
- (void)gotoPostAtIndexPath:(NSIndexPath *)indexPath;
- (void)itchPost:(id)sender;
- (void)showPostSharingOptions:(id)sender;
- (void)showPostDeletionOptionsAtIndexPath:(NSIndexPath *)indexPath;
- (void)handlePostSharingAtIndexPath:(NSIndexPath *)indexPath forButtonAtIndex:(int)buttonIndex;
- (void)handlePostDeletionAtIndexPath:(NSIndexPath *)indexPath;

@end
