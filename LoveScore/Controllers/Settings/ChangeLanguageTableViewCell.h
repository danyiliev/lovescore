//
//  ChangeLanguageTableViewCell.h
//  LoveScore
//
//  Created by Vasyl Khmil on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeLanguageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *languageImage;
@property (weak, nonatomic) IBOutlet UIImageView *isSelectedImage;
@property (weak, nonatomic) IBOutlet UIButton *disclosureButton;
@property (weak, nonatomic) IBOutlet UILabel *languageName;

@end
