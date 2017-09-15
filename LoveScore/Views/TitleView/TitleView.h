//
//  TitleView.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 3/21/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *witdhConstraint;

@end
