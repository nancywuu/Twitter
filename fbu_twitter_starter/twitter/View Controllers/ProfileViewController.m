//
//  ProfileViewController.m
//  twitter
//
//  Created by Nancy Wu on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "DetailViewController.h"

@interface ProfileViewController () <DetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL *isFromTab;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    NSLog(@"loaded in PROFILE");
    [[APIManager shared] getUser:^(NSString *screenName, NSError *error) {
        if (screenName) {
//            NSLog(@"SCNREE NAME");
//            NSLog(@"%@", screenName);
            //self.ourName = screenName;
            [[APIManager shared] getImageFromUser:screenName completion:^(User *user, NSError *error) {
                if (user) {
//                    NSLog(@"USER NAME");
//                    NSLog(@"%@", screenName);
                    //NSString *URLString = user.profilePicture;
                    NSLog(@"setting user");
                    self.user = user;
                    [self setProfile];
                } else {
                    NSLog(@"😫Error getting url from user : %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"😫Error getting username: %@", error.localizedDescription);
        }
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didChange {
    [self fetchUserTweets];
}

- (void)setProfile {
    self.userName.text = self.user.name;
    self.userUser.text = [NSString stringWithFormat:@"%s%@", "@", self.user.screenName];
    //[NSString stringWithFormat:@"%s/%@", "@", current.user.screenName]
    self.followerCount.text = [NSString stringWithFormat:@"%i%s", self.user.followers, " followers"];
    self.followingCount.text = [NSString stringWithFormat:@"%i%s", self.user.following, " following"];
    self.location.text = self.user.location;
    self.userBio.text = self.user.bio;
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSString *backString = self.user.backgroundPicture;
    NSURL *urlBack = [NSURL URLWithString:backString];
    self.joinDate.text = [NSString stringWithFormat:@"%s%@", "Joined ", self.user.joinDate];
    //NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    // formatting for images
    [self.pfpImage setImageWithURL:url];
    [self.bgImage setImageWithURL:urlBack];
    NSLog(@"hit profile viewdidload");
    NSLog(@"%@", self.user.screenName);
    [self fetchUserTweets];
    //[[UINavigationBar appearance] setTranslucent:NO];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchUserTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchUserTweets {
    [[APIManager shared] getUserTimeline:self.user.screenName completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            //NSString *URLString = user.profilePicture;
            NSLog(@"😎Successfully loaded user timeline");
            self.arrayOfTweets = (NSMutableArray*) tweets;
            //[self setPFP:URLString];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫Error getting url from user : %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTweetCell" forIndexPath:indexPath];
    Tweet *current = self.arrayOfTweets[indexPath.row];
    //cell.delegate = self;
    cell.currentTweet = current;
    NSLog(@"%@", current.text);
    
    // formating for text
    cell.text.text = current.text;
    cell.authorName.text = current.user.name;
    cell.authorUser.text = [NSString stringWithFormat:@"%s/%@", "@", current.user.screenName];;
    cell.date.text = current.createdAtString;
    //NSLog(@"%@", current.createdAtString);
    [cell changeDate];
    
    //cell.retweets.value = current.retweetCount;
    NSString *URLString = current.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    //NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    // formatting for images
    [cell.profileImage setImageWithURL:url];
    cell.profileImage.layer.borderWidth = 1;
    cell.profileImage.layer.masksToBounds = false;
//    cell.profileImage.layer.borderColor = UIColor.black.cgColor;
//    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height/2;
    cell.profileImage.clipsToBounds = true;
    
    // formatting for buttons
    [cell.likes setTitle:[NSString stringWithFormat:@"%d",current.favoriteCount] forState:UIControlStateNormal];
    [cell.retweets setTitle:[NSString stringWithFormat:@"%d",current.retweetCount] forState:UIControlStateNormal];
    [cell.comments setTitle:[NSString stringWithFormat:@"%d",current.commentCount] forState:UIControlStateNormal];
    [cell.retweets setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    [cell.likes setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    if(current.retweeted == YES){
        [cell.retweets setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    if(current.favorited == YES){
        [cell.likes setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    
    //cell.currentTweet = [[Tweet alloc] initWithDictionary:<#(nonnull NSDictionary *)#>:*dict];;
    return cell;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[TweetCell class]]){
        TweetCell *cell = sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
    //     Pass the selected object to the new view controller.
        Tweet *dataToPass = self.arrayOfTweets[path.row];
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.delegate = self;
        detailVC.detailTweet = dataToPass;
    }
}


@end
