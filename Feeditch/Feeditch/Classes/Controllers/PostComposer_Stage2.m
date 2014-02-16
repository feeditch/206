//
//  PostComposer_Stage2.m
//  Feeditch
//
//  Created by MachOSX on 2/10/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "PostComposer_Stage2.h"
#import "AppDelegate.h"
#import "UIImage+iPhone5extension.h"

@implementation PostComposer_Stage2

UITableView *tmpTable;

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
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    [self setTitle:NSLocalizedString(@"Venue", nil)];
    
    nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleDone target:self action:@selector(goNext)];
    self.navigationController.navigationItem.rightBarButtonItem = nextButton;
    nextButton.enabled = NO;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 27, 19);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    stage3 = [[PostComposer_Stage3 alloc] init];
    venues = [[NSMutableArray alloc] init];
    listDidFinishDownloading = NO;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_dust"]];
    
    searchBox = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    searchBox.tintColor = [UIColor colorWithRed:26.0/255.0 green:142.0/255.0 blue:135.0/255.0 alpha:1.0];
    searchBox.delegate = self;
    searchBox.placeholder = NSLocalizedString(@"Search", nil);
    
    UIImageView *searchBoxShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bar_shadow_down"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];
    searchBoxShadow.frame = CGRectMake(0, 44, screenWidth, 20);
    searchBoxShadow.opaque = YES;
    
    UIImageView *viewBottomShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bar_shadow_up"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];
    viewBottomShadow.frame = CGRectMake(0, screenHeight - 84, screenWidth, 20);
    viewBottomShadow.opaque = YES;
    
    searchResultsDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBox contentsController:self];
    searchResultsDisplayController.delegate = self;
    
    UIImageView *paper_BG = [[UIImageView alloc] initWithImage:[UIImage imageNamedForDevice:@"tablecloth_paper"]];
    paper_BG.opaque = YES;
    paper_BG.userInteractionEnabled = YES;
    
    if ( IS_IPHONE_5 )
    {
        paper_BG.frame = CGRectMake(3, 30, 314, 494);
    }
    else
    {
        paper_BG.frame = CGRectMake(3, 30, 314, 401);
    }
    
    venueTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, screenHeight - 107)];
    venueTable.delegate = self;
    venueTable.dataSource = self;
    venueTable.backgroundColor = [UIColor clearColor];
    venueTable.separatorColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    venueTable.tag = 1;
    
    
    
    [self.view addSubview:venueTable];
    [self.view addSubview:searchBox];
    [self.view addSubview:searchBoxShadow];
    [self.view addSubview:viewBottomShadow];
    [super viewDidLoad];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"nav_bar"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    navBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 35)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getNearbyVenues];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [dataRequest clearDelegatesAndCancel]; // Cancel any previously running requests.
    
    [super viewWillDisappear:animated];
}

- (void)didTapBackButton:(id)sender
{
    if ( self.navigationController.viewControllers.count > 1 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getNearbyVenues
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [dataRequest clearDelegatesAndCancel]; // Cancel any previously running requests.
    listDidFinishDownloading = NO;
    [venues removeAllObjects];
    [venueTable reloadData];
    
    NSString *urlString = @"https://api.foursquare.com/v2/venues/search?v=20130228"; // 4sq requires this first param as v=yyyymmdd.
    
    // Put it together.
    urlString = [urlString stringByAppendingFormat:@"&client_id=ZHK22TFDORRHHDKGN4L40EQKGUBJEXM3F2FPGS14JCM1MKPE"];
    urlString = [urlString stringByAppendingFormat:@"&client_secret=PMQDW1TFREX5P2UJU2G0C42IIT01SQBR52YOHFN2TCW3S2RK"];
    urlString = [urlString stringByAppendingFormat:@"&ll=%f,%f", appDelegate.currentLocation.latitude, appDelegate.currentLocation.longitude]; // The ordering is important!!!
    
    if ( searchBox.text.length > 0 )
    {
        urlString = [urlString stringByAppendingFormat:@"&query=%@", searchBox.text];
        urlString = [urlString stringByAppendingFormat:@"&intent=browse"];
        urlString = [urlString stringByAppendingFormat:@"&radius=18000"];
        urlString = [urlString stringByAppendingFormat:@"&limit=20"];
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setRequestMethod:@"GET"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        //NSLog(@"%@", responseData);
        
        for ( NSMutableDictionary *venue in [[responseData objectForKey:@"response"] objectForKey:@"venues"] )
        {
            [venues addObject:[venue mutableCopy]];  // IMPORTANT: MAKE A MUTABLE COPY!!!
        }
        
        listDidFinishDownloading = YES;
        [venueTable reloadData];
        //[[[UIAlertView alloc] initWithTitle:@"teft" message:[NSString stringWithFormat:@"vebues count: %d", venues.count] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
        
        
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        
        // Set custom view mode.
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = @"Could not connect!";
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        listDidFinishDownloading = YES;
        [venueTable reloadData];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

- (void)getNearbyVenuesForSearchTableView:(UITableView *) tableView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [dataRequest clearDelegatesAndCancel]; // Cancel any previously running requests.
    listDidFinishDownloading = NO;
    [venues removeAllObjects];
    [venueTable reloadData];
    
    NSString *urlString = @"https://api.foursquare.com/v2/venues/search?v=20130228"; // 4sq requires this first param as v=yyyymmdd.
    
    // Put it together.
    urlString = [urlString stringByAppendingFormat:@"&client_id=ZHK22TFDORRHHDKGN4L40EQKGUBJEXM3F2FPGS14JCM1MKPE"];
    urlString = [urlString stringByAppendingFormat:@"&client_secret=PMQDW1TFREX5P2UJU2G0C42IIT01SQBR52YOHFN2TCW3S2RK"];
    urlString = [urlString stringByAppendingFormat:@"&ll=%f,%f", appDelegate.currentLocation.latitude, appDelegate.currentLocation.longitude]; // The ordering is important!!!
    
    if ( searchBox.text.length > 0 )
    {
        urlString = [urlString stringByAppendingFormat:@"&query=%@", searchBox.text];
        urlString = [urlString stringByAppendingFormat:@"&intent=browse"];
        urlString = [urlString stringByAppendingFormat:@"&radius=18000"];
        urlString = [urlString stringByAppendingFormat:@"&limit=20"];
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    dataRequest = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *wrequest = dataRequest;
    
    [wrequest setRequestMethod:@"GET"];
    [wrequest setCompletionBlock:^{
        NSError *jsonError;
        responseData = [NSJSONSerialization JSONObjectWithData:[wrequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
        
        //NSLog(@"%@", responseData);
        
        for ( NSMutableDictionary *venue in [[responseData objectForKey:@"response"] objectForKey:@"venues"] )
        {
            [venues addObject:[venue mutableCopy]];  // IMPORTANT: MAKE A MUTABLE COPY!!!
        }
        
        listDidFinishDownloading = YES;
        [tableView reloadData];
        //[[[UIAlertView alloc] initWithTitle:@"teft" message:[NSString stringWithFormat:@"vebues count: %d", venues.count] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
        
        
    }];
    [wrequest setFailedBlock:^{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_white.png"]];
        
        // Set custom view mode.
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = @"Could not connect!";
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
        
        listDidFinishDownloading = YES;
        [tableView reloadData];
        
        NSError *error = [dataRequest error];
        NSLog(@"%@", error);
    }];
    [wrequest startAsynchronous];
}

#pragma mark -
#pragma mark Move on to the next view

- (void)goNext
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"المكان" style:UIBarButtonItemStylePlain target:nil action:nil];
    stage3.postChunk = self.postChunk;
    [self.navigationController pushViewController:stage3 animated:YES];
}

#pragma mark -
#pragma mark UISearchBarDelegate methods

- (BOOL)searchBarDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getNearbyVenues];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self getNearbyVenuesForSearchTableView:tmpTable];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (appDelegate.currentLocation.longitude == 9999) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", nil)
                                                      message:NSLocalizedString(@"Couldn't get your location. Please enable location services in your phone settings.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                            otherButtonTitles:nil];
        [alert show];
    }
    else
    {
       [self getNearbyVenues]; 
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    tmpTable.hidden = YES;
    [self getNearbyVenues];
}
#pragma mark -
#pragma mark UISearchDisplayDelegate methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    //tableView.hidden = YES;
    tmpTable = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self getNearbyVenuesForSearchTableView:tableView];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [venues count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *assembledCell;
    int lastIndex = [venues count] - 1;
    
    if ( indexPath.row == [venues count] ) // Cell for adding a venue.
    {
        static NSString *cellIdentifier = @"loadingCell";
        venueCell = (VenueCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ( assembledCell == nil )
        {
            venueCell = [[VenueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            venueCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
        }
        
        [venueCell convertToLoadingCell];
        
        if ( !listDidFinishDownloading )
        {
            venueCell.mainTextLabel.text = NSLocalizedString(@"Loading...", nil);
            venueCell.mainTextLabel.textAlignment = NSTextAlignmentCenter;
            venueCell.selectionStyle = UITableViewCellSelectionStyleNone;
            venueCell.disclosureAdd.hidden = YES;
        }
        else
        {
            venueCell.mainTextLabel.text = @"";
            venueCell.selectionStyle = UITableViewCellSelectionStyleNone;
            venueCell.disclosureAdd.hidden = YES;
            
            /*
            if (searchBox.text.length == 0)
            {
                venueCell.mainTextLabel.text = @"";
                venueCell.selectionStyle = UITableViewCellSelectionStyleNone;
                venueCell.disclosureAdd.hidden = YES;
            }
            else
            {
                venueCell.mainTextLabel.text = [NSString stringWithFormat:@"أضف \"%@\"", searchBox.text];
                venueCell.selectionStyle = UITableViewCellSelectionStyleGray;
                venueCell.disclosureAdd.hidden = NO;
            }
            
            venueCell.mainTextLabel.textAlignment = NSTextAlignmentLeft;*/
        }
        
        assembledCell = venueCell;
    }
    else if ( indexPath.row == [venues count] + 1 ) // Display "Powered by Foursquare"
    {
        static NSString *cellIdentifier = @"foursquareCell";
        assembledCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UIImageView *poweredBy4sq;
        
        if ( assembledCell == nil )
        {
            assembledCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            assembledCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
            
            poweredBy4sq = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powered_by_foursquare_gray"]];
            poweredBy4sq.frame = CGRectMake(35, 0, 241, 44);
            poweredBy4sq.opaque = YES;
            poweredBy4sq.hidden = YES;
            
            [assembledCell addSubview:poweredBy4sq];
        }
        
        assembledCell.textLabel.text = @"";
        assembledCell.selectionStyle = UITableViewCellSelectionStyleNone;
        poweredBy4sq.hidden = NO;
    }
    else if (indexPath.row <= lastIndex && listDidFinishDownloading) // Display venues.
    {
        static NSString *cellIdentifier = @"venueCell";
        venueCell = (VenueCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ( assembledCell == nil )
        {
            venueCell = [[VenueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            venueCell.frame = CGRectMake(0, 0, assembledCell.frame.size.width, assembledCell.frame.size.height);
            venueCell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        NSMutableDictionary *venueData = [venues objectAtIndex:indexPath.row];
        
        [venueCell convertToVenueCell];
        [venueCell populateCellWithContent:venueData];
        venueCell.disclosureAdd.hidden = YES;
        
        assembledCell = venueCell;
    }
    
    return assembledCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int lastIndex = [venues count] - 1;
    
    if ( [venues count] > 0 && indexPath.row <= lastIndex )
    {
        if ( listDidFinishDownloading )
        {
            NSMutableDictionary *venueData = [venues objectAtIndex:indexPath.row];
            selectedVenueName = [venueData objectForKey:@"name"];
            selectedVenueId = [venueData objectForKey:@"id"];
            selectedVenueLat = [[venueData objectForKey:@"location"] objectForKey:@"lat"];
            selectedVenueLong = [[venueData objectForKey:@"location"] objectForKey:@"lng"];
            
            [self.postChunk setObject:selectedVenueName forKey:@"fsq_venue_name"];
            [self.postChunk setObject:selectedVenueId forKey:@"fsq_venue_id"];
            [self.postChunk setObject:selectedVenueLat forKey:@"current_location_lat"];
            [self.postChunk setObject:selectedVenueLong forKey:@"current_location_long"];
            
            [self goNext];
        }
    }
    /*else if ( indexPath.row == [venues count] && searchBox.text.length > 0 )
    {
        // Add the new venue.
        [self.postChunk setObject:searchBox.text forKey:@"fqvenue"];
        [self.postChunk setObject:[NSNumber numberWithInt:-1] forKey:@"fqvenueid"];
        
        [self goNext];
    }*/
    else
    {
        // "Powered by Foursquare" cell...
        // Don't do anything.
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
