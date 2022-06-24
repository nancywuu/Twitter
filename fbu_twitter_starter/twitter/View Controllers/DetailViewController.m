//
//  DetailViewController.m
//  twitter
//
//  Created by Nancy Wu on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
- (IBAction)didTapRetweet:(id)sender {
    if(self.detailTweet.retweeted == NO){
        self.detailTweet.retweeted = YES;
        self.detailTweet.retweetCount += 1;
        [self.retweets setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [[APIManager shared] retweet:self.detailTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error rting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully rted the following Tweet: %@", tweet.text);
                 [self.delegate didChange];
             }
         }];
    } else {
        self.detailTweet.retweeted = NO;
        self.detailTweet.retweetCount -= 1;
        [self.retweets setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [[APIManager shared] unretweet:self.detailTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unrting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unrted the following Tweet: %@", tweet.text);
                 [self.delegate didChange];
             }
         }];
    }
    NSLog(@"rt button tapped");
    [self refreshData];
}

- (IBAction)didTapLike:(id)sender {
    if(self.detailTweet.favorited == NO){
        self.detailTweet.favorited = YES;
        self.detailTweet.favoriteCount += 1;
        [self.likes setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [[APIManager shared] favorite:self.detailTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                 [self.delegate didChange];
             }
         }];
        
    } else {
        self.detailTweet.favorited = NO;
        self.detailTweet.favoriteCount -= 1;
        [self.likes setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [[APIManager shared] unfavorite:self.detailTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                 [self.delegate didChange];
             }
         }];
    }
    
    
    NSLog(@"like button tapped");
    [self refreshData];
}
- (void)refreshData {
    [self.likes setTitle:[NSString stringWithFormat:@"%d",self.detailTweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweets setTitle:[NSString stringWithFormat:@"%d",self.detailTweet.retweetCount] forState:UIControlStateNormal];
    [self.comms setTitle:[NSString stringWithFormat:@"%d",self.detailTweet.commentCount] forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.authorName.text = self.detailTweet.user.name;
    self.authorUser.text = self.detailTweet.user.screenName;
    self.text.text = self.detailTweet.text;
    self.date.text = self.detailTweet.createdAtString;

    NSString *URLString = self.detailTweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileImage setImageWithURL:url];
    self.profileImage.layer.borderWidth = 1;
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.clipsToBounds = true;
    
    // formatting for buttons
    [self.likes setTitle:[NSString stringWithFormat:@"%d",self.detailTweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweets setTitle:[NSString stringWithFormat:@"%d",self.detailTweet.retweetCount] forState:UIControlStateNormal];
    [self.comms setTitle:[NSString stringWithFormat:@"%d",self.detailTweet.commentCount] forState:UIControlStateNormal];
    if(self.detailTweet.retweeted == YES){
        [self.retweets setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    if(self.detailTweet.favorited == YES){
        [self.likes setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
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
