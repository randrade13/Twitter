//
//  ComposeViewController.h

//  twitter
//
//  Created by rodrigoandrade on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@protocol ComposeViewControllerDelegate
- (void)didTweet:(Tweet *)tweet;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
