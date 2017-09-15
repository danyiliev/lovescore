//
//  CommentCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/20/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "CommentCell.h"
@interface CommentCell()

@property (weak, nonatomic) IBOutlet UITextView *commentCellTextView;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _commentCellTextView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCommentText:(NSString *)commentText {
    _commentText = commentText;
    _commentCellTextView.text = _commentText;
}

@end
