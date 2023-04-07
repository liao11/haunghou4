#import <UIKit/UIKit.h>
@protocol Queen_HIAutoLoginViewDelegate <NSObject>
- (void)JPBaoFu_autoLoginViewClickSwitchEvent;
@end
@interface QueenCHIAutoLoginView : UIView
@property (nonatomic, weak) id<Queen_HIAutoLoginViewDelegate> delegate;
+ (instancetype)QueenShowAutoLoginViewInContext:(UIView *)context account:(NSString *)account;
- (void)Queen_refreshMainView;
- (void)Queen_canClickSwitchButton:(BOOL)isEnable;
@end
