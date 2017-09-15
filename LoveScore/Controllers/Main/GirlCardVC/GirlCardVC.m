//
//  GirlCardVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "GirlCardVC.h"
#import "GirlCardCell.h"
#import "UIView+ViewCreator.h"
#import "Person.h"
#import "TeaserCardVC.h"
#import "DataStoreEntity.h"
#import "DataStore.h"
#import "CoreDataManager.h"
#import "ImageManager.h"

#import "AddGirlsServices.h"


@interface GirlCardVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    IBOutlet UICollectionView *_collectionView;
    NSIndexPath *_indexPath;
}

@property (strong, nonatomic)NSDictionary *countriesDictioanry;

@end

@implementation GirlCardVC
#pragma mark - init methods
- (void)viewDidLoad {
    [super viewDidLoad];

    [_collectionView registerNib:[UINib nibWithNibName:@"GirlCardCell" bundle:nil] forCellWithReuseIdentifier:GirlCardCellId];
    self.countriesDictioanry = [self getCountriesDictionaryFromDataBase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  //  self.girls = (NSMutableArray *)[[CoreDataManager instance] getGirlsFromDataBase];
    [_collectionView reloadData];
}

#pragma mark - Public methods

- (void)refresh {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (UICollectionViewCell *item in _collectionView.visibleCells) {
        
        [array addObject:[_collectionView indexPathForCell:item]];
    }
    
    [_collectionView reloadItemsAtIndexPaths:[array mutableCopy]];
}

#pragma mark - Collection view delegate and data source methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.girls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = GirlCardCellId;
    
    GirlCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [GirlCardCell createView];
    }
    Person *person = [self.girls objectAtIndex:indexPath.row];
    
    [cell setRate:person.rating];
    cell.flagImageView.image = person.flagImage;
    
    // photo setup
    
    [cell loadImageWithPhotoUUID:person.uuid];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    [self performSegueWithIdentifier:@"GirlCard@TeaserCard" sender:self];
}

#pragma mark - Collection view flowlayout delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(18, 15, 18, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize returnSize;
    
    CGFloat cellWidth = (self.view.frame.size.width - 60) / 3;
    CGFloat cellHeight = (self.view.frame.size.height - 72) / 3;
    returnSize = CGSizeMake(cellWidth, cellHeight);
    
    return returnSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section  {
    return 15.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18.f;
}

- (NSDictionary *)getCountriesDictionaryFromDataBase {
    
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
    DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];

    if (lError != nil) {
        NSLog(@"%@ %s %@", self.class, __func__, lError.description);
    }

    NSDictionary *countriesDictionary = [dataStore.internationalisation objectForKey:@"countries"];
    return countriesDictionary;
}

- (void)setGirls:(NSMutableArray *)girls {
    _girls = girls;
    [_collectionView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TeaserCardVC *viewController = [segue destinationViewController];
    viewController.girls = [self.girls mutableCopy];
    viewController.index = _indexPath.row;
    viewController.titleString = self.titleString;
}

@end
