//
//  TweetCell.m
//  twitter
//
//  Created by rodrigoandrade on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)didTapFav:(id)sender {
    
    // Update the local tweet model based on fav status
    if (self.tweet.favorited == NO){
        [self favoriteTweet];
    }
    
    else{
        [self unFavoriteTweet];
    }
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

-(void)favoriteTweet{
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self.favorite_button setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    
    // reload fav count data
    self.favourites_count.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
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
    self.favourites_count.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
