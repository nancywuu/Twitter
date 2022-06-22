//
//  TweetCell.m
//  twitter
//
//  Created by Nancy Wu on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell
- (IBAction)didTapComment:(id)sender {
    self.currentTweet.commented = YES;
    self.currentTweet.commentCount += 1;
    NSLog(@"comment button tapped");
    [self refreshData];
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.currentTweet.retweeted == NO){
        self.currentTweet.retweeted = YES;
        self.currentTweet.retweetCount += 1;
        [self.retweets setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    } else {
        self.currentTweet.retweeted = NO;
        self.currentTweet.retweetCount -= 1;
        [self.retweets setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    [[APIManager shared] retweet:self.currentTweet completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error rting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully rted the following Tweet: %@", tweet.text);
         }
     }];
    
    NSLog(@"rt button tapped");
    [self refreshData];
    
}
- (IBAction)didTapLike:(id)sender {
    if(self.currentTweet.favorited == NO){
        self.currentTweet.favorited = YES;
        self.currentTweet.favoriteCount += 1;
        [self.likes setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        
    } else {
        self.currentTweet.favorited = NO;
        self.currentTweet.favoriteCount -= 1;
        [self.likes setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    [[APIManager shared] favorite:self.currentTweet completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
         }
     }];
    
    NSLog(@"like button tapped");
    [self refreshData];
}
- (IBAction)didTapMessage:(id)sender {
}

- (void)refreshData {
    [self.likes setTitle:[NSString stringWithFormat:@"%d",self.currentTweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweets setTitle:[NSString stringWithFormat:@"%d",self.currentTweet.retweetCount] forState:UIControlStateNormal];
    [self.comments setTitle:[NSString stringWithFormat:@"%d",self.currentTweet.commentCount] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
