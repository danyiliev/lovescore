//
//  BestVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "BestVC.h"
#import "LuckyListCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "CoreDataManager.h"
#import "FullCardVC.h"
#import "Person.h"

@interface BestVC ()
@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSArray *filteredGirls;
@property (strong, nonatomic)NSMutableDictionary *girlsRatings;
@property (strong, nonatomic)NSDictionary *countriesDictionary;

@end

@implementation BestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LuckyListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LuckyListCellId"];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.girlsRatings = [NSMutableDictionary new];
    self.countriesDictionary = [[CoreDataManager instance] getCountriesDictionaryFromDataBase];
    [self filterGirls];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredGirls.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LuckyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LuckyListCellId"];
    Person *person = [self.filteredGirls objectAtIndex:indexPath.row];
    [cell setLuckyListCellColor:indexPath.row % 2];
    [cell setPerson:person cellNumber:indexPath.row + 1 countriesDictionary:self.countriesDictionary rating:[self.girlsRatings objectForKey:person.uuid]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FullCardVC *viewController = (FullCardVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"FullCheckInId");
    viewController.person = [self.filteredGirls objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

#pragma mark Bar Buttons Actions

- (void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private methods

- (void)filterGirls {
    [self.girlsRatings removeAllObjects];
    if ([self.recordType isEqualToString:@"Best All Time"]) {
        self.filteredGirls = [self bestAllTimeGirls];
    }
    if ([self.recordType isEqualToString:@"Best Body"]) {
        self.filteredGirls = [self bestBodyGirls];
    }
    if ([self.recordType isEqualToString:@"Best Face"]) {
        self.filteredGirls = [self bestFaceGirls];
    }
    if ([self.recordType isEqualToString:@"Best Personality"]) {
        self.filteredGirls = [self bestPersonalityGirl];
    }
    if ([self.recordType isEqualToString:@"Best Kiss"]) {
        self.filteredGirls = [self bestKissedGirls];
    }
    if ([self.recordType isEqualToString:@"Best Love"]) {
        self.filteredGirls = [self bestLovedGirls];
    }
}

- (NSArray *)bestAllTimeGirls {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girls sortedArrayUsingDescriptors:sortDescriptors];
    return girls;
}

- (NSArray *)bestBodyGirls {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSNumber *firstRating;
        NSNumber *secondRating;
        if (person1.personRatings.count > 0) {
            float legsRatingFirst = [[[person1 personRatings] objectForKey:@"legs"] floatValue];
            float backRatingFirst = [[[person1 personRatings] objectForKey:@"back"] floatValue];
            float bustRatingFirst = [[[person1 personRatings] objectForKey:@"bust"] floatValue];
            firstRating = [NSNumber numberWithFloat: (legsRatingFirst + bustRatingFirst + backRatingFirst)/3];
            if (firstRating) {
                [self.girlsRatings setObject:firstRating forKey:person1.uuid];
            }
        }
        if (person2.personRatings.count > 0) {
            float legsRatingSecond = [[[person2 personRatings] objectForKey:@"legs"] floatValue];
            float backRatingSecond = [[[person2 personRatings] objectForKey:@"back"] floatValue];
            float bustRatingSecond = [[[person2 personRatings] objectForKey:@"bust"] floatValue];
            secondRating = [NSNumber numberWithFloat:(legsRatingSecond + bustRatingSecond + backRatingSecond)/3];
            if (secondRating) {
                [self.girlsRatings setObject:secondRating forKey:person2.uuid];
            }
        }
        if (!firstRating) {
            firstRating = [NSNumber numberWithInteger:0];
        }
        if (!secondRating) {
            secondRating = [NSNumber numberWithInteger:0];
        }
        return [firstRating compare:secondRating];
    
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girls sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray *mutableGirls = [NSMutableArray arrayWithArray:girls];
    for (Person *person in girls) {
        float legsRating = 0.0;
        float backRating = 0.0;
        float bustRating = 0.0;
        if (person.personRatings.count > 0) {
             legsRating = [[[person personRatings] objectForKey:@"legs"] floatValue];
             backRating = [[[person personRatings] objectForKey:@"back"] floatValue];
             bustRating = [[[person personRatings] objectForKey:@"bust"] floatValue];
        }
        if (legsRating == 0.0 || backRating == 0.0 || bustRating == 0.0) {
            [mutableGirls removeObject:person];
        }
          }
    girls = mutableGirls;
    
    return girls;
}

- (NSArray *)bestFaceGirls {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSNumber *firstRating;
        NSNumber *secondRating;
        if (person1.personRatings.count > 0) {
            float first = [[[person1 personRatings] objectForKey:@"face"] floatValue];
            firstRating = [NSNumber numberWithFloat:first];
            if (firstRating) {
                [self.girlsRatings setObject:firstRating forKey:person1.uuid];
            }
        }
        if (person2.personRatings.count > 0) {
            float second = [[[person2 personRatings] objectForKey:@"face"] floatValue];
            secondRating = [NSNumber numberWithFloat:second];
            if (secondRating) {
                [self.girlsRatings setObject:secondRating forKey:person2.uuid];
            }

        }
        if (!firstRating) {
            firstRating = [NSNumber numberWithInteger:0];
        }
        if (!secondRating) {
            secondRating = [NSNumber numberWithInteger:0];
        }

        return [firstRating compare:secondRating];
        
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girls sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray *mutableGirls = [NSMutableArray arrayWithArray:girls];
    for (Person *person in girls) {
        float faceRating = 0.0;
        if (person.personRatings.count > 0) {
            faceRating = [[[person personRatings] objectForKey:@"face"] floatValue];
        }
        if (faceRating == 0.0) {
            [mutableGirls removeObject:person];
        }
    }
    girls = mutableGirls;
    return girls;
}

- (NSArray *)bestPersonalityGirl {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSNumber *firstRating;
        NSNumber *secondRating;
        if (person1.personRatings.count > 0) {
            float characterRatingFirst = [[[person1 personRatings] objectForKey:@"character"] floatValue];
            float intelligenceRatingFirst = [[[person1 personRatings] objectForKey:@"intelligence"] floatValue];
            firstRating = [NSNumber numberWithFloat:(characterRatingFirst + intelligenceRatingFirst)/2];
            if (firstRating) {
                [self.girlsRatings setObject:firstRating forKey:person1.uuid];
            }
        }
        if (person2.personRatings.count > 0) {
            float characterRatingSecond = [[[person2 personRatings] objectForKey:@"character"] floatValue];
            float intelligenceRatingSecond = [[[person2 personRatings] objectForKey:@"intelligence"] floatValue];
            secondRating = [NSNumber numberWithFloat:(characterRatingSecond + intelligenceRatingSecond)/2];
            if (secondRating) {
            [self.girlsRatings setObject:secondRating forKey:person2.uuid];
            }
        }
        if (!firstRating) {
            firstRating = [NSNumber numberWithInteger:0];
        }
        if (!secondRating) {
            secondRating = [NSNumber numberWithInteger:0];
        }

        return [firstRating compare:secondRating];
        
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girls sortedArrayUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *mutableGirls = [NSMutableArray arrayWithArray:girls];
    for (Person *person in girls) {
        float characterRating = 0.0;
        float intelligenceRating = 0.0;
        if (person.personRatings.count > 0) {
            characterRating = [[[person personRatings] objectForKey:@"character"] floatValue];
            intelligenceRating = [[[person personRatings] objectForKey:@"intelligence"] floatValue];
        }
        if (intelligenceRating == 0.0 || characterRating == 0.0) {
            [mutableGirls removeObject:person];
        }
    }
    girls = mutableGirls;
    
    return girls;
}

- (NSArray *)bestKissedGirls {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSNumber *firstRating;
        NSNumber *secondRating;
        if (person1.personRatings.count > 0 ) {
            float first = [[[person1 personRatings] objectForKey:@"kissing"] floatValue];
            firstRating = [NSNumber numberWithFloat:first];
            if (firstRating) {
                [self.girlsRatings setObject:firstRating forKey:person1.uuid];
            }
        }
        if (person2.personRatings.count > 0) {
            float second = [[[person2 personRatings] objectForKey:@"kissing"] floatValue];
            secondRating = [NSNumber numberWithFloat:second];
            if (secondRating) {
                [self.girlsRatings setObject:secondRating forKey:person2.uuid];
            }
        }
        
        if (!firstRating) {
            firstRating = [NSNumber numberWithInteger:0];
        }
        if (!secondRating) {
            secondRating = [NSNumber numberWithInteger:0];
        }

        return [firstRating compare:secondRating];
        
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girls sortedArrayUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *mutableGirls = [NSMutableArray arrayWithArray:girls];
    for (Person *person in girls) {
        if ([[self.girlsRatings objectForKey:person.uuid] integerValue] == 0) {
            [mutableGirls removeObject:person];
        }
    }
    girls = mutableGirls;
    return girls;
}

- (NSArray *)bestLovedGirls {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *person1 = (Person *)obj1;
        Person *person2 = (Person *)obj2;
        NSNumber *firstRating;
        NSNumber *secondRating;
        if (person1.personRatings.count > 0) {
            float kissingRatingFirst = [[[person1 personRatings] objectForKey:@"kissing"] floatValue];
            float oralRatingFirst = [[[person1 personRatings] objectForKey:@"oral"] floatValue];
            float intercourseRatingFirst = [[[person1 personRatings] objectForKey:@"intercourse"] floatValue];
            firstRating = [NSNumber numberWithFloat: (kissingRatingFirst + oralRatingFirst + intercourseRatingFirst)/3];
            if (firstRating) {
                [self.girlsRatings setObject:firstRating forKey:person1.uuid];
            }
        }
        if (person2.personRatings.count > 0) {
            float kissingRatingSecond = [[[person2 personRatings] objectForKey:@"kissing"] floatValue];
            float oralRatingSecond = [[[person2 personRatings] objectForKey:@"oral"] floatValue];
            float intercourseRatingSecond = [[[person2 personRatings] objectForKey:@"intercourse"] floatValue];
            secondRating = [NSNumber numberWithFloat:(kissingRatingSecond + oralRatingSecond + intercourseRatingSecond)/3];
            if (secondRating) {
                [self.girlsRatings setObject:secondRating forKey:person2.uuid];
            }
        }
        if (!firstRating) {
            firstRating = [NSNumber numberWithInteger:0];
        }
        if (!secondRating) {
            secondRating = [NSNumber numberWithInteger:0];
        }

        return [firstRating compare:secondRating];
        
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girls sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray *mutableGirls = [NSMutableArray arrayWithArray:girls];
    for (Person *person in girls) {
        float kissingRating = 0.0;
        float oralRating = 0.0;
        float intercourseRating = 0.0;
        
        if (person.personRatings.count > 0) {
            kissingRating = [[[person personRatings] objectForKey:@"kissing"] floatValue];
            oralRating = [[[person personRatings] objectForKey:@"oral"] floatValue];
            intercourseRating = [[[person personRatings] objectForKey:@"intercourse"] floatValue];
        }
        
        if (kissingRating == 0.0 || oralRating == 0.0 || intercourseRating == 0.0) {
            [mutableGirls removeObject:person];
        }
    }
    girls = mutableGirls;
    return girls;
}


@end
