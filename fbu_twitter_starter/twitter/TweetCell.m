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
        [[APIManager shared] retweet:self.currentTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error rting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully rted the following Tweet: %@", tweet.text);
             }
         }];
    } else {
        self.currentTweet.retweeted = NO;
        self.currentTweet.retweetCount -= 1;
        [self.retweets setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [[APIManager shared] unretweet:self.currentTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unrting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unrted the following Tweet: %@", tweet.text);
             }
         }];
    }
    
    NSLog(@"rt button tapped");
    [self refreshData];
    
}
- (IBAction)didTapLike:(id)sender {
    if(self.currentTweet.favorited == NO){
        self.currentTweet.favorited = YES;
        self.currentTweet.favoriteCount += 1;
        [self.likes setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [[APIManager shared] favorite:self.currentTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
        
    } else {
        self.currentTweet.favorited = NO;
        self.currentTweet.favoriteCount -= 1;
        [self.likes setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [[APIManager shared] unfavorite:self.currentTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    
    
    NSLog(@"like button tapped");
    [self refreshData];
}

- (void)refreshData {
    [self.likes setTitle:[NSString stringWithFormat:@"%d",self.currentTweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweets setTitle:[NSString stringWithFormat:@"%d",self.currentTweet.retweetCount] forState:UIControlStateNormal];
    [self.comments setTitle:[NSString stringWithFormat:@"%d",self.currentTweet.commentCount] forState:UIControlStateNormal];
}

- (void)changeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *temp = [[NSDate alloc] init];
    temp = [dateFormatter dateFromString:self.currentTweet.createdAtString];
    NSString *shortTimeAgo = [temp shortTimeAgoSinceNow];
    //NSLog(@"%@", shortTimeAgo);
    self.date.text = shortTimeAgo;


    //NSString *dateString = [timeFormatter stringFromDate: localDate];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    //TODO: Call method delegate
    NSLog(@"TWEETCELL did tap user profile");
    NSLog(@"%@", self.currentTweet.user.screenName);
    [self.delegate tweetCell:self didTap:self.currentTweet.user];
    
    //[self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImage addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImage setUserInteractionEnabled:YES];
    NSLog(@"Awake from nib!");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
