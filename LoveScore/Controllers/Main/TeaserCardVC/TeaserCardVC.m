//
//  TeaserCardVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "TeaserCardVC.h"
#import "ZLSwipeableView.h"
#import "TeaserCardView.h"
#import "UIView+ViewCreator.h"
#import "CardView.h"
#import "Global.h"
#import "ShareController.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"
#import "FullCardVC.h"
#import "CoreDataManager.h"
#import "Person.h"
#import "SyncManager.h"
#import "FullCheckInVC.h"
#import "AddGirlsServices.h"
#import "ImageManager.h"
#import "TitleView.h"

@interface TeaserCardVC () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, CardViewDelegate> {
    
}

@property (strong, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (strong, nonatomic)AppDelegate *appDelegate;
@property (nonatomic)BOOL isEditMode;
@property (strong, nonatomic) TeaserCardView * currentView;

@property (nonatomic) BOOL wasEdited;

- (IBAction)shareTapped:(id)sender;
- (IBAction)deleteTapped:(id)sender;
- (IBAction)editTapped:(id)sender;

@end

@implementation TeaserCardVC

#pragma mark - Init methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    self.isEditMode = NO;
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    if (self.titleString == nil) {
        self.navigationItem.titleView = [TTTAttributedLabel getString:@"MY GIRLS" withRedWord:@"MY"];
    } else {
        [self addTitleToNavigationBar];
    }
    self.appDelegate = APP_DELEGATE;
    
    self.wasEdited = NO;
}

- (void)addTitleToNavigationBar {
    UIImage *flagImage = [UIImage imageNamed:[self.titleString lowercaseString]];
    if (flagImage) {
        TitleView *view = [TitleView createView];
        view.title.text = self.titleString;
        view.imageView.image = flagImage;
        self.navigationItem.titleView = view;
        [self.view layoutSubviews];
        
    } else {
        self.navigationItem.title = self.titleString;
    }

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.isEditMode) {
//    self.girls = (NSMutableArray *)[[CoreDataManager instance] getGirlsFromDataBase];
//        self.index = self.appDelegate.index;
//        self.isEditMode = NO;
//    }
//    [self.swipeableView discardAllSwipeableViews];
//    [self.swipeableView loadNextSwipeableViewsIfNeeded];
    //self.index -= 1;
   // self.swipeableView.dataSource = self;
   //[self.swipeableView loadNextSwipeableViewsIfNeeded];
//    if (self.currentView) {
//        [self.currentView setPersonModel:[self.girls objectAtIndex:self.index]];
//    }
    
    if (self.wasEdited) {
        self.wasEdited = NO;
        
        self.index = [self returnCurrentCardIndex];
        
        [self.swipeableView discardAllSwipeableViews];
        [self.swipeableView loadNextSwipeableViewsIfNeeded];

    }
}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.isEditMode = YES;
//    self.appDelegate.index = self.index;
//}
//
- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.swipeableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    //    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    //    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    //    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    //    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
    //          location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    //    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    
    if (self.index >= self.girls.count) {
        self.index = 0;
    }
    
    NSLog(@"current index - %ldl", (long)self.index);
    
    
    CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
    view.delegate = self;
    
    TeaserCardView *contentView = [TeaserCardView createView];
    [contentView setPersonModel:[self.girls objectAtIndex:self.index]];
    [contentView setFrame:swipeableView.bounds];
//    self.currentView = contentView;
    view.clipsToBounds = YES;
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:contentView];
    
    NSDictionary *metrics = @{
                              @"height" : @(view.bounds.size.height),
                              @"width" : @(view.bounds.size.width)
                              };
    
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    
    [view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[contentView(width)]"
      options:0
      metrics:metrics
      views:views]];
    
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:
                          @"V:|[contentView(height)]"
                          options:0
                          metrics:metrics
                          views:views]];
    
    self.index++;
    return view;
}

- (void)cardViewWasTapped {
    
    [self performSegueWithIdentifier:@"Teaser@FullCheckInSegue" sender:self];
    
    //    FullCardVC *vc = [[FullCardVC alloc] init];
    //    vc.person = [self.girls objectAtIndex:self.index];
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods

- (NSInteger)returnCurrentCardIndex {
    int numberToDecrease = 0;
    
    switch (self.girls.count) {
        case 0: {
            numberToDecrease = 0;
        }
            break;
        case 1: {
            numberToDecrease = 1;
        }
            break;
            
        case 2: {
            numberToDecrease = 1;
        }
            break;
        default: {
            numberToDecrease = 3;
        }
            break;
    }
    
    NSInteger currentIndex = self.index - numberToDecrease;
    
    if (currentIndex < 0) {
        currentIndex = self.girls.count - (numberToDecrease - self.index);
    }
    
    return currentIndex;
}

- (void)confirmDeletingWithCompletion:(void (^)(bool delete))completion {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Delete girl?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = RED_COLOR;
    
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:@"Delete"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       completion(YES);
                                   }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                   }];
    
    alertController.view.tintColor = RED_COLOR;
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteTapped:(id)sender {
    
    [self confirmDeletingWithCompletion:^(bool delete) {
        if (delete) {
            NSInteger curIndex = [self returnCurrentCardIndex];
            
            Person *personToDelete = self.girls[curIndex];
            personToDelete.status = @"DEL";
            
            NSError *error = nil;
            
            [MTLManagedObjectAdapter managedObjectFromModel:personToDelete
                                       insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                                      error:&error];
            [[CoreDataManager instance] saveContext];
            
            [self.girls removeObjectAtIndex:curIndex];
            
            if ([[SyncManager sharedInstance] connected]) {
                AddGirlsServices *addGirlsServices = [AddGirlsServices new];
                [[addGirlsServices uploadPersons] subscribeCompleted:^(void) {
                    [[ImageManager sharedInstance] deleteAllImagesWithUUID:personToDelete.uuid];
                    [[CoreDataManager instance] cleanDeletedPerson];
                }];
            } else {
                [SyncManager sharedInstance].checkForPersonsUploading = YES;
            }
            
            if (curIndex < 1) {
                [self backBarButtonAction];
            } else {
                [self.swipeableView swipeTopViewToRight];
            }
        }
    }];
}

- (IBAction)editTapped:(id)sender {
    
    self.wasEdited = YES;
    
    NSInteger curIndex = [self returnCurrentCardIndex];
    
    FullCheckInVC *viewController = (FullCheckInVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"GirlEditor", @"FullCheckInVC");
    [viewController setPerson:[self.girls objectAtIndex:curIndex]];
    viewController.isEditMode = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)shareTapped:(id)sender {
    
    if ([[SyncManager sharedInstance] connected]) {
        [[ShareController sharedInstance]presentShareControllerInViewController:self withPerson:[self.girls objectAtIndex:[self returnCurrentCardIndex]]];
        
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning!"
                                              message:@"Check your internet connection."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *showWarningAction = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action)
                                            {
                                                
                                            }];
        
        [alertController addAction:showWarningAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        alertController.view.tintColor = RED_COLOR;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Teaser@FullCheckInSegue"]) {
        FullCardVC *vc = [segue destinationViewController];
        vc.person = [self.girls objectAtIndex:[self returnCurrentCardIndex]];
    }
}

@end
