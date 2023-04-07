#import <UIKit/UIKit.h>
@protocol Queen_HIForgotPwViewDelegate <NSObject>
- (void)JPBaoFu_forgotPwViewClickReturnEvents;
- (void)JPBaoFu_forgotPwViewClickSendCodeEvent:(NSString *)email callback:(void(^)())callback;
- (void)JPBaoFu_forgotPwViewClickSubmitEvent:(NSString *)email inputCode:(NSString *)inputCode newPassword:(NSString *)newPassword;
@end
@interface QueenCHIForgotPwView : UIView
@property (nonatomic, weak) id<Queen_HIForgotPwViewDelegate> delegate;
+ (instancetype)QueenShowForgotPwViewInContext:(UIView *)context data:(NSDictionary *)data;
- (void)Queen_refreshMainView;
- (void)QueenShowCountdownAnimation;
- (void)JPBaoFu_obtainVerificationCode;
@end
