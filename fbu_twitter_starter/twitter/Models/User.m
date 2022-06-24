//
//  User.m
//  twitter
//
//  Created by Nancy Wu on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.followers = [dictionary[@"followers_count"] intValue];
        self.following = [dictionary[@"friends_count"] intValue];
        self.bio = dictionary[@"description"];
        self.location = dictionary[@"location"];
        self.backgroundPicture = dictionary[@"profile_banner_url"];
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.joinDate = [formatter stringFromDate:date];
    // Initialize any other properties
    }
    return self;
}

@end
