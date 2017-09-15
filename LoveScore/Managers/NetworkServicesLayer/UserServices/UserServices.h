//
//  UserServicesImplementation.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIHTTPClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@protocol UserServicesDelegate <NSObject>

- (void)showErrorMessage:(NSString *)message;

@end

@interface UserServices : NSObject

@property (nonatomic, weak) id<UserServicesDelegate> delegate;

- (RACSignal *)uploadAvatarImage:(UIImage *)image
                          inView:(UIView *)imageView;


- (RACSignal *)loginWithUsername:(NSString *)username password:(NSString *)password;

- (RACSignal *)registrationWithUsername:(NSString *)username
                               password:(NSString *)password
                                  email:(NSString *)email
                                country:(NSString *)country;
- (RACSignal *)retrieveUserDetails;
- (RACSignal *)updateUserDetailsWithField:(NSString *)field value:(id)value;
- (RACSignal *)removeUserImage;
- (RACSignal *)getNewPasswordForUserWithUsername:(NSString *)username;
- (RACSignal *)wipeUserAcount;
- (RACSignal *)uploadNotificationSettings:(NSDictionary *)params;

@end
