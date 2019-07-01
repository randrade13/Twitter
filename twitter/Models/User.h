//
//  User.h
//  twitter
//
//  Created by rodrigoandrade on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// define properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;

// create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
