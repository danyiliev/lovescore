//
//  AddGirlVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AddGirlVC.h"
#import "FullCheckInVC.h"
#import "SideMenuModel.h"
#import "NavigationTitle.h"
#import "Global.h"
#import "SelectionButton.h"
#import "ActionDateView.h"
#import "ActionButton.h"
#import "UIView+ViewCreator.h"
#import "RoundRateView.h"
#import "TTTAttributedLabel + ColorText.h"
#import "CoreDataManager.h"
#import "PersonEntity.h"
#import "Person.h"
#import "DataStore.h"
#import "DataStoreEntity.h"
#import "SearchTableVC.h"
#import "AddGirlsServices.h"
#import "ImageManager.h"
#import "AddPersonImages.h"
#import "SyncManager.h"
#import "WYPopoverController.h"
#import "CalendarVC.h"
#import "SendToVC.h"
#import "Calendar.h"
#import "PlaceholderTextView.h"
#import "JTCalendarVC.h"
#import "PicturesEntity.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface AddGirlVC ()<UITextFieldDelegate, UIAlertViewDelegate, UITextViewDelegate, SearchTableProtocol, JTCalendarVCDelegate> {
    
}

@property (strong, nonatomic) WYPopoverController *popover;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rateStarView;
@property (strong, nonatomic) IBOutlet UIButton *checkInButton;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) DataStore *dataStore;

@property (weak, nonatomic) IBOutlet ActionButton *dateButton;
@property (weak, nonatomic) IBOutlet ActionButton *kissButton;
@property (weak, nonatomic) IBOutlet ActionButton *loveButton;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (strong, nonatomic) IBOutlet UIButton *photoButton;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *yearTextField;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *dataForPicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (weak, nonatomic) IBOutlet SelectionButton *countryBtn;

@property (strong, nonatomic) ActionDateView *actionDateView;

@property (nonatomic, strong) NSMutableDictionary *eventsDictionaries;

@property (strong, nonatomic) Person *person;
@property (strong, nonatomic) AddGirlsServices *addGirlServices;
@property (strong, nonatomic) AddPersonImages *addPersonImages;

//@property (strong, nonatomic) Calendar *dateCalendar;
//@property (strong, nonatomic) Calendar *kissCalendar;
//@property (strong, nonatomic) Calendar *loveCalendar;

@property (strong, nonatomic) JTCalendarVC *dateCalendar;
@property (strong, nonatomic) JTCalendarVC *kissCalendar;
@property (strong, nonatomic) JTCalendarVC *loveCalendar;


@property (nonatomic) BOOL isImageSelected;

- (IBAction)countryTaped:(id)sender;
- (IBAction)loveTaped:(id)sender;
- (IBAction)kissTaped:(id)sender;
- (IBAction)dateTaped:(id)sender;
- (IBAction)photoButtonTaped:(UIButton *)sender;

@end

@implementation AddGirlVC

- (UIImagePickerController *)imagePickerController
{
    if(!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        [_imagePickerController setAllowsEditing:YES];
    }
    return _imagePickerController;
}

- (void)viewDidLoad {
    //
    [super viewDidLoad];
    
    if (self.isFiltered) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        [backItem setTintColor:RED_COLOR];
        self.navigationItem.leftBarButtonItem = backItem;
    } else {
        [[SideMenuModel sharedInstance] addEdgeSwipeOnView:self.view];
    }
    
    self.dataStore = [[CoreDataManager instance] getDataStore];
    [self setupUI];
    [self.photoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    _photoButton.layer.cornerRadius = _photoButton.frame.size.height / 2;
    _photoButton.layer.masksToBounds = YES;
    
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.isImageSelected = NO;
    
    self.eventsDictionaries = [[NSMutableDictionary alloc] init];
    
    self.addGirlServices = [AddGirlsServices new];
    self.addPersonImages = [AddPersonImages new];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignOpenedInputViews:)];
    
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"ADD GIRL" withRedWord:@"ADD"];
    
    [_rateStarView setValue:2.5f];
    
    self.person =  [Person new];
    
    [self girlRateValueChanged];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // update fields when return from full check in
    if (self.person.firstName != nil && ![self.person.firstName isEqualToString:@""]) {
        [self.nameTextField setText:self.person.firstName];
    }
    
    if (self.person.country != nil && ![self.person.country isEqualToString:@""]) {
        NSString  *newCountry = [[self.dataStore.internationalisation objectForKey:@"nationalities"] objectForKey:self.person.nationality];
        [self.countryBtn setTitle:newCountry forState:UIControlStateNormal];
        [self.countryBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
    }
    
    if (self.person.age != nil && ![[self.person.age stringValue] isEqualToString:@""]) {
        [self.yearTextField setText:[self.person.age stringValue]];
    }
    
    if (self.person.rating) {
        [_rateStarView setValue:self.person.rating.floatValue / 2.0f];
    }
    
    if (self.person.comment) {
        [self.commentTextView setText:self.person.comment];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSURLCache * const urlCache = [NSURLCache sharedURLCache];
    const NSUInteger memoryCapacity = urlCache.memoryCapacity;
    urlCache.memoryCapacity = 0;
    urlCache.memoryCapacity = memoryCapacity;
}

#pragma mark - SearchTableView delegate

- (void)stringWasSelected:(NSString *)string {
    [self.countryBtn setTitle:string forState:UIControlStateNormal];
    [self.countryBtn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
}

#pragma mark - Private methods

- (void)showSimpleAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = RED_COLOR;
    
    
    UIAlertAction *okayAction = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *action)
                                 {
                                 }];
    
    [alertController addAction:okayAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isEnteredDataValid {
    
    BOOL isInputDataValid = YES;
    
    [self.nameTextField removeSpacesFromString];
    
    if (self.nameTextField.text.length < 2) {
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please add the girl's name."];
        isInputDataValid = NO;
    } else if ([self.nameTextField.text characterAtIndex:1] == ' ' ) {
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please adjust girl's name."];
        isInputDataValid = NO;
    }
    
    NSMutableCharacterSet *set = [[NSCharacterSet letterCharacterSet] mutableCopy];
    [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if ([self.nameTextField.text rangeOfCharacterFromSet:[set invertedSet]].location != NSNotFound) {
        isInputDataValid = NO;
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please adjust girl's name."];
    }
    
    if ([self.countryBtn.titleLabel.text isEqualToString:@""] || [self.countryBtn.titleLabel.text isEqualToString:@"What's her nationality?"]) {
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please add a nationality"];
        
        isInputDataValid = NO;
    }
    
    if ([self.yearTextField.text isEqualToString:@""]) {
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@" Please add the girl's age."];
        isInputDataValid = NO;
    } else {
        NSInteger age = [self.yearTextField.text integerValue];
        
        if (age < 16 || age > 99) {
            [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please adjust age"];
            isInputDataValid = NO;
        }
    }
    
    if (!self.eventsDictionaries || self.eventsDictionaries.count < 1) {
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Which item fits best for your event?"];
        isInputDataValid = NO;
    }
    
    return isInputDataValid;
}

-(void)setViewMovedUp:(BOOL)movedUp {
    
    if (movedUp) {
        self.topSpace.constant = -200;
        [UIView animateWithDuration:0.8f animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        self.topSpace.constant = 0;
        [UIView animateWithDuration:0.8f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)resignOpenedInputViews:(UITapGestureRecognizer *)gesture {
    [_nameTextField resignFirstResponder];
    [_yearTextField resignFirstResponder];
    [_commentTextView resignFirstResponder];
    
}

- (void)setupUI {

    [_dateButton.layer setCornerRadius:4.f];
    [_kissButton.layer setCornerRadius:4.f];
    [_loveButton.layer setCornerRadius:4.f];
    
    [_checkInButton.layer setCornerRadius:2.f];
    
    self.actionDateView = [ActionDateView createView];
    [self.actionDateView setHidden:YES];
    [self.containerView addSubview:self.actionDateView];
    
    [self.countryBtn setTitleColor:[UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:180.f/255.f alpha:1] forState:UIControlStateNormal];
    
    [self setupTextViews];
    
}

- (void)setupTextViews {
    [self.nameTextField setReturnKeyType:UIReturnKeyDone];
    [self.nameTextField addTarget:self
                           action:@selector(resignOpenedInputViews:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.yearTextField setReturnKeyType:UIReturnKeyDone];
    [self.yearTextField addTarget:self
                           action:@selector(resignOpenedInputViews:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.commentTextView setContentInset:UIEdgeInsetsMake(0, 0, self.commentTextView.contentOffset.y, self.commentTextView.contentOffset.x)];
    
    [self.commentTextView setReturnKeyType:UIReturnKeyDone];
    
    self.commentTextView.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)uncheckCheckedActionButton {
    if (self.dateButton.isChecked) {
        [self.dateButton uncheckWithImageName:@"check-event-icon-bubble-off"];
    }
    if (self.kissButton.isChecked) {
        [self.kissButton uncheckWithImageName:@"check-event-icon-mouth-off"];
    }
    if (self.loveButton.isChecked) {
        [self.loveButton uncheckWithImageName:@"check-event-icon-heart-off"];
    }
    //    [self.dateButton setEnabled:YES];
    //    [self.kissButton setEnabled:YES];
    //    [self.loveButton setEnabled:YES];
    
    [self.actionDateView setHidden:YES];
}


- (BOOL)addInfoIntoCoreData {
    
    [self setDataForModel];
    
    NSError *error = nil;
    
    [MTLManagedObjectAdapter managedObjectFromModel:self.person
                               insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                              error:&error];
    [[CoreDataManager instance] saveContext];
    
    return YES;
}

-(void)setDataForModel {
    
    self.person.firstName = [self.nameTextField.text capitalizedString];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.person.age = [numberFormatter numberFromString:self.yearTextField.text];
    if ([self.commentTextView.text isEqualToString:@"Any comments?"]) {
        self.person.comment = nil;
    } else {
        self.person.comment = self.commentTextView.text;
    }
    // setup countries
    NSString *knownObject = self.countryBtn.titleLabel.text;
    NSArray *nationalityArray = [knownObject componentsSeparatedByString:@", "];
    NSArray *temp = [[self.dataStore.internationalisation objectForKey:@"nationalities"] allKeysForObject:[nationalityArray firstObject]];
    NSString *key = [temp objectAtIndex:0];
    self.person.nationality = [NSString stringWithString:key] ;
    self.person.state = nil;
    if (nationalityArray.count > 1) {
        temp = [self.dataStore.states allKeysForObject:[nationalityArray lastObject]];
        NSString *stateKey =[temp objectAtIndex:0];
        self.person.state = [NSString stringWithString:stateKey];
    }
    
    //    if (self.person.nationality == nil || [self.person.nationality isEqualToString:@""]) {
    //        self.person.nationality = key;
    //    }
    //
    self.person.events = self.eventsDictionaries;
    self.person.rating = @(_rateStarView.value * 2.0f);
    self.person.status = @"ACT";
    
    if (self.girlId == nil) {
        NSString *UUID = [[NSUUID UUID] UUIDString];
        self.girlId = [UUID lowercaseString];
    }
    
    self.person.uuid = self.girlId;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setLocale:[NSLocale systemLocale]];
    NSDate *currentDate = [self getCurrentTimeZoneDateAndTimeFromDate:[NSDate date]];
    NSString *strDate = [formatter stringFromDate:currentDate];
    self.person.createdAt = strDate;
    
    //
    //    [[ImageManager sharedInstance] setGirlAvatarImage:self.photoButton.currentImage withUUID:self.person.uuid];
}

- (void)selectLoveButtonWithDate:(NSDate *)date {
    [self.actionDateView setDate:date];
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    [self.eventsDictionaries setValue:[formater stringFromDate:date] forKey:@"LOVE"];
    [self.eventsDictionaries setValue:[formater stringFromDate:date] forKey:@"KISS"];
    [self.eventsDictionaries setValue:[formater stringFromDate:date] forKey:@"DATE"];
    [self.actionDateView setFrame:CGRectMake(self.loveButton.superview.frame.origin.x, self.loveButton.superview.frame.origin.y - self.loveButton.frame.size.height / 2, self.loveButton.superview.frame.size.width, self.loveButton.frame.size.height / 2)];
    [self.actionDateView setHidden:NO];
    [self.loveButton checkWithImageName:@"check-event-icon-heart-on"];
}

- (void)selectKissButtonWithDate:(NSDate *)date {
    [self.actionDateView setDate:date];
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    [self.eventsDictionaries setValue:[formater stringFromDate:date] forKey:@"KISS"];
    [self.eventsDictionaries setValue:[formater stringFromDate:date] forKey:@"DATE"];
    [self.kissButton checkWithImageName:@"check-event-icon-mouth-on"];
    [self.actionDateView setFrame:CGRectMake(self.kissButton.superview.frame.origin.x , self.kissButton.superview.frame.origin.y - self.kissButton.frame.size.height / 2, self.kissButton.superview.frame.size.width, self.kissButton.frame.size.height / 2)];
    [self.actionDateView setHidden:NO];
}

- (void)selectDateButtonWithDate:(NSDate *)date {
    [self.actionDateView setDate:date];
    NSDateFormatter *formater = [TTFormatter dateFormatter];
    [self.eventsDictionaries setValue:[formater stringFromDate:date] forKey:@"DATE"];
    [self.dateButton checkWithImageName:@"check-event-icon-bubble-on"];
    [self.actionDateView setFrame:CGRectMake(self.dateButton.superview.frame.origin.x, self.dateButton.superview.frame.origin.y - self.dateButton.frame.size.height / 2, self.dateButton.superview.frame.size.width, self.dateButton.frame.size.height / 2)];
    [self.actionDateView setHidden:NO];
    
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


- (NSDate *)getCurrentTimeZoneDateAndTimeFromDate:(NSDate *)date {
    NSDate* currentDate = date;
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    return nowDate;
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.commentTextView) {
        self.commentTextView.text = @"";
        [self.commentTextView setTextColor:DARK_COLOR];
        self.topSpace.constant = -200;
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView == self.commentTextView) {
        if ([self.commentTextView.text isEqualToString:@""]) {
            self.commentTextView.text = @"Any comments?";
            [self.commentTextView setTextColor:[UIColor lightGrayColor]];
        }
        self.topSpace.constant = 0;
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Combo Box

- (void)chooseCountry:(id)sender {
    UIViewController *viewController = VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"GirlEditor", @"SearchVC");
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - TextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField {
    
    return YES;
}

#pragma mark - ImagePickerController Delegate and method for opening

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.photoButton setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:
     UIControlStateNormal];
    
    self.isImageSelected = YES;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CalendarDelegate

- (void)calendar:(JTCalendarVC *)calendar didSelectDate:(NSDate *)date {
    NSDate *nowDate = [NSDate date];
    if ([date compare:nowDate] == NSOrderedDescending) {
        calendar.calendarView.date = [NSDate date];
        [self showAlertControllerWithTitle:@"" withMessage:@"You can't pick a date in the future"];
    } else {
        [self uncheckCheckedActionButton];
        [self.eventsDictionaries removeAllObjects];
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
        
    }
    [self.popover dismissPopoverAnimated:YES];
    
}

#pragma mark - IBActions


- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    [[SideMenuModel sharedInstance] anchorRight];
}

- (IBAction)callCheckInButtonAction:(id)sender {
    
    BOOL successOperation = [self isEnteredDataValid];
    
    if (successOperation) {
        
        [self addInfoIntoCoreData];
        
        NSString *imageName = nil;
        if (self.isImageSelected == YES) {
            imageName = [[ImageManager sharedInstance] saveImage:self.photoButton.currentImage withUUID:self.person.uuid];
            
            PicturesEntity *picturesEntity = (PicturesEntity *)[[CoreDataManager instance] insertNewManagedObject:@"Pictures"];
            picturesEntity.uuid = self.person.uuid;
            [[CoreDataManager instance] saveContext];
        }
        
        // if is network is available
        
        if ([[SyncManager sharedInstance] connected]) {
            [[self.addGirlServices uploadPersons] subscribeCompleted:^(void) {
                if (self.isImageSelected == YES) {
                    
                    NSArray *array = [NSArray arrayWithObjects:self.photoButton.currentImage, nil];
                    
                    [[self.addPersonImages uploadImage:array
                                                inView:self.photoButton
                                               forUUID:self.person.uuid
                                           imagesNames:@[imageName]]
                     subscribeCompleted:^(void) {
                         
                     }];
                }
            }];
        } else {
            
            if (self.isImageSelected == YES) {
                
                if ([[ImageManager sharedInstance].imagesToUpload objectForKey:self.person.uuid]) {
                    
                    [[[ImageManager sharedInstance].imagesToUpload objectForKey:self.person.uuid] addObject:imageName];
                } else {
                    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:imageName, nil];
                    
                    [[ImageManager sharedInstance].imagesToUpload setObject:array forKey:self.person.uuid];
                }
                
                [SyncManager sharedInstance].checkForImagesUploading = YES;
            }
            
            [SyncManager sharedInstance].checkForPersonsUploading = YES;
        }
        
        [((SideMenuModel *)[SideMenuModel sharedInstance]).slidingViewController resetTopViewAnimated:NO];
        [((SideMenuModel *)[SideMenuModel sharedInstance]).sideMenuVC performSegueWithID:@"MyGirlNavigationControllerSegue"];
    }
}

- (IBAction)girlRateValueChanged {
    self.person.rating = @(_rateStarView.value * 2.f);
}

- (IBAction)countryTaped:(id)sender {
    [self screenTapped];
    
    SearchTableVC *vc = [SearchTableVC new];
    vc.searchValuesArray = [[self.dataStore.internationalisation objectForKey:@"nationalities"] allValues];
    vc.delegate = self;
    vc.dataStore = [[CoreDataManager instance] getDataStore];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dateTaped:(id)sender {
    [self screenTapped];
    
    ActionButton *button = sender;
    [self uncheckCheckedActionButton];
    [self.eventsDictionaries removeAllObjects];
    
    if (!self.dateCalendar) {
        UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
        self.dateCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
        self.dateCalendar.delegate = self;
    }
    [self setupPopupCalendarDemo:self.dateCalendar inView:button];
}

- (IBAction)kissTaped:(id)sender {
    [self screenTapped];
    
    ActionButton *button = sender;
    [self uncheckCheckedActionButton];
    [self.eventsDictionaries removeAllObjects];
    
    if (!self.kissCalendar) {
        UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
        self.kissCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
        self.kissCalendar.delegate = self;
    }
    [self setupPopupCalendarDemo:self.kissCalendar inView:button];
    
}

- (IBAction)loveTaped:(id)sender {
    [self screenTapped];
    
    ActionButton *button = sender;
    [self uncheckCheckedActionButton];
    [self.eventsDictionaries removeAllObjects];
    
    if (!self.loveCalendar) {
        UIStoryboard *storiboard = [UIStoryboard storyboardWithName:@"GirlEditor" bundle:[NSBundle mainBundle]];
        self.loveCalendar = [storiboard instantiateViewControllerWithIdentifier:@"JTCalendarVC"];
        self.loveCalendar.delegate = self;
    }
    [self setupPopupCalendarDemo:self.loveCalendar inView:button];
}

- (IBAction)photoButtonTaped:(UIButton *)sender {
    [self screenTapped];
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil                                                                            message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    alertController.view.tintColor = RED_COLOR;
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *openGallery = [UIAlertAction
                                  actionWithTitle:@"Open Gallery"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                          
                                          [self presentViewController:self.imagePickerController animated:YES completion:nil];
                                      });
                                  }];
    
    UIAlertAction *openCamera = [UIAlertAction
                                 actionWithTitle:@"Open Camera"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     NSString *model = [[UIDevice currentDevice] model];
                                     if (![model isEqualToString:@"iPhone Simulator"]) {
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                                                 _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                 [self presentViewController:self.imagePickerController animated:YES completion:nil];
                                             }
                                             else
                                                 [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Camera is not suuported on this device."];                                         });
                                     }
                                 }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:openGallery];
    [alertController addAction:openCamera];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}

- (void)dealloc {
    
}

- (IBAction)ageValueChanged:(id)sender {
    
    if (self.yearTextField.text.length == 2) {
        [self resignOpenedInputViews:nil];
    }
}

@end
