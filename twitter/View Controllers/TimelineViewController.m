//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TTTAttributedLabel.h"
#import "Tweet.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *tweet_array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup datasource for tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // initialize refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // populate with movie data
    [self fetchTweets];
    
    // configure refresh control
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweet_array = tweets;
            
            // NSLog(@" Successfully loaded home timeline");
            // NSLog(@"%@", self.tweet_array);
            [self.tableView reloadData];
            /*
             for (NSDictionary *dictionary in tweets) {
             NSString *text = dictionary[@"text"];
             
             NSLog(@"%@", text);
             } */
            
        } else {
            NSLog(@" Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return self.tweet_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.tweet_array[indexPath.row];
    
    // NSLog(@"%@", tweet.user);
    cell.name.text = tweet.user.name;
    cell.screen_name.text = tweet.user.screenName;
    
    cell.date_posted.text = tweet.createdAtString;
    cell.tweet_text.text = tweet.text;
    cell.reply_count.text = [NSString stringWithFormat:@"%d", tweet.replyCount];
    cell.retweet_count.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favourites_count.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];

    NSString *profile_image_address = tweet.user.profile_image_address;
    NSURL *profile_image_url = [NSURL URLWithString:profile_image_address];
    
    cell.profile_image.image = nil;
    [cell.profile_image setImageWithURL:profile_image_url];
    
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
