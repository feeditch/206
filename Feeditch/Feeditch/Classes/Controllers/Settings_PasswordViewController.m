//
//  Settings_PasswordViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/24/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "Settings_PasswordViewController.h"
#import "AppDelegate.h"

@implementation Settings_PasswordViewController

AppDelegate *appDelegate;

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    changePasswdButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Change Password", nil) style:UIBarButtonItemStyleDone target:self action:@selector(changePasswd)];
    self.navigationItem.rightBarButtonItem = changePasswdButton;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    
    oldPasswdField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 260, 25)];
    oldPasswdField.delegate = self;
    oldPasswdField.borderStyle = UITextBorderStyleRoundedRect;
    oldPasswdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    oldPasswdField.returnKeyType = UIReturnKeyNext;
    oldPasswdField.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    oldPasswdField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    oldPasswdField.placeholder = NSLocalizedString(@"Current Password", nil);
    oldPasswdField.tag = 0;
    
    newPasswdField = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 260, 25)];
    newPasswdField.delegate = self;
    newPasswdField.borderStyle = UITextBorderStyleRoundedRect;
    newPasswdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    newPasswdField.returnKeyType = UIReturnKeyNext;
    newPasswdField.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    newPasswdField.font = [UIFont fontWithName:@"HelveticaNeue" size:MIN_MAIN_FONT_SIZE];
    newPasswdField.placeholder = NSLocalizedString(@"New Password", nil);
    newPasswdField.tag = 1;
    
    [self.view addSubview:oldPasswdField];
    [self.view addSubview:newPasswdField];
    [super viewDidLoad];
}

- (void)changePasswd
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *oldPasswd = oldPasswdField.text;
    NSString *newPasswd = newPasswdField.text;
    
    if ( oldPasswd.length > 0 && newPasswd.length > 0 )
    {        
        if ( newPasswd.length < 6 )
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Error!", nil)
                                  message:NSLocalizedString(@"The password should have at least 6 characters", nil) delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/update-password", FI_DOMAIN]];
        
        dataRequest = [ASIFormDataRequest requestWithURL:url];
        __weak ASIFormDataRequest *wrequest = dataRequest;
        
        [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
        [wrequest setPostValue:oldPasswd forKey:@"old_password"];
        [wrequest setPostValue:newPasswd forKey:@"new_password"];
        [wrequest setCompletionBlock:^{
            NSError *jsonError;
            responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
            
            if ( [[responseData objectForKey:@"error"] intValue] == 0 )
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSString *errorMsg = [responseData objectForKey:@"error_msg"];
                
                if ( [errorMsg isEqualToString:@"old_password_error"] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:NSLocalizedString(@"Current password is incorrect", nil) delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Error!", nil)
                                          message:NSLocalizedString(@"Error in new password", nil) delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                }
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
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag == 0 )
    {
        [newPasswdField becomeFirstResponder];
    }
    else if ( textField.tag == 1 )
    {
        if ( oldPasswdField.text.length > 0 && newPasswdField.text.length > 0 )
        {
            [self changePasswd];
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
