//
//  ChangePasscodeVC.h
//  LoveScore
//
//  Created by Taras Pasichnyk on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavePasscodeVC : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *firstPasscode;
@property (nonatomic, strong) NSString *username;

@end
