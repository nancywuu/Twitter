//
//  User.h
//  twitter
//
//  Created by Nancy Wu on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *backgroundPicture;
@property (nonatomic) int *followers;
@property (nonatomic) int *following;
@property (nonatomic, strong) NSString *joinDate;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *bio;


// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
