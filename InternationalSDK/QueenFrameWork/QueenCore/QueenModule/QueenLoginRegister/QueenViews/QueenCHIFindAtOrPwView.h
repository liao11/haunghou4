#import <UIKit/UIKit.h>
@protocol Queen_HIFindAtOrPwViewDelegate <NSObject>
- (void)JPBaoFu_findAtOrPwViewClickReturnEvent;
- (void)JPBaoFu_findAtOrPwViewClickForgotIDEvent;
- (void)JPBaoFu_findAtOrPwViewClickSubmitEvent:(NSString *)email inputCode:(NSString *)inputCode codeViewStr:(NSString *)codeViewStr;
@end
@interface QueenCHIFindAtOrPwView : UIView
@property (nonatomic, strong) UITextField *JPBaoFu_accountField;
@property (nonatomic, weak) id<Queen_HIFindAtOrPwViewDelegate> delegate;
+ (instancetype)QueenShowFindAtOrPwViewInContext:(UIView *)context;
- (void)Queen_refreshMainView;
- (void)JPBaoFu_freshVerCode;
@end
