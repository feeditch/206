//
//  FriendInviter.h
//  Feeditch
//
//  Created by MachOSX on 5/3/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Accounts/Accounts.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface FriendInviter : UIViewController <MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    NSMutableArray *listData;
    NSMutableArray *selectedListItems;
    MBProgressHUD *HUD;
    UITableView *friendsList;
}

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;

- (void)dismissInviter;
- (void)inviteAll;

@end
