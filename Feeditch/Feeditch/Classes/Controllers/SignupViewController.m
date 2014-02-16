//
//  SignupViewController.m
//  Feeditch
//
//  Created by MachOSX on 4/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <Social/Social.h>
#import "SignupViewController.h"
#import "AppDelegate.h"
#import "SignupFormViewController.h"
#import "LoginViewController.h"
#import "UIImage+iPhone5extension.h"

@implementation SignupViewController

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
   UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];    self.view.backgroundColor = [UIColor whiteColor];
    navBar.hidden = YES;
    
    tickerBG = [[UIImageView alloc] init];
    tickerBG.frame = CGRectMake(0, 0, 320, screenBounds.size.height);
    tickerBG.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    tickerBG.userInteractionEnabled = YES;
    tickerBG.opaque = YES;
    
    ticker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 00, 320, screenBounds.size.height)];
    ticker.delegate = self;
    ticker.contentSize = CGSizeMake(320 * 5, screenBounds.size.height); // +75 pixels to account for padding.
    ticker.pagingEnabled = YES;
    ticker.showsHorizontalScrollIndicator = NO;
    ticker.showsVerticalScrollIndicator = NO;

    
    ticker.bounces = NO;
    
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - 38, 320, 20)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 5;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    pageControl.hidden = YES;
    
    
    UIImageView *card_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"instructions_1"]];
    card_1.opaque = YES;
    
    UIImageView *card_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"instructions_3"]];
    card_2.opaque = YES;
    
    UIImageView *card_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"instructions_2"]];
    card_3.opaque = YES;
    
    UIImageView *card_3_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"instructions_3_3"]];
    card_3_3.opaque = YES;
    
    UIImageView *card_4 = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"instructions_4"]];
    card_4.opaque = YES;
    
    if ( IS_IPHONE_5 )
    {
        card_1.frame = CGRectMake(card_1.frame.size.width , 0, screenBounds.size.width, screenBounds.size.height);
        card_2.frame = CGRectMake(card_1.frame.size.width * 2 , 0, screenBounds.size.width, screenBounds.size.height);
        card_3.frame = CGRectMake(card_1.frame.size.width * 3 , 0, screenBounds.size.width, screenBounds.size.height);
        card_3_3.frame = CGRectMake(card_1.frame.size.width * 4 , 0, screenBounds.size.width, screenBounds.size.height);
        card_4.frame = CGRectMake(0, 0, 320, screenBounds.size.height);
    }
    else
    {
        card_1.frame = CGRectMake(card_1.frame.size.width , 0, screenBounds.size.width, screenBounds.size.height);
        card_2.frame = CGRectMake(card_1.frame.size.width * 2, 0, screenBounds.size.width, screenBounds.size.height);
        card_3.frame = CGRectMake(card_1.frame.size.width * 3 , 0, screenBounds.size.width, screenBounds.size.height);
        card_3_3.frame = CGRectMake(card_1.frame.size.width * 4, 0, screenBounds.size.width, screenBounds.size.height);
        card_4.frame = CGRectMake(0, 0, 320, 480);
    }
    
    emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailButton.backgroundColor = [UIColor clearColor];
    [emailButton setTitle:NSLocalizedString(@"Signup with your email", nil) forState:UIControlStateNormal];
    emailButton.titleLabel.font = [UIFont boldSystemFontOfSize:MIN_MAIN_FONT_SIZE];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"join_email"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
    emailButton.opaque = YES;
    emailButton.frame = CGRectMake(15, screenBounds.size.height - 185, 292, 44);
    emailButton.tag = 0;
    
    FBButton = [UIButton buttonWithType:UIButtonTypeCustom];
    FBButton.backgroundColor = [UIColor clearColor];
    [FBButton setTitle:NSLocalizedString(@"Login through Facebook", nil) forState:UIControlStateNormal];
    FBButton.titleLabel.font = [UIFont boldSystemFontOfSize:MIN_MAIN_FONT_SIZE];
    [FBButton setBackgroundImage:[UIImage imageNamed:@"join_fb"] forState:UIControlStateNormal];
    [FBButton addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
    FBButton.opaque = YES;
    FBButton.frame = CGRectMake(15, screenBounds.size.height - 245, 292, 44);
    FBButton.tag = 1;
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor clearColor];
    [loginButton setTitle:NSLocalizedString(@"Already have an account?", nil) forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:MIN_MAIN_FONT_SIZE];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginButton.opaque = YES;
    loginButton.frame = CGRectMake(15, screenBounds.size.height - 135, 292, 44);
    
    UIImageView *scrollIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward_arrow"]];
    scrollIndicator.frame = CGRectMake(200, screenBounds.size.height - 38, 27, 19);
    scrollIndicator.alpha = 0.2;
    
  //  [card_4 addSubview:scrollIndicator];
    [ticker addSubview:card_1];
    [ticker addSubview:card_2];
    [ticker addSubview:card_3];
    [ticker addSubview:card_3_3];
    [ticker addSubview:card_4];
    [ticker addSubview:emailButton];
    [ticker addSubview:FBButton];
    [ticker addSubview:loginButton];
    [tickerBG addSubview:ticker];
    [tickerBG addSubview:pageControl];
    
    [self.view addSubview:tickerBG];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Ticker

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible.
    CGFloat pageWidth = ticker.frame.size.width;
    int page = floor((ticker.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    pageControl.currentPage = page;
    pageControl.hidden = (page == 0);

}

- (void)changePage
{
    // Update the ticker to the appropriate page.
    CGRect frame;
    frame.origin.x = ticker.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = ticker.frame.size;
    
    [ticker scrollRectToVisible:frame animated:YES];
}

- (void)join:(id)sender
{
    UIButton *button = (UIButton *)sender;
    SignupFormViewController *signupForm = [[SignupFormViewController alloc] init];
    NSLog(@"AFTER ALLOC signupform.email%@ ", signupForm.emailField);
    
    
    if ( button.tag == 0 ) // Email
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:signupForm animated:YES];
        signupForm.signupType = @"email";
    }/*else{
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        emailButton.enabled = NO;
        FBButton.enabled = NO;
        
    }*/
    else // Facebook
    {
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        emailButton.enabled = NO;
        FBButton.enabled = NO;
        
        if ( !self.accountStore )
        {
            self.accountStore = [[ACAccountStore alloc] init];
        }
        
        ACAccountType *facebookTypeAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        NSDictionary *options = @{
                                  @"ACFacebookAppIdKey" : FB_APP_ID,
                                  @"ACFacebookPermissionsKey" : @[@"email", @"user_about_me", @"user_location"],
                                  @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};
        
        [self.accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                               options:options
                                            completion:^(BOOL granted, NSError *error){
                                                if ( granted )
                                                {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookTypeAccount];
                                                    self.facebookAccount = [accounts lastObject];
                                                    NSLog(@"Success");
                                                    
                                                    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me"];
                                                    
                                                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                                                              requestMethod:SLRequestMethodGET
                                                                                                        URL:url
                                                                                                 parameters:nil];
                                                    
                                                    request.account = _facebookAccount;
                                                    
                                                    [request performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error){
                                                        responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                                                        
                                                        UIApplication* app = [UIApplication sharedApplication];
                                                        app.networkActivityIndicatorVisible = NO;
                                                        
                                                        emailButton.enabled = YES;
                                                        FBButton.enabled = YES;
                                                        
                                                        // This next part must be done on the main thread, or it'll crash the app!
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
                                                            [self.navigationController pushViewController:signupForm animated:YES];
                                                            
                                                            NSLog(@"resp data=%@", [responseData objectForKey:@"email"]);
                                                            
                                                            if ( [[responseData objectForKey:@"gender"] isEqualToString:@"male"] ) {
                                                                signupForm.genderField.text = NSLocalizedString(@"Male", nil);
                                                            }
                                                            else
                                                            {
                                                                signupForm.genderField.text = NSLocalizedString(@"Female", nil);
                                                            }
                                                            
                                                            signupForm.signupType = @"facebook";
                                                            signupForm.FBID = [responseData objectForKey:@"id"];
                                                            //signupForm.nameField.text = [NSString stringWithFormat:@"%@ %@", [responseData objectForKey:@"first_name"], [responseData objectForKey:@"last_name"]];
                                                             signupForm.preloaded_full_name = [NSString stringWithFormat:@"%@ %@", [responseData objectForKey:@"first_name"], [responseData objectForKey:@"last_name"]];
                                                            //signupForm.emailField.text = [responseData objectForKey:@"email"];
                                                            signupForm.preloaded_email = [responseData objectForKey:@"email"];
                                                            NSLog(@"signupForm.preloaded_email%@ ", signupForm.preloaded_email);
                                                        });
                                                    }];
                                                }
                                                else
                                                {
                                                    NSLog(@"Facebook error: %@", error);
                                                    
                                                    // This next part must be done on the main thread, or it'll crash the app!
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        UIApplication* app = [UIApplication sharedApplication];
                                                        app.networkActivityIndicatorVisible = NO;
                                                        
                                                        emailButton.enabled = YES;
                                                        FBButton.enabled = YES;
                                                        
                                                        switch ( error.code )
                                                        {
                                                            case 1: {
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"An error occurred. Please try again later.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
                                                                [alert show];
                                                                break;
                                                            }
                                                                
                                                            case 3: {
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Authentication failed. Try again later!" delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
                                                                [alert show];
                                                                break;
                                                            }
                                                                
                                                            case 6: {
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fb_no_account_title", nil) message:NSLocalizedString(@"fb_no_account", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles: nil];
                                                                [alert show];
                                                                break;
                                                            }
                                                                
                                                            case 7: {
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Permission request failed." delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
                                                                [alert show];
                                                                break;
                                                            }
                                                                
                                                            default: {
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"fb_no_account", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
                                                                [alert show];
                                                                break;
                                                            }
                                                                
                                                        }
                                                    });
                                                }
                                            }];
    }
}


- (void)login
{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
