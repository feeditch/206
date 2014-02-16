//
//  PostComposer_Stage1.h
//  Feeditch
//
//  Created by MachOSX on 2/8/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PostComposer_Stage2.h"
#import "PostComposer_Stage3.h"
#import "Global.h"

@interface PostComposer_Stage1 : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UIActionSheetDelegate> {
    PostComposer_Stage2 *stage2;
    PostComposer_Stage3 *stage3;
    UIBarButtonItem *nextButtonItem;
    CLLocationManager *locationManager;
    UIView *postControls;
    UIButton *cameraButton;
    UIButton *photoLibraryButton;
    UIButton *imagePreviewDisplay;
    UIImagePickerController *photoPicker;
    UIImageView *imagePreview;
    UIImageView *postTypeIcon_food;
    UIImageView *postTypeIcon_drink;
    UIImageView *postTypeSwitch;
    UIImageView *postTypeSwitchOverlay;
    UIImage *selectedImage;
    UISlider *mealTypeSlider;
    UIView *locationError;
    UIImageView *locationErrorIcon;
    UILabel *locationErrorLabel;
    NSString *mealType;
    BOOL isDrink;
}

@property (strong, nonatomic) NSMutableDictionary *postChunk;
@property (nonatomic) CGPoint sliderDragCoord;

- (void)dismissComposer;
- (void)showPhotoOptions;
- (void)hidePhotoOptions;
- (void)showCamera;
- (void)showPhotoLibrary;
- (void)changeImage;
- (void)togglePostType:(id)sender;
- (void)sliderValueChanged:(id)sender;
- (void)goNext;

@end
