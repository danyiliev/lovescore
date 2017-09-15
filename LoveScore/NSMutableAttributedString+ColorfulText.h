//
//  NSMutableAttributedString+ColorfulText.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/19/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ColorfulText)

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color;

@end
