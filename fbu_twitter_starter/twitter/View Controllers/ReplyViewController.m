//
//  ReplyViewController.m
//  twitter
//
//  Created by Nancy Wu on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ReplyViewController.h"

@interface ReplyViewController ()

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originalUser.text = self.currentTweet.user.screenName;
    self.originalText.text = self.currentTweet.text;
    self.originalName.text = self.currentTweet.user.name;
    self.replyingTo.text = [NSString stringWithFormat:@"%s%@", "Replying to @", self.currentTweet.user.name];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *temp = [[NSDate alloc] init];
    temp = [dateFormatter dateFromString:self.currentTweet.createdAtString];
    NSString *shortTimeAgo = [temp shortTimeAgoSinceNow];
    self.originalDate.text = shortTimeAgo;
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
