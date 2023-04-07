#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol JPBaoFu_BindYKAccViewDelegate <NSObject>
- (void)JPBaoFu_bindYKAccViewClickReturnEvent;
- (void)JPBaoFu_bindYKAccViewClickSendCodeEvent:(NSString *)email callback:(void(^)(void))callback;
- (void)JPBaoFu_bindYKAccViewClickLinkEvent:(NSString *)email password:(NSString *)password password2:(NSString *)password2 verifyCode:(NSString *)verifyCode;
@end
@interface QueenBindYKAccView : UIView
@property (nonatomic, weak) id<JPBaoFu_BindYKAccViewDelegate> delegate;
+ (instancetype)QueenShowBindYKAccViewInContext:(UIView *)context email:(NSString *)email;
- (void)Queen_refreshMainView;
- (void)JPBaoFu_obtainVerificationCode;
@end
NS_ASSUME_NONNULL_END
