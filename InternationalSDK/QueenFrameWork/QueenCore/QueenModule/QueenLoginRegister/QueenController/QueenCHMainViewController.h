#import <UIKit/UIKit.h>
typedef void(^JPBaoFu_DismissCallBack)(NSDictionary *result);
@interface QueenCHMainViewController : UIViewController
@property (nonatomic, copy) JPBaoFu_DismissCallBack JPBaoFu_dismissCallBack;
@end
