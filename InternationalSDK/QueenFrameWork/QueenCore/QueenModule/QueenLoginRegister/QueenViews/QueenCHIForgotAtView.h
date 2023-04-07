#import <UIKit/UIKit.h>
typedef void (^JPBaoFu_FtConfigBlock)(UITableViewCell *sourceCell);
@protocol Queen_HIForgotAtViewDelegate <NSObject>
- (void)JPBaoFu_forgotAtViewClickReturnEvents;
- (void)JPBaoFu_forgotAtViewClickAccountInfoOfIndex:(NSInteger)index;
@end
@interface QueenCHIForgotAtView : UIView
@property (nonatomic, weak) id<Queen_HIForgotAtViewDelegate> delegate;
- (void)JPBaoFu_setData:(NSDictionary *)data;
+ (instancetype)QueenShowForgotAtViewInContext:(UIView *)context;
- (void)Queen_refreshMainView;
@end
