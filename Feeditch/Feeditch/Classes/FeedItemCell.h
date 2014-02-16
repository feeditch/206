//
//  FeedItemCell.h
//  Feeditch
//
//  Created by MachOSX on 3/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "EGOImageView.h"

@interface FeedItemCell : UITableViewCell {
    UIImageView *cardBottom;
    EGOImageView *imageView;
    EGOImageView *userThumbnailView;
    UIImageView *bottomHorizontalSeparator;
    UIImageView *bottomVerticalSeparator;
    UIImageView *clockIcon;
    UIImageView *distanceIcon;
    CALayer *captionContainer;
    UILabel *captionLabel_name;
    UILabel *captionLabel_verb;
    UILabel *captionLabel_dish;
    UILabel *captionLabel_at;
    UILabel *captionLabel_venue;
    UILabel *timestampLabel;
    UILabel *distanceLabel;
}

@property (nonatomic) NSInteger rowNumber;
@property (strong, nonatomic) UIImageView *cardBG;
@property (strong, nonatomic) UILabel *itchCountLabel;
@property (strong, nonatomic) UIButton *itchButton;
@property (strong, nonatomic) UIButton *shareButton;

- (void)populateCellWithContent:(NSMutableDictionary *)data;

@end
