//
//  FullCheckInVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface FullCheckInVC : UIViewController

@property (strong, nonatomic)Person *person;
@property (nonatomic, strong) NSString *girlId;
@property (assign, nonatomic) BOOL isEditMode;

@end
