//
//  GirlCardVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGirlVCProtocol.h"

@interface GirlCardVC : UIViewController <AddGirlVCProtocol>

@property (strong, nonatomic) NSMutableArray *girls;
@property (strong, nonatomic) NSString *titleString;
- (void)refresh;

@end
