//
//  AddGirlVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGirlVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *girlId;
@property (nonatomic, assign, getter=isFiltered) BOOL filtered;

@end
