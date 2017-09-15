//
//  PlaceholderTextView.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 3/28/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (strong, nonatomic) NSString *placeholder;
- (void)showOrHidePlaceholder;
@end
