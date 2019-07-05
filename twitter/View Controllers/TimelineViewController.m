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
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetDetailsViewController.h"
#import "DateTools.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TTTAttributedLabelDelegate, UIScrollViewDelegate>

@property NSMutableArray *tweet_array;
// Step 1 View controller has table view as subview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) NSNumber *max_ID;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step 3 View controller becomes its datasources and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
    
    // Format short date
    NSString *formatted_date = tweet.createdAtString.shortTimeAgoSinceNow;
    cell.date_posted.text = formatted_date;
    
    // Configure tweet text to detect and support clickable links
    cell.tweet_text.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    cell.tweet_text.delegate = self;
    cell.tweet_text.text = tweet.text;
    
    cell.reply_count.text = [NSString stringWithFormat:@"%d", tweet.replyCount];
    cell.retweet_count.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favourites_count.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];

    NSString *profile_image_address = tweet.user.profile_image_address;
    NSURL *profile_image_url = [NSURL URLWithString:profile_image_address];
    
    cell.profile_image.image = nil;
    [cell.profile_image setImageWithURL:profile_image_url];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.max_ID = cell.tweet.id_num;
    
    return cell;
}

- (void)didTweet:(Tweet *)tweet{
    [self.tweet_array insertObject:tweet atIndex: 0];
    [self.tableView reloadData];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (IBAction)didTapSignOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

-(void)loadMoreData{
    
    // ... Create the NSURLRequest (myRequest) ...
    [[APIManager shared] loadMoreTweets:self.max_ID completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {

            self.tweet_array = [NSMutableArray arrayWithArray:tweets];
            
            // NSLog(@" Successfully loaded home timeline");
            // NSLog(@"%@", self.tweet_array);
            
            self.isMoreDataLoading = false;
            
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    
    if ([segue.identifier  isEqual: @"tweet_details_segue"]){
        // Pass the selected object to the new view controller.
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweet_array[indexPath.row];
        
        TweetDetailsViewController *tweetDetailViewController = [segue destinationViewController];
        tweetDetailViewController.tweet = tweet;
        
        }
    else if ([segue.identifier  isEqual: @"compose_segue"]){
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
        }
    }




@end
