//
//  Settings_ProfileEditorViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/24/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "Settings_ProfileEditorViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "UIImage+iPhone5extension.h"

@implementation Settings_ProfileEditorViewController

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    genderList = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Male", nil), NSLocalizedString(@"Female", nil), nil];
    
    saveChangesButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit Profile", nil) style:UIBarButtonItemStyleDone target:self action:@selector(saveChanges)];
    self.navigationItem.rightBarButtonItem = saveChangesButton;
    
    mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 60)];
    mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_black"]];
    mainView.contentSize = CGSizeMake(320, screenHeight - 60);
    mainView.scrollEnabled = NO;
    
    UIImageView *paper_BG = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"tablecloth_paper"]];
    paper_BG.opaque = YES;
    paper_BG.userInteractionEnabled = YES;
    
    if ( IS_IPHONE_5 )
    {
        paper_BG.frame = CGRectMake(3, -10, 314, 494);
    }
    else
    {
        paper_BG.frame = CGRectMake(3, -10, 314, 401);
    }
    
    nameLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 100, 15)] :
                                            [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 15)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.shadowOffset = CGSizeMake(0, 1);
    nameLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    nameLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    nameLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    nameLabel.text = NSLocalizedString(@"Name", nil);
    nameLabel.opaque = YES;
    
    locationLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 55, 100, 15)]:
                                                [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 100, 15)];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.shadowOffset = CGSizeMake(0, 1);
    locationLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    locationLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    locationLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    locationLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    locationLabel.text = NSLocalizedString(@"Country", nil);
    locationLabel.opaque = YES;
    
    genderLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 95, 100, 13)]:
                                            [[UILabel alloc] initWithFrame:CGRectMake(20, 95, 100, 13)];
    genderLabel.backgroundColor = [UIColor clearColor];
    genderLabel.shadowOffset = CGSizeMake(0, 1);
    genderLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    genderLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    genderLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    genderLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    genderLabel.text = NSLocalizedString(@"Sex", nil);
    genderLabel.opaque = YES;
    
    emailLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 135, 100, 13)]:
                                            [[UILabel alloc] initWithFrame:CGRectMake(20, 135, 100, 13)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.shadowOffset = CGSizeMake(0, 1);
    emailLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    emailLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    emailLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    emailLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    emailLabel.text = NSLocalizedString(@"Email", nil);
    emailLabel.opaque = YES;
    
    bioLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 175, 100, 15)]:
                                            [[UILabel alloc] initWithFrame:CGRectMake(20, 175, 100, 15)];
    bioLabel.backgroundColor = [UIColor clearColor];
    bioLabel.shadowOffset = CGSizeMake(0, 1);
    bioLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    bioLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    bioLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    bioLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    bioLabel.text = NSLocalizedString(@"Biography", nil);
    bioLabel.opaque = YES;
    
    locationField = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 25)]:
                                                [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 25)] ;
    locationField.backgroundColor = [UIColor clearColor];
    locationField.shadowOffset = CGSizeMake(0, 1);
    locationField.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    locationField.textColor = [UIColor blackColor];
    locationField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    locationField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    locationField.tag = 0;
    
    genderField = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 25)]:
                                            [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 25)] ;
    genderField.backgroundColor = [UIColor clearColor];
    genderField.shadowOffset = CGSizeMake(0, 1);
    genderField.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    genderField.textColor = [UIColor blackColor];
    genderField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    genderField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    genderField.tag = 1;
    
    locationFieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationFieldButton.backgroundColor = [UIColor clearColor];
    [locationFieldButton addTarget:self action:@selector(showLocationOptions) forControlEvents:UIControlEventTouchUpInside];
    locationFieldButton.opaque = YES;
    locationFieldButton.frame = CGRectMake(20, 49, 180, 25);
    
    genderFieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    genderFieldButton.backgroundColor = [UIColor clearColor];
    [genderFieldButton addTarget:self action:@selector(showGenderOptions) forControlEvents:UIControlEventTouchUpInside];
    genderFieldButton.opaque = YES;
    genderFieldButton.frame = CGRectMake(20, 90, 180, 25);
    
    nameField = [appDelegate isArabic] ? [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 180, 25)]:
                                            [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 180, 25)];
    nameField.delegate = self;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.returnKeyType = UIReturnKeyNext;
    nameField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    nameField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    nameField.tag = 2;
    
    emailField = [appDelegate isArabic] ? [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 180, 25)]:
                                                [[UITextField alloc] initWithFrame:CGRectMake(120, 130, 180, 25)];
    emailField.delegate = self;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.returnKeyType = UIReturnKeyNext;
    emailField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    emailField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    emailField.tag = 3;
    
    bioField = [appDelegate isArabic] ? [[UITextField alloc] initWithFrame:CGRectMake(20, 170, 180, 25)]:
                                         [[UITextField alloc] initWithFrame:CGRectMake(120, 170, 180, 25)] ;
    bioField.delegate = self;
    bioField.borderStyle = UITextBorderStyleNone;
    bioField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    bioField.returnKeyType = UIReturnKeyNext;
    bioField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    bioField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    bioField.tag = 4;
    
    CALayer *dotted_line_red_1 = [CALayer layer];
    dotted_line_red_1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red_1.frame = CGRectMake(11, 42, 297, 3);
    dotted_line_red_1.opaque = YES;
    [dotted_line_red_1 setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    CALayer *dotted_line_red_2 = [CALayer layer];
    dotted_line_red_2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red_2.frame = CGRectMake(11, 80, 297, 3);
    dotted_line_red_2.opaque = YES;
    [dotted_line_red_2 setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    CALayer *dotted_line_red_3 = [CALayer layer];
    dotted_line_red_3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red_3.frame = CGRectMake(11, 118, 297, 3);
    dotted_line_red_3.opaque = YES;
    [dotted_line_red_3 setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    CALayer *dotted_line_red_4 = [CALayer layer];
    dotted_line_red_4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red_4.frame = CGRectMake(11, 162, 297, 3);
    dotted_line_red_4.opaque = YES;
    [dotted_line_red_4 setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    locationPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
    locationPicker.delegate = self;
    locationPicker.dataSource = self;
    locationPicker.showsSelectionIndicator = YES;
    locationPicker.tag = 0;
    
    genderPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    genderPicker.showsSelectionIndicator = YES;
    genderPicker.tag = 1;
    
    NSString *gender;
    
    if ( [[appDelegate.global readProperty:@"gender"] isEqualToString:@"male"] )
    {
        gender = NSLocalizedString(@"Male", nil);
        [genderPicker selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        gender = NSLocalizedString(@"Female", nil);
        [genderPicker selectRow:1 inComponent:0 animated:YES];
    }
    
    nameField.text = [appDelegate.global readProperty:@"name"];
    locationField.text = [appDelegate.global readProperty:@"country"];
    genderField.text = gender;
    emailField.text = [appDelegate.global readProperty:@"email"];
    bioField.text = [appDelegate.global readProperty:@"bio"];
    
    //[locationPicker selectRow:[appDelegate.countryList indexOfObject:locationField.text] inComponent:0 animated:YES];
    [nameField becomeFirstResponder];
    
    [locationFieldButton addSubview:locationField];
    [genderFieldButton addSubview:genderField];
    [mainView addSubview:paper_BG];
    [mainView.layer addSublayer:dotted_line_red_1];
    [mainView.layer addSublayer:dotted_line_red_2];
    [mainView.layer addSublayer:dotted_line_red_3];
    [mainView.layer addSublayer:dotted_line_red_4];
    [mainView addSubview:locationPicker];
    [mainView addSubview:genderPicker];
    [mainView addSubview:nameLabel];
    [mainView addSubview:locationLabel];
    [mainView addSubview:genderLabel];
    [mainView addSubview:emailLabel];
    [mainView addSubview:bioLabel];
    [mainView addSubview:locationFieldButton];
    [mainView addSubview:genderFieldButton];
    [mainView addSubview:nameField];
    [mainView addSubview:emailField];
    [mainView addSubview:bioField];
    [self.view addSubview:mainView];
    [super viewDidLoad];
}

- (void)showLocationOptions
{
    [nameField resignFirstResponder];
    [genderField resignFirstResponder];
    [emailField resignFirstResponder];
    [bioField resignFirstResponder];
    [self dismissGenderOptions];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    locationField.textColor = [UIColor colorWithRed:47.0/255.0 green:171.0/255.0 blue:164.0/255.0 alpha:1.0];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        locationPicker.frame = CGRectMake(0, screenHeight - 330, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)dismissLocationOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    locationField.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        locationPicker.frame = CGRectMake(0, screenHeight, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)showGenderOptions
{
    [nameField resignFirstResponder];
    [genderField resignFirstResponder];
    [emailField resignFirstResponder];
    [bioField resignFirstResponder];
    [self dismissLocationOptions];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    genderField.textColor = [UIColor colorWithRed:47.0/255.0 green:171.0/255.0 blue:164.0/255.0 alpha:1.0];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        genderPicker.frame = CGRectMake(0, screenHeight - 280, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)dismissGenderOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    genderField.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        genderPicker.frame = CGRectMake(0, screenHeight, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)saveChanges
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [nameField resignFirstResponder];
    [genderField resignFirstResponder];
    [emailField resignFirstResponder];
    [bioField resignFirstResponder];
    [self dismissLocationOptions];
    [self dismissGenderOptions];
    
    NSString *name = nameField.text;
    NSString *location = locationField.text;
    NSString *gender = genderField.text;
    NSString *email = emailField.text;
    NSString *bio = bioField.text;
    
    if ( name.length == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error!", nil)
                              message:NSLocalizedString(@"The name field can't be left empty", nil) delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Close", nil)
                              otherButtonTitles:nil];
        [alert show];
        [nameField becomeFirstResponder];
        return;
    }
    
    if ( email.length == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error!", nil)
                              message:NSLocalizedString(@"The email field can't be left empty", nil) delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Close", nil)
                              otherButtonTitles:nil];
        [alert show];
        [emailField becomeFirstResponder];
        return;
    }
    
    if ( email.length > 0 && email.length > 0 )
    {
        // Disable the fields to prevent editing.
        nameField.enabled = NO;
        locationFieldButton.enabled = NO;
        genderFieldButton.enabled = NO;
        emailField.enabled = NO;
        bioField.enabled = NO;
        
        if ( [gender isEqualToString:NSLocalizedString(@"Male", nil)] )
        {
            gender = @"male";
        }
        else
        {
            gender = @"female";
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/update-profile", FI_DOMAIN]];
        
        dataRequest = [ASIFormDataRequest requestWithURL:url];
        __weak ASIFormDataRequest *wrequest = dataRequest;
        
        [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
        [wrequest setPostValue:name forKey:@"full_name"];
        int countryIndex = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) indexOfObject:location];
        
        [wrequest setPostValue:[appDelegate.countryList objectAtIndex:countryIndex] forKey:@"country"];
        
        NSLog(@")))))))))) %@", [appDelegate.countryList objectAtIndex:countryIndex]);
        //    NSString *country = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:[appDelegate.countryList indexOfObject:[NSString stringWithFormat:@"%@", [data objectForKey:@"country"]]]];
        [wrequest setPostValue:gender forKey:@"sex"];
        [wrequest setPostValue:email forKey:@"email"];
        [wrequest setPostValue:bio forKey:@"bio"];
        [wrequest setCompletionBlock:^{
            NSError *jsonError;
            responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
            
            if ( [[responseData objectForKey:@"error"] intValue] == 0 )
            {
                [appDelegate.global writeValue:name forProperty:@"name"];
                [appDelegate.global writeValue:location forProperty:@"country"];
                [appDelegate.global writeValue:gender forProperty:@"gender"];
                [appDelegate.global writeValue:email forProperty:@"email"];
                [appDelegate.global writeValue:bio forProperty:@"bio"];
                
                ProfileViewController *profileView = (ProfileViewController *)[self.navigationController.viewControllers objectAtIndex:0];
                [profileView redrawContents];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                // Enable these back.
                nameField.enabled = YES;
                locationFieldButton.enabled = YES;
                genderFieldButton.enabled = YES;
                emailField.enabled = YES;
                bioField.enabled = YES;
                
                NSString *errorMsg = [responseData objectForKey:@"error_msg"];
                
                if ( [errorMsg isEqualToString:@"invalid_email_error"] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:NSLocalizedString(@"Incorrect Email", nil) delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                    [emailField becomeFirstResponder];
                }
                else if ( [errorMsg isEqualToString:@"user_exists_error"] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:NSLocalizedString(@"Email already registered.", nil) delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                    [emailField becomeFirstResponder];
                }
            }
        }];
        [wrequest setFailedBlock:^{
            // Enable these back.
            nameField.enabled = YES;
            locationFieldButton.enabled = YES;
            genderFieldButton.enabled = YES;
            emailField.enabled = YES;
            bioField.enabled = YES;
            
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
    
    if ( pickerView.tag == 0 )
    {
        return [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) count];
    }
    else
    {
        return [genderList count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( pickerView.tag == 0 )
    {
        return [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:row];
    }
    else
    {
        return [genderList objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( pickerView.tag == 0 )
    {
        locationField.text = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:row];
    }
    else
    {
        genderField.text = [genderList objectAtIndex:row];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag == 2 )
    {
        [emailField becomeFirstResponder];
    }
    else if ( textField.tag == 3 )
    {
        [bioField becomeFirstResponder];
    }
    else if ( textField.tag == 4 )
    {
        [self saveChanges];
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
