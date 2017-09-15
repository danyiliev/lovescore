//
//  ActionDateView.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/7/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionDateView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateLable;

- (void)setDate:(NSDate *)date;

@end
