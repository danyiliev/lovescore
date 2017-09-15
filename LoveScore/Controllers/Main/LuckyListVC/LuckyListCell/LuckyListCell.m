//
//  LuckyListCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/20/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "LuckyListCell.h"
#import "RoundRateView.h"
#import "ImageManager.h"
#import "CoreDataManager.h"

@interface LuckyListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellNumberLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet RoundRateView *rateView;



@end

@implementation LuckyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // set photo layer
    [_photoImageView setImage:[UIImage imageNamed:@"checkin-avatar-upload"]];
    _photoImageView.layer.cornerRadius = _photoImageView.frame.size.height / 2;
    _photoImageView.clipsToBounds = YES;
    
    // label
    [_nameLabel sizeToFit];
    [_ageLabel sizeToFit];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _ageLabel.adjustsFontSizeToFitWidth = YES;
    
    //    [self setRateWithValue:@"0.9"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setLuckyListCellColor:(CellColor)luckyListCellColor {
    _luckyListCellColor = luckyListCellColor;
    
    if (luckyListCellColor == CellColorLighter) {
        [self setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    }
}

- (void)setPerson:(Person *)person cellNumber:(NSInteger)cellNUmber countriesDictionary:(NSDictionary *)countriesDictionary rating:(NSNumber *)rating {
    if (person.lastName) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",person.firstName, person.lastName];
    } else {
        self.nameLabel.text = person.firstName;
    }
    
    if(rating){
        [self.rateView setRoundRateViewValue:rating];
    } else {
    [self.rateView setRoundRateViewValue:person.rating];
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@ years",[person.age stringValue]];
    [self setGirlNumber:cellNUmber];
    [self.flagImageView setImage:person.flagImage];

    [self loadImageWithPhotoUUID:person.uuid];
}

- (void)loadImageWithPhotoUUID:(NSString *)photoUUID {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image =  [UIImage imageWithContentsOfFile:[[ImageManager sharedInstance].avatarDictionaries objectForKey:photoUUID]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (image) {
                self.photoImageView.image = image;
            } else {
                [self.photoImageView setImage:[UIImage imageNamed:@"checkin-avatar-nocamera"]];
            }
        });
    });
}

- (void)setGirlNumber:(NSInteger)girlNumber {
    _girlNumber = girlNumber;
    
    [self.cellNumberLable setText:[NSString stringWithFormat:@"%ld.", (long)girlNumber]];
}
@end
