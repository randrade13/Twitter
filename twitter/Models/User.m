//
//  User.m
//  twitter
//
//  Created by rodrigoandrade on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

// init method
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screenName"];

        // Initialize any other properties
    }
    return self;
}

@end
