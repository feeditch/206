//
//  AppDelegate.h
//  Feeditch
//
//  Created by MachOSX on 2/7/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Global.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "Flurry.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define FI_DOMAIN @"feeditch.me" // For use in URLs. Alternate between actual domain and localhost for testing purposes.
#define APP_NAME @"Feeditch"
#define APP_TARGET_PLATFORM @"iOS"
#define APP_TARGET_PLATFORM_MINVER @"6.0"
#define APP_VERSION @"2.0"
#define BATCH_SIZE 15
#define AUTOREFRESH_THRESHOLD 5
#define FB_APP_ID @"117360185055023"

#define MAIN_FONT_SIZE 18
#define MIN_MAIN_FONT_SIZE 15
#define SECONDARY_FONT_SIZE 12
#define MIN_SECONDARY_FONT_SIZE 10

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    CLLocationManager *locationManager;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) Global *global;
@property (strong, nonatomic) NSString *FIToken;
@property (strong, nonatomic) NSString *FIAppid;
@property (strong, nonatomic) NSString *device_token;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) NSArray *countryList_en;
@property (strong, nonatomic) NSArray *countryList_ar;
@property (strong, nonatomic) NSArray *countryList;
@property (strong, nonatomic) NSArray *cuisineList_en;
@property (strong, nonatomic) NSArray *cuisineList_ar;
@property (strong, nonatomic) UIColor *MAIN_COLOR;

@property (strong, nonatomic) NSString *lang;

- (void)logout;
- (void)saveAction;
- (NSString *)applicationDocumentsDirectory;
- (BOOL)isArabic;

@end
