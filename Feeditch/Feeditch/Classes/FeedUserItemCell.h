//
//  FeedUserItemCell.h
//  Feeditch
//
//  Created by MachOSX on 3/26/13.
//  Copyright (c) 2013 Scapehouse. All rights reserved.
//

#import "EGOImageView.h"

@interface FeedUserItemCell : UITableViewCell {
    UIImageView *cardBottom;
    EGOImageView *userThumbnailView;
    CALayer *captionContainer;
    UILabel *nameLabel;
    UILabel *countryLabel;
    UILabel *followerCountLabel;
    UILabel *followingCountLabel;
}

@property (nonatomic) NSInteger rowNumber;
@property (strong, nonatomic) UIImageView *cardBG;
@property (strong, nonatomic) UILabel *followButtonLabel;
@property (strong, nonatomic) UIButton *followButton;

- (void)populateCellWithContent:(NSMutableDictionary *)data;

@end
