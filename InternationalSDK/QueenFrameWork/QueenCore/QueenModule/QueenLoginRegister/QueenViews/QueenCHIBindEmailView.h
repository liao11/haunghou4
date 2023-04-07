#import <UIKit/UIKit.h>
@protocol Queen_HIBindEmailViewDelegate <NSObject>
- (void)JPBaoFu_bindEmailViewClickReturnEvent;
- (void)JPBaoFu_bindEmailViewClickSendCodeEvent:(NSString *)email callback:(void(^)())callback;
- (void)JPBaoFu_bindEmailViewClickLinkEvent:(NSString *)email verifyCode:(NSString *)verifyCode;
@end
@interface QueenCHIBindEmailView : UIView
@property (nonatomic, weak) id<Queen_HIBindEmailViewDelegate> delegate;
+ (instancetype)QueenShowBindEmailViewInContext:(UIView *)context email:(NSString *)email;
- (void)Queen_refreshMainView;
- (void)JPBaoFu_obtainVerificationCode;
@end
