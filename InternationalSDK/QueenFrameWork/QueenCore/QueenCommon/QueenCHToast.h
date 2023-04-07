#import <Foundation/Foundation.h>
#import "QueenToast.h"
#import "QueenToastConfig.h"
@interface QueenCHToast : NSObject
+ (void)JPBaoFu_displayToastWithMessage:(NSString *)message toastType:(QueenToastType)toastType;
+ (void)JPBaoFu_displayToastWithMessage:(NSString *)message toastType:(QueenToastType)toastType showTime:(NSInteger)showTime;
+ (void)JPBaoFu_displayCountdownToastWithMessage:(NSString *)message NavTitle:(NSString *)navTitle showTime:(NSInteger)showTime delegate:(id)delegate displayType:(QueenToastDisplayType)displayType;
@end
