

#import "UIView+ViewCreator.h"
#import <objc/runtime.h>

@implementation UIView (ViewCreator)

+ (instancetype)createView {

    NSArray *lViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    id lRetView;
    if (lViews.count > 0) {
        lRetView = lViews[0];
    }
    return lRetView;
}

- (void)addViewToContainer:(UIView *)container {
    [container addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *verticalLayoutFormat = [NSString stringWithFormat:@"V:|-0-[%@]-0-|", @"self"];
    NSString *horizontalLayoutFormat = [NSString stringWithFormat:@"H:|-0-[%@]-0-|", @"self"];
    
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalLayoutFormat
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(self)]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalLayoutFormat
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(self)]];
}

@end
