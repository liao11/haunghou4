

#import <UIKit/UIKit.h>

typedef void(^CallBack)(NSDictionary *info);
@interface CHTRoleOfInforView : UIView

@property (nonatomic, copy) CallBack callInfo;
- (void)setup;
@end
