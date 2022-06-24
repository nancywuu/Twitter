//
//  ReplyViewController.h
//  twitter
//
//  Created by Nancy Wu on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "DateTools.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ReplyViewControllerDelegate
- (void)didReply:(Tweet *)tweet;
@end

@interface ReplyViewController : UIViewController
@property (nonatomic, weak) id<ReplyViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *originalImage;
@property (weak, nonatomic) IBOutlet UILabel *originalText;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *originalUser;
@property (weak, nonatomic) IBOutlet UILabel *originalName;
@property (weak, nonatomic) IBOutlet UILabel *originalDate;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *replyingTo;
@property (nonatomic, strong) Tweet *currentTweet;

@end

NS_ASSUME_NONNULL_END
