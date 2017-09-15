

#import <UIKit/UIKit.h>

@interface UIView (ViewCreator)
/**
 *  Create an instance of some view
 *
 *  @return reference to the created view instance
 */
+ (instancetype)createView;

/**
 *  add a view to a container
 *
 *  @param container where the view will be added
 */
- (void)addViewToContainer:(UIView *)container;

@end
