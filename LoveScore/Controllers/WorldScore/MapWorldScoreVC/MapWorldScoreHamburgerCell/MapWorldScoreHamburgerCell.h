//
//  MapWorldScoreHamburgerCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MapWorldScoreHamburgerCell <NSObject>

- (void)selectCountry:(NSString *)country;

@end


@interface MapWorldScoreHamburgerCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *colectionView;
@property (weak, nonatomic) id <MapWorldScoreHamburgerCell> delegate;
@property (nonatomic, strong) NSArray *countriesNames;

@end
