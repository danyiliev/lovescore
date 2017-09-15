//
//  SendToCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendToCellDelegate <NSObject>
@required
- (void)selectUsername:(NSString *)username;
- (void)deselectUsername:(NSString *)username;


@end

@interface SendToCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkboxBtn;
- (IBAction)checkBoxHandle:(UIButton *)sender;

@property (weak, nonatomic) id<SendToCellDelegate> delegate;


@end
