//
//  LoginViewController.h
//  Feeditch
//
//  Created by MachOSX on 2/7/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    MBProgressHUD *HUD;
    UITextField *emailFieldBG;
    UITextField *passwdFieldBG;
    UITextField *emailField;
    UITextField *passwdField;
    UITextField *passwdResetField;
    UILabel *passwdResetLabel;
    UILabel *loginButtonLabel;
    UILabel *joinButtonLabel;
    UIButton *forgotPasswdButton;
    UIButton *loginButton;
    UIButton *joinButton;
    UIImageView *loginIcon;
    UIImageView *joinIcon;
}

- (void)login;
- (void)join;
- (void)resetPasswd;
- (void)showLoginInterface;
- (void)showPasswordResetInterface;

@end
