//
//  FullCheckInGeneralVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCheckInGeneralVC.h"
#import "ExtendedButton.h"
#import "Global.h"
#import "SelectionButton.h"
#import "RoundRateView.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "DataStore.h"
#import "DataStoreEntity.h"
#import "CoreDataManager.h"
#import "SearchTableVC.h"
#import "PersonEntity.h"
#import "UINavigationItem+CustomBackButton.h"
#import "FullCheckInVC.h"
#import "SearchCityVC.h"
#import "ActionButton.h"
#import "JTCalendarVC.h"
#import "WYPopoverController.h"
#import "KeyboardHandlingMechanism.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface FullCheckInGeneralVC () <SearchTableProtocol, SearchCityProtocol, JTCalendarVCDelegate, UITextViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(ExtendedButton) NSArray *radioButtonsCollection;

@property (strong, nonatomic)WYPopoverController *popover;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *faclebookField;
@property (weak, nonatomic) IBOutlet UITextField *instagramField;
@property (weak, nonatomic) IBOutlet UITextField *snapchatField;
@property (strong, nonatomic)DataStore *dataStore;

@property (strong, nonatomic)KeyboardHandlingMechanism *keyboardHandlingMechanism;

@property (weak, nonatomic) IBOutlet SelectionButton *meetingPointBtn;
@property (weak, nonatomic) IBOutlet UITextField *surnameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet SelectionButton *jobBtn;
@property (weak, nonatomic) IBOutlet SelectionButton *hairColorBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *birthdayDateBtn;
@property (weak, nonatomic) IBOutlet SelectionButton *nationalityBtn;
@property (weak, nonatomic) IBOutlet SelectionButton *countryBtn;
@property (weak, nonatomic) IBOutlet SelectionButton *cityBtn;
@property (strong, nonatomic)id currentSender;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *rateStarView;
@property (weak, nonatomic) IBOutlet RoundRateView *rateView;
@property (nonatomic) StoryType selectedStoryType;
@property (weak, nonatomic) IBOutlet ActionButton *dateBtn;
@property (weak, nonatomic) IBOutlet ActionButton *kissBtn;
@property (weak, nonatomic) IBOutlet ActionButton *loveBtn;
@property (strong, nonatomic)NSDictionary *categories;

@property (strong, nonatomic)JTCalendarVC *dateCalendar;
@property (strong, nonatomic)JTCalendarVC *kissCalendar;
@property (strong, nonatomic)JTCalendarVC *loveCalendar;
@property (strong, nonatomic)JTCalendarVC *birthDayCalendar;

@property (strong, nonatomic)NSDictionary *jobsDictionary;
@property (strong, nonatomic)NSDictionary *hairColorsDictionary;

- (IBAction)nationalityTapped:(id)sender;
- (IBAction)countryTapped:(id)sender;
- (IBAction)cityTapped:(id)sender;
- (IBAction)meetingPointTaped:(id)sender;
- (IBAction)jobTapped:(id)sender;
- (IBAction)hairColorTapped:(id)sender;
- (IBAction)dateTapped:(UIButton *)sender;
- (IBAction)kissTapped:(UIButton *)sender;
- (IBAction)loveTapped:(UIButton *)sender;
- (IBAction)birthdayDateTapped:(UIButton *)sender;
- (IBAction)loveIconTapped:(UIButton *)sender;
- (IBAction)kissIconTapped:(UIButton *)sender;
- (IBAction)dateIconTapped:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@end

@implementation FullCheckInGeneralVC

#pragma mark - System and init methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboardHandlingMechanism = [KeyboardHandlingMechanism new];
    //    [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.dataStore = [self getDataStoreFromDataBase];
    [self initializeMappingDictionaries];
    
    [self setupUi];
    //    [self setupPersonInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self.keyboardHandlingMechanism registerForKeyboardNotificationWithController:self scrollView:self.scrollView bottomConstraint:self.bottomConstraint];
    
    if (self.person.rating) {
        [_rateStarView setValue:self.person.rating.floatValue / 2.0f];
    }
}

#pragma mark - Story actions

- (IBAction)readStoryButtonAction:(ExtendedButton *)sender {
    
    StoryType storyType = (int)sender.tag;
    
    self.selectedStoryType = storyType;
    
    [self performSegueWithIdentifier:@"FullCheckInGeneralVC@StoryListVC" sender:self];
    
}

- (IBAction)addStoryButtonAction:(ExtendedButton *)sender {
    
    StoryType storyType = (int)sender.tag;
    self.selectedStoryType = storyType;
    
    [self performSegueWithIdentifier:@"FullCheckInGeneralVC@AddStoryVC" sender:self];
}

#pragma mark - Radio Buttons Action

- (IBAction)radioButtonAction:(ExtendedButton *)sender {
    
    for (ExtendedButton *button in self.radioButtonsCollection) {
        [button setBackgroundColor:[UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.f]];
        [button setTitleColor:DARK_COLOR forState:UIControlStateNormal | UIControlStateSelected];
    }
    
    if (!sender.isSelected) {
        [sender setBackgroundColor:[UIColor colorWithRed:208.f / 255.f green:2.f / 255.f blue:27.f / 255.f alpha:1.f]];
        for (ExtendedButton *button in self.radioButtonsCollection) {
            button.isSelected = NO;
        }
        sender.isSelected = YES;
        self.person.category = [self.categories objectForKey:sender.titleLabel.text];
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal | UIControlStateSelected];
    } else {
        sender.isSelected = NO;
        self.person.category = nil;
    }
}

#pragma mark - Private methods

- (void)initializeMappingDictionaries {
    self.categories = @{
                        @"Wedding material" : @"wedding",
                        @"Girlfriend material" : @"girlfriend",
                        @"Friends with benefits" : @"friends",
                        @"Backup girl" : @"backup"
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
}

- (NSDate *)currentYearMinusEighteen {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd"];
    [formater setLocale:[NSLocale systemLocale]];
    NSString *nowDateString = [formater stringFromDate:[NSDate date]];
    NSArray *dateComponets = [nowDateString componentsSeparatedByString:@"-"];
    NSInteger year = [[dateComponets firstObject] integerValue];
    nowDateString = [NSString stringWithFormat:@"%zd-12-31",year-18];
    NSDate *currDate = [formater dateFromString:nowDateString];
    return currDate;
}
- (NSString *)dictionary:(NSDictionary *)dictionary keyForValue:(id)value{
    NSArray *allKeys = [dictionary allKeysForObject:value];
    return [allKeys firstObject];
}
- (void)setPerson:(Person *)person {
    _person = person;
    
    self.nameField.text = person.firstName;
    [self.ageField setText:[person.age stringValue]];
    
    NSString *country = [[self getCountriesFromDataStore] objectForKey:person.country];
    NSString *nationality =[[self getNationalitiesFromDataStore] objectForKey:person.nationality];
    if (country && ![country isEqualToString:@""]) {
        [self.countryBtn setTitle:country forState:UIControlStateNormal];
    }
    [self.nationalityBtn setTitle:nationality forState:UIControlStateNormal];
    
    [self setupPersonInfo];
}

- (void)savePerson {
    
    [self.nameField removeSpacesFromString];
    
    self.person.firstName = [self.nameField.text capitalizedString];
    
    if ([self.surnameField.text isEqualToString:@""]) {
        self.person.lastName = nil;
    } else {
        [self.surnameField removeSpacesFromString];
        
        self.person.lastName = [self.surnameField.text capitalizedString];
    }
    
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [formater numberFromString:self.ageField.text];
    self.person.age = myNumber;
    
    //    self.person.nationality = self.nationalityBtn.titleLabel.text;
    
    // setup countries
    NSString *knownObject = self.nationalityBtn.titleLabel.text;
    NSArray *nationalityArray = [knownObject componentsSeparatedByString:@", "];
    NSArray *temp = [[self.dataStore.internationalisation objectForKey:@"nationalities"] allKeysForObject:[nationalityArray firstObject]];
    NSString *key = [temp objectAtIndex:0];
    self.person.nationality = [NSString stringWithString:key];
    self.person.state = nil;
    if (nationalityArray.count > 1) {
        temp = [self.dataStore.states allKeysForObject:[nationalityArray lastObject]];
        NSString *stateKey =[temp objectAtIndex:0];
        self.person.state = [NSString stringWithString:stateKey];
    }
    NSDictionary *countries = [self getNationalitiesFromDataStore];
    
    NSString *country = self.countryBtn.titleLabel.text;
    if(country && ![country isEqualToString:@""] && ![country isEqualToString:@"In which country does she live?"]){
        knownObject = self.countryBtn.titleLabel.text;
        countries = [self getCountriesFromDataStore];
        temp = [countries allKeysForObject:knownObject];
        key = [temp objectAtIndex:0];
        self.person.country = key;
    }
    
    if ([self.jobBtn.titleLabel.text isEqualToString:@"Job?"]) {
        self.person.job = nil;
    } else {
        NSString *value = [self dictionary:self.jobsDictionary keyForValue: self.jobBtn.titleLabel.text];
        if(value) {
            self.person.job = value;
        } else {
            self.person.job = [self.jobBtn.titleLabel.text lowercaseString];
        }
    }
    
    if ([self.hairColorBtn.titleLabel.text isEqualToString:@"Hair сolor?"]) {
        self.person.hairColor = nil;
    } else {
        self.person.hairColor= [self dictionary:self.hairColorsDictionary keyForValue: self.hairColorBtn.titleLabel.text];
    }
    
    if ([self.meetingPointBtn.titleLabel.text isEqualToString:@"Where did you meet her?"]) {
        self.person.location = nil;
    } else {
        self.person.location= [self.meetingPointBtn.titleLabel.text lowercaseString];
    }
    
    
    if (self.phoneNumberField.text && self.phoneNumberField.text.length > 0) {
        
        self.person.phoneNumber = self.phoneNumberField.text;
    }
    
//    self.person.rating = self.rateView.roundRateViewValue;
    self.person.rating = @(self.rateStarView.value * 2.0f);

    NSDateFormatter *dateFormater = [TTFormatter dateFormatter];
    self.person.dateOfBirth = [dateFormater dateFromString:self.birthdayDateBtn.titleLabel.text];
    self.person.socialMedia = @{@"facebook" : self.faclebookField.text,
                                @"instagram" : self.instagramField.text,
                                @"snapchat" : self.snapchatField.text};
    
    NSDate *dateDate = [dateFormater dateFromString:self.dateBtn.titleLabel.text];
    NSDate *kissDate = [dateFormater dateFromString:self.kissBtn.titleLabel.text];
    NSDate *loveDate = [dateFormater dateFromString:self.loveBtn.titleLabel.text];
    NSMutableDictionary *dictionary;
    
    if (self.person.events.count > 0) {
        dictionary = [[NSMutableDictionary alloc] initWithDictionary:self.person.events];
    } else {
        dictionary = [NSMutableDictionary new];
    }
    if (dateDate) {
        [dictionary setObject:self.dateBtn.titleLabel.text forKey:@"DATE"];
    }
    if (kissDate) {
        [dictionary setObject:self.kissBtn.titleLabel.text forKey:@"KISS"];
    }
    if (loveDate) {
        [dictionary setObject:self.loveBtn.titleLabel.text forKey:@"LOVE"];
    }
    
    self.person.events = dictionary;
    if ([self.commentTextView.text isEqualToString:@"Any comments?"]) {
        self.person.comment = nil;
    } else {
        self.person.comment = self.commentTextView.text;
    }
    for(ExtendedButton *button in self.radioButtonsCollection) {
        if ([button isSelected]) {
            
        }
    }
}

- (void)setupPersonInfo {
    self.nameField.text = self.person.firstName;
    self.surnameField.text = self.person.lastName;
    self.ageField.text = [self.person.age stringValue];
    NSDateFormatter *dateFormater = [TTFormatter dateFormatter];
    [self.birthdayDateBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
    
    if (self.person.dateOfBirth) {
        [self.birthdayDateBtn setTitle:[dateFormater stringFromDate:self.person.dateOfBirth] forState:UIControlStateNormal];
        [self.birthdayDateBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    }
    
    
    NSString *country = [[self getCountriesFromDataStore] objectForKey:self.person.country];
    NSString *nationality;
    if (self.person.state) {
        nationality = [NSString stringWithFormat:@"%@, %@",[[self getNationalitiesFromDataStore] objectForKey:self.person.nationality], [self.dataStore.states objectForKey:self.person.state]];
    } else {
        nationality = [[self getNationalitiesFromDataStore] objectForKey:self.person.nationality];
    }
    
    
    [self.countryBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
    if (country && ![country isEqualToString:@""]) {
        [self.countryBtn setTitle:country forState:UIControlStateNormal];
        [self.countryBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    }
    [self.nationalityBtn setTitle:nationality forState:UIControlStateNormal];
    
    
    if (self.person.city && ![[self.person.city valueForKey:@"name"] isEqual:[NSNull null]]) {
        [self.cityBtn setTitle:[self.person.city valueForKey:@"name"] forState:UIControlStateNormal];
        [self.cityBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    } else {
        [self.cityBtn setTitle:@"In which city does she live?" forState:UIControlStateNormal];
        
        [self.cityBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
    }
    
    if (self.person.location) {
        [self.meetingPointBtn setTitle:[self.person.location capitalizedString] forState:UIControlStateNormal];
        
        [self.meetingPointBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    } else {
        [self.meetingPointBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
    }
    
    if (self.person.job) {
        if(self.jobsDictionary[self.person.job]) {
            [self.jobBtn setTitle:[self.jobsDictionary[self.person.job] capitalizedString] forState:UIControlStateNormal];
        } else {
            [self.jobBtn setTitle:[self.person.job capitalizedString] forState:UIControlStateNormal];
        }
        [self.jobBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    } else {
        [self.jobBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
    }
    
    if (self.person.hairColor) {
        [self.hairColorBtn setTitle:[self.hairColorsDictionary objectForKey: self.person.hairColor] forState:UIControlStateNormal];
        [self.hairColorBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    } else {
        [self.hairColorBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
    }
    
    self.phoneNumberField.text = self.person.phoneNumber;
    if (self.person.rating) {
        [_rateStarView setValue:self.person.rating.floatValue / 2.0f];
    }

    if (self.person.socialMedia.count > 0) {
        self.faclebookField.text = [self.person.socialMedia objectForKey:@"facebook"];
        self.instagramField.text = [self.person.socialMedia objectForKey:@"instagram"];
        self.snapchatField.text = [self.person.socialMedia objectForKey:@"snapchat"];
    }
    
    [self.rateView setRoundRateViewValue:self.person.rating];
    
    
    if (self.person.rating != nil) {
        [self.rateSlider setValue:[self.person.rating floatValue]];
    } else {
        [self.rateSlider setValue:5.f];
    }
    
    if (self.radioButtonsCollection && self.person.category && self.person.category.length > 0) {
        ExtendedButton *button;
        if ([self.person.category isEqualToString:@"wedding"]) {
            button = [_radioButtonsCollection objectAtIndex:0];
        } else if ([self.person.category isEqualToString:@"girlfriend"]) {
            button = [_radioButtonsCollection objectAtIndex:1];
        } else if ([self.person.category isEqualToString:@"friends"]) {
            button = [_radioButtonsCollection objectAtIndex:2];
        } else if ([self.person.category isEqualToString:@"backup"]) {
            button = [_radioButtonsCollection objectAtIndex:3];
        }
        
        [button setBackgroundColor:[UIColor colorWithRed:208.f / 255.f green:2.f / 255.f blue:27.f / 255.f alpha:1.f]];
        button.isSelected = YES;
        self.person.category = [self.categories objectForKey:button.titleLabel.text];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal | UIControlStateSelected];
    }
    
    NSDate *dateDate;
    NSDate *kissDate;
    NSDate *loveDate;
    
    if (self.person.events.count > 0) {
        dateDate = [dateFormater dateFromString:[self.person.events objectForKey:@"DATE"]];
        kissDate = [dateFormater dateFromString:[self.person.events objectForKey:@"KISS"]];
        loveDate = [dateFormater dateFromString:[self.person.events objectForKey:@"LOVE"]];
    }
    
    if (dateDate) {
        [self.dateBtn setTitle:[self.person.events objectForKey:@"DATE"] forState:UIControlStateNormal];
        [self.dateBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1]forState:UIControlStateNormal];
        self.dateBtn.isChecked = YES;
    }
    if (kissDate) {
        [self.kissBtn setTitle:[self.person.events objectForKey:@"KISS"] forState:UIControlStateNormal];
        [self.kissBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1]forState:UIControlStateNormal];
        self.kissBtn.isChecked = YES;
    }
    if (loveDate) {
        [self.loveBtn setTitle:[self.person.events objectForKey:@"LOVE"] forState:UIControlStateNormal];
        [self.loveBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1]forState:UIControlStateNormal];
        self.loveBtn.isChecked = YES;
    }
    NSString *string = self.person.comment;
    if (string && ![string isEqualToString:@""]) {
        self.commentTextView.text = string;
    }
}

- (void)uncheckCheckedActionButton {
    [self.dateBtn setTitle:@"Soon!" forState:UIControlStateNormal];
    [self.kissBtn setTitle:@"Soon!" forState:UIControlStateNormal];
    [self.loveBtn setTitle:@"Soon!" forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [self.kissBtn setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [self.loveBtn setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [self.person.events removeAllObjects];
}

- (void)setupUi {
    [self.rateSlider setThumbImage:[UIImage imageNamed:@"ui-slider-button"] forState:UIControlStateNormal];
    [self.rateSlider addTarget:self action:@selector(rateSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.rateView setFontName:@"Lato-Light" size:13];
    [self.rateStarView setValue:2.5f];
    [self setupTextFields];
}

- (NSDictionary *)getCountriesFromDataStore {
    NSDictionary *countriesDictionary = [self.dataStore.internationalisation objectForKey:@"countries"];
    return  countriesDictionary;
}

- (NSDictionary *)getNationalitiesFromDataStore {
    NSDictionary *countriesDictionary = [self.dataStore.internationalisation objectForKey:@"nationalities"];
    return  countriesDictionary;
}

- (DataStore *)getDataStoreFromDataBase {
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
    DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
    
    if (lError != nil) {
        NSLog(@"%@ %s %@", self.class, __func__, lError.description);
    }
    
    return dataStore;
}

- (void)setupTextFields {
    
    [self.nameField setReturnKeyType:UIReturnKeyDone];
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.nameField addTarget:self
                       action:@selector(dismissKeyboard)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    self.nameField.delegate = self;
    
    [self.surnameField setReturnKeyType:UIReturnKeyDone];
    self.surnameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.surnameField addTarget:self
                          action:@selector(dismissKeyboard)
                forControlEvents:UIControlEventEditingDidEndOnExit];
    self.surnameField.delegate = self;
    
    [self.ageField setReturnKeyType:UIReturnKeyDone];
    [self.ageField addTarget:self
                      action:@selector(dismissKeyboard)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    self.ageField.delegate = self;
    
    [self.phoneNumberField setReturnKeyType:UIReturnKeyDone];
    [self.phoneNumberField addTarget:self
                              action:@selector(dismissKeyboard)
                    forControlEvents:UIControlEventEditingDidEndOnExit];
    self.phoneNumberField.delegate = self;
    self.phoneNumberField.inputAccessoryView = [self inputAccessoryView];
    
    
    [self.instagramField setReturnKeyType:UIReturnKeyDone];
    [self.instagramField addTarget:self
                            action:@selector(dismissKeyboard)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
    self.instagramField.delegate = self;
    
    
    [self.faclebookField setReturnKeyType:UIReturnKeyDone];
    [self.faclebookField addTarget:self
                            action:@selector(dismissKeyboard)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
    self.faclebookField.delegate = self;
    
    
    [self.snapchatField setReturnKeyType:UIReturnKeyDone];
    [self.snapchatField addTarget:self
                           action:@selector(dismissKeyboard)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    self.snapchatField.delegate = self;
    
    [self.commentTextView setContentInset:UIEdgeInsetsMake(0, 0, self.commentTextView.contentOffset.y, self.commentTextView.contentOffset.x)];
    
    [self.commentTextView setReturnKeyType:UIReturnKeyDone];
    
    self.commentTextView.delegate = self;
}

- (UIToolbar *)inputAccessoryView {
    UIToolbar *accessoryView = [[UIToolbar alloc] init];
    
    UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    UIBarButtonItem *flexSpace   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *placeholder = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [accessoryView sizeToFit];
    [accessoryView setItems:[NSArray arrayWithObjects: flexSpace, placeholder, doneButton, nil] animated:YES];
    return accessoryView;
}

- (void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.surnameField resignFirstResponder];
    [self.ageField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.faclebookField resignFirstResponder];
    [self.instagramField resignFirstResponder];
    [self.snapchatField resignFirstResponder];
    [self.commentTextView resignFirstResponder];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        
    }];
}

- (void)selectDateButtonWithDate:(NSDate *)date {
    self.dateBtn.isChecked = YES;
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    [self.dateBtn setTitle:[formater stringFromDate:date] forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1] forState:UIControlStateNormal];
    
}

- (void)selectKissButtonWithDate:(NSDate *)date {
    self.kissBtn.isChecked = YES;
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    NSDate *dateDate = [formater dateFromString:[self.person.events objectForKey:@"DATE"]];
    NSDate *dateFromButton = [formater dateFromString:self.dateBtn.titleLabel.text];
    
    if (!dateDate && !dateFromButton) {
        self.dateBtn.isChecked = YES;
        [self.dateBtn setTitle:[formater stringFromDate:date] forState:UIControlStateNormal];
        [self.dateBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1] forState:UIControlStateNormal];
    }
    
    [self.kissBtn setTitle:[formater stringFromDate:date] forState:UIControlStateNormal];
    [self.kissBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1] forState:UIControlStateNormal];
    
}

- (void)selectLoveButtonWithDate:(NSDate *)date {
    self.loveBtn.isChecked = YES;
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    
    NSDate *dateDate = [formater dateFromString:[self.person.events objectForKey:@"DATE"]];
    NSDate *kissDate = [formater dateFromString:[self.person.events objectForKey:@"KISS"]];
    NSDate *dateFromButton = [formater dateFromString:self.dateBtn.titleLabel.text];
    NSDate *kissFromButton = [formater dateFromString:self.kissBtn.titleLabel.text];
    
    if (!dateDate && !dateFromButton) {
        [self.dateBtn setTitle:[formater stringFromDate:date] forState:UIControlStateNormal];
        [self.dateBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1] forState:UIControlStateNormal];
        self.dateBtn.isChecked = YES;
    }
    if (!kissDate && !kissFromButton) {
        [self.kissBtn setTitle:[formater stringFromDate:date] forState:UIControlStateNormal];
        [self.kissBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1] forState:UIControlStateNormal];
        self.kissBtn.isChecked = YES;
    }
    
    [self.loveBtn setTitle:[formater stringFromDate:date] forState:UIControlStateNormal];
    [self.loveBtn setTitleColor:[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1] forState:UIControlStateNormal];
    
}

- (void)selectBirthDayWithDate:(NSDate *)date {
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    [self.birthdayDateBtn setTitle:[formater stringFromDate:date] forState:UIControlStateNormal];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:date
                                       toDate:[NSDate date]
                                       options:0];
    [self.ageField setText:[NSString stringWithFormat:@"%li",(long)ageComponents.year]];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self dismissKeyboard];
        return NO;
    }
    
    return YES;
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardHandlingMechanism addActiveTextField:textField];
}

#pragma mark - Text view delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.commentTextView.text isEqualToString:@"Any comments?"]) {
        self.commentTextView.text = @"";
        
    }
    [self.view layoutIfNeeded];
    self.bottomConstraint.constant = 230;
    [self.view layoutIfNeeded];
    CGRect rect = [self.commentTextView superview].frame;
    
    [self.scrollView scrollRectToVisible:CGRectMake(rect.origin.x, rect.origin.y + 210, rect.size.width, rect.size.height) animated:YES];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.commentTextView) {
        if ([self.commentTextView.text isEqualToString:@""]) {
            self.commentTextView.text = @"Any comments?";
            [self.commentTextView setTextColor:[UIColor lightGrayColor]];
        }
    }
    
}

#pragma mark - Calendar delegate

- (void)calendar:(JTCalendarVC *)calendar didSelectDate:(NSDate *)date {
    NSDate *nowDate = [NSDate date];
    //    BOOL dismiss = YES;
    if ([date compare:nowDate] == NSOrderedDescending) {
        calendar.calendarView.date = [NSDate date];
        [self showAlertControllerWithTitle:@"" withMessage:@"You can't pick a date in the future"];
    } else {
        if (calendar == self.dateCalendar) {
            [self selectDateButtonWithDate:date];
            self.dateCalendar = nil;
        }
        if (calendar == self.kissCalendar) {
            [self selectKissButtonWithDate:date];
            self.kissCalendar = nil;
        }
        if (calendar == self.loveCalendar) {
            [self selectLoveButtonWithDate:date];
            self.loveCalendar = nil;
        }
        if (calendar == self.birthDayCalendar) {
            NSDate *currentDateMinusEighteen = [self currentYearMinusEighteen];
            if ([date compare:currentDateMinusEighteen] == NSOrderedDescending) {
                calendar.calendarView.date = currentDateMinusEighteen;
                [self showAlertControllerWithTitle:@"Wrong Date!" withMessage:@"Girl should be over 18 years old."];
                //                dismiss = NO;
            } else {
                [self selectBirthDayWithDate:date];
                self.birthDayCalendar = nil;
            }
        }
        //        if (dismiss) {
        //        }
    }
    [self.popover dismissPopoverAnimated:YES];
    
}

#pragma mark - SearchTableVC delegate

- (void)stringWasSelected:(NSString *)string {
    [self.currentSender setTitle:string forState:UIControlStateNormal];
    [self.currentSender setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    
    if(self.currentSender == self.countryBtn) {
        [self.cityBtn setTitle:@"In which city does she live?" forState:UIControlStateNormal];
        [self.cityBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
        
        self.person.city = nil;
    }
}

#pragma mark - SearchCityProtocol

- (void)cityWasSelected:(NSDictionary *)city {
    
    [self.cityBtn setTitle:[city objectForKey:@"name"] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    
    self.person.city = city;
}

#pragma  mark - IBActions

- (IBAction)rateSliderValueChange:(id)sender {
    UISlider *slider = sender;
    
    [self.rateView setRoundRateViewValue:@(slider.value)];
//    self.person.rating = @(slider.value);
}

- (IBAction)girlRateValueChanged {
    self.person.rating = @(_rateStarView.value * 2.f);
}

- (IBAction)countryTapped:(id)sender {
    SearchTableVC *vc = [SearchTableVC new];
    vc.searchValuesArray = [[self.dataStore.internationalisation objectForKey:@"countries"] allValues];
    vc.delegate = self;
    self.currentSender = sender;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cityTapped:(id)sender {
    
    if ([[SyncManager sharedInstance] connected]) {
        SearchCityVC *vc = [SearchCityVC new];
        // setup countries
        NSString *knownObject = self.countryBtn.titleLabel.text;
        NSDictionary *countries = [self getCountriesFromDataStore];
        NSArray *temp = [countries allKeysForObject:knownObject];
        if (temp.count != 0) {
            NSString *key = [temp objectAtIndex:0];
            
            vc.country = key;
            vc.delegate = self;
            self.currentSender = sender;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Please choose country first!"];
        }
        
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
        
        alertController.view.tintColor = [UIColor colorWithRed:217.f / 255.f green:63.f / 255.f blue:48.f / 255.f alpha:1.f];
    }
}

- (IBAction)meetingPointTaped:(id)sender {
    UIButton * button = sender;
    NSMutableArray *meetingPoints = [NSMutableArray new];
    for (NSString *string in self.dataStore.locations) {
        [meetingPoints addObject:[string capitalizedString]];
    }
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"Meeting Point" rows:meetingPoints initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [picker.pickerView setTintColor:[UIColor redColor]];
        
        [button setTitle:selectedValue forState:UIControlStateNormal];
        
        [button setTitleColor:DARK_COLOR forState:UIControlStateNormal];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    [doneButton setTitle:@"Done"];
    [doneButton setTintColor:RED_COLOR];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] init];
    [cancelButton setTitle:@"Cancel"];
    [cancelButton setTintColor:RED_COLOR];
    [picker setDoneButton:doneButton];
    [picker setCancelButton:cancelButton];
    [picker showActionSheetPicker];
    
}

- (IBAction)jobTapped:(id)sender {
    UIButton * button = sender;
    NSMutableArray *jobs = [NSMutableArray new];
    for (NSString *string in self.dataStore.jobs) {
        if(self.jobsDictionary[string]) {
            [jobs addObject:self.jobsDictionary[string]];
        } else {
            [jobs addObject:[string capitalizedString]];
        }
    }
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"Job" rows:jobs initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [picker.pickerView setTintColor:[UIColor redColor]];
        [button setTitle:selectedValue forState:UIControlStateNormal];
        [button setTitleColor:DARK_COLOR forState:UIControlStateNormal];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    [doneButton setTitle:@"Done"];
    [doneButton setTintColor:RED_COLOR];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] init];
    [cancelButton setTitle:@"Cancel"];
    [cancelButton setTintColor:RED_COLOR];
    [picker setDoneButton:doneButton];
    [picker setCancelButton:cancelButton];
    [picker showActionSheetPicker];
    
}

- (IBAction)hairColorTapped:(id)sender {
    UIButton *button = sender;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != 'GRY' && SELF != 'WHT'"];
    NSArray *hairColors = [self.dataStore.hairColor filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *hairColorStrings = [NSMutableArray new];
    for (NSString *string in hairColors) {
        [hairColorStrings addObject:[self.hairColorsDictionary objectForKey:string]];
    }
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"Hair color" rows:hairColorStrings initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [picker.pickerView setTintColor:[UIColor redColor]];
        
        [button setTitle:selectedValue forState:UIControlStateNormal];
        [button setTitleColor:DARK_COLOR forState:UIControlStateNormal];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    [doneButton setTitle:@"Done"];
    [doneButton setTintColor:RED_COLOR];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] init];
    [cancelButton setTitle:@"Cancel"];
    [cancelButton setTintColor:RED_COLOR];
    [picker setDoneButton:doneButton];
    [picker setCancelButton:cancelButton];
    [picker showActionSheetPicker];
    
}

- (void)setupPopupCalendarDemo:(JTCalendarVC *)calendar inView:(UIView *)view {
    //    calendar.delegate = self;
    self.popover = [[WYPopoverController alloc] initWithContentViewController:calendar];
    [self.popover presentPopoverFromRect:self.navigationController.navigationBar.frame
                                  inView:view
                permittedArrowDirections:WYPopoverArrowDirectionNone
                                animated:YES
                                 options:WYPopoverAnimationOptionFadeWithScale];
    
    [self.popover setPopoverContentSize:CGSizeMake(calendar.calendarView.frame.size.width , calendar.calendarView.frame.size.height + calendar.headerView.frame.size.height)];
}


- (IBAction)dateTapped:(UIButton *)sender {
    ActionButton *button = (ActionButton *)sender;
    if (button.isChecked) {
        button.isChecked = NO;
        [button setTitle:@"Soon!" forState:UIControlStateNormal];
        [button setTitleColor:RED_COLOR forState:UIControlStateNormal];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.person.events];
        [dictionary removeObjectForKey:@"DATE"];
        self.person.events = dictionary;
    } else {
        if (!self.dateCalendar) {
            UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
            self.dateCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
            self.dateCalendar.delegate = self;
        }
        [self setupPopupCalendarDemo:self.dateCalendar inView:sender];
        
        
    }
    
}

- (IBAction)kissTapped:(UIButton *)sender {
    ActionButton *button = (ActionButton *)sender;
    if (button.isChecked) {
        button.isChecked = NO;
        [button setTitle:@"Soon!" forState:UIControlStateNormal];
        [button setTitleColor:RED_COLOR forState:UIControlStateNormal];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.person.events];
        [dictionary removeObjectForKey:@"KISS"];
        self.person.events = dictionary;
    } else {
        if (!self.kissCalendar) {
            UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
            self.kissCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
            self.kissCalendar.delegate = self;
            
        }
        [self setupPopupCalendarDemo:self.kissCalendar inView:sender];
        
    }
}


- (IBAction)loveTapped:(UIButton *)sender {
    ActionButton *button = (ActionButton *)sender;
    if (button.isChecked) {
        button.isChecked = NO;
        [button setTitle:@"Soon!" forState:UIControlStateNormal];
        [button setTitleColor:RED_COLOR forState:UIControlStateNormal];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.person.events];
        [dictionary removeObjectForKey:@"LOVE"];
        self.person.events = dictionary;
    } else {
        if (!self.loveCalendar) {
            UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
            self.loveCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
            self.loveCalendar.delegate = self;
        }
        [self setupPopupCalendarDemo:self.loveCalendar inView:sender];
    }
}


- (IBAction)birthdayDateTapped:(UIButton *)sender {
    
    if (!self.birthDayCalendar) {
        UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
        self.birthDayCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
        self.birthDayCalendar.delegate = self;    }
    
    [self setupPopupCalendarDemo:self.birthDayCalendar inView:sender];
    
    self.birthDayCalendar.calendarView.date = [self currentYearMinusEighteen];
}

- (IBAction)loveIconTapped:(UIButton *)sender {
    if (self.loveBtn.isChecked) {
        self.loveBtn.isChecked = NO;
        [self.loveBtn setTitle:@"Soon!" forState:UIControlStateNormal];
        [self.loveBtn setTitleColor:RED_COLOR forState:UIControlStateNormal];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.person.events];
        [dictionary removeObjectForKey:@"LOVE"];
        self.person.events = dictionary;
    } else {
        if (!self.loveCalendar) {
            UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
            self.loveCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
            self.loveCalendar.delegate = self;
        }
        [self setupPopupCalendarDemo:self.loveCalendar inView:sender];
    }
    
}

- (IBAction)kissIconTapped:(UIButton *)sender {
    if (self.kissBtn.isChecked) {
        self.kissBtn.isChecked = NO;
        [self.kissBtn setTitle:@"Soon!" forState:UIControlStateNormal];
        [self.kissBtn setTitleColor:RED_COLOR forState:UIControlStateNormal];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.person.events];
        [dictionary removeObjectForKey:@"KISS"];
        self.person.events = dictionary;
    } else {
        if (!self.kissCalendar) {
            UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
            self.kissCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
            self.kissCalendar.delegate = self;        }
        [self setupPopupCalendarDemo:self.kissCalendar inView:sender];
        
    }
    
}

- (IBAction)dateIconTapped:(UIButton *)sender {
    
    if (self.dateBtn.isChecked) {
        self.dateBtn.isChecked = NO;
        [self.dateBtn setTitle:@"Soon!" forState:UIControlStateNormal];
        [self.dateBtn setTitleColor:RED_COLOR forState:UIControlStateNormal];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.person.events];
        [dictionary removeObjectForKey:@"DATE"];
        self.person.events = dictionary;
    } else {
        if (!self.dateCalendar) {
            UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
            self.dateCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
            self.dateCalendar.delegate = self;          }
        [self setupPopupCalendarDemo:self.dateCalendar inView:sender];
    }
    
    
}

- (IBAction)nationalityTapped:(id)sender {
    SearchTableVC *vc = [SearchTableVC new];
    vc.searchValuesArray = [[self.dataStore.internationalisation objectForKey:@"nationalities"]  allValues];
    vc.delegate = self;
    vc.dataStore = self.dataStore;
    vc.titleString = @"What's her nationality?";
    self.currentSender = sender;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
