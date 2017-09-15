//
//  NetworkActivityIndicator.h
//  MoveboxTF
//
//  Created by  Кирилл Легкодух on 06.10.15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkActivityIndicator : NSObject

+ (instancetype)sharedNetworkActivityIndicator;

- (void)showLoader;
- (void)showLoaderWithText:(NSString *)text;
- (void)hideLoader;

@end
