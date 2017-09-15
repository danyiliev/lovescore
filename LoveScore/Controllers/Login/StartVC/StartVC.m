//
//  StartVC.m
//  LoveScore
//
//  Created by Taras Pasichnykon 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StartVC.h"
#import "UIColor+ColorAdditions.h"
#import "UIImage+ImageAdditions.h"
#import "TTTAttributedLabel.h"
#import "CoreDataManager.h"
#import "DataStoreServices.h"
#import "DataStore.h"

@interface StartVC ()
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *logoLabel;

@end

@implementation StartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[SyncManager sharedInstance] connected]) {

        DataStoreServices *dataStore = [[DataStoreServices alloc]init];
        
        [[dataStore getDataStore] subscribeCompleted:^(void) {

        }];
    } else {
        
    }
    
    self.logoLabel.numberOfLines = 0;
    
    NSString *lString = self.logoLabel.text;

    [self.logoLabel setText:lString afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange redRange = [lString rangeOfString:@"Love"];
        if (redRange.location != NSNotFound) {

            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RED_COLOR.CGColor range:redRange];
        }
        
        return mutableAttributedString;
    }];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithImage:[UIImage imageNamed:@"bg-intro"] scaledToSize:self.view.frame.size]];
}

@end
