//
//  MyGirlsVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MyGirlsVC : UIViewController
@property (strong, nonatomic)NSArray *girls;
@property (assign, nonatomic)BOOL isFiltered;
@property (strong, nonatomic)NSString *titleString;
@end
