//
//  RatingsCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "RatingsCell.h"
#import "FullCardSlider.h"
#import "RoundRateView.h"

@interface RatingsCell ()

@property (weak, nonatomic) IBOutlet FullCardSlider *faceRatingSlider;
@property (weak, nonatomic) IBOutlet RoundRateView *faceRatingCustomView;

@property (weak, nonatomic) IBOutlet FullCardSlider *bustRatingSlider;
@property (weak, nonatomic) IBOutlet RoundRateView *bustRatingCustomView;

@property (weak, nonatomic) IBOutlet FullCardSlider *backRatingSlider;
@property (weak, nonatomic) IBOutlet RoundRateView *backRatingCustomView;

@property (weak, nonatomic) IBOutlet FullCardSlider *legsRatingSlider;
@property (weak, nonatomic) IBOutlet RoundRateView *legsRatingCustomView;

@property (strong, nonatomic) IBOutlet RoundRateView *characterRoundRateView;
@property (strong, nonatomic) IBOutlet RoundRateView *intelligenceRoundRateView;
@property (strong, nonatomic) IBOutlet RoundRateView *hairRoundRateView;
@property (strong, nonatomic) IBOutlet RoundRateView *kissingRoundRateView;
@property (strong, nonatomic) IBOutlet RoundRateView *oralRoundRateView;
@property (strong, nonatomic) IBOutlet RoundRateView *intercoursRoundRateView;

@end

@implementation RatingsCell

#pragma mark - setters
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //    first parameters
    [self.faceRatingCustomView setFontName:@"Lato-Medium" size:15];
    [self.legsRatingCustomView setFontName:@"Lato-Medium" size:15];
    [self.backRatingCustomView setFontName:@"Lato-Medium" size:15];
    [self.bustRatingCustomView setFontName:@"Lato-Medium" size:15];
    
    // second parameters
    
    [self.characterRoundRateView setFontName:@"Lato-Medium" size:15];
    [self.intelligenceRoundRateView setFontName:@"Lato-Medium" size:15];
    [self.hairRoundRateView setFontName:@"Lato-Medium" size:15];
    [self.kissingRoundRateView setFontName:@"Lato-Medium" size:15];
    [self.oralRoundRateView setFontName:@"Lato-Medium" size:15];
    [self.intercoursRoundRateView setFontName:@"Lato-Medium" size:15];
    
}

#pragma mark - Public sliders values
- (void) setFaceRate:(NSNumber *)faceRate {
    _faceRate = faceRate;

    [_faceRatingSlider setValue:[_faceRate floatValue] animated:YES];
    [_faceRatingCustomView setRoundRateViewValue:faceRate];
}

- (void) setBustRate:(NSNumber *)bustRate {
    _bustRate = bustRate;
    
    [_bustRatingSlider setValue:[_bustRate floatValue] animated:YES];
    [_bustRatingCustomView setRoundRateViewValue:bustRate];
}

- (void) setBackRate:(NSNumber *)backRate {
    _backRate = backRate;
    
    [_backRatingSlider setValue:[backRate floatValue] animated:YES];
    [_backRatingCustomView setRoundRateViewValue:backRate];
}

- (void) setLegsRate:(NSNumber *)legsRate{
    _legsRate = legsRate;
    
    [_legsRatingSlider setValue:[_legsRate floatValue] animated:YES];
    [_legsRatingCustomView setRoundRateViewValue:legsRate];
}

#pragma mark - Public round rate values

- (void)setCharacterRate:(NSNumber *)characterRate {
    _characterRate = characterRate;
    
    [self.characterRoundRateView setRoundRateViewValue:characterRate];
}

- (void)setIntelligenceRate:(NSNumber *)intelligenceRate {
    _intelligenceRate = intelligenceRate;
    
    [self.intelligenceRoundRateView setRoundRateViewValue:intelligenceRate];
}

- (void)setHairRate:(NSNumber *)hairRate {
    _hairRate = hairRate;
    
    [self.hairRoundRateView setRoundRateViewValue:hairRate];
}

- (void)setKissingRate:(NSNumber *)kissingRate {
    _kissingRate = kissingRate;
    
    [self.kissingRoundRateView setRoundRateViewValue:kissingRate];
}

- (void)setOralRate:(NSNumber *)oralRate {
    _oralRate = oralRate;
    
    [self.oralRoundRateView setRoundRateViewValue:oralRate];
}

- (void)setIntercoursRate:(NSNumber *)intercoursRate {
    _intercoursRate = intercoursRate;
    
    [self.intercoursRoundRateView setRoundRateViewValue:intercoursRate];
}

@end
