//
//  FullCardVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface FullCardVC : UIViewController

@property (strong, nonatomic) NSString *personIdentifier;
@property (strong, nonatomic) Person *person;
@end
