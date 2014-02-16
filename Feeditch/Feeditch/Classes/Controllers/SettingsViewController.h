//
//  SettingsViewController.h
//  Feeditch
//
//  Created by MachOSX on 4/24/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UINavigationControllerDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    NSDictionary *tableContents;
    NSArray *sortedKeys;
}

@property (strong, nonatomic) IBOutlet UITableView *settingsTable;


@end
