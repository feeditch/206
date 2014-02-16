//
//  InnerPostViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/23/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "EGOImageView.h"

@interface InnerPostViewController : UIViewController <MBProgressHUDDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    MBProgressHUD *HUD;
    IBOutlet UIScrollView *mainView;
    IBOutlet UIBarButtonItem *recommendButton;
    IBOutlet UIBarButtonItem *shareButton;
    IBOutlet UIBarButtonItem *reportButton;
    UIButton *itchButton;
    UIButton *gotoUserButton;
    UIButton *venueButton;
    UIButton *recommendationsButton;
    EGOImageView *preview;
    EGOImageView *userThumbnailView;
    UILabel *itchCountLabel;
    UILabel *recommendCountLabel;
}

@property (strong, nonatomic) NSMutableDictionary *postChunk;

- (void)itchPost;
- (void)gotoUser;
- (void)gotoVenue;
- (void)gotoRecommendations;
- (IBAction)recommendPost;
- (IBAction)showSharingOptions;
- (void)showDeletionOptions;
- (IBAction)showFlaggingOptions;
- (void)deletePost;
- (void)flagInappropriate;

@end
