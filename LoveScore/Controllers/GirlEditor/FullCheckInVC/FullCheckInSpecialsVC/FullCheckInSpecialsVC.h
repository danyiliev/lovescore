//
//  FullCheckInSpecialsVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface FullCheckInSpecialsVC : UIViewController

@property (nonatomic, strong) Person *person;

- (void)savePerson;

@end
