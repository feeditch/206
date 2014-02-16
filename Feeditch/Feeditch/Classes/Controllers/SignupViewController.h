//
//  SignupViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Accounts/Accounts.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"


@interface SignupViewController : UIViewController <MBProgressHUDDelegate, UIScrollViewDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    MBProgressHUD *HUD;
    UIImageView *tickerBG;
    UIScrollView *ticker;
    UIPageControl *pageControl;
    UIButton *emailButton;
    UIButton *FBButton;
    UIButton *loginButton;
}

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;


- (void)changePage;
- (void)join:(id)sender;
- (void)login;

@end
