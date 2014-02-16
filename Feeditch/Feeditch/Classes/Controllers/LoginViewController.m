//
//  LoginViewController.m
//  Feeditch
//
//  Created by MachOSX on 2/7/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIImage+iPhone5extension.h"
#import "ProfileViewController.h"

@implementation LoginViewController

AppDelegate *appDelegate;
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIImageView *BG = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"login_BG"]];
    BG.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    BG.opaque = YES;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logo.frame = CGRectMake(105, 10, 103, 103);
    logo.opaque = YES;
    
    emailFieldBG = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 280, 40)];
    emailFieldBG.borderStyle = UITextBorderStyleRoundedRect;
    emailFieldBG.enabled = NO;
    
    passwdFieldBG = [[UITextField alloc] initWithFrame:CGRectMake(20, 190, 280, 40)];
    passwdFieldBG.borderStyle = UITextBorderStyleRoundedRect;
    passwdFieldBG.enabled = NO;
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(30, 140, 260, 20)];
    emailField.delegate = self;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.returnKeyType = UIReturnKeyNext;
    emailField.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    emailField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    emailField.placeholder = NSLocalizedString(@"Email ", nil);
    emailField.tag = 0;
    
    passwdField = appDelegate.isArabic ? [[UITextField alloc] initWithFrame:CGRectMake(55, 200, 235, 20)] : [[UITextField alloc] initWithFrame:CGRectMake(30, 200, 235, 20)];
    passwdField.delegate = self;
    passwdField.borderStyle = UITextBorderStyleNone;
    passwdField.secureTextEntry = YES;
    passwdField.returnKeyType = UIReturnKeyDone;
    passwdField.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    passwdField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    passwdField.placeholder = NSLocalizedString(@"Password", nil);
    passwdField.clipsToBounds = NO; // So it doesn't clip the forgotPasswdButton.
    passwdField.tag = 1;
    
    passwdResetField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 280, 25)];
    passwdResetField.delegate = self;
    passwdResetField.borderStyle = UITextBorderStyleRoundedRect;
    passwdResetField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwdResetField.keyboardType = UIKeyboardTypeEmailAddress;
    passwdResetField.returnKeyType = UIReturnKeyDone;
    passwdResetField.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    passwdResetField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    passwdResetField.placeholder = NSLocalizedString(@"Email ", nil);
    passwdResetField.tag = 2;
    passwdResetField.alpha = 0;
    passwdResetField.enabled = NO;
    
    passwdResetLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 45)];
    passwdResetLabel.backgroundColor = [UIColor clearColor];
    passwdResetLabel.shadowOffset = CGSizeMake(0, 1);
    passwdResetLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    passwdResetLabel.textColor = [UIColor grayColor];
    passwdResetLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    passwdResetLabel.numberOfLines = 0;
    passwdResetLabel.font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
    passwdResetLabel.text = NSLocalizedString(@"Forgot your password? Enter your email and we will help you reset it.", nil);
    passwdResetLabel.opaque = YES;
    passwdResetLabel.alpha = 0;
    
    forgotPasswdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPasswdButton.backgroundColor = [UIColor clearColor];
    [forgotPasswdButton setBackgroundImage:[UIImage imageNamed:@"forgot_passwd"] forState:UIControlStateNormal];
    [forgotPasswdButton addTarget:self action:@selector(showPasswordResetInterface) forControlEvents:UIControlEventTouchUpInside];
    forgotPasswdButton.opaque = YES;
    forgotPasswdButton.frame = appDelegate.isArabic ? CGRectMake(30, 200, 21, 21) : CGRectMake(265, 200, 21, 21);
    forgotPasswdButton.showsTouchWhenHighlighted = YES;
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor clearColor];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"login_button"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:24.0] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginButton.opaque = YES;
    loginButton.frame = CGRectMake(250, 35, 54, 54);
    loginButton.tag = 0;
    
    joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinButton.backgroundColor = [UIColor clearColor];
    [joinButton setBackgroundImage:[[UIImage imageNamed:@"join_button"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:24.0] forState:UIControlStateNormal];
    [joinButton addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    joinButton.opaque = YES;
    joinButton.frame = CGRectMake(20, 35, 54, 54);
    joinButton.tag = 1;
    
    loginIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_small"]];
    loginIcon.frame = CGRectMake(19, 10, 18, 14);
    loginIcon.opaque = YES;
    
    loginButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, loginButton.frame.size.width, loginButton.frame.size.height)];
    loginButtonLabel.backgroundColor = [UIColor clearColor];
    loginButtonLabel.shadowOffset = CGSizeMake(0, -1);
    loginButtonLabel.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    loginButtonLabel.textColor = [UIColor whiteColor];
    loginButtonLabel.textAlignment = NSTextAlignmentCenter;
    loginButtonLabel.font = [UIFont boldSystemFontOfSize:MIN_SECONDARY_FONT_SIZE];
    loginButtonLabel.text = NSLocalizedString(@"Login", nil);
    loginButtonLabel.opaque = YES;
    
    joinButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, joinButton.frame.size.width, joinButton.frame.size.height)];
    joinButtonLabel.backgroundColor = [UIColor clearColor];
    joinButtonLabel.shadowOffset = CGSizeMake(0, -1);
    joinButtonLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    joinButtonLabel.textColor = [UIColor whiteColor];
    joinButtonLabel.textAlignment = NSTextAlignmentCenter;
    joinButtonLabel.font = [UIFont boldSystemFontOfSize:MIN_SECONDARY_FONT_SIZE];
    joinButtonLabel.text = NSLocalizedString(@"Back", nil);
    joinButtonLabel.opaque = YES;
    
    [loginButton addSubview:loginButtonLabel];
    [loginButton addSubview:loginIcon];
    [joinButton addSubview:joinButtonLabel];
    
    [self.view addSubview:BG];
    [self.view addSubview:logo];
    [self.view addSubview:passwdResetLabel];
    [self.view addSubview:passwdResetField];
    [self.view addSubview:emailFieldBG];
    [self.view addSubview:passwdFieldBG];
    [self.view addSubview:emailField];
    [self.view addSubview:passwdField];
    [self.view addSubview:forgotPasswdButton];
    [self.view addSubview:loginButton];
    [self.view addSubview:joinButton];
    
    [emailField becomeFirstResponder];
    
    [super viewDidLoad];
}

-(void) hideNavBar {
    if (self.navigationController.navigationBarHidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    //[self performSelector:@selector(hideNavBar) withObject:nil afterDelay:0.0];
    [super viewWillAppear:animated];
}

- (void)login
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [emailField resignFirstResponder];
    [passwdField resignFirstResponder];
    emailField.enabled = NO;
    passwdField.enabled = NO;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/login", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    NSString *email = emailField.text;
    NSString *passwd = passwdField.text;
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    passwd = [passwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [wrequest setPostValue:email forKey:@"email"];
    [wrequest setPostValue:passwd forKey:@"password"];
    [wrequest setPostValue:appDelegate.device_token forKey:@"device_token"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 && ![responseData isEqual:[NSNull null]] )
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
            
            [HUD hide:YES];
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            UINavigationController *nearbyNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:0];
            ProfileViewController *nearbyView = (ProfileViewController *)[nearbyNavController.viewControllers objectAtIndex:0];
            [nearbyView downloadFeedForBatch:0];
            
            UINavigationController *followingNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:1];
            ProfileViewController *followingView = (ProfileViewController *)[followingNavController.viewControllers objectAtIndex:0];
            [followingView downloadFeedForBatch:0];
            
            UINavigationController *profileNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:2];
            ProfileViewController *profileView = (ProfileViewController *)[profileNavController.viewControllers objectAtIndex:0];
            [profileView getUserInfoForID:currentUserid];
        }
        else
        {
            NSString *errorMsg = [responseData objectForKey:@"error_msg"];
            emailField.enabled = YES;
            passwdField.enabled = YES;
            
            if ( [errorMsg isEqualToString:@"login_fail_error"] )
            {
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
                HUD.labelText = NSLocalizedString(@"Incorrect email/password", nil);
                HUD.mode = MBProgressHUDModeCustomView;
            }
            else
            {
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
                HUD.labelText = NSLocalizedString(@"An error happened :(", nil);
                HUD.mode = MBProgressHUDModeCustomView;
            }
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
        }
    }];
    [wrequest setFailedBlock:^{
        [HUD hide:YES];
        
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

- (void)join
{
    if ( !passwdResetField.alpha == 0 ) // This button also serves as a back button when the password reset UI is shown.
    {
        [self showLoginInterface];
    }
    else
    {;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)resetPasswd
{
    [passwdResetField resignFirstResponder];
    passwdResetField.enabled = NO;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    if ( passwdResetField.text.length > 0 )
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/forgot-pass-email", FI_DOMAIN]];
        
        dataRequest = [ASIFormDataRequest requestWithURL:url];
        __weak ASIFormDataRequest *wrequest = dataRequest;
        
        NSString *email = passwdResetField.text;
        
        email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [wrequest setPostValue:email forKey:@"email"];
        [wrequest setCompletionBlock:^{
            NSError *jsonError;
            responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
            
            if ( [[responseData objectForKey:@"error"] intValue] == 0 && ![responseData isEqual:[NSNull null]] )
            {
                [HUD hide:YES];
                [self showLoginInterface];
                
                UIAlertView *logoutAlert = [[UIAlertView alloc]
                                            initWithTitle:NSLocalizedString(@"Success", nil)
                                            message:NSLocalizedString(@"Check your email inbox", nil) delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Close", nil), nil];
                [logoutAlert show];
            }
            else
            {
                NSString *errorMsg = [responseData objectForKey:@"error_msg"];
                emailField.enabled = YES;
                passwdField.enabled = YES;
                
                if ( [errorMsg isEqualToString:@""] )
                {
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
                    HUD.labelText = NSLocalizedString(@"Incorrect email/password", nil);
                    HUD.mode = MBProgressHUDModeCustomView;
                    
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:3];
                }
            }
        }];
        [wrequest setFailedBlock:^{
            passwdResetField.enabled = YES;
            
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

- (void)showLoginInterface
{
    [emailField becomeFirstResponder];
    passwdResetField.enabled = NO;
    loginButton.hidden = NO;
    emailField.hidden = NO;
    passwdField.hidden = NO;
    forgotPasswdButton.hidden = NO;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        loginButton.alpha = 1;
        emailFieldBG.alpha = 1;
        passwdFieldBG.alpha = 1;
        emailField.alpha = 1;
        passwdField.alpha = 1;
        forgotPasswdButton.alpha = 1;
        passwdResetLabel.alpha = 0;
        passwdResetField.alpha = 0;
    } completion:^(BOOL finished){
        
    }];
}

- (void)showPasswordResetInterface
{
    passwdResetField.enabled = YES;
    [passwdResetField becomeFirstResponder];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        loginButton.alpha = 0;
        emailFieldBG.alpha = 0;
        passwdFieldBG.alpha = 0;
        emailField.alpha = 0;
        passwdField.alpha = 0;
        forgotPasswdButton.alpha = 0;
        passwdResetLabel.alpha = 1;
        passwdResetField.alpha = 1;
    } completion:^(BOOL finished){
        loginButton.hidden = YES;
        emailField.hidden = YES;
        passwdField.hidden = YES;
        forgotPasswdButton.hidden = YES;
    }];
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag == 0 )
    {
        [passwdField becomeFirstResponder];
    }
    else if ( textField.tag == 1 )
    {
        if ( emailField.text.length > 0 && passwdField.text.length > 0 )
        {
            [self login];
        }
    }
    else if ( textField.tag == 2 )
    {
        if ( passwdResetField.text.length > 0 )
        {
            [self resetPasswd];
        }
        else
        {
            [self showLoginInterface];
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
