//
//  InboxCardVC.m
//  LoveScore
//
//  Created by админ on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "InboxCardVC.h"
#import "FullCardView.h"
#import "UIView+ViewCreator.h"
#import "UINavigationItem+CustomBackButton.h"
#import "SharingServices.h"
#import "AppDelegate.h"
#import "CardEntity.h"
#import "CoreDataManager.h"

@interface InboxCardVC ()


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) FullCardView *fullCardView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSDate *cardDate;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger timeLeft;
@end

@implementation InboxCardVC

#pragma mark - life cycle methods
- (void)viewDidLoad {

    [super viewDidLoad];
    _fullCardView = [FullCardView createView];
    [_fullCardView setFrame:CGRectMake(0, 64, _containerView.frame.size.width, _containerView.frame.size.height - 64)];
    NSError *error = nil;
    _fullCardView.person = [MTLJSONAdapter modelOfClass:[Person class] fromJSONDictionary:self.card.person error:&error];
    _fullCardView.pictures = [self.card.person objectForKey:@"pictures"];
    [_containerView addSubview:_fullCardView];
    self.cardDate = [NSDate date];
    self.timeLeft = 30;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES];
  //  _fullCardView.person = self.person;
    
//    self.appDelegate = [UIApplication sharedApplication].delegate;
//
//    if ([self setupDataFromDataBase]) {
//        _fullCardView.person = self.person;
//        _fullCardView.pictures = [self.card.person objectForKey:@"pictures"];
//        [_containerView addSubview:_fullCardView];
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                                      target:self
//                                                    selector:@selector(tick)
//                                                    userInfo:nil
//                                                     repeats:YES];
//    } else {
//  
//    if (!self.person) {
//        [[shareServ getRetrieveSingleCardWithIdent:self.ident] subscribeNext:^(id x) {
//            self.card = (CardModel *)x;
//            NSError *error;
//            Person *person = [MTLJSONAdapter modelOfClass:[Person class] fromJSONDictionary:self.card.person error:&error];
//            if (person) {
//            
//            _fullCardView.person = person;
//            _fullCardView.pictures = [self.card.person objectForKey:@"pictures"];
//            if (!self.cardDate) {
//                self.cardDate = [NSDate date];
//            }
//                CardEntity *cardEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:[[CoreDataManager instance] managedObjectContext]];
//                cardEntity.ident = self.card.ident;
//                cardEntity.person = self.card.person;
//                cardEntity.expire_date = self.cardDate;
//                [[CoreDataManager instance] saveContext];
//                
//                [_containerView addSubview:_fullCardView];
//                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                                              target:self
//                                                            selector:@selector(tick)
//                                                            userInfo:nil
//                                                             repeats:YES];
//            } else {
//                [self showAlertControllerWithTitle:@"Server error!" withMessage:@"No data." withCompletion:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//            }
//        }];
//    }
//    }
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
}

//- (BOOL)setupDataFromDataBase {
//    
//    BOOL success = NO;
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Card"];
//    NSPredicate *identPredicate = [NSPredicate predicateWithFormat:@"(SELF.ident == %@)",self.ident];
//    [fetchRequest setPredicate:identPredicate];
//    [fetchRequest setReturnsObjectsAsFaults:NO];
//
//    NSError *error = nil;
//    CardEntity *cardEntity = [[[[CoreDataManager instance] managedObjectContext] executeFetchRequest:fetchRequest error:&error] lastObject];
//
//    if (cardEntity) {
//        self.card = [CardModel new];
//        self.card.ident = cardEntity.ident;
//        self.person = [MTLJSONAdapter modelOfClass:[Person class] fromJSONDictionary:cardEntity.person error:&error];
//        self.card.person = cardEntity.person;
//        self.cardDate = cardEntity.expire_date;
//
//        success = YES;
//    } else {
//        success = NO;
//    }
//    return success;
//}

- (void)tick {
    
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.cardDate];
//    NSTimeInterval timeLeft = 3600.0f - timeInterval;
//    div_t h = div(timeLeft,3600);
//    NSInteger hours = h.quot;
//    div_t m = div(h.rem, 60);
//    NSInteger minutes = m.quot;
//    NSInteger seconds = m.rem;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"00:%02zd",self.timeLeft]];
    self.timeLeft -- ;
   // NSLog(@"min - %li, sec - %li",(long)minutes,(long)seconds);
//    
    if (self.timeLeft == 0) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
//
}


#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

@end
