//
//  PhotoCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define PhotoCellId @"PhotoCellId"

#import <UIKit/UIKit.h>

@interface PhotoCell : UITableViewCell

@property (nonatomic, strong) NSArray *imagesPathArray;
@property (nonatomic, strong) NSArray *photosUrl;

@end
