//
//  SignupFormViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/25/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "SignupFormViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "NearbyViewController.h"
#import "FollowingViewController.h"
#import "UIImage+iPhone5extension.h"

@implementation SignupFormViewController
@synthesize preloaded_full_name, preloaded_email;

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    [self setTitle:NSLocalizedString(@"Sign Up", nil)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_black"]];
    self.navigationController.navigationBarHidden = NO;
    saveChangesButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(saveChanges)];
    self.navigationItem.rightBarButtonItem = saveChangesButton;
    
    genderList = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Male", nil), NSLocalizedString(@"Female", nil), nil];
    
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
    
    nameLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 100, 13)] :
                                                [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 13)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.shadowOffset = CGSizeMake(0, 1);
    nameLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    nameLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    nameLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    nameLabel.text = NSLocalizedString(@"Name", nil);
    nameLabel.opaque = YES;
    
    locationLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 55, 100, 13)]:
                                                [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 100, 13)];
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
    
    passwdLabel = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(200, 175, 100, 13)]:
                                                [[UILabel alloc] initWithFrame:CGRectMake(20, 175, 100, 13)];
    passwdLabel.backgroundColor = [UIColor clearColor];
    passwdLabel.shadowOffset = CGSizeMake(0, 1);
    passwdLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    passwdLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    passwdLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    passwdLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
    passwdLabel.text = NSLocalizedString(@"Password", nil);
    passwdLabel.opaque = YES;
    
    UILabel *emailTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 50)];
    emailTipLabel.backgroundColor = [UIColor clearColor];
    emailTipLabel.shadowOffset = CGSizeMake(0, 1);
    emailTipLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    emailTipLabel.numberOfLines = 0;
    emailTipLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    emailTipLabel.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    emailTipLabel.font = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
    emailTipLabel.text = NSLocalizedString(@"Add your personal email to receive offers and special invitations (We promise we won't bother you with spam)", nil);
    emailTipLabel.opaque = YES;
    
    self.locationField = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 25)]:
                                                    [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 25)] ;
    self.locationField.backgroundColor = [UIColor clearColor];
    self.locationField.shadowOffset = CGSizeMake(0, 1);
    self.locationField.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.locationField.textColor = [UIColor blackColor];
    self.locationField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.locationField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    self.locationField.tag = 0;
    self.locationField.text = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:0];
    
    self.genderField = [appDelegate isArabic] ? [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 25)]:
                                                [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 25)] ;
    self.genderField.backgroundColor = [UIColor clearColor];
    self.genderField.shadowOffset = CGSizeMake(0, 1);
    self.genderField.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.genderField.textColor = [UIColor blackColor];
    self.genderField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    self.genderField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.genderField.tag = 1;
    self.genderField.text = NSLocalizedString(@"Male", nil);
    
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
    
    self.nameField = [appDelegate isArabic] ? [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 180, 25)]:
                                                [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 180, 25)];
    self.nameField.delegate = self;
    self.nameField.borderStyle = UITextBorderStyleNone;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.nameField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    self.nameField.tag = 2;
    self.nameField.text = preloaded_full_name != nil ? preloaded_full_name : @"";
    
    self.emailField = [appDelegate isArabic] ? [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 180, 25)]:
                                                [[UITextField alloc] initWithFrame:CGRectMake(120, 130, 180, 25)];
    self.emailField.delegate = self;
    self.emailField.borderStyle = UITextBorderStyleNone;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.emailField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.emailField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    self.emailField.tag = 3;
    self.emailField.text = preloaded_email != nil ? preloaded_email : @"";
    
    self.passwdField= [appDelegate isArabic] ? [[UITextField alloc] initWithFrame:CGRectMake(20, 170, 180, 25)]:
                                                [[UITextField alloc] initWithFrame:CGRectMake(120, 170, 180, 25)];;
    self.passwdField.delegate = self;
    self.passwdField.borderStyle = UITextBorderStyleNone;
    self.passwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwdField.returnKeyType = UIReturnKeyDone;
    self.passwdField.textAlignment = [appDelegate isArabic] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.passwdField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    self.passwdField.tag = 4;
    
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
    
    CALayer *dotted_line_red_5 = [CALayer layer];
    dotted_line_red_5.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted_separator_line_black"]].CGColor;
    dotted_line_red_5.frame = CGRectMake(11, 202, 297, 3);
    dotted_line_red_5.opaque = YES;
    [dotted_line_red_5 setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    
    locationPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
    locationPicker.delegate = self;
    locationPicker.dataSource = self;
    locationPicker.showsSelectionIndicator = YES;
    locationPicker.tag = 0;
    [locationPicker selectRow:0 inComponent:0 animated:YES];
    
    genderPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    genderPicker.showsSelectionIndicator = YES;
    genderPicker.tag = 1;
    [genderPicker selectRow:0 inComponent:0 animated:YES];
    
    [locationFieldButton addSubview:self.locationField];
    [genderFieldButton addSubview:self.genderField];
    [self.view addSubview:paper_BG];
    [self.view.layer addSublayer:dotted_line_red_1];
    [self.view.layer addSublayer:dotted_line_red_2];
    [self.view.layer addSublayer:dotted_line_red_3];
    [self.view.layer addSublayer:dotted_line_red_4];
    [self.view.layer addSublayer:dotted_line_red_5];
    [self.view addSubview:nameLabel];
    [self.view addSubview:locationLabel];
    [self.view addSubview:genderLabel];
    [self.view addSubview:emailLabel];
    [self.view addSubview:passwdLabel];
    [self.view addSubview:locationFieldButton];
    [self.view addSubview:genderFieldButton];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwdField];
    [self.view addSubview:emailTipLabel];
    [self.view addSubview:locationPicker];
    [self.view addSubview:genderPicker];
    
    [self.nameField becomeFirstResponder];
    
    [super viewDidLoad];
}

- (void)showLocationOptions
{
    [self.nameField resignFirstResponder];
    [self.genderField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwdField resignFirstResponder];
    [self dismissGenderOptions];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    self.locationField.textColor = [UIColor colorWithRed:47.0/255.0 green:171.0/255.0 blue:164.0/255.0 alpha:1.0];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        locationPicker.frame = CGRectMake(0, screenHeight - 280, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)dismissLocationOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    self.locationField.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        locationPicker.frame = CGRectMake(0, screenHeight, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)showGenderOptions
{
    [self.nameField resignFirstResponder];
    [self.genderField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwdField resignFirstResponder];
    [self dismissLocationOptions];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    self.genderField.textColor = [UIColor colorWithRed:47.0/255.0 green:171.0/255.0 blue:164.0/255.0 alpha:1.0];
    
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
    
    self.genderField.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        genderPicker.frame = CGRectMake(0, screenHeight, screenWidth, 216);
    } completion:^(BOOL finished){
        
    }];
}

- (void)saveChanges
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.nameField resignFirstResponder];
    [self.genderField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self dismissLocationOptions];
    [self dismissGenderOptions];
    
    NSString *name = self.nameField.text;
    NSString *location = self.locationField.text;
    NSString *gender = self.genderField.text;
    NSString *email = self.emailField.text;
    NSString *passwd = self.passwdField.text;
    
    if ( name.length == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error!", nil)
                              message:NSLocalizedString(@"The name field can't be left empty", nil) delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Close", nil)
                              otherButtonTitles:nil];
        [alert show];
        [self.nameField becomeFirstResponder];
        
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
        [self.emailField becomeFirstResponder];
        
        return;
    }
    
    if ( passwd.length == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error!", nil)
                              message:NSLocalizedString(@"The email field can't be left empty", nil) delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Close", nil)
                              otherButtonTitles:nil];
        [alert show];
        [self.passwdField becomeFirstResponder];
        
        return;
    }
    
    if ( passwd.length < 6 )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error!", nil)
                              message:NSLocalizedString(@"The password should have at least 6 characters", nil) delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Close", nil)
                              otherButtonTitles:nil];
        [alert show];
        [self.passwdField becomeFirstResponder];
        
        return;
    }
    
    if ( email.length > 0 && email.length > 0 && passwd.length > 0 )
    {
        // Disable the fields to prevent editing.
        self.nameField.enabled = NO;
        locationFieldButton.enabled = NO;
        genderFieldButton.enabled = NO;
        self.emailField.enabled = NO;
        self.passwdField.enabled = NO;
        
        if ( [gender isEqualToString:NSLocalizedString(@"Male", nil)] )
        {
            gender = @"male";
        }
        else
        {
            gender = @"female";
        }
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/signup", FI_DOMAIN]];
        
        dataRequest = [ASIFormDataRequest requestWithURL:url];
        __weak ASIFormDataRequest *wrequest = dataRequest;
        
        [wrequest setPostValue:_FBID forKey:@"fb_id"];
        [wrequest setPostValue:name forKey:@"full_name"];
        NSLog(@")))))))))) %d", [appDelegate.countryList indexOfObject:location]);
        
        int countryIndex = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) indexOfObject:location];
        [wrequest setPostValue:[appDelegate.countryList objectAtIndex:countryIndex] forKey:@"country"];
        
        [wrequest setPostValue:gender forKey:@"sex"];
        [wrequest setPostValue:email forKey:@"email"];
        [wrequest setPostValue:passwd forKey:@"password"];
        [wrequest setPostValue:appDelegate.device_token forKey:@"device_token"];
        [wrequest setCompletionBlock:^{
            NSError *jsonError;
            responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
            NSLog(@"%@", responseData);
            if ( [[responseData objectForKey:@"error"] intValue] == 0 )
            {
                NSDictionary *response = [responseData objectForKey:@"response"];
                NSDictionary *userData = [response objectForKey:@"user_data"];
                
                int currentUserid = [[userData objectForKey:@"id"] intValue];
                NSString *currentName = [userData objectForKey:@"full_name"];
                NSString *currentGender = [userData objectForKey:@"sex"];
                NSString *currentEmail = [userData objectForKey:@"email"];
                NSString *currentHash = [userData objectForKey:@"user_pic_hash"];
                NSString *currentBio = [userData objectForKey:@"bio"];
                NSString *currentCountry = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:[appDelegate.countryList indexOfObject:[NSString stringWithFormat:@"%@", [userData objectForKey:@"country"]]]];
                
                // Store the generated token and user data.
                [appDelegate.global writeValue:[response objectForKey:@"token"] forProperty:@"token"];
                [appDelegate.global writeValue:[NSString stringWithFormat:@"%d", currentUserid] forProperty:@"userid"];
                [appDelegate.global writeValue:currentName forProperty:@"name"];
                [appDelegate.global writeValue:currentGender forProperty:@"gender"];
                [appDelegate.global writeValue:currentEmail forProperty:@"email"];
                [appDelegate.global writeValue:currentHash forProperty:@"userPicHash"];
                [appDelegate.global writeValue:currentBio forProperty:@"bio"];
                [appDelegate.global writeValue:currentCountry forProperty:@"country"];
                
                // Refresh the variables.
                appDelegate.FIToken = [appDelegate.global readProperty:@"token"];
                
                [HUD hide:YES];
                [self dismissViewControllerAnimated:YES completion:NULL];
                
                // Flurry.
                [Flurry setUserID:[appDelegate.global readProperty:@"userid"]];
                
                if ( [currentGender isEqualToString:@"male"] )
                {
                    [Flurry setGender:@"m"];
                }
                else
                {
                    [Flurry setGender:@"f"];
                }
                
                if ( [self.signupType isEqualToString:@"email"] )
                {
                    [Flurry logEvent:@"Signed up using email"];
                }
                else
                {
                    [Flurry logEvent:@"Signed up using Facebook"];
                }
                
                // Reload profile.
                UINavigationController *profileNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:2];
                ProfileViewController *profileView = (ProfileViewController *)[profileNavController.viewControllers objectAtIndex:0];
                [profileView getUserInfoForID:currentUserid];
                
                UINavigationController *nearbyFeedNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:1];
                NearbyViewController *nearbyFeed = (NearbyViewController *)[nearbyFeedNavController.viewControllers objectAtIndex:0];
                [nearbyFeed downloadFeedForBatch:0];
                
                UINavigationController *followingNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:0];
                FollowingViewController *followingView = (FollowingViewController *)[followingNavController.viewControllers objectAtIndex:0];
                [followingView downloadFeedForBatch:0];
                
                appDelegate.tabBarController.selectedViewController = [appDelegate.tabBarController.viewControllers objectAtIndex:0]; // Go to Nearby feed.
            }
            else
            {
                // Enable these back.
                self.nameField.enabled = YES;
                locationFieldButton.enabled = YES;
                genderFieldButton.enabled = YES;
                self.emailField.enabled = YES;
                self.passwdField.enabled = YES;
                [HUD hide:YES];
                
                NSString *errorMsg = [responseData objectForKey:@"error_msg"];
                
                if ( [errorMsg isEqualToString:@"invalid_full_name_error"] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:NSLocalizedString(@"signup_name_error", nil) delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                    [self.nameField becomeFirstResponder];
                }
                else if ( [errorMsg isEqualToString:@"invalid_email_error"] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:NSLocalizedString(@"Incorrect Email", nil) delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                    [self.emailField becomeFirstResponder];
                }
                else if ( [errorMsg isEqualToString:@"user_exists_error"] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:NSLocalizedString(@"signup_email_taken", nil) delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                    [self.emailField becomeFirstResponder];
                }
                else if ( [errorMsg isEqualToString:@"password_length_error"] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:@"كلمة السر خطأ. قم بتعديلها." delegate:self
                                          cancelButtonTitle:@"حسناً"
                                          otherButtonTitles:nil];
                    [alert show];
                    [self.passwdField becomeFirstResponder];
                }
            }
        }];
        [wrequest setFailedBlock:^{
            // Enable these back.
            self.nameField.enabled = YES;
            locationFieldButton.enabled = YES;
            genderFieldButton.enabled = YES;
            self.emailField.enabled = YES;
            self.passwdField.enabled = YES;
            
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
        self.locationField.text = [((NSArray *) (appDelegate.isArabic ? appDelegate.countryList_ar : appDelegate.countryList_en)) objectAtIndex:row];
    }
    else
    {
        self.genderField.text = [genderList objectAtIndex:row];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self dismissGenderOptions];
    [self dismissLocationOptions];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag == 2 )
    {
        [self.emailField becomeFirstResponder];
    }
    else if ( textField.tag == 3 )
    {
        [self.passwdField becomeFirstResponder];
    }
    else
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
