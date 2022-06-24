//
//  ProfileViewController.h
//  twitter
//
//  Created by Nancy Wu on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *pfpImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userUser;
@property (weak, nonatomic) IBOutlet UILabel *userBio;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *joinDate;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (nonatomic, strong) User *user;
@property BOOL isFromTab;
@property BOOL isFromTimeline;
@end

NS_ASSUME_NONNULL_END
