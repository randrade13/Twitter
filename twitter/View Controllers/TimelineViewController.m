//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
// Step 2 Define custom table view cell and set its reuse identifier
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TTTAttributedLabel.h"
#import "Tweet.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property NSMutableArray *tweet_array;
// Step 1 View controller has table view as subview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step 3 View controller becomes its datasources and delegate
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
    // Step 4 Get tweets is making API Request
    // Step 5 API manager calls the completion handler passing back data
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            // Step 6 View controller stores that data passed into the completion handler
            self.tweet_array = [NSMutableArray arrayWithArray:tweets];
            
            // NSLog(@" Successfully loaded home timeline");
            // NSLog(@"%@", self.tweet_array);
            
            // Step 7 reload the table view (using reload data)
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
/* Step 8, 9, 10:
 8. Table view asks its dataSource for numberOfRows & cellForRowAt (i.e. the two functions are called implicitly during reload data)
 9. numberofRows returns number of items returned from the API
 10. cellForRow returns an instance  of the custom cell with that reuse identifier with it's elements populated with data at the index asked for
*/
- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return self.tweet_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.tweet_array[indexPath.row];
    
    // NSLog(@"%@", tweet.user);
    // Update cell properties
    cell.tweet = tweet;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)didTweet:(Tweet *)tweet{
    [self.tweet_array insertObject:tweet atIndex: 0];
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}


@end
