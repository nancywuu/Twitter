//
//  ReplyViewController.m
//  twitter
//
//  Created by Nancy Wu on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ReplyViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ReplyViewController () <UITextViewDelegate>

@end

@implementation ReplyViewController
- (IBAction)didReply:(id)sender {
    [[APIManager shared]postReply:self.textView.text status_id:self.currentTweet.idStr completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didReply:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
            NSLog(@"Compose Tweet Success!");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originalUser.text = [NSString stringWithFormat:@"%s%@", "@", self.currentTweet.user.name];
    self.originalText.text = self.currentTweet.text;
    self.originalName.text = self.currentTweet.user.screenName;
    self.replyingTo.text = [NSString stringWithFormat:@"%s%@", "Replying to @", self.currentTweet.user.name];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *temp = [[NSDate alloc] init];
    temp = [dateFormatter dateFromString:self.currentTweet.createdAtString];
    NSString *shortTimeAgo = [temp shortTimeAgoSinceNow];
    self.originalDate.text = shortTimeAgo;
    
    self.textView.text = @"Type your thoughts here...";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    NSString *urlSt = self.currentTweet.user.profilePicture;
    
    NSURL *urlTemp = [NSURL URLWithString:urlSt];
    [self.originalImage setImageWithURL:urlTemp];

    [[APIManager shared] getUser:^(NSString *screenName, NSError *error) {
        if (screenName) {
//            NSLog(@"SCNREE NAME");
//            NSLog(@"%@", screenName);
            //self.ourName = screenName;
            [[APIManager shared] getImageFromUser:screenName completion:^(User *user, NSError *error) {
                if (user) {
//                    NSLog(@"USER NAME");
//                    NSLog(@"%@", screenName);
                    NSString *URLString = user.profilePicture;
                    
                    NSURL *url = [NSURL URLWithString:URLString];
                    NSLog(@"%@", url);
                    [self.myImage setImageWithURL:url];
                } else {
                    NSLog(@"😫Error getting url from user : %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"😫Error getting username: %@", error.localizedDescription);
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //NSLog(@"hit begin editing");
    if([textView.text isEqualToString: @"Type your thoughts here..."]) {
        //NSLog(@"if passed");
        textView.text = [NSString stringWithFormat:@"%s%@%s", "@", self.currentTweet.user.screenName, " "];
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
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
