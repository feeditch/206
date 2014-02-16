//
//  PostComposer_Stage2.h
//  Feeditch
//
//  Created by MachOSX on 2/10/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "PostComposer_Stage3.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "VenueCell.h"

@interface PostComposer_Stage2 : UIViewController <UINavigationControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource> {
    PostComposer_Stage3 *stage3;
    __block ASIFormDataRequest *dataRequest;
    NSDictionary *responseData;
    NSMutableArray *venues;
    UIBarButtonItem *nextButton;
    UISearchBar *searchBox;
    UISearchDisplayController *searchResultsDisplayController;
    MBProgressHUD *HUD;
    UITableView *venueTable;
    VenueCell *venueCell;
    NSString *selectedVenueName;
    NSString *selectedVenueId;
    NSString *selectedVenueLat;
    NSString *selectedVenueLong;
    BOOL listDidFinishDownloading;
}

@property (strong, nonatomic) NSMutableDictionary *postChunk;

- (void)didTapBackButton:(id)sender;
- (void)getNearbyVenues;
- (void)getNearbyVenuesForSearchTableView:(UITableView *) tableView;
- (void)goNext;

@end
