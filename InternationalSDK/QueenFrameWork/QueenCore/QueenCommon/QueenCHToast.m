#import "QueenCHToast.h"
#import "QueenToast.h"
@implementation QueenCHToast
+ (void)JPBaoFu_displayToastWithMessage:(NSString *)message toastType:(QueenToastType)toastType {
    QueenToast *toast = [[QueenToast alloc] init];
    toast.title = Queen_HLocalizedString(Queen_HIAlertTitleText);
    toast.message = message;
    switch (toastType) {
        case QueenToastTypeSuccess:
            toast.icon = @"Toast_Center_Success";
            break;
        case QueenToastTypeWarning:
            toast.icon = @"Toast_Center_Warning";
            break;
        case QueenToastTypeError:
            toast.icon = @"Toast_Center_Error";
            break;
        default:
            break;
    }
    toast.displayType = QueenToastDisplayTypeDefault;
    [toast show];
}
+ (void)JPBaoFu_displayToastWithMessage:(NSString *)message toastType:(QueenToastType)toastType showTime:(NSInteger)showTime {
    QueenToast *toast = [[QueenToast alloc] init];
    toast.title = Queen_HLocalizedString(Queen_HIAlertTitleText);
    toast.message = message;
    switch (toastType) {
        case QueenToastTypeSuccess:
            toast.icon = @"Toast_Center_Success";
            break;
        case QueenToastTypeWarning:
            toast.icon = @"Toast_Center_Warning";
            break;
        case QueenToastTypeError:
            toast.icon = @"Toast_Center_Error";
            break;
        default:
            break;
    }
    toast.showTime = showTime;
    toast.displayType = QueenToastDisplayTypeDefault;
    [toast show];
}
+ (void)JPBaoFu_displayCountdownToastWithMessage:(NSString *)message NavTitle:(NSString *)navTitle showTime:(NSInteger)showTime delegate:(id)delegate displayType:(QueenToastDisplayType)displayType{
    QueenToast *toast = [[QueenToast alloc] init];
    toast.title = navTitle;
    toast.message = message;
    toast.displayType = displayType;
    toast.showTime = showTime;
    toast.delegate = delegate;
    [toast show];
}
@end
