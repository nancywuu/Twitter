//
//  DetailViewController.h
//  twitter
//
//  Created by Nancy Wu on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DetailViewControllerDelegate
- (void)didChange;
@end

@interface DetailViewController : UIViewController
@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *detailTweet;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorUser;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIButton *comms;
@property (weak, nonatomic) IBOutlet UIButton *retweets;
@property (weak, nonatomic) IBOutlet UIButton *likes;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@end

NS_ASSUME_NONNULL_END
