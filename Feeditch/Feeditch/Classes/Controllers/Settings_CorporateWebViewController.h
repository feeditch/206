

#import "MBProgressHUD.h"

@interface Settings_CorporateWebViewController : UIViewController <UIWebViewDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UIWebView *browser;
@property (nonatomic, retain) NSString *url;

@end
