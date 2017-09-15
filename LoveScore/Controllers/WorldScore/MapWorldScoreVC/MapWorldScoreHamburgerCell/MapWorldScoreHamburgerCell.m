//
//  MapWorldScoreHamburgerCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MapWorldScoreHamburgerCell.h"
#import "CollectionViewItem.h"
#import "CoreDataManager.h"

@interface MapWorldScoreHamburgerCell()

@property (strong, nonatomic)UITapGestureRecognizer *tapRecognizer;

@end

@implementation MapWorldScoreHamburgerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_colectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewItem class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewItem class])];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItem:)];
    [[self.colectionView superview] addGestureRecognizer:self.tapRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCountriesNames:(NSArray *)countriesNames {
    _countriesNames = countriesNames;
}

#pragma mark - Colection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.countriesNames.count;
}

#pragma mark - Colection view delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewItem class]) forIndexPath:indexPath];
    
    NSString *imageName = [self.countriesNames objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed: imageName];
    [item.flagImageView setImage:image];
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Actions

- (IBAction)tapOnItem:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:self.colectionView];
        NSIndexPath *indexPath = [self.colectionView indexPathForItemAtPoint:point];
        if (indexPath)
        {
            if ([_delegate respondsToSelector:@selector(selectCountry:)]) {
                [_delegate selectCountry:[self.countriesNames objectAtIndex:indexPath.row]];
            }
        }
        else
        {
            
        }
    }
}


@end
