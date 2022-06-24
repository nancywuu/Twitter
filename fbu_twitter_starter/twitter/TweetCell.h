//
//  TweetCell.h
//  twitter
//
//  Created by Nancy Wu on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "DateTools.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@property (nonatomic, strong) Tweet *currentTweet;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorUser;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIButton *comments;
@property (weak, nonatomic) IBOutlet UIButton *retweets;
@property (weak, nonatomic) IBOutlet UIButton *likes;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

- (void)changeDate;

@end

@protocol TweetCellDelegate
// TODO: Add required methods the delegate needs to implement
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end

NS_ASSUME_NONNULL_END
