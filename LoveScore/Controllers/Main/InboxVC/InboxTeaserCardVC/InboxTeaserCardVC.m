//
//  InboxTeaserCardVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/4/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "InboxTeaserCardVC.h"
#import "SharingTeaserCardView.h"
#import "UIView+ViewCreator.h"
#import "UINavigationItem+CustomBackButton.h"
#import "SharingServices.h"
#import "AppDelegate.h"

@interface InboxTeaserCardVC ()

@property (strong, nonatomic)SharingTeaserCardView *teaserCard;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic)NSTimer *timer;
@property (nonatomic)NSTimeInterval time;
@property (strong, nonatomic)NSDate *nowDate;
@property (strong, nonatomic)NSDate *cardDate;
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UIBarButtonItem *timeItem;
@property (weak, nonatomic)AppDelegate *appDelegate;
@property (nonatomic) NSInteger timeLeft;

@end

@implementation InboxTeaserCardVC

#pragma mark - life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.teaserCard = [SharingTeaserCardView createView];
    self.appDelegate = APP_DELEGATE;
    NSError *error = nil;
    
    if (self.card.person.count == 0 && !self.person) {
        [self showAlertControllerWithTitle:@"Server error" withMessage:@"Wrong data." withCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else if (!self.person) {
        self.person = [MTLJSONAdapter modelOfClass:[Person class] fromJSONDictionary:self.card.person error:&error];
        NSDictionary *photoDictionary = [self.card.person objectForKey:@"pictures"];
        if (photoDictionary.count > 0) {
            [self.teaserCard setPhotoWithString:[photoDictionary objectForKey:@"url"]];
        }
    } else if(self.person) {
        [self.teaserCard loadImageWithPhotoUUID:self.person.uuid];
    }
    
    [self.teaserCard setPersonModel:self.person];
    [self.containerView addSubview:self.teaserCard];
    self.timeLeft = 10;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES];
    
    
    //
    //    if (!self.person) {
    //        [[sharingServ getRetrieveSingleCardWithIdent:self.ident] subscribeNext:^(id x) {
    //            self.card = (CardModel *)x;
    //
    //            NSError *error;
    //            Person *person = [MTLJSONAdapter modelOfClass:[Person class] fromJSONDictionary:self.card.person error:&error];
    //            if (person) {
    //                NSDictionary *photoDictionary = [self.card.person objectForKey:@"pictures"];
    //                if (photoDictionary.count > 0) {
    //                      [self.teaserCard setPhotoWithString:[[photoDictionary objectForKey:@"pictures"] objectForKey:@"url"]];
    //                }
    //                [self.teaserCard setPersonModel:person];
    //                self.cardDate = [self.appDelegate.timeDictionary objectForKey:self.card.ident];
    //                if (!self.cardDate) {
    //                    self.cardDate = [NSDate date];
    //                    [self.appDelegate.timeDictionary setObject:self.cardDate forKey:self.card.ident];
    //                }
    //                [self.containerView addSubview:self.teaserCard];
    //            }  else {
    //
    //                [self showAlertControllerWithTitle:@"Server error" withMessage:@"Wrong data." withCompletion:^{
    //                    [self.navigationController popViewControllerAnimated:YES];
    //                }];
    //
    //            }
    //
    //        }];
    //    }
    //    [self createTimeLabelRightBarItem];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
}


- (void)viewDidLayoutSubviews {
    [self.teaserCard setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
    
    
}

#pragma mark - Private methods

- (void)tick {
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"00:%02zd",self.timeLeft]];
    self.timeLeft -- ;
    if (self.timeLeft == 0) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark Bar Buttons Actions


-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTimeLabelRightBarItem {
    UILabel *label = [UILabel new];
    [self.navigationItem.rightBarButtonItem setCustomView:label];
}

- (void)dealloc {
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
