//
//  FullCardView.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface FullCardView : UIView

@property (strong, nonatomic) NSString *commentText;
@property (strong, nonatomic)Person *person;
@property (strong, nonatomic)NSArray *pictures;

- (void)reloadTableView;

@end