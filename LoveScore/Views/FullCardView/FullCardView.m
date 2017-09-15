//
//  FullCardView.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "PhotoCell.h"
#import "RatingsCell.h"
#import "AboutCell.h"
#import "SpecialsCell.h"
#import "SocialCell.h"
#import "HistoryCell.h"
#import "CommentCell.h"
#import "StarRatingView.h"

#import "FullCardView.h"
#import "UIView+ViewCreator.h"
#import "RoundRateView.h"
#import "Person.h"
#import "CoreDataManager.h"
#import "PersonEntity.h"
#import "ImageManager.h"

static NSString * const PHOTO_SECTION_TITLE = @"";
static NSString * const RATINGS_SECTION_TITLE = @"RATINGS";
static NSString * const ABOUT_SECTION_TITLE = @"ABOUT";
static NSString * const COMMENTS_SECTION_TITLE = @"COMMENTS";
static NSString * const SPECIALS_SECTION_TITLE = @"FEATURES";
static NSString * const SOCIAL_SECTION_TITLE = @"SOCIAL";
static NSString * const HISTORY_SECTION_TITLE = @"SCORE HISTORY";

@interface FullCardView () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *_aboutCategoryArray;
    NSArray *_specialsCategoryArray;
    NSMutableArray *_socialIconsNamesArray;
}

@property (weak, nonatomic) IBOutlet StarRatingView *starRateView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (strong, nonatomic)Person *currentPerson;
@property (strong, nonatomic)NSMutableDictionary *aboutPersonDictionary;
@property (strong, nonatomic)NSMutableDictionary *socialDictionary;
@property (strong, nonatomic)NSMutableArray *namesForSection;
@property (strong, nonatomic)NSDictionary *countriesDictionary;
@property (nonatomic, strong) NSIndexPath *photoIndexPath;
@property (strong, nonatomic)NSDictionary *attributesDictionary;
@property (strong, nonatomic)NSDictionary *categories;
@property (strong, nonatomic)NSDictionary *hairColorsDictionary;
@property (strong, nonatomic)NSDictionary *jobsDictionary;

@end

@implementation FullCardView

#pragma mark - Init methods

- (void)awakeFromNib {
    [super awakeFromNib];
    [_tableView registerClass:[PhotoCell class] forCellReuseIdentifier:PhotoCellId];
    
    _tableView.separatorColor = [UIColor clearColor];
    [_tableView setBounces:NO];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    self.countriesDictionary = [[CoreDataManager instance] getCountriesDictionaryFromDataBase];
    self.attributesDictionary = @{
                                  @"tattoo" : @"Tattoo",
                                  @"piercing" : @"Piercing",
                                  @"exotic" : @"Exotic",
                                  @"vip" : @"Famous",
                                  @"gold-digger" : @"Gold Digger",
                                  @"phone" : @"Text fun",
                                  @"online" : @"Video fun",
                                  @"model" : @"Model",
                                  @"playmate" : @"Playmate",
                                  @"milf" : @"MILF"
                                  };
    self.categories = @{
                        @"wedding" : @"Wedding material",
                        @"girlfriend" : @"Girlfriend material",
                        @"friends" : @"Friends with benefits",
                        @"backup" : @"Backup girl"
                        };
    self.hairColorsDictionary = @{
                                  @"BLK" : @"Black",
                                  @"BRW" : @"Brunette",
                                  @"BLD" : @"Blonde",
                                  @"RED" : @"Ginger",
                                  @"OTH" : @"Other"
                                  };
    self.jobsDictionary = @{
                            @"daddy-girl" : @"Daddy's girl",
                            };
    self.starRateView.tintColor = [UIColor whiteColor];
}

- (void)setupPersonInfo {
    
    [self setupAboutPerson];
    
    _specialsCategoryArray = self.person.attributes;
    
    [self setupSocialMedia];
    
    _commentText = self.person.comment;
}

- (void)reloadTableView {
    [self setupPersonInfo];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = 0;
    if (section > 0) {
        headerHeight = 56.f;
    }
    
    return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    sectionName = [self.namesForSection objectAtIndex:section];
    
    return sectionName;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width, 56);
    label.font = [UIFont fontWithName:@"Lato-Bold" size:19];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor colorWithRed:161.0 / 255.0 green:55.0 / 255.0 blue:49.0 / 255.0 alpha:1];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowsNumber = 1;
    
    if ([[self tableView:tableView titleForHeaderInSection:section]  isEqualToString: ABOUT_SECTION_TITLE]) {
        rowsNumber = _aboutPersonDictionary.count;
    }
    
    if ([[self tableView:tableView titleForHeaderInSection:section]  isEqualToString: SPECIALS_SECTION_TITLE]) {
        rowsNumber = _specialsCategoryArray.count;
    }
    if ([[self tableView:tableView titleForHeaderInSection:section]  isEqualToString: SOCIAL_SECTION_TITLE]) {
        rowsNumber = _socialIconsNamesArray.count;
    }
    
    return rowsNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = 1.f;
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: PHOTO_SECTION_TITLE]) {
        rowHeight = [UIScreen mainScreen].bounds.size.width;
    } else if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: RATINGS_SECTION_TITLE]) {
        rowHeight = 392.f;
    } else if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: ABOUT_SECTION_TITLE]) {
        rowHeight = 44.f;
    } else if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: COMMENTS_SECTION_TITLE]) {
        rowHeight = [self heightForCommentCellWithText:_commentText];
    } else if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: SPECIALS_SECTION_TITLE]) {
        rowHeight = 44.f;
    } else if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: SOCIAL_SECTION_TITLE]) {
        rowHeight = 44.f;
    } else if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: HISTORY_SECTION_TITLE]) {
        rowHeight = 159.f;
    }
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: PHOTO_SECTION_TITLE]) {
        
        self.photoIndexPath = indexPath;
        
        return [self photoCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: RATINGS_SECTION_TITLE]) {
        return [self ratingsCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: ABOUT_SECTION_TITLE]) {
        return [self aboutCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: COMMENTS_SECTION_TITLE]) {
        return [self commentCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: SPECIALS_SECTION_TITLE]) {
        return [self specialsCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: SOCIAL_SECTION_TITLE]) {
        return [self socialCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section]  isEqualToString: HISTORY_SECTION_TITLE]) {
        return [self historyCellForTableView:tableView atIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - Cells
- (PhotoCell *)photoCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:PhotoCellId forIndexPath:indexPath];
    [cell setFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    
    NSArray *imagesPathArray = [[ImageManager sharedInstance] getImagesArrayWithUUID:self.person.uuid];
    if (imagesPathArray.count > 0) {
        [cell setImagesPathArray:imagesPathArray];
    } else {
        [cell setPhotosUrl:self.pictures];
    }
    
    return cell;
}

- (RatingsCell *)ratingsCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    RatingsCell *cell = [tableView dequeueReusableCellWithIdentifier:RatingsCellId];
    
    if (!cell) {
        cell = [RatingsCell createView];
    }
    if ([self.person.personRatings isKindOfClass:[NSDictionary class]]) {
        [cell setFaceRate:[self.person.personRatings objectForKey:@"face"]];
        [cell setBustRate:[self.person.personRatings objectForKey:@"bust"]];
        [cell setBackRate:[self.person.personRatings objectForKey:@"back"]];
        [cell setLegsRate:[self.person.personRatings objectForKey:@"legs"]];
        [cell setCharacterRate:[self.person.personRatings objectForKey:@"character"]];
        [cell setKissingRate:[self.person.personRatings objectForKey:@"kissing"]];
        [cell setIntelligenceRate:[self.person.personRatings objectForKey:@"intelligence"]];
        [cell setOralRate:[self.person.personRatings objectForKey:@"oral"]];
        [cell setHairRate:[self.person.personRatings objectForKey:@"hair"]];
        [cell setIntercoursRate:[self.person.personRatings objectForKey:@"intercourse"]];
    }
    
    return cell;
}

- (AboutCell *)aboutCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutCellId];
    
    if (!cell) {
        cell = [AboutCell createView];
    }
    
    [cell setAboutCellColor:indexPath.row % 2];
    
    [cell setCategoryName:_aboutCategoryArray[indexPath.row]];
    [cell setInfoText:[self.aboutPersonDictionary objectForKey:_aboutCategoryArray[indexPath.row]]];
    
    return cell;
}

- (CommentCell *)commentCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellId];
    
    if (!cell) {
        cell = [CommentCell createView];
    }
    
    cell.commentText = _commentText;
    return cell;
}

- (SpecialsCell *)specialsCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SpecialsCell *cell = [tableView dequeueReusableCellWithIdentifier:SpecialsCellId];
    
    if (!cell) {
        cell = [SpecialsCell createView];
    }
    
    [cell setSpecialsCellColor:indexPath.row % 2];
    [cell setCategoryName:[self.attributesDictionary objectForKey: _specialsCategoryArray[indexPath.row]]];
    
    return cell;
}

- (SocialCell *)socialCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SocialCell *cell = [tableView dequeueReusableCellWithIdentifier:SocialCellId];
    
    if (!cell) {
        cell = [SocialCell createView];
    }
    
    [cell setSocialCellColor:indexPath.row % 2];
    [cell setIconImage:[UIImage imageNamed:_socialIconsNamesArray[indexPath.row]]];
    [cell setSocialNameString:[self.socialDictionary objectForKey:_socialIconsNamesArray[indexPath.row]]];
    
    return cell;
}

- (HistoryCell *)historyCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryCellId];
    
    if (!cell) {
        cell = [HistoryCell createView];
    }
    [cell setEvents:self.person.events];
    return cell;
}

#pragma mark - Private methods


- (BOOL)checkSocialDictionary {
    return self.person.socialMedia.count > 0 && (![self.person.socialMedia[@"facebook"] isEqualToString:@""] || ![self.person.socialMedia[@"instagram"] isEqualToString:@""] || ![self.person.socialMedia[@"snapchat"] isEqualToString:@""]);
}

- (void)setupSectionsNames {
    self.namesForSection = [NSMutableArray new];
    [self.namesForSection addObject:PHOTO_SECTION_TITLE];
    [self.namesForSection addObject:ABOUT_SECTION_TITLE];

    if (self.person.comment && ![self.person.comment isEqualToString:@""]) {
        [self.namesForSection addObject:COMMENTS_SECTION_TITLE];
    }

    if (self.person.attributes && self.person.attributes.count != 0) {
        [self.namesForSection addObject:SPECIALS_SECTION_TITLE];
    }
    if ([self checkSocialDictionary]) {
        [self.namesForSection addObject:SOCIAL_SECTION_TITLE];
    }
    
    [self.namesForSection addObject:HISTORY_SECTION_TITLE];
    
}

- (NSInteger)numberOfSections {
    NSInteger numberOfSections = 3;
    if (self.person.attributes && self.person.attributes.count != 0) {
        numberOfSections++;
    }
    if ([self checkSocialDictionary]) {
        numberOfSections++;
    }
    if (self.person.comment && ![self.person.comment isEqualToString:@""]) {
        numberOfSections++;
    }
    
    return numberOfSections;
}

- (CGFloat)heightForCommentCellWithText: (NSString*)text {
    UITextView *helpTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    
    helpTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    helpTextView.font = [UIFont fontWithName:@"Lato-Regular" size:14.f];
    helpTextView.text = text;
    
    [helpTextView sizeToFit];
    
    return helpTextView.frame.size.height + 5;
}

- (void)setupAboutPerson {
    _aboutPersonDictionary = [NSMutableDictionary new];
    _aboutCategoryArray = [NSMutableArray new];
    
    if (self.person.category) {
        [self.aboutPersonDictionary setObject:[self.categories objectForKey:self.person.category] forKey:@"Potential"];
        [_aboutCategoryArray addObject:@"Potential"];
        
    }
    if (self.person.dateOfBirth) {
        NSDateFormatter *formatter = [TTFormatter dateFormatter];
        NSString *dateAndAge = [NSString stringWithFormat:@"%zd (%@)",[self.person.age integerValue],[formatter stringFromDate:self.person.dateOfBirth]];
        [self.aboutPersonDictionary setObject:dateAndAge forKey:@"Age"];
        [_aboutCategoryArray addObject:@"Age"];
    } else if (self.person.age) {
        [self.aboutPersonDictionary setObject:[self.person.age stringValue] forKey:@"Age"];
        [_aboutCategoryArray addObject:@"Age"];
    }
    if (self.person.location) {
        [self.aboutPersonDictionary setObject:[self.person.location capitalizedString] forKey:@"Meeting Point"];
        [_aboutCategoryArray addObject:@"Meeting Point"];
    }
    
    if (self.person.job) {
        if(self.jobsDictionary[self.person.job]) {
            [self.aboutPersonDictionary setObject:self.jobsDictionary[self.person.job] forKey:@"Job"];
        } else {
            [self.aboutPersonDictionary setObject:[self.person.job capitalizedString] forKey:@"Job"];
        }
        
        [self.aboutPersonDictionary setObject:[self.person.job capitalizedString] forKey:@"Job"];
        [_aboutCategoryArray addObject:@"Job"];
    }
    if (self.person.phoneNumber) {
        [self.aboutPersonDictionary setObject:self.person.phoneNumber forKey:@"Phone"];
        [_aboutCategoryArray addObject:@"Phone"];
    }
    
    NSString *city = [self.person.city objectForKey:@"name"];
    NSString *county = self.person.country;
    
    if (county && city && ![city isEqual:[NSNull null]]) {
        
        NSString *residence = [NSString stringWithFormat:@"%@, %@",[self.person.city objectForKey:@"name"],[self.countriesDictionary objectForKey:self.person.country]];
        [self.aboutPersonDictionary setObject:residence forKey:@"Residence"];
        [_aboutCategoryArray addObject:@"Residence"];
    } else if (county) {
        [self.aboutPersonDictionary setObject:[self.countriesDictionary objectForKey:self.person.country] forKey:@"Residence"];
        [_aboutCategoryArray addObject:@"Residence"];
        
    }
    
    if (self.person.hairColor && [self.hairColorsDictionary objectForKey:self.person.hairColor]) {
        [self.aboutPersonDictionary setObject:[self.hairColorsDictionary objectForKey:self.person.hairColor] forKey:@"Hair Color"];
        [_aboutCategoryArray addObject:@"Hair Color"];
    }
}

- (void)setupSocialMedia {
    _socialDictionary = [NSMutableDictionary new];
    _socialIconsNamesArray = [NSMutableArray new];
    if (self.person.socialMedia.count > 0) {
        if ([self.person.socialMedia objectForKey:@"facebook"] && ![[self.person.socialMedia objectForKey:@"facebook"] isEqualToString:@""]) {
            [_socialDictionary setObject:[self.person.socialMedia objectForKey:@"facebook"] forKey:@"card-icon-facebook"];
            [_socialIconsNamesArray addObject:@"card-icon-facebook"];
        }
        if ([self.person.socialMedia objectForKey:@"instagram"] && ![[self.person.socialMedia objectForKey:@"instagram"] isEqualToString:@""]) {
            [_socialDictionary setObject:[self.person.socialMedia objectForKey:@"instagram"] forKey:@"card-icon-instagram"];
            [_socialIconsNamesArray addObject:@"card-icon-instagram"];
        }
        if ([self.person.socialMedia objectForKey:@"snapchat"] && ![[self.person.socialMedia objectForKey:@"snapchat"] isEqualToString:@""]) {
            [_socialDictionary setObject:[self.person.socialMedia objectForKey:@"snapchat"] forKey:@"card-icon-snapchat"];
            [_socialIconsNamesArray addObject:@"card-icon-snapchat"];
        }
    }
}

#pragma mark - Public methods

- (void)setPerson:(Person *)person {
    _person = person;
    
    [self.flagImageView setImage:person.flagImage];
    
    if (person.lastName) {
        self.nameLable.text = [NSString stringWithFormat:@"%@ %@",person.firstName,person.lastName];
    } else {
        self.nameLable.text = person.firstName;
    }
    
    [_starRateView setValue:[person.rating floatValue]];
    [self setupPersonInfo];
    [self setupSectionsNames];
    [_tableView reloadData];
}

@end
