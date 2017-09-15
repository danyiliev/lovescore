//
//  GirlListVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "GirlListVC.h"
#import "GirlListCell.h"
#import "UIView+ViewCreator.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "Global.h"
#import "ShareController.h"
#import "CoreDataManager.h"
#import "Person.h"
#import "PersonEntity.h"
#import "FullCheckInVC.h"
#import "FullCardVC.h"
#import "CardModel.h"
#import "ImageManager.h"
#import "UserServices.h"
#import "AddGirlsServices.h"
#import "SyncManager.h"
#import "DataStoreEntity.h"
#import "DataStore.h"
#import "MyGirlsVC.h"

#import "NetworkActivityIndicator.h"

@interface GirlListVC () <UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *_currentIndexPath;
}


@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *swipedCellIndexPath;
@property (nonatomic, strong) NSString *selectedPersonIdentifier;
@property (nonatomic, strong) NSDictionary *countiesDictionary;
@property (nonatomic, strong) NSOperationQueue *imageDownloadQueue;

//@property (nonatomic, strong) AddGirlsServices *addGirlServices;
@end

@implementation GirlListVC

#pragma mark - Init and system methods

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.imageDownloadQueue = [[NSOperationQueue alloc] init];
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    self.countiesDictionary = [self getCountriesDictionaryFromDataBase];
    
    [_tableView registerNib:[UINib nibWithNibName:@"GirlListCell" bundle:nil] forCellReuseIdentifier:GirlListCellId];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView)
                                                 name:@"ComplateDownloadPhotos"
                                               object:nil];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideAllUtilityButtons)
                                                 name:@"SideBarMenu Button Pressed"
                                               object:nil];
    [self hideAllUtilityButtons];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.girls.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GirlListCell *cell = (GirlListCell *)[tableView dequeueReusableCellWithIdentifier:GirlListCellId forIndexPath:indexPath];
    
    [cell setGirlListCellColor:indexPath.row % 2];
    
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    Person *person = [self.girls objectAtIndex:indexPath.row];
    [cell setName:person.firstName surname:person.lastName];
    [cell setAge:[person.age stringValue] country:[self.countiesDictionary objectForKey:person.country] city:[person.city objectForKey:@"name"]];
    
    if (person.events.count > 0) {
        [cell setIconForEvent:[[self.girls objectAtIndex:indexPath.row]events]];
    }
    [cell setRate:person.rating];
    cell.flagImageView.image = person.flagImage;
    
    // photo setup

    [cell loadImageWithPhotoUUID:person.uuid];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //self.selectedPersonIdentifier = ((Person *)[self.girls objectAtIndex:indexPath.row]).uuid;
    _currentIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"GirlList@FullCheckInSegue" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark - Publci methods
- (void)refresh {
    if (_tableView) {
        NSArray *paths = [_tableView indexPathsForVisibleRows];
        [_tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

#pragma mark - Private methods

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

- (NSDictionary *)getCountriesDictionaryFromDataBase {
    
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    if (lReturn && lReturn.count > 0) {
        DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
        DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
        
        if (lError != nil) {
            NSLog(@"%@ %s %@", self.class, __func__, lError.description);
        }

        NSDictionary *countriesDictionary = [dataStore.internationalisation objectForKey:@"countries"];
        
        return countriesDictionary;
    }
    return nil;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:RED_COLOR icon:[UIImage imageNamed:@"edit"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:RED_COLOR icon:[UIImage imageNamed:@"delete"]];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:RED_COLOR icon:[UIImage imageNamed:@"share"]];
    
    return leftUtilityButtons;
}

- (void)hideAllUtilityButtons{
    
    GirlListCell *girlSwipedCell = [self.tableView cellForRowAtIndexPath:self.swipedCellIndexPath];
    [girlSwipedCell hideUtilityButtonsAnimated:YES];
    
}

- (void)setGirls:(NSMutableArray *)girls {
    _girls = girls;
    [_tableView reloadData];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
    if (self.swipedCellIndexPath != nil){
        GirlListCell *girlSwipedCell = [self.tableView cellForRowAtIndexPath:self.swipedCellIndexPath];
        [self swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:girlSwipedCell];
    }
    GirlListCell *girlCell = (GirlListCell *)cell;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.swipedCellIndexPath = indexPath;
    
    if(state ==kCellStateLeft){
        girlCell.swipeCellView.alpha = 0.2f;
    }
    else if (state ==kCellStateRight){
        girlCell.swipeCellView.alpha = 0.2f;
    }
    else {
        girlCell.swipeCellView.alpha = 0.0f;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    if ([[SyncManager sharedInstance] connected]) {
        Person *person = [self.girls objectAtIndex:self.swipedCellIndexPath.row];
        
        [[ShareController sharedInstance] presentShareControllerInViewController:self withPerson:person];
        [self hideAllUtilityButtons];
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            FullCheckInVC *viewController = (FullCheckInVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"GirlEditor", @"FullCheckInVC");
            viewController.person = [self.girls objectAtIndex:self.swipedCellIndexPath.row];
            viewController.isEditMode = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 1:{
            
            [self confirmDeletingWithCompletion:^(bool delete) {
                if (delete) {
                    Person *personToDelete = self.girls[self.swipedCellIndexPath.row];
                    personToDelete.status = @"DEL";
                    
                    NSError *error = nil;
                    
                    [MTLManagedObjectAdapter managedObjectFromModel:personToDelete
                                               insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                                              error:&error];
                    [[CoreDataManager instance] saveContext];
                    
                    
                    // if is network is available
                    
                    if ([[SyncManager sharedInstance] connected]) {
                        AddGirlsServices *addGirlsServices = [AddGirlsServices new];
                        [[addGirlsServices uploadPersons] subscribeCompleted:^(void) {
                            [[ImageManager sharedInstance] deleteAllImagesWithUUID:personToDelete.uuid];
                            [[CoreDataManager instance] cleanDeletedPerson];
                        }];
                    } else {
                        [SyncManager sharedInstance].checkForPersonsUploading = YES;
                    }
                    
                    [self.girls removeObjectAtIndex:self.swipedCellIndexPath.row];
                    
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.swipedCellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:changesWithGirlsNotification object:self];
                }
            }];
        }
            break;
    }
    [self hideAllUtilityButtons];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    
    return YES;
}
- (void)reloadTableView {
        [self.tableView reloadData];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GirlList@FullCheckInSegue"]) {
        FullCardVC *vc = [segue destinationViewController];
        vc.person = [self.girls objectAtIndex:_currentIndexPath.row];
    }
}

- (void)dealloc {
    
}
@end
