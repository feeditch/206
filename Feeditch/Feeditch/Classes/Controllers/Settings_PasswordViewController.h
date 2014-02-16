//
//  Settings_PasswordViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/24/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface Settings_PasswordViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    MBProgressHUD *HUD;
    UIBarButtonItem *changePasswdButton;
    UITextField *oldPasswdField;
    UITextField *newPasswdField;
}

- (void)changePasswd;

@end
