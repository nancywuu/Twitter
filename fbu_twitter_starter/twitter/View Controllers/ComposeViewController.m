//
//  ComposeViewController.m
//  twitter
//
//  Created by Nancy Wu on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) NSString *ourName;

@end

@implementation ComposeViewController
- (IBAction)tweetOut:(id)sender {
    [[APIManager shared]postStatusWithText:self.textField.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
            NSLog(@"Compose Tweet Success!");
        }
    }];
}
- (IBAction)closeOut:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.text = @"Type your thoughts here...";
    self.textField.textColor = [UIColor lightGrayColor];
    self.textField.delegate = self;
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
                    
                    [self setPFP:URLString];
                } else {
                    NSLog(@"😫Error getting url from user : %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"😫Error getting username: %@", error.localizedDescription);
        }
    }];
}

- (void)setPFP:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);
    [self.profileImage setImageWithURL:url];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //NSLog(@"hit begin editing");
    if([textView.text isEqualToString: @"Type your thoughts here..."]) {
        //NSLog(@"if passed");
        textView.text = @"";
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
