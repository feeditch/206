//
//  SignupFormViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/25/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface SignupFormViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    NSArray *genderList;
    MBProgressHUD *HUD;
    UIBarButtonItem *saveChangesButton;
    UILabel *nameLabel;
    UILabel *locationLabel;
    UILabel *genderLabel;
    UILabel *emailLabel;
    UILabel *passwdLabel;
    UIPickerView *locationPicker;
    UIPickerView *genderPicker;
    UIButton *locationFieldButton;
    UIButton *genderFieldButton;
}

// These fields need to be accessible from outside.
@property (nonatomic, retain) NSString *signupType;
@property (nonatomic, retain) NSString *FBID;
@property (nonatomic, retain) NSString *preloaded_full_name;
@property (nonatomic, retain) NSString *preloaded_email;
@property (nonatomic, retain) UILabel *locationField;
@property (nonatomic, retain) UILabel *genderField;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UITextField *passwdField;

- (void)showLocationOptions;
- (void)dismissLocationOptions;
- (void)showGenderOptions;
- (void)dismissGenderOptions;
- (void)saveChanges;

@end
