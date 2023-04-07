#import <UIKit/UIKit.h>
#import "QueenToastConfig.h"
@class QueenToast;
@interface QueenToastView : UIView
@property (nonatomic, assign) NSInteger showTime;
@property (nonatomic, assign) QueenToastDisplayType displayType;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message icon:(NSString *)icon toastContent:(UIView *)toastContent inView:(UIView *)context autoDismiss:(BOOL)autoDismiss;
- (void)show;
- (void)hid;
@end
