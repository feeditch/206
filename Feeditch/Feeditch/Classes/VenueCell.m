#import "AppDelegate.h"
#import "VenueCell.h"

@implementation VenueCell

AppDelegate *appDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        self.opaque = YES;
        
        self.mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 245, 22)];
        self.mainTextLabel.backgroundColor = [UIColor clearColor];
        self.mainTextLabel.textColor = [UIColor blackColor];
        self.mainTextLabel.highlightedTextColor = [UIColor whiteColor];
        self.mainTextLabel.font = [UIFont boldSystemFontOfSize:MIN_MAIN_FONT_SIZE];
        self.mainTextLabel.numberOfLines = 1;
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 245, 22)];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        addressLabel.highlightedTextColor = [UIColor whiteColor];
        addressLabel.font = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
        addressLabel.numberOfLines = 1;
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(261, 11, 55, 22)];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor colorWithRed:211.0/255.0 green:70.0/255.0 blue:65.0/255.0 alpha:1.0];
        distanceLabel.highlightedTextColor = [UIColor whiteColor];
        distanceLabel.font = [UIFont boldSystemFontOfSize:SECONDARY_FONT_SIZE];
        distanceLabel.textAlignment = appDelegate.isArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
        distanceLabel.numberOfLines = 1;
        
        self.disclosureAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure_add"]];
        self.disclosureAdd.frame = CGRectMake(7, 10, 29, 31);
        
        [self.contentView addSubview:self.mainTextLabel];
        [self.contentView addSubview:addressLabel];
        [self.contentView addSubview:distanceLabel];
        [self.contentView addSubview:self.disclosureAdd];
	}
	
	return self;
}

- (void)populateCellWithContent:(NSMutableDictionary *)data
{
    NSString *venueName = [data objectForKey:@"name"];
    NSString *venueAddress = [[data objectForKey:@"location"] objectForKey:@"address"];
    NSString *venueDistance = [[data objectForKey:@"location"] objectForKey:@"distance"];
    
    float distance = [venueDistance intValue];
    distance /= 1000;
    
    venueDistance = [NSString stringWithFormat:@"%.02f", distance];
    venueDistance = [NSString stringWithFormat:@"%@", venueDistance]; // Convert to Arabic numerals.
    
    self.mainTextLabel.text = venueName;
    distanceLabel.text =  appDelegate.isArabic ? [NSString stringWithFormat:@"%@ كم", venueDistance] : [NSString stringWithFormat:@"%@ km", venueDistance];
    
    if ( ![venueAddress isEqual:[NSNull null]] )
    {
        addressLabel.text = venueAddress;
    }
}

- (void)convertToLoadingCell
{
    self.mainTextLabel.frame = CGRectMake(38, 0, 244, 44);
}

- (void)convertToVenueCell
{
    self.mainTextLabel.frame = CGRectMake(10, 0, 245, 22);
    self.disclosureAdd.hidden = NO;
}

@end
