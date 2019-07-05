//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by rodrigoandrade on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "APIManager.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tweet_text;
@property (weak, nonatomic) IBOutlet UILabel *date_posted;
@property (weak, nonatomic) IBOutlet UILabel *retweet_count;
@property (weak, nonatomic) IBOutlet UILabel *favorites_count;
@property (weak, nonatomic) IBOutlet UIButton *reply_button;
@property (weak, nonatomic) IBOutlet UIButton *retweet_button;
@property (weak, nonatomic) IBOutlet UIButton *favorite_button;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name.text = self.tweet.user.name;
    self.screen_name.text = self.tweet.user.screenName;
    
    // Format short date
    NSString *formatted_date = self.tweet.createdAtString.timeAgoSinceNow;
    self.date_posted.text = formatted_date;
    
    self.tweet_text.text = self.tweet.text;
    self.retweet_count.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favorites_count.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    NSString *profile_image_address = self.tweet.user.profile_image_address;
    NSURL *profile_image_url = [NSURL URLWithString:profile_image_address];
    
    self.profile_image.image = nil;
    [self.profile_image setImageWithURL:profile_image_url];
}

- (IBAction)didTapRetweet:(id)sender {
    
    // Update the local tweet model based on fav status
    if (self.tweet.retweeted == NO){
        [self retweet];
    }
    
    else{
        [self unRetweet];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    
    // Update the local tweet model based on fav status
    if (self.tweet.favorited == NO){
        [self favoriteTweet];
    }
    
    else{
        [self unFavoriteTweet];
    }
}

-(void)favoriteTweet{
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self.favorite_button setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    
    // reload fav count data
    self.favorites_count.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    // call to APIManager to favorite tweet
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
}

-(void)unFavoriteTweet{
    
    self.tweet.favorited = NO;
    self.tweet.favoriteCount -= 1;
    [self.favorite_button setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    
    // reload fav count data
    self.favorites_count.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    // call to APIManager to favorite tweet
    [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
        }
    }];
}

- (void)retweet{
    
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    [self.retweet_button setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    
    // reload retweet count data
    self.retweet_count.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    // call to APIManager to favorite tweet
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
}

- (void)unRetweet{
    
    self.tweet.retweeted = NO;
    self.tweet.retweetCount -= 1;
    [self.retweet_button setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    
    // reload retweet count data
    self.retweet_count.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    // call to APIManager to favorite tweet
    [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
