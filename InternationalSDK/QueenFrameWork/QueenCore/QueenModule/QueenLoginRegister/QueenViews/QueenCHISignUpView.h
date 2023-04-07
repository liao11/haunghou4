#import <UIKit/UIKit.h>
@protocol Queen_HISignUpViewDelegate <NSObject>
- (void)JPBaoFu_signUpVeiwClickReturnEvent;
- (void)JPBaoFu_signUpViewClickRegisterEvent:(NSString *)account password:(NSString *)password confirmP:(BOOL)confirmP;
- (void)JPBaoFu_signUpViewClickDetailProtocolInfo;

- (void)JPBaoFu_ShowDeteleViewClickRegisterEvent;
@end
@interface QueenCHISignUpView : UIView
@property (nonatomic, weak) id<Queen_HISignUpViewDelegate> delegate;
+ (instancetype)QueenShowSignUpViewInContext:(UIView *)context;
- (void)Queen_refreshMainView;
@end
