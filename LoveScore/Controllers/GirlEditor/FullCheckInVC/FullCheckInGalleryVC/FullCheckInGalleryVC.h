//
//  FullCheckInGalleryVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"  

@protocol FullCheckInGalleryDelegate <NSObject>

- (void)avatarWasChanged;

@end

@interface FullCheckInGalleryVC : UIViewController

@property (nonatomic, strong) Person *person;

@property (nonatomic, weak) id<FullCheckInGalleryDelegate> delegate;

@end
