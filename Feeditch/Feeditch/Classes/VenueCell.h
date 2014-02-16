
@interface VenueCell : UITableViewCell {
    UILabel *addressLabel;
    UILabel *distanceLabel;
}

@property (strong, nonatomic) UILabel *mainTextLabel;
@property (strong, nonatomic) UIImageView *disclosureAdd;

- (void)populateCellWithContent:(NSMutableDictionary *)data;
- (void)convertToLoadingCell;
- (void)convertToVenueCell;

@end
