//
//  MyGirlsVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MyGirlsVC.h"
#import "GirlListVC.h"
#import "GirlCardVC.h"
#import "SideMenuModel.h"
#import "NavigationTitle.h"
#import "ActionSheetPicker.h"
#import "SortButton.h"
#import "TTTAttributedLabel + ColorText.h"
#import "Person.h"
#import "DataStoreServices.h"
#import "DataStore.h"
#import "DataStoreEntity.h"
#import "PersonEntity.h"
#import "CoreDataManager.h"
#import "SharingServices.h"
#import "UserServices.h"
#import "TitleView.h"
#import "UIView+ViewCreator.h"
#import "AddGirlVC.h"

static NSString * const ageSortTitle = @"Age";
static NSString * const ratinSortTitle = @"Rating";
static NSString * const dateSortTitle = @"Recently added";
static NSString * const nameSortTitle = @"Name";
static NSString * const countrySortTitle = @"Nationality";
static NSString * const actionSortTitle = @"Action";

@interface MyGirlsVC ()

- (IBAction)sortTaped:(id)sender;

@property (weak, nonatomic) IBOutlet SortButton *sortBtn;
@property (weak, nonatomic) IBOutlet UILabel *girlCountLbl;
@property (nonatomic)NSInteger sortIndex;
@property (nonatomic, weak) UIViewController<AddGirlVCProtocol> *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic)AppDelegate *appDelegate;
@end

@implementation MyGirlsVC

#pragma mark - Init methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = APP_DELEGATE;
    
    
    if (self.isFiltered) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        [backItem setTintColor:RED_COLOR];
        self.navigationItem.leftBarButtonItem = backItem;
        //        self.navigationItem.title = self.titleString;
        [self addTitleToNavigationBar];
        self.sortIndex = 1;
        self.appDelegate.myGirlsSortType = dateSortTitle;
    } else {
        self.girls = [self getGirlsFromDataBase];
        self.navigationItem.titleView = [TTTAttributedLabel getString:@"MY GIRLS" withRedWord:@"MY"];
        self.sortIndex = 1;
        self.appDelegate.myGirlsSortType = dateSortTitle;
    }
    
    self.currentViewController = (GirlListVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ComponentA"];
    self.currentViewController.girls = [self.girls mutableCopy];
    
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    
    
    
    [[SideMenuModel sharedInstance] addEdgeSwipeOnView:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateGirls:) name:changesWithGirlsNotification object:nil];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.isFiltered) {
        self.girls = [self getGirlsFromDataBase];
    }
    if (self.appDelegate.myGirlsSortType && ![self.appDelegate.myGirlsSortType isEqualToString:@""]) {
        [self.sortBtn setTitle:self.appDelegate.myGirlsSortType forState:UIControlStateNormal];
        [self sortGirls:self.appDelegate.myGirlsSortType];
    }
    self.currentViewController.girls = (NSMutableArray *)self.girls;
    
    
    if (self.girls.count == 1) {
        [self.girlCountLbl setText:[NSString stringWithFormat:@"%lu girl",(unsigned long)self.girls.count]];
    } else {
        [self.girlCountLbl setText:[NSString stringWithFormat:@"%lu girls",(unsigned long)self.girls.count]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddGirlTapped:(id)sender {
    AddGirlVC *vc = (AddGirlVC *) VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"GirlEditor", @"AddGirlVCId");
    vc.filtered = YES;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)callSideMenu:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SideBarMenu Button Pressed"
                                                        object:nil];
    
    [[SideMenuModel sharedInstance] anchorRight];
}

#pragma mark - Private

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

- (NSArray *)getGirlsFromDataBase {
    NSMutableArray *persons = [NSMutableArray new];
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    
    // make predicate for status==ACT person
    NSPredicate *lPredicate = [NSPredicate predicateWithFormat:@"(SELF.status == %@)", @"ACT"];
    [lFetchRequest setPredicate:lPredicate];
    
    [lFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    for (PersonEntity *personEntity in lReturn) {
        Person *person = [MTLManagedObjectAdapter modelOfClass:[Person class] fromManagedObject:personEntity error:&lError];
        [persons addObject:person];
    }
    
    return persons;
}

- (void)sortGirls:(NSString *)selectedValue {
    if ([selectedValue isEqualToString:ratinSortTitle]) {
        self.girls = [self girlsSortedByKey:@"rating" ascending:NO];
    } else if ([selectedValue isEqualToString:ageSortTitle]) {
        self.girls = [self girlsSortedByKey:@"age" ascending:YES];
    } else if ([selectedValue isEqualToString:nameSortTitle]) {
        self.girls = [self girlsSortedByKey:@"firstName" ascending:YES];
    } else if ([selectedValue isEqualToString:countrySortTitle]) {
        self.girls = [self girlsSortedByKey:@"nationality" ascending:YES];
    } else if ([selectedValue isEqualToString:dateSortTitle]) {
        self.girls = [self girlsSortedByDate];
    } else if ([selectedValue isEqualToString:actionSortTitle]) {
        self.girls = [self girlsSortedByAction];
    }
    
}

#pragma mark - Sorting methods

- (NSArray *)girlsSortedByKey:(NSString *)key ascending:(BOOL)ascending {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girls sortedArrayUsingDescriptors:sortDescriptors];
    return girls;
}

- (NSArray *)girlsSortedByDate {
    NSMutableArray *girls;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        
        NSDate *firstDate = [formater dateFromString:person1.createdAt];
        NSDate *secondDate = [formater dateFromString:person2.createdAt];
        
        return [firstDate compare:secondDate];
        
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [NSMutableArray arrayWithArray:[self.girls sortedArrayUsingDescriptors:sortDescriptors]];
    return girls;
}

- (NSArray *)girlsSortedByAction {
    NSMutableArray *girls = [NSMutableArray new];
    NSMutableArray *girlsWithDate = [NSMutableArray new];
    NSMutableArray *girlsWithKiss = [NSMutableArray new];
    NSMutableArray *girlsWithLove = [NSMutableArray new];
    
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    NSDate *dateDate;
    NSDate *kissDate;
    NSDate *loveDate;
    
    for (Person *person in self.girls) {
        dateDate = [formater dateFromString:[person.events objectForKey:@"DATE"]];
        kissDate = [formater dateFromString:[person.events objectForKey:@"KISS"]];
        loveDate = [formater dateFromString:[person.events objectForKey:@"LOVE"]];
        
        if (loveDate) {
            [girlsWithLove addObject:person];
        } else if (kissDate) {
            [girlsWithKiss addObject:person];
        } else if (dateDate) {
            [girlsWithDate addObject:person];
        }
    }
    
    
    
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSDate *firstDate = [formater dateFromString:[person1.events objectForKey:@"DATE"]];
        NSDate *secondDate = [formater dateFromString:[person2.events objectForKey:@"DATE"]];
        
        return [firstDate compare:secondDate];
        
    }];
    NSSortDescriptor *kissSortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSDate *firstDate = [formater dateFromString:[person1.events objectForKey:@"KISS"]];
        NSDate *secondDate = [formater dateFromString:[person2.events objectForKey:@"KISS"]];
        
        return [firstDate compare:secondDate];
        
    }];
    NSSortDescriptor *loveSortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSDate *firstDate = [formater dateFromString:[person1.events objectForKey:@"LOVE"]];
        NSDate *secondDate = [formater dateFromString:[person2.events objectForKey:@"LOVE"]];
        
        return [firstDate compare:secondDate];
        
    }];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:loveSortDescriptor];
    [girls addObjectsFromArray:[girlsWithLove sortedArrayUsingDescriptors:sortDescriptors]];
    sortDescriptors = [NSArray arrayWithObject:kissSortDescriptor];
    [girls addObjectsFromArray:[girlsWithKiss sortedArrayUsingDescriptors:sortDescriptors]];
    sortDescriptors = [NSArray arrayWithObject:dateSortDescriptor];
    [girls addObjectsFromArray:[girlsWithDate sortedArrayUsingDescriptors:sortDescriptors]];
    
    return girls;
}

#pragma mark - Actions

- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        UIViewController <AddGirlVCProtocol>*newViewController = (GirlListVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ComponentA"];
        newViewController.girls = [self.girls mutableCopy];
        
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    } else {
        UIViewController <AddGirlVCProtocol>*newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ComponentB"];
        newViewController.girls = [self.girls mutableCopy];
        newViewController.titleString = self.titleString;
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
    //    self.currentViewController.girls = [self.girls mutableCopy];
}

- (void)cycleFromViewController:(UIViewController<AddGirlVCProtocol>*) oldViewController
               toViewController:(UIViewController<AddGirlVCProtocol>*) newViewController {
    
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    
    [UIView animateWithDuration:0.01
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         
                         [newViewController didMoveToParentViewController:self];
                     }];
}

- (IBAction)sortTaped:(id)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:@"Sort" rows:[NSArray arrayWithObjects: ageSortTitle, dateSortTitle, nameSortTitle, countrySortTitle, actionSortTitle, nil] initialSelection:self.sortIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.sortIndex = selectedIndex;
        [self sortGirls:selectedValue];
        self.appDelegate.myGirlsSortType = selectedValue;
        if ([self.currentViewController isKindOfClass:[GirlListVC class]]) {
            GirlListVC *viewController = (GirlListVC *)self.currentViewController;
            viewController.girls = (NSMutableArray *)self.girls;
        }
        if ([self.currentViewController isKindOfClass:[GirlCardVC class]]) {
            GirlCardVC *viewController = (GirlCardVC *)self.currentViewController;
            viewController.girls = (NSMutableArray *)self.girls;
        }
        [self.sortBtn setTitle:selectedValue forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (void)addTitleToNavigationBar {
    UIImage *flagImage = [UIImage imageNamed:self.titleString];
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

#pragma mark - changesInGirlsArray notification

- (void)calculateGirls:(NSNotification *)notification {
    //    [[NSNotificationCenter defaultCenter] postNotificationName:changesWithGirlsNotification object:self];
    
    self.girls = [self getGirlsFromDataBase];
    self.currentViewController.girls = [self.girls mutableCopy];
    [self.currentViewController refresh];
    
    if (self.girls.count == 1) {
        [self.girlCountLbl setText:[NSString stringWithFormat:@"%lu girl",(unsigned long)self.girls.count]];
    } else {
        [self.girlCountLbl setText:[NSString stringWithFormat:@"%lu girls",(unsigned long)self.girls.count]];
    }
}

- (void)dealloc {
    [[SideMenuModel sharedInstance] removeEdgeSwipeFromView:self.view];
}

@end
