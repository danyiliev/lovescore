//
//  PhotoCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "PhotoCell.h"
#import "EAIntroPage.h"
#import "UIImageView+Haneke.h"
#import "EAIntroView.h"


@interface PhotoCell () <EAIntroDelegate> {
    UIImageView *_imageView;
    UIView *_containerView;
    
    UIImage *_photo;
}

@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
}

- (void)prepareForReuse {
    [_containerView removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
}

- (void)setImagesPathArray:(NSArray *)imagesPathArray {
    _imagesPathArray = imagesPathArray;
    
    if (imagesPathArray.count > 0) {
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_containerView];
        
        NSMutableArray *pagesArray = [NSMutableArray new];
        
        for (int i = 0; i < imagesPathArray.count; i++) {
            EAIntroPage *page1 = [EAIntroPage page];
            page1.titleIconPositionY = 0;
            
            page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagesPathArray[i]]];
            page1.titleIconView.contentMode = UIViewContentModeScaleAspectFit;
            
            [page1.titleIconView setBackgroundColor:[UIColor blackColor]];
            
            [page1.titleIconView setFrame:_containerView.bounds];
            [pagesArray addObject:page1];
        }
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:_containerView.bounds andPages:pagesArray];
        
        intro.pageControlY -= 30;
        
        [intro setDelegate:self];
        
        [intro setSkipButton:nil];
        intro.scrollingEnabled = YES;
        intro.swipeToExit = NO;
        
        [intro showInView:_containerView animateDuration:0.3];
    }
}

- (void)setPhotosUrl:(NSArray *)photosUrl {
    _photosUrl = photosUrl;
    
    
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [_containerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_containerView];
    
    NSMutableArray *pagesArray = [NSMutableArray new];
    if (photosUrl.count > 0) {
        for (int i = 0; i < photosUrl.count; i++) {
            EAIntroPage *page1 = [EAIntroPage page];
            page1.titleIconPositionY = 0;
            NSString *photoUrl = [photosUrl[i] objectForKey:@"url"];
            page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]]];
            page1.titleIconView.contentMode = UIViewContentModeScaleAspectFill;
            
            [page1.titleIconView setBackgroundColor:[UIColor blackColor]];
            
            [page1.titleIconView setFrame:_containerView.bounds];
            [pagesArray addObject:page1];
        }
    } else {
        EAIntroPage *page1 = [EAIntroPage page];
        page1.titleIconPositionY = 25;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default-avatar"]];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        page1.titleIconView = imageView;
        page1.titleIconView.contentMode = UIViewContentModeScaleAspectFill;
        
        [page1.titleIconView setBackgroundColor:[UIColor whiteColor]];
        
        [page1.titleIconView setFrame:CGRectMake(_containerView.bounds.origin.x, _containerView.bounds.origin.y, _containerView.bounds.size.width - 20, _containerView.bounds.size.height - 30)];
        [pagesArray addObject:page1];
        
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:_containerView.bounds andPages:pagesArray];
    [intro setBackgroundColor:[UIColor whiteColor]];
    intro.pageControlY -= 30;
    
    [intro setDelegate:self];
    
    [intro setSkipButton:nil];
    intro.scrollingEnabled = YES;
    intro.swipeToExit = NO;
    
    [intro showInView:_containerView animateDuration:0.3];
    
}

@end
