//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "DetailViewController.h"
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "ReplyViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <TweetCellDelegate, ReplyViewControllerDelegate, DetailViewControllerDelegate, ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController
- (IBAction)didTapLogout:(id)sender {
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}
//- (void) viewDidAppear:(BOOL) animated{
//    [super viewDidAppear: animated];
//    // Get timeline
//    [self fetchTweets];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchTweets];
    //[[UINavigationBar appearance] setTranslucent:NO];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    NSLog(@"viewDidLoad Timeline");
    
}

//TimelineViewController.h
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // TODO: Perform segue to profile view controller
    NSLog(@"segue activated");
    NSLog(@"%@", user.screenName);
    
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (Tweet *dictionary in tweets) {
//                NSString *text = dictionary.text;
//                //NSLog(@"%@", dictionary);
//                NSLog(@"%@", text);
//            }
            self.arrayOfTweets = (NSMutableArray*) tweets;
//            NSDictionary *dict = self.arrayOfTweets[1];
//            NSLog(@"%@", dict);
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet *)tweet {
    [self fetchTweets];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"😎we've tweeted!");
    }];
}

- (void)didChange {
    [self fetchTweets];
}

- (void)didReplyChange {
    [self fetchTweets];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *current = self.arrayOfTweets[indexPath.row];
    cell.delegate = self;
    cell.currentTweet = current;
    //NSLog(@"%@", current.text);
    
    // formating for text
    cell.text.text = current.text;
    cell.authorName.text = current.user.name;
    cell.authorUser.text = [NSString stringWithFormat:@"%s%@", "@", current.user.screenName];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[TweetCell class]]){
        TweetCell *cell = sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        Tweet *dataToPass = self.arrayOfTweets[path.row];
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.delegate = self;
        detailVC.detailTweet = dataToPass;
    } else if([sender isKindOfClass:[UIButton class]]) {
        TweetCell *cell = sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        Tweet *dataToPass = self.arrayOfTweets[path.row];
        ReplyViewController *replyVC = [segue destinationViewController];
        replyVC.delegate = self;
        replyVC.currentTweet = dataToPass;
    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if (([segue.identifier isEqualToString:@"profileSegue"])){
        NSLog(@"timeline segue activated");
        User *temp = sender;
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = temp;
    }
}

@end
