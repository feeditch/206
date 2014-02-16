//
//  AppDelegate.m
//  Feeditch
//
//  Created by MachOSX on 2/7/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "SignupViewController.h"
#import "FollowingViewController.h"
#import "NearbyViewController.h"
#import "ProfileViewController.h"
#import "UIImage+iPhone5extension.h"

@implementation AppDelegate
@synthesize lang, countryList, MAIN_COLOR;

- (NSString *) lang{
    if (lang == nil)
        lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    return lang;
}

- (BOOL)isArabic{
    if ([self.lang isEqualToString:@"ar"])
        return YES;
    
    return NO;
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden.
	[HUD removeFromSuperview];
	HUD = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    splashView.image = [UIImage imageNamedForDevice:@"Default.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    [NSThread sleepForTimeInterval:3];
    //sleep(2);
    [splashView removeFromSuperview];     
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"THRQPJNM6S68HCHTWZMN"];
    NSLog(@"Flurry agent version= %@",[Flurry getFlurryAgentVersion]);
    
    // Let the device know we want to receive push notifications.
    self.device_token = @"";
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    
    self.FIAppid = @"655793476"; // iTunes App ID
    self.global = [[Global alloc] init];
    self.FIToken = [self.global readProperty:@"token"];
    
    // Set the usage count.
    if ( ![self.global readProperty:@"usageCount"] || [[self.global readProperty:@"usageCount"] isEqualToString:@""] )
    {
        [self.global writeValue:@"1" forProperty:@"usageCount"];
    }
    else
    {
        int usageCount = [[self.global readProperty:@"usageCount"] intValue];
        [self.global writeValue:[NSString stringWithFormat:@"%d", ++usageCount] forProperty:@"usageCount"];
    }
    
    locationManager = [[CLLocationManager alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.countryList_ar = [[NSArray alloc] initWithObjects:/*@"أفغانستان",*/@"ألبانيا",@"الجزائر",@"ساموا-الأمريكي",@"أندورا",@"أنغولا",@"أنغويلا",@"أنتاركتيكا",@"أنتيغوا وبربودا",@"الأرجنتين",@"أرمينيا",@"أروبه",@"أستراليا",@"النمسا",@"أذربيجان",@"الباهاماس",@"البحرين",@"بنغلاديش",@"بربادوس",@"روسيا البيضاء",@"بلجيكا",@"بيليز",@"بنين",@"جزر برمودا",@"بوتان",@"بوليفيا",@"البوسنة و الهرسك",@"بوتسوانا",@"البرازيل",@"بروني",@"بلغاريا",@"بوركينا فاسو",@"بوروندي",@"كمبوديا",@"كاميرون",@"كندا",@"الرأس الأخضر",@"جمهورية أفريقيا الوسطى",@"تشاد",@"شيلي",@"جمهورية الصين الشعبية",@"كولومبيا",@"جزر القمر",@"جمهورية الكونغو الديمقراطية",@"جمهورية الكونغو",@"جزر كوك",@"كوستاريكا",@"ساحل العاج",@"كرواتيا",@"كوبا",@"قبرص",@"الجمهورية التشيكية",@"الدانمارك",@"جيبوتي",@"دومينيكا",@"الجمهورية الدومينيكية",@"تيمور الشرقية",@"إكوادور",@"مصر",@"إلسلفادور",@"غينيا الاستوائي",@"إريتريا",@"استونيا",@"أثيوبيا",@"جزر فارو",@"فيجي",@"فنلندا",@"فرنسا",@"غويانا الفرنسية",@"بولينيزيا الفرنسية",@"الغابون",@"غامبيا",@"جيورجيا",@"ألمانيا",@"غانا",@"جبل طارق",@"اليونان",@"جرينلاند",@"غرينادا",@"جزر جوادلوب",@"جوام",@"غواتيمال",@"غينيا",@"غينيا-بيساو",@"غيانا",@"هايتي",@"هندوراس",@"هونغ كونغ",@"المجر",@"آيسلندا",@"الهند",@"أندونيسيا",@"إيران",@"العراق",@"إيرلندا",@"إيطاليا",@"جمايكا",@"اليابان",@"الأردن",@"كازاخستان",@"كينيا",@"كيريباتي",@"كوريا الشمالية",@"كوريا الجنوبية",@"الكويت",@"قيرغيزستان",@"لاوس",@"لاتفيا",@"لبنان",@"ليسوتو",@"ليبيريا",@"ليبيا",@"ليختنشتين",@"لتوانيا",@"لوكسمبورغ",@"ماكاو",@"مقدونيا",@"مدغشقر",@"مالاوي",@"ماليزيا",@"المالديف",@"مالي",@"مالطا",@"جزر مارشال",@"مارتينيك",@"موريتانيا",@"موريشيوس",@"المكسيك",@"مايكرونيزيا",@"مولدافيا",@"موناكو",@"منغوليا",@"الجبل الأسود",@"مونتسيرات",@"المغرب",@"موزمبيق",@"ميانمار",@"ناميبيا",@"نورو",@"نيبال",@"هولندا",@"جزر الأنتيل الهولندي",@"كاليدونيا الجديدة",@"نيوزيلندا",@"نيكاراجوا",@"النيجر",@"نيجيريا",@"ني",@"جزر ماريانا الشمالية",@"النرويج",@"عُمان",@"باكستان",@"بالاو",@"فلسطين",@"بنما",@"بابوا غينيا الجديدة",@"باراغواي",@"بيرو",@"الفليبين",@"بولونيا",@"البرتغال",@"بورتو ريكو",@"قطر",@"ريونيون",@"رومانيا",@"روسيا",@"رواندا",@"سانت كيتس ونيفس",@"سانت لوسيا",@"سانت فنسنت وجزر غرينادين",@"المناطق",@"سان مارينو",@"ساو تومي وبرينسيبي",@"المملكة العربية السعودية",@"السنغال",@"جمهورية صربيا",@"سيشيل",@"سيراليون",@"سنغافورة",@"سلوفاكيا",@"سلوفينيا",@"جزر سليمان",@"الصومال",@"جنوب أفريقيا",@"إسبانيا",@"سريلانكا",@"السودان",@"سورينام",@"سوازيلند",@"السويد",@"سويسرا",@"سوريا",@"تايوان",@"طاجيكستان",@"تنزانيا",@"تايلندا",@"تبت",@"تيمور الشرقية",@"توغو",@"تونغا",@"ترينيداد وتوباغو",@"تونس",@"تركيا",@"تركمانستان",@"توفالو",@"أوغندا",@"أوكرانيا",@"الإمارات العربية المتحدة",@"المملكة المتحدة",@"الولايات المتحدة",@"أورغواي",@"أوزباكستان",@"فانواتو",@"الفاتيكان",@"فنزويلا",@"فيتنام",@"الجزر العذراء البريطانية",@"الجزر العذراء الأمريكي",@"والس وفوتونا",@"الصحراء الغربية",@"اليمن",@"زامبيا",@"زمبابوي", nil];
    
    self.countryList_en = [[NSArray alloc] initWithObjects: /*@"Afghanistan",*/ @"Albania", @"Algeria", @"American Samoa", @"Andora", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentine", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bengladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Brazil", @"Brunei Darussalam", @"Bulgaria", @"Burkina Faso", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Central African Republic", @"Chad", @"Chili", @"China", @"Colombia", @"Comoros", @"Dem. Republic of Congo", @"Congo", @"Cook Islands", @"Costa Rica", @"Cote d'Ivoire", @"Croatia", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominica", @"Dominican Republic", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Guiana", @"French Polynesia", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guinia", @"Guinia-Bissau", @"Guyana", @"Haiti", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Italy", @"Jamaica", @"Japan", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea - North", @"Korea - South", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall ISlands", @"Martinique", @"Mauritania", @"Mauritius", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands", @"Netherlands Antilles", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestine", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion Island", @"Romania", @"Russia", @"Rwanda", @"Saint Kitts And Nevis", @"Saint Lucia", @"St.Vincent & Grenadines", @"Samoa", @"San Marino", @"Sao Tome and Príncipe", @"Saudi Arabia", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"Solomon Islands", @"Somalia", @"South Africa", @"Spain", @"Sri Lanka", @"Sudan", @"Suriname", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Tibet",@"East Timor", @"Togo", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City State", @"Venezuela", @"Vietnam", @"Virgin Islands (British)", @"Virgin Islands (U.S.)", @"Wallis and Futuna Islands", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe",
                           nil];
    
    self.countryList = [[NSArray alloc] initWithObjects:/*@"1",*/@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100",@"101",@"102",@"103",@"104",@"105",@"106",@"107",@"108",@"109",@"110",@"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118",@"119",@"120",@"121",@"122",@"123",@"124",@"125",@"126",@"127",@"128",@"129",@"130",@"131",@"132",@"133",@"134",@"135",@"136",@"137",@"138",@"139",@"140",@"141",@"142",@"143",@"144",@"145",@"146",@"147",@"148",@"149",@"150",@"151",@"152",@"153",@"154",@"155",@"156",@"157",@"158",@"159",@"160",@"161",@"162",@"163",@"164",@"165",@"166",@"167",@"168",@"169",@"170",@"171",@"172",@"173",@"174",@"175",@"176",@"177",@"178",@"179",@"180",@"181",@"182",@"183",@"184",@"185",@"186",@"187",@"188",@"189",@"190",@"191",@"192",@"193",@"194",@"195",@"196",@"197",@"198",@"199",@"200",@"201",@"202",@"203",@"204",@"205",@"206",@"207",@"208",@"209",@"210",@"211",@"212",@"213",@"214",@"215",@"216",@"217",@"218",@"219",@"220",@"221",@"222",@"223", nil];
    
    self.cuisineList_ar = [[NSArray alloc] initWithObjects:@"",
                   @"أفغاني",
                   @"أفريقي",
                   @"جزائري",
                   @"أمريكي",
                   @"أرجنتيني",
                   @"أرمني",
                   @"آسيوي",
                   @"بحراني",
                   @"مخبز /باتيسري",
                   @"برازيلي",
                   @"بيرغرز",
                   @"كاريبي",
                   @"صيني",
                   @"قهوة",
                   @"كوبي",
                   @"حلوى",
                   //@"آيس كريم",
                   @"مصري",
                   @"إماراتي",
                   @"الطعام الجاهز",
                   @"فيليبيني",
                   @"فرنسي",
                   @"اللبن المثلج",
                   @"ألماني",
                   @"يوناني",
                   @"هاواي",
                   @"المقانق المقلية",
                   @"آيس كريم",
                   @"هندي",
                   @"أندونيسي",
                   @"دولي",
                   @"إيطالي",
                   @"ياباني",
                   @"أردني",
                   @"كوري",
                   @"كويتي",
                   @"أميركي لاتيني",
                   @"لبناني",
                   @"ماليزي",
                   @"مكسيكي",
                   @"مغربي",
                   @"عماني",
                   @"باكستاني",
                   @"فلسطيني",
                   @"بيتزا",
                   @"برتغالي",
                   @"بورتوريكي",
                   @"قطري",
                   @"الني",
                   @"سندويشات",
                   @"سعودي",       
                   @"مأكولات بحرية",
                   @"شوربات",
                   @"إسباني",
                   @"ستيك",
                   @"سوشي",
                   @"سوري",
                   @"التاكو",
                   @"شاي",
                   @"تايلاندي",
                   @"تونسي",
                   @"تركي",
                   @"نباتي",
                   @"فيتنامي",
                   //@"لبناني",
                   //@"سوري",
                   //@"فلسطيني",
                   //@"أردني",
                   //@"سعودي",
                   //@"كويتي",
                   //@"عماني",
                   //@"بحراني",
                   @"يمني",
                   //@"إماراتي",
                   //@"قطري",
                   //@"مصري",
                   //@"جزائري",
                   //@"تونسي",
                           nil];
    
    self.cuisineList_en = [[NSArray alloc] initWithObjects:@"",
                   @"afghani",
                   @"african",
                   @"algerian",
                   @"american",
                   @"argentinian",
                   @"armenian",
                   @"asian",
                   @"bahraini",
                   @"bakery",
                   @"brazilian",
                   @"burgers",
                   @"caribbean",
                   @"chinese",
                   @"coffee",
                   @"cuban",
                   @"dessert",
                  // @"ice cream",
                   @"egyptian",
                   @"emarati",
                   @"fast food",
                   @"filipino",
                   @"french",
                   @"frozen yogurt",
                   @"german",
                   @"greek",
                   @"hawaiian",
                   @"hot dogs",
                   @"ice cream",
                   @"indian",
                   @"indonesian",
                   @"international",
                   @"italian",
                   @"japanese",
                   @"jordanian",
                   @"korean",
                   @"kuwaiti",
                   @"latin american",
                   @"lebanese",
                   @"malaysian",
                   @"mexican",
                   @"moroccan",
                   @"omani",
                   @"pakistani",
                   @"palestinian",
                   @"pizza",
                   @"portuguese",
                   @"puerto rican",
                   @"qatari",
                   @"raw food",
                   @"sandwiches",
                   @"saudi",
                   @"seafood",
                   @"soups",
                   @"spanish",
                   @"steaks",
                   @"sushi",
                   @"syrian",
                   @"tacos",
                   @"tea",
                   @"thai",
                   @"tunisian",
                   @"turkish",
                   @"vegetarian",
                   @"vietnamese",
                   //@"lebanese",
                   //@"syrian",
                   //@"palestinian",
                   //@"jordanian",
                   //@"saudi",
                   //@"kuwaiti",
                  // @"omani",
                   //@"bahraini",
                   @"yemeni",
                   //@"emarati",
                  // @"qatari",
                   // @"egyptian",
                   //@"algerian",
                   //@"tunisian"
                           nil];
    self.MAIN_COLOR = [UIColor colorWithRed:77/255.0 green:189/255.0 blue:148/255.0 alpha:1];//[UIColor colorWithRed:242/255.0 green:23/255.0 blue:40/255.0 alpha:1];
    
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[NearbyViewController alloc] initWithNibName:@"NearbyViewController" bundle:nil];
    UIViewController *viewController2 = [[FollowingViewController alloc] initWithNibName:@"FollowingViewController" bundle:nil];
    UIViewController *viewController3 = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
   
    
    
    
    self.tabBarController.viewControllers = @[navigationController1, navigationController2, navigationController3];
    
    self.window.rootViewController = self.tabBarController;
    
    NSLog(@">>>>>>>__ %@", self.tabBarController);
    [self.window makeKeyAndVisible];
    
    
    // Check if we have a token or not.
    // If not, show the login.
    if ( !self.FIToken || [self.FIToken isEqualToString:@""] )
    {
        SignupViewController *signupView = [[SignupViewController alloc] init];
        
        UINavigationController *loginViewNavigationController = [[UINavigationController alloc] initWithRootViewController:signupView];
        loginViewNavigationController.navigationBarHidden = YES;
        [self.tabBarController presentViewController:loginViewNavigationController animated:NO completion:NULL];
        
            
    } else {
        // Flurry.
        [Flurry setUserID:[self.global readProperty:@"userid"]];
        
        if ( [[self.global readProperty:@"gender"] isEqualToString:@"male"] )
        {
            [Flurry setGender:@"m"];
        }
        else
        {
            [Flurry setGender:@"f"];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    
    // Get the user's current location & save it.
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSError *error;
    
    if ( managedObjectContext != nil )
    {
        if ( [managedObjectContext hasChanges] && ![managedObjectContext save:&error] )
        {
			// Handle the error.
        }
    }
}

// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ( self.tabBarController.selectedIndex == 0 )
    {
        [Flurry logEvent:@"Nearby feed selected"];
    }
    else
    {
        [Flurry logEvent:@"Following feed selected"];
    }
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark -
#pragma mark Push notifications

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.device_token = [NSString stringWithFormat:@"%@", deviceToken];
    self.device_token = [self.device_token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.device_token = [self.device_token stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	//NSLog(@"Failed to get device token, error: %@", error);
    self.device_token = @"";
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( userInfo )
    {
        NSString *notifData = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        UIAlertView *alert = [[UIAlertView alloc]
                                    initWithTitle:@"إعلام"
                                    message:notifData delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:NSLocalizedString(@"Close", nil), nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark Flurry crash tracking

void uncaughtExceptionHandler(NSException *exception)
{
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

#pragma mark -
#pragma mark Logout

- (void)logout
{
    SignupViewController *signupView = [[SignupViewController alloc] init];
    signupView.navigationController.navigationBarHidden = YES;
    
    UINavigationController *signupViewNavigationController = [[UINavigationController alloc] initWithRootViewController:signupView];
    [self.tabBarController presentViewController:signupViewNavigationController animated:NO completion:NULL];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/logout", FI_DOMAIN]];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setPostValue:appDelegate.FIToken forKey:@"token"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ( [[responseData objectForKey:@"error"] intValue] == 0 )
        {
            [self.global clearAll]; // Clear everything out.
            self.FIToken = [self.global readProperty:@"token"]; // This ivar needs refreshing!
        }
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
        
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

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation.coordinate;
    [Flurry setLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude horizontalAccuracy:newLocation.horizontalAccuracy verticalAccuracy:newLocation.verticalAccuracy];
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ( status != kCLAuthorizationStatusAuthorized || ![CLLocationManager locationServicesEnabled] )
    {
        self.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.currentLocation = CLLocationCoordinate2DMake(9999, 9999);
}

#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (void)saveAction
{
    NSError *error;
    
    if ( ![[self managedObjectContext] save:&error] )
    {
		// Handle error.
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if ( managedObjectContext != nil )
    {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if ( coordinator != nil )
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return self.managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if ( managedObjectModel != nil )
    {
        return managedObjectModel;
    }
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if ( persistentStoreCoordinator != nil )
    {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Feeditch.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if ( ![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error] )
    {
        // Handle the error.
    }
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return basePath;
}

@end
