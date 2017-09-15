//
//  RatingsCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define RatingsCellId @"RatingsCellId"

#import <UIKit/UIKit.h>

@interface RatingsCell : UITableViewCell

// slider values
@property (nonatomic) NSNumber *faceRate;
@property (nonatomic) NSNumber * bustRate;
@property (nonatomic) NSNumber * backRate;
@property (nonatomic) NSNumber * legsRate;

// round rate view values
@property (nonatomic) NSNumber * characterRate;
@property (nonatomic) NSNumber * intelligenceRate;
@property (nonatomic) NSNumber * hairRate;
@property (nonatomic) NSNumber * kissingRate;
@property (nonatomic) NSNumber * oralRate;
@property (nonatomic) NSNumber * intercoursRate;


@end
