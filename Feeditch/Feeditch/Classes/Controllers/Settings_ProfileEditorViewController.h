//
//  Settings_ProfileEditorViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/24/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface Settings_ProfileEditorViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    NSArray *genderList;
    MBProgressHUD *HUD;
    UIBarButtonItem *saveChangesButton;
    UIScrollView *mainView;
    UILabel *nameLabel;
    UILabel *locationLabel;
    UILabel *genderLabel;
    UILabel *emailLabel;
    UILabel *bioLabel;
    UILabel *locationField;
    UILabel *genderField;
    UITextField *nameField;
    UITextField *emailField;
    UITextField *bioField;
    UIPickerView *locationPicker;
    UIPickerView *genderPicker;
    UIButton *locationFieldButton;
    UIButton *genderFieldButton;
}

- (void)showLocationOptions;
- (void)dismissLocationOptions;
- (void)showGenderOptions;
- (void)dismissGenderOptions;
- (void)saveChanges;

@end
