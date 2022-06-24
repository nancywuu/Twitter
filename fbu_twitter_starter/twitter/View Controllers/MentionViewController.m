//
//  MentionViewController.m
//  twitter
//
//  Created by Nancy Wu on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "MentionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface MentionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    [self fetchMentions];
    //[[UINavigationBar appearance] setTranslucent:NO];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMentions) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchMentions {
    [[APIManager shared] getMentionTimeline:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"LOADED MENTIONS");
            for (Tweet *dictionary in tweets) {
                NSString *text = dictionary.text;
                //NSLog(@"%@", dictionary);
                NSLog(@"%@", text);
            }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MentionTweetCell" forIndexPath:indexPath];
    Tweet *current = self.arrayOfTweets[indexPath.row];
    cell.currentTweet = current;
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
