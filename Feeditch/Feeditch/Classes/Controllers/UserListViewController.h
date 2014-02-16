//
//  UserListViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/23/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "FeedUserItemCell.h"

@interface UserListViewController : UIViewController <MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    MBProgressHUD *HUD;
    FeedUserItemCell *feedItemCell;
    int batchNo;
    BOOL feedDidFinishDownloading;
    BOOL reloading;
    BOOL endOfFeed;
}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) UITableView *listTableView;
@property (nonatomic, retain) NSString *listType;
@property (nonatomic) int targetID;

- (void)gotoUserAtIndexPath:(NSIndexPath *)indexPath;
- (void)downloadListForBatch:(int)batch;
- (void)followUser:(id)sender;

@end
