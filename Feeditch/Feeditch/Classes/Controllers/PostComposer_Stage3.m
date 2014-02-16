//
//  PostComposer_Stage1.m
//  Feeditch
//
//  Created by MachOSX on 2/17/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "PostComposer_Stage3.h"
#import "AppDelegate.h"
#import "UIImage+iPhone5extension.h"
#import "ProfileViewController.h"

@implementation PostComposer_Stage3

AppDelegate *appDelegate;
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    [self setTitle:NSLocalizedString(@"New Picture", nil)];
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(submitPost)];
    self.navigationItem.rightBarButtonItem = doneButton;
    doneButton.enabled = NO;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 27, 19);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    
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
    
    backgroundTouchDetector = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundTouchDetector.backgroundColor = [UIColor clearColor];
    [backgroundTouchDetector addTarget:self action:@selector(backgroundTouched) forControlEvents:UIControlEventTouchUpInside];
    backgroundTouchDetector.opaque = YES;
    backgroundTouchDetector.frame = self.view.frame;
    
    UITextField *dishNameFieldBG = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, 280, 40)];
    dishNameFieldBG.borderStyle = UITextBorderStyleRoundedRect;
    dishNameFieldBG.enabled = NO;
    
    dishNameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, 260, 20)];
    dishNameField.delegate = self;
    dishNameField.borderStyle = UITextBorderStyleNone;
    dishNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    dishNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    dishNameField.keyboardType = UIKeyboardTypeEmailAddress;
    dishNameField.returnKeyType = UIReturnKeyNext;
    dishNameField.textColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
    dishNameField.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    dishNameField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    dishNameField.placeholder = NSLocalizedString(@"What did you eat/drink?", nil);
    dishNameField.tag = 0;
    
    UITextField *tipViewBG = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 120)];
    tipViewBG.borderStyle = UITextBorderStyleRoundedRect;
    tipViewBG.enabled = NO;
    
    tipView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, 277, 120)];
    tipView.backgroundColor = [UIColor clearColor];
    tipView.textColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
    tipView.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    tipView.returnKeyType = UIReturnKeyDone;
    tipView.tag = 911;
    tipView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTextInDishNameField) name:UITextFieldTextDidChangeNotification object:dishNameField]; // Listen for keystrokes (dishNameField).
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTextInTipView) name:UITextViewTextDidChangeNotification object:tipView]; // Listen for keystrokes (tipView).
    
    tipViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 260, 35)];
    tipViewPlaceholder.backgroundColor = [UIColor clearColor];
    tipViewPlaceholder.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0];
    tipViewPlaceholder.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    tipViewPlaceholder.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    tipViewPlaceholder.shadowOffset = CGSizeMake(0, 1);
    tipViewPlaceholder.numberOfLines = 0;
    tipViewPlaceholder.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    tipViewPlaceholder.text = NSLocalizedString(@"How was your meal/drink?\nWhat do you prefer it with? Different sauce, etc...", nil);
    
    UILabel *cuisineDescriptionLabel = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(200, 223, 100, 20)] : [[UILabel alloc] initWithFrame:CGRectMake(25, 223, 100, 20)];
    cuisineDescriptionLabel.backgroundColor = [UIColor clearColor];
    cuisineDescriptionLabel.textColor = [UIColor blackColor];
    cuisineDescriptionLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    cuisineDescriptionLabel.text = NSLocalizedString(@"Cuisine", nil);
    cuisineDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
    cuisineDescriptionLabel.opaque = YES;
    
    cuisineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 130, 17)];
    cuisineLabel.backgroundColor = [UIColor clearColor];
    cuisineLabel.shadowOffset = CGSizeMake(0, 1);
    cuisineLabel.shadowColor = [UIColor whiteColor];
    cuisineLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    cuisineLabel.textAlignment = NSTextAlignmentCenter;
    cuisineLabel.text = NSLocalizedString(@"Tap Here", nil);
    cuisineLabel.numberOfLines = 1;
    cuisineLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cuisineLabel.minimumScaleFactor = 8.0/MIN_MAIN_FONT_SIZE;
    cuisineLabel.adjustsFontSizeToFitWidth = YES;
    cuisineLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
    cuisineLabel.opaque = YES;
    
    UIImageView *cuisinePickerBox_from = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cuisine_picker_box"]];
    cuisinePickerBox_from.frame = CGRectMake(0, 0, 143, 51);
    cuisinePickerBox_from.opaque = YES;
    
    UIImageView *cuisinePickerCover_from = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cuisine_picker_cover"]];
    cuisinePickerCover_from.frame = CGRectMake(0, 0, 143, 51);
    cuisinePickerCover_from.opaque = YES;
    
    UIView *cuisinePickerFrame_from = [[UIView alloc] initWithFrame:CGRectMake(7, 5, 128, 36)];
    cuisinePickerFrame_from.backgroundColor = [UIColor clearColor];
    cuisinePickerFrame_from.userInteractionEnabled = NO;
    cuisinePickerFrame_from.clipsToBounds = YES;
    
    UIButton *cuisinePickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cuisinePickerButton.backgroundColor = [UIColor clearColor];
    [cuisinePickerButton addTarget:self action:@selector(presentCuisinePicker) forControlEvents:UIControlEventTouchUpInside];
    cuisinePickerButton.opaque = YES;
    cuisinePickerButton.frame = appDelegate.isArabic ? CGRectMake(17, 210, 141, 51) : CGRectMake(160, 210, 141, 51);
    cuisinePickerButton.tag = 0;
    
    cuisinePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
    cuisinePicker.delegate = self;
    cuisinePicker.dataSource = self;
    cuisinePicker.showsSelectionIndicator = YES;
    [cuisinePicker selectRow:0 inComponent:0 animated:YES];
    
    selectedCuisine = 0;
    
    CALayer *dotted_line_grey = [CALayer layer];
    dotted_line_grey.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_grey"]].CGColor;
    dotted_line_grey.frame = CGRectMake(9, 260, 296, 3);
    dotted_line_grey.opaque = YES;
    [dotted_line_grey setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    CALayer *dotted_line_red = [CALayer layer];
    dotted_line_red.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red.frame = CGRectMake(9, 320, 296, 3);
    dotted_line_red.opaque = YES;
    [dotted_line_red setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    priceButtonCheckbox_fair = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_empty"]];
    priceButtonCheckbox_fair.frame = appDelegate.isArabic ? CGRectMake(80, 0, 52, 52) : CGRectMake(0, 0, 52, 52);
    priceButtonCheckbox_fair.opaque = YES;
    
    priceButtonCheckbox_over = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_empty"]];
    priceButtonCheckbox_over.frame = appDelegate.isArabic ? CGRectMake(80, 0, 52, 52) : CGRectMake(0, 0, 52, 52);
    priceButtonCheckbox_over.opaque = YES;
    
    priceButtonLabel_fair = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 52)] : [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 85, 52)];
    priceButtonLabel_fair.backgroundColor = [UIColor clearColor];
    priceButtonLabel_fair.textColor = [UIColor blackColor];
    priceButtonLabel_fair.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    priceButtonLabel_fair.text = NSLocalizedString(@"Fair price", nil);
    priceButtonLabel_fair.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    priceButtonLabel_fair.opaque = YES;
    
    priceButtonLabel_over = appDelegate.isArabic ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 52)] : [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 85, 52)];
    priceButtonLabel_over.backgroundColor = [UIColor clearColor];
    priceButtonLabel_over.textColor = [UIColor blackColor];
    priceButtonLabel_over.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    priceButtonLabel_over.text = NSLocalizedString(@"Expensive", nil);
    priceButtonLabel_over.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    priceButtonLabel_over.opaque = YES;
    
    UIButton *priceButton_fair = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton_fair.backgroundColor = [UIColor clearColor];
    [priceButton_fair addTarget:self action:@selector(togglePriceValue:) forControlEvents:UIControlEventTouchUpInside];
    priceButton_fair.opaque = YES;
    priceButton_fair.frame = appDelegate.isArabic ? CGRectMake(183, 270, 120, 52) : CGRectMake(10, 270, 120, 52);
    priceButton_fair.showsTouchWhenHighlighted = YES;
    priceButton_fair.tag = 0;
    
    UIButton *priceButton_over = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton_over.backgroundColor = [UIColor clearColor];
    [priceButton_over addTarget:self action:@selector(togglePriceValue:) forControlEvents:UIControlEventTouchUpInside];
    priceButton_over.opaque = YES;
    priceButton_over.frame = appDelegate.isArabic ? CGRectMake(38, 270, 120, 52) : CGRectMake(163, 270, 120, 52);
    priceButton_over.showsTouchWhenHighlighted = YES;
    priceButton_over.tag = 1;
    
    price_fair = NO;
    price_over = NO;
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.backgroundColor = [UIColor clearColor];
    [locationButton addTarget:self action:@selector(editLocation) forControlEvents:UIControlEventTouchUpInside];
    locationButton.opaque = YES;
    locationButton.frame = CGRectMake(20, paper_BG.frame.size.height - 32, 275, 21);
    locationButton.showsTouchWhenHighlighted = YES;
    
    UIImageView *locationMarker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_marker_grey_small"]];
    locationMarker.frame = CGRectMake(265, 0, 15, 21);
    locationMarker.opaque = YES;
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 260, 19)];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.numberOfLines = 1;
    locationLabel.textAlignment = NSTextAlignmentRight;
    locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:MIN_MAIN_FONT_SIZE];
    
    [paper_BG.layer addSublayer:dotted_line_grey];
    [paper_BG.layer addSublayer:dotted_line_red];
    [tipView addSubview:tipViewPlaceholder];
    [cuisinePickerFrame_from addSubview:cuisineLabel];
    [cuisinePickerButton addSubview:cuisinePickerBox_from];
    [cuisinePickerButton addSubview:cuisinePickerFrame_from];
    [cuisinePickerButton addSubview:cuisinePickerCover_from];
    [priceButton_fair addSubview:priceButtonCheckbox_fair];
    [priceButton_fair addSubview:priceButtonLabel_fair];
    [priceButton_over addSubview:priceButtonCheckbox_over];
    [priceButton_over addSubview:priceButtonLabel_over];
    [locationButton addSubview:locationLabel];
    [locationButton addSubview:locationMarker];
    
    [self.view addSubview:backgroundTouchDetector];
    [self.view addSubview:dishNameFieldBG];
    [self.view addSubview:dishNameField];
    [self.view addSubview:tipViewBG];
    [self.view addSubview:tipView];
    [self.view addSubview:priceButton_fair];
    [self.view addSubview:priceButton_over];
    [self.view addSubview:locationButton];
    [self.view addSubview:cuisineDescriptionLabel];
    [self.view addSubview:cuisinePickerButton];
    [self.view addSubview:cuisinePicker];
    [super viewDidLoad];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 35)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
}

- (void)viewWillAppear:(BOOL)animated
{
    locationLabel.text = [self.postChunk objectForKey:@"fsq_venue_name"];
    
    [super viewWillAppear:animated];
}

- (void)didTapBackButton:(id)sender
{
    if ( self.navigationController.viewControllers.count > 1 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backgroundTouched
{
    [self dismissCuisinePicker];
    [dishNameField resignFirstResponder];
    [tipView resignFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag == 0 )
    {
        [tipView becomeFirstResponder];
    }
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self dismissCuisinePicker];
    
    return YES;
}

- (void)respondToTextInDishNameField
{
    if ( dishNameField.text.length > 0 )
    {
        doneButton.enabled = YES;
    }
    else
    {
        doneButton.enabled = NO;
    }
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self dismissCuisinePicker];
    
    if ( tipView.text.length >= 1 )
    {
        tipViewPlaceholder.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ( tipView.text.length == 0 )
    {
        tipViewPlaceholder.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] )
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)respondToTextInTipView
{
    NSString *tipViewTxt = tipView.text;
    tipViewTxt = [tipViewTxt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( tipViewTxt.length > 0 )
    {
        tipViewPlaceholder.hidden = YES;
    }
    else
    {
        tipViewPlaceholder.hidden = NO;
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [((NSArray *) (appDelegate.isArabic ? appDelegate.cuisineList_ar : appDelegate.cuisineList_en)) count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [[((NSArray *) (appDelegate.isArabic ? appDelegate.cuisineList_ar : appDelegate.cuisineList_en)) objectAtIndex:row] capitalizedString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    selectedCuisine = row;
    [self animateCuisinePickerForValue:[[((NSArray *) (appDelegate.isArabic ? appDelegate.cuisineList_ar : appDelegate.cuisineList_en)) objectAtIndex:row] capitalizedString]];
}

- (void)presentCuisinePicker
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    [dishNameField resignFirstResponder];
    [tipView resignFirstResponder];
    
    int slideupDistance_view = 0;
    int slideupDistance_picker = 250;
    
    if ( !IS_IPHONE_5 ) // No need to move the view up if it's an iPhone 5.
    {
        slideupDistance_view = 65;
        slideupDistance_picker = 215;
    }
    
    [Flurry logEvent:@"Cuisine button tapped"];
    
    cuisineLabel.textColor = [UIColor colorWithRed:47.0/255.0 green:171.0/255.0 blue:164.0/255.0 alpha:1.0];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //self.view.frame = CGRectMake(0, self.view.frame.origin.y - slideupDistance_view, screenWidth, self.view.frame.size.height + 100); // Slide the view up.
        cuisinePicker.frame = CGRectMake(0, screenHeight - slideupDistance_picker, screenWidth, 160);
    } completion:^(BOOL finished){
        
    }];
}

- (void)dismissCuisinePicker
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    cuisineLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
   
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
       // self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight - 44); // Slide the view back down.
        cuisinePicker.frame = CGRectMake(0, screenHeight, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)animateCuisinePickerForValue:(NSString *)value
{
    CGRect tempFrame;
    
    if ( ![value isEqualToString:cuisineLabel.text] )
    {
        tempFrame = cuisineLabel.frame;
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cuisineLabel.frame = CGRectMake(0, -15, 130, 17);
            cuisineLabel.alpha = 0.5;
        } completion:^(BOOL finished){
            cuisineLabel.text = value;
            
            [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
                cuisineLabel.frame = tempFrame;
                cuisineLabel.alpha = 1.0;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    cuisineLabel.frame = CGRectMake(0, 8, 130, 17);
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        cuisineLabel.frame = tempFrame;
                    } completion:^(BOOL finished){
                        
                    }];
                }];
            }];
        }];
    }
}

#pragma mark -
#pragma mark Pricing

- (void)togglePriceValue:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if ( button.tag == 0 )
    {
        if ( price_fair )
        {
            priceButtonCheckbox_fair.image = [UIImage imageNamed:@"checkbox_empty"];
            priceButtonLabel_fair.layer.shadowRadius = 0.0f;
            priceButtonLabel_fair.layer.shadowOpacity = 0.0;
            priceButtonLabel_fair.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
            price_fair = NO;
        }
        else
        {
            priceButtonCheckbox_fair.image = [UIImage imageNamed:@"checkbox_checked"];
            priceButtonLabel_fair.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
            
            // Reset the other checkbox.
            priceButtonCheckbox_over.image = [UIImage imageNamed:@"checkbox_empty"];
            priceButtonLabel_over.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
            
            price_over = NO;
            price_fair = YES;
        }
    }
    else if ( button.tag == 1 )
    {
        if ( price_over )
        {
            priceButtonCheckbox_over.image = [UIImage imageNamed:@"checkbox_empty"];
            priceButtonLabel_over.layer.shadowRadius = 0.0;
            priceButtonLabel_over.layer.shadowOpacity = 0.0;
            priceButtonLabel_over.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
            price_over = NO;
        }
        else
        {
            priceButtonCheckbox_over.image = [UIImage imageNamed:@"checkbox_checked"];
            priceButtonLabel_over.textColor = [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1.0];
            
            // Reset the other checkbox.
            priceButtonCheckbox_fair.image = [UIImage imageNamed:@"checkbox_empty"];
            priceButtonLabel_fair.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
            
            price_fair = NO;
            price_over = YES;
        }
    }
}

#pragma mark -
#pragma mark Go back & edit location

- (void)editLocation
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Post

- (void)submitPost
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [Flurry logEvent:@"Post a section Done button tapped"];
    
    [dishNameField resignFirstResponder];
    [tipView resignFirstResponder];
    
    [HUD hide:YES];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/create-post", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    NSString *dishName = dishNameField.text;
    NSString *tipText = tipView.text;
    NSString *price = @"fair";
    
    tipText = [tipText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( tipText.length > 200 )
    {
        tipText = [tipText substringToIndex:200];
    }
    
    if ( !price_fair && !price_over )
    {
        price = @"";
    }
    
    if ( price_over )
    {
        price = @"over";
    }
    
    [wrequest setPostFormat:ASIMultipartFormDataPostFormat]; 
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"type"] forKey:@"type"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"period"] forKey:@"period"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"fsq_venue_name"] forKey:@"fsq_venue_name"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"fsq_venue_id"] forKey:@"fsq_venue_id"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"current_location_lat"] forKey:@"current_location_lat"];
    [wrequest setPostValue:[self.postChunk objectForKey:@"current_location_long"] forKey:@"current_location_long"];
    [wrequest setPostValue:dishName forKey:@"dish_name"];
    [wrequest setPostValue:tipText forKey:@"tip"];
    [wrequest setPostValue:[appDelegate.cuisineList_en objectAtIndex:selectedCuisine] forKey:@"cuisine"];
    [wrequest setPostValue:[NSString stringWithFormat:@"%@", price] forKey:@"price"];
    [wrequest setData:[self.postChunk objectForKey:@"imageData"] withFileName:@"image_file.jpg" andContentType:@"image/jpeg" forKey:@"image_file"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        NSLog(@"%@", wrequest.responseString);
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            [HUD hide:YES];
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            UINavigationController *profileNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:2];
            ProfileViewController *profileView = (ProfileViewController *)[profileNavController.viewControllers objectAtIndex:0];
            profileView.hasNewPost = YES;
            [profileView getUserInfoForID:[[appDelegate.global readProperty:@"userid"] intValue]];
            
            appDelegate.tabBarController.selectedViewController = [appDelegate.tabBarController.viewControllers objectAtIndex:2]; // Go to the profile feed.
        }
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        
        // Set custom view mode.
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"Communication Error", nil);
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
