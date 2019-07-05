//
//  TweetCell.h
//  twitter
//
//  Created by rodrigoandrade on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TTTAttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date_posted;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweet_text;
@property (weak, nonatomic) IBOutlet UILabel *reply_count;
@property (weak, nonatomic) IBOutlet UILabel *retweet_count;
@property (weak, nonatomic) IBOutlet UILabel *favourites_count;
@property (weak, nonatomic) IBOutlet UIButton *reply_button;
@property (weak, nonatomic) IBOutlet UIButton *retweet_button;
@property (weak, nonatomic) IBOutlet UIButton *favorite_button;
@property (weak, nonatomic) IBOutlet UIButton *message_button;

@property(strong, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
