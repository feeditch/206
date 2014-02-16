//
//  PostComposer_Stage1.m
//  Feeditch
//
//  Created by MachOSX on 2/8/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "PostComposer_Stage1.h"
#import "AppDelegate.h"
#import "UIImage+iPhone5extension.h"

@implementation PostComposer_Stage1

AppDelegate *appDelegate;

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenBounds.size.height;
    
    [self setTitle:NSLocalizedString(@"New Picture", nil)];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 35)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"forward_arrow"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(0, 0, 27, 19);
    nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    nextButtonItem.enabled = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dismissComposer)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelButton;
    
    stage2 = [[PostComposer_Stage2 alloc] init];
    stage3 = [[PostComposer_Stage3 alloc] init];
    self.postChunk = [[NSMutableDictionary alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    
    // Get the user's current location & save it.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    
    UIImageView *paper_BG = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"tablecloth_paper"]];
    paper_BG.opaque = YES;
    paper_BG.userInteractionEnabled = YES;
    
    if ( IS_IPHONE_5 )
    {
        paper_BG.frame = CGRectMake(3, 5, 314, 494);
    }
    else
    {
        paper_BG.frame = CGRectMake(3, 5, 314, 401);
    }
    
    postControls = [[UIView alloc] initWithFrame:CGRectMake(8, paper_BG.frame.size.height - 180, 297, 170)];
    postControls.opaque = YES;
    postControls.alpha = 0.0;
    postControls.hidden = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, 280, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment =  appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    titleLabel.text = NSLocalizedString(@"Add picture from...", nil);
    titleLabel.opaque = YES;
    
    CALayer *dotted_line_red = [CALayer layer];
    dotted_line_red.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red.frame = CGRectMake(13, 70, 297, 3);
    dotted_line_red.opaque = YES;
    [dotted_line_red setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.backgroundColor = [UIColor clearColor];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"post_camera"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.opaque = YES;
    cameraButton.frame = CGRectMake(125, 120, 76, 55);
    
    photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoLibraryButton.backgroundColor = [UIColor clearColor];
    [photoLibraryButton setBackgroundImage:[UIImage imageNamed:@"post_lib"] forState:UIControlStateNormal];
    [photoLibraryButton addTarget:self action:@selector(showPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    photoLibraryButton.opaque = YES;
    photoLibraryButton.frame = CGRectMake(125, 250, 76, 55);
    
    UILabel *cameraButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(-65, 65, 200, 22)];
    cameraButtonLabel.backgroundColor = [UIColor clearColor];
    cameraButtonLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    cameraButtonLabel.textAlignment = NSTextAlignmentCenter;
    cameraButtonLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    cameraButtonLabel.text = NSLocalizedString(@"Camera", nil);
    cameraButtonLabel.opaque = YES;

    UILabel *photoLibraryButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(-65, 65, 200, 22)];
    photoLibraryButtonLabel.backgroundColor = [UIColor clearColor];
    photoLibraryButtonLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    photoLibraryButtonLabel.textAlignment = NSTextAlignmentCenter;
    photoLibraryButtonLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    photoLibraryButtonLabel.text = NSLocalizedString(@"Existing Picture", nil);
    photoLibraryButtonLabel.opaque = YES;
    
    imagePreview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight - 280)];
    imagePreview.contentMode = UIViewContentModeScaleAspectFill;
    imagePreview.clipsToBounds = YES;
    imagePreview.opaque = YES;
    
    imagePreviewDisplay = [UIButton buttonWithType:UIButtonTypeCustom];
    imagePreviewDisplay.backgroundColor = [UIColor clearColor];
    [imagePreviewDisplay addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    imagePreviewDisplay.opaque = YES;
    imagePreviewDisplay.frame = CGRectMake(0, -400, 320, 200);
    imagePreviewDisplay.showsTouchWhenHighlighted = YES;
    
    UIImageView *imagePreviewDisplayShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bar_shadow_down"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];
    imagePreviewDisplayShadow.frame = CGRectMake(0, imagePreview.frame.size.height, 320, 20);
    imagePreviewDisplayShadow.opaque = YES;
    
    postTypeIcon_food = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"f&b_food_highlighted"]];
    postTypeIcon_food.frame = CGRectMake(0, 0, 23, 22);
    postTypeIcon_food.opaque = YES;
    
    postTypeIcon_drink = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"f&b_drink"]];
    postTypeIcon_drink.frame = CGRectMake(3, 0, 13, 22);
    postTypeIcon_drink.opaque = YES;
    
    UIButton *postType_food = [UIButton buttonWithType:UIButtonTypeCustom];
    postType_food.backgroundColor = [UIColor clearColor];
    [postType_food addTarget:self action:@selector(togglePostType:) forControlEvents:UIControlEventTouchUpInside];
    postType_food.opaque = YES;
    postType_food.frame = CGRectMake(180, 20, 23, 22);
    postType_food.showsTouchWhenHighlighted = YES;
    postType_food.tag = 0;
    
    UIButton *postType_drink = [UIButton buttonWithType:UIButtonTypeCustom];
    postType_drink.backgroundColor = [UIColor clearColor];
    [postType_drink addTarget:self action:@selector(togglePostType:) forControlEvents:UIControlEventTouchUpInside];
    postType_drink.opaque = YES;
    postType_drink.frame = CGRectMake(100, 20, 23, 22);
    postType_drink.showsTouchWhenHighlighted = YES;
    postType_drink.tag = 1;
    
    postTypeSwitch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch_f&b_well"]];
    postTypeSwitch.frame = CGRectMake(-53, 1, 132, 28);
    postTypeSwitch.opaque = YES;
    
    postTypeSwitchOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch_f&b_overlay"]];
    postTypeSwitchOverlay.frame = CGRectMake(5, 20, 82, 30);
    postTypeSwitchOverlay.opaque = YES;
    postTypeSwitchOverlay.layer.cornerRadius = 17.5;
    postTypeSwitchOverlay.layer.masksToBounds = YES;
    postTypeSwitchOverlay.userInteractionEnabled = YES;
    
    CALayer *dotted_line_grey = [CALayer layer];
    dotted_line_grey.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_grey"]].CGColor;
    dotted_line_grey.frame = CGRectMake(0, 80, 297, 3);
    dotted_line_grey.opaque = YES;
    [dotted_line_grey setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    UILabel *mealType_bfast = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(240, 110, 70, 14)] : [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 65, 14)];
    mealType_bfast.backgroundColor = [UIColor clearColor];
    mealType_bfast.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    mealType_bfast.textAlignment = NSTextAlignmentCenter;
    mealType_bfast.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    mealType_bfast.text = NSLocalizedString(@"Breakfast", nil);
    mealType_bfast.opaque = YES;
    
    UILabel *mealType_lunch = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(155, 110, 70, 14)] : [[UILabel alloc] initWithFrame:CGRectMake(70, 110, 70, 14)];
    mealType_lunch.backgroundColor = [UIColor clearColor];
    mealType_lunch.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    mealType_lunch.textAlignment = NSTextAlignmentCenter;
    mealType_lunch.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    mealType_lunch.text = NSLocalizedString(@"Lunch", nil);
    mealType_lunch.opaque = YES;
    
    UILabel *mealType_dinner = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(70, 110, 70, 14)] : [[UILabel alloc] initWithFrame:CGRectMake(155, 110, 70, 14)];
    mealType_dinner.backgroundColor = [UIColor clearColor];
    mealType_dinner.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    mealType_dinner.textAlignment = NSTextAlignmentCenter;
    mealType_dinner.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    mealType_dinner.text = NSLocalizedString(@"Dinner", nil);
    mealType_dinner.opaque = YES;
    
    UILabel *mealType_dessert = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 65, 14)] : [[UILabel alloc] initWithFrame:CGRectMake(240, 110, 70, 14)];
    mealType_dessert.backgroundColor = [UIColor clearColor];
    mealType_dessert.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    mealType_dessert.textAlignment = NSTextAlignmentCenter;
    mealType_dessert.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    mealType_dessert.text = NSLocalizedString(@"Dessert", nil);
    mealType_dessert.opaque = YES;
    
    UIImageView *mealTypeSliderTrack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_4_heads"]];
    mealTypeSliderTrack.frame = CGRectMake(11, 134, 274, 19);
    mealTypeSliderTrack.opaque = YES;
    
    mealTypeSlider = [[UISlider alloc] initWithFrame:CGRectMake(6, 120, 289, 44)];
    [mealTypeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [mealTypeSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_dummy_track"] forState:UIControlStateNormal];
    [mealTypeSlider setMaximumTrackImage:[UIImage imageNamed:@"slider_dummy_track"] forState:UIControlStateNormal];
    [mealTypeSlider setThumbImage:[UIImage imageNamed:@"slider_head"] forState:UIControlStateNormal];
    mealTypeSlider.continuous = NO;
    mealTypeSlider.value = appDelegate.isArabic ? 1 : 0;

    
    locationError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight - 64)];
    locationError.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    locationError.userInteractionEnabled = YES;
    locationError.hidden = YES;
    
    locationErrorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error_big"]];
    locationErrorIcon.frame = CGRectMake(120, 100, 81, 67);
    locationErrorIcon.opaque = YES;
    
    locationErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 35)];
    locationErrorLabel.backgroundColor = [UIColor clearColor];
    locationErrorLabel.textColor = [UIColor colorWithRed:123.0/255.0 green:123.0/255.0 blue:123.0/255.0 alpha:1.0];
    locationErrorLabel.textAlignment = NSTextAlignmentCenter;
    locationErrorLabel.numberOfLines = 0;
    locationErrorLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    locationErrorLabel.opaque = YES;
    locationErrorLabel.text = NSLocalizedString(@"Couldn't get your location. Please enable location services in your phone settings.", nil);
    
    isDrink = NO; // Food is chosen by default.
    mealType = @"breakfast"; // Breakfast by default.
    
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) // If the device has a camera.
    {
        
    }
    else
    {
        photoLibraryButton.frame = CGRectMake(120, 200, 76, 55);
        cameraButton.hidden = YES;
    }
    
    [postType_drink addSubview:postTypeIcon_drink];
    [postType_food addSubview:postTypeIcon_food];
    
    [cameraButton addSubview:cameraButtonLabel];
    [photoLibraryButton addSubview:photoLibraryButtonLabel];
    [imagePreviewDisplay addSubview:imagePreview];
    [imagePreviewDisplay addSubview:imagePreviewDisplayShadow];
    [postTypeSwitchOverlay addSubview:postTypeSwitch];
    //[postControls addSubview:postTypeSwitchOverlay];
    [postControls addSubview:postType_food];
    [postControls addSubview:postType_drink];
    [postControls.layer addSublayer:dotted_line_grey];
    [postControls addSubview:mealType_bfast];
    [postControls addSubview:mealType_lunch];
    [postControls addSubview:mealType_dinner];
    [postControls addSubview:mealType_dessert];
    [postControls addSubview:mealTypeSliderTrack];
    [postControls addSubview:mealTypeSlider];
    [locationError addSubview:locationErrorIcon];
    [locationError addSubview:locationErrorLabel];
    [self.view addSubview:titleLabel];
    [self.view.layer addSublayer:dotted_line_red];
    [self.view addSubview:cameraButton];
    [self.view addSubview:photoLibraryButton];
    [self.view addSubview:postControls];
    [self.view addSubview:imagePreviewDisplay];
    [self.view addSubview:locationError];
    [super viewDidLoad];
    
    
   // [self hidePhotoOptions];
   // [self showPhotoLibrary];
}

- (void)dismissComposer
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showPhotoOptions
{
    nextButtonItem.enabled = NO;
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imagePreviewDisplay.frame = CGRectMake(0, -400, imagePreviewDisplay.frame.size.width, imagePreviewDisplay.frame.size.height);
        postControls.frame = CGRectMake(8, postControls.frame.origin.y + 10, postControls.frame.size.width, postControls.frame.size.height);
        postControls.alpha = 0.0;
        cameraButton.alpha = 1.0;
        photoLibraryButton.alpha = 1.0;
    } completion:^(BOOL finished){
        postControls.hidden = YES;
    }];
}

- (void)hidePhotoOptions
{
    nextButtonItem.enabled = YES;
    postControls.hidden = NO;
    
    [UIView animateWithDuration:1.0 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imagePreviewDisplay.frame = CGRectMake(0, 0, imagePreviewDisplay.frame.size.width, imagePreviewDisplay.frame.size.height);
        cameraButton.alpha = 0.0;
        photoLibraryButton.alpha = 0.0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            postControls.frame = CGRectMake(8, postControls.frame.origin.y - 10, postControls.frame.size.width, postControls.frame.size.height);
            postControls.alpha = 1.0;
        } completion:^(BOOL finished){
            
        }];
    }];
}

- (void)showCamera
{
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

- (void)showPhotoLibrary
{
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

- (void)changeImage
{
    UIActionSheet *photoOptions = [[UIActionSheet alloc]
                 initWithTitle:NSLocalizedString(@"Pic Options", nil)
                 delegate:self
                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                 destructiveButtonTitle:nil
                 otherButtonTitles:NSLocalizedString(@"Change Picture", nil), nil];
    photoOptions.tag = 0;
    [photoOptions showInView:self.view];
}

#pragma mark -
#pragma mark Custom switch handler

- (void)switchDragging:(UIPanGestureRecognizer *)gesture
{
    CGPoint newCoord = [gesture locationInView:postTypeSwitchOverlay];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.sliderDragCoord = [gesture locationInView:postTypeSwitchOverlay];
    }
    
    float dX = newCoord.x - self.sliderDragCoord.x;
    
    if ( gesture.state == UIGestureRecognizerStateEnded )
    {
        if ( dX >= 10 )
        {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                postTypeSwitch.frame = CGRectMake(1, postTypeSwitch.frame.origin.y, postTypeSwitch.frame.size.width, postTypeSwitch.frame.size.height);
            } completion:^(BOOL finished){
                isDrink = YES;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                postTypeSwitch.frame = CGRectMake(0, postTypeSwitch.frame.origin.y, postTypeSwitch.frame.size.width, postTypeSwitch.frame.size.height);
            } completion:^(BOOL finished){
                isDrink = NO;
            }];
        }
    }
    else
    {
        if ( dX >= 30 )
        {
            postTypeSwitch.frame = CGRectMake(1, postTypeSwitch.frame.origin.y, postTypeSwitch.frame.size.width, postTypeSwitch.frame.size.height);
        }
        else if ( dX <= -50 )
        {
            postTypeSwitch.frame = CGRectMake(0, postTypeSwitch.frame.origin.y, postTypeSwitch.frame.size.width, postTypeSwitch.frame.size.height);
        }
        else
        {
            if ( newCoord.x > self.sliderDragCoord.x )
            {
                postTypeSwitch.frame = CGRectMake(dX - 30, postTypeSwitch.frame.origin.y, postTypeSwitch.frame.size.width, postTypeSwitch.frame.size.height);
            }
            else
            {
                postTypeSwitch.frame = CGRectMake(dX, postTypeSwitch.frame.origin.y, postTypeSwitch.frame.size.width, postTypeSwitch.frame.size.height);
            }
            
        }
    }
}

- (void)togglePostType:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if ( button.tag == 0 )
    {
        isDrink = NO;
        postTypeIcon_food.image = [UIImage imageNamed:@"f&b_food_highlighted"];
        postTypeIcon_drink.image = [UIImage imageNamed:@"f&b_drink"];
    }
    else
    {
        postTypeIcon_food.image = [UIImage imageNamed:@"f&b_food"];
        postTypeIcon_drink.image = [UIImage imageNamed:@"f&b_drink_highlighted"];
        isDrink = YES;
    }
}

#pragma mark -
#pragma mark Custom slider handler

- (void)sliderValueChanged:(id)sender
{
    // The slider needs to snap to the nearest value.
    UISlider *slider = (UISlider *)sender;
    
    if ( slider.value <= 0.2 ) // Dessert(ar) - breakfast(en)
    {
        mealType = appDelegate.isArabic ? @"dessert" : @"breakfast"; // Switch sides between arabic and english
        [slider setValue:0 animated:YES];
    }
    else if ( slider.value >= 0.2 && slider.value <= 0.4 ) // Dinner(ar) - lunch(en)
    {
        mealType = appDelegate.isArabic ? @"dinner" : @"lunch";
        [slider setValue:0.331373 animated:YES];
    }
    else if ( slider.value > 0.4 && slider.value <= 0.8 ) // Lunch(ar) - dinner(en)
    {
        mealType = appDelegate.isArabic ? @"lunch" : @"dinner";
        [slider setValue:0.664706 animated:YES];
    }
    else if ( slider.value > 0.8 ) // Breakfast(ar) - dessert(en)
    {
        mealType = appDelegate.isArabic ? @"breakfast" : @"dessert";
        [slider setValue:1 animated:YES];
    }
}

#pragma mark -
#pragma mark Move on to the next view

- (void)goNext
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"اللقطة" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Get Image
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, 0.3);
    
    [self.postChunk setObject:imageData forKey:@"imageData"];
    [self.postChunk setObject:[NSString stringWithFormat:@"%@", isDrink ? @"drink" : @"food"] forKey:@"type"];
    [self.postChunk setObject:mealType forKey:@"period"];
    
    NSString *venueName = [self.postChunk objectForKey:@"fsq_venue_name"];
    
    if ( venueName.length > 0 )
    {
        stage3.postChunk = self.postChunk;
        [self.navigationController pushViewController:stage3 animated:YES];
    }
    else
    {
        stage2.postChunk = self.postChunk;
        [self.navigationController pushViewController:stage2 animated:YES];
    }
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    imagePreview.image = selectedImage;
    
    [self hidePhotoOptions];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.currentLocation = newLocation.coordinate;
    
    locationError.hidden = YES;
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( status != kCLAuthorizationStatusAuthorized || ![CLLocationManager locationServicesEnabled] )
    {
        // Show the location error.
        locationError.hidden = NO;
        appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    // Show the location error.
    locationError.hidden = NO;
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( actionSheet.tag == 0 ) // Change image.
    {
        if ( buttonIndex == 0 )
        {
            [self showPhotoOptions];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
