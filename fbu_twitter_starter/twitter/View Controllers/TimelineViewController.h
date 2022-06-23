//
//  TimelineViewController.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TimelineViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)didTweet:(Tweet *)tweet;
- (void)didChange;
@end
