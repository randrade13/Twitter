//
//  TweetCell.h
//  twitter
//
//  Created by rodrigoandrade on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *date_posted;
@property (weak, nonatomic) IBOutlet UILabel *tweet_text;
@property (weak, nonatomic) IBOutlet UILabel *reply_count;
@property (weak, nonatomic) IBOutlet UILabel *retweet_count;
@property (weak, nonatomic) IBOutlet UILabel *favourites_count;
@property (weak, nonatomic) IBOutlet UIImageView *reply_button;
@property (weak, nonatomic) IBOutlet UIImageView *retweet_button;
@property (weak, nonatomic) IBOutlet UIImageView *favourite_button;
@property (weak, nonatomic) IBOutlet UIImageView *message_button;

@property(strong, nonatomic) NSDictionary *tweet;

@end

NS_ASSUME_NONNULL_END
