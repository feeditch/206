//
//  PostComposer_Stage3.h
//  Feeditch
//
//  Created by MachOSX on 2/17/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "Global.h"

@interface PostComposer_Stage3 : UIViewController <UINavigationControllerDelegate, MBProgressHUDDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    UIBarButtonItem *doneButton;
    MBProgressHUD *HUD;
    UIButton *backgroundTouchDetector;
    UITextField *dishNameField;
    UITextView *tipView;
    UIPickerView *cuisinePicker;
    UIImageView *priceButtonCheckbox_fair;
    UIImageView *priceButtonCheckbox_over;
    UILabel *tipViewPlaceholder;
    UILabel *cuisineLabel;
    UILabel *priceButtonLabel_fair;
    UILabel *priceButtonLabel_over;
    UILabel *locationLabel;
    int selectedCuisine;
    BOOL price_fair;
    BOOL price_over;
}

@property (strong, nonatomic) NSMutableDictionary *postChunk;
@property (strong, nonatomic) NSString *location;

- (void)didTapBackButton:(id)sender;
- (void)backgroundTouched;
- (void)respondToTextInDishNameField;
- (void)respondToTextInTipView;
- (void)presentCuisinePicker;
- (void)dismissCuisinePicker;
- (void)animateCuisinePickerForValue:(NSString *)value;
- (void)togglePriceValue:(id)sender;
- (void)editLocation;
- (void)submitPost;

@end
