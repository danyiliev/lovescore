//
//  User.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 12/25/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface User : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *displayName;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSDate *dateOfBirth;
@property (nonatomic, strong)NSString *language;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSDate *createdAt;
@property (nonatomic, strong)NSString *avatarUrl;

@property (nonatomic, strong) NSDictionary *generalNotification;
@property (nonatomic, strong) NSDictionary *girlsNotification;
@property (nonatomic, strong) NSDictionary *friendsNotification;
@property (nonatomic, strong) NSDictionary *city;

- (BOOL)fromUS;

@end
