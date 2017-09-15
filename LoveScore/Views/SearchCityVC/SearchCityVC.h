//
//  SearchCityVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/8/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SearchCityProtocol <NSObject>

- (void)cityWasSelected:(NSDictionary *)city;

@end

@interface SearchCityVC : UIViewController

@property (nonatomic, strong) NSString *country;
@property (nonatomic, weak) id<SearchCityProtocol> delegate;

@end
