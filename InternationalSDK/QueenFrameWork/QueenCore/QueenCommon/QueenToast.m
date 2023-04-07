#import "QueenToast.h"
#import "QueenToastView.h"
#import "QueenCountdownView.h"
@interface QueenToast ()
@property (nonatomic, assign) BOOL isCustomView;
@property (nonatomic, assign, getter=isAutoDismiss) BOOL autoDismiss;
@property (nonatomic, strong) UIView *customView;
@end
@implementation QueenToast
- (instancetype)initCustomToastWithView:(UIView *)customView autoDismiss:(BOOL)autoDismiss {
    if (self = [super init]) {
        self.isCustomView = YES;
        self.customView = customView;
        self.autoDismiss = autoDismiss;
    }
    return self;
}
- (void)show {
    if (!self.context) {
        self.context = [UIApplication sharedApplication].keyWindow;
    }
    for (UIView *loadedView in self.context.subviews) {
        if ([loadedView isKindOfClass:[QueenToastView class]] && (self.displayType != QueenToastDisplayTypeSkipInCenter && self.displayType != QueenToastDisplayTypeInquriryInCenter)) {
            [NSRunLoop cancelPreviousPerformRequestsWithTarget:loadedView];
            [loadedView removeFromSuperview];
        }else if ([loadedView isKindOfClass:[QueenCountdownView class]] && (self.displayType == QueenToastDisplayTypeSkipInCenter || self.displayType == QueenToastDisplayTypeInquriryInCenter)) {
            [loadedView removeFromSuperview];
        }
    }
    if (!self.isCustomView) {
        if (self.displayType == QueenToastDisplayTypeSkipInCenter) {
            QueenCountdownView *view = [[QueenCountdownView alloc] initWithTitle:self.title content:self.message InView:self.context displayType:QueenCountdownTypeSkip];
            view.showTime = self.showTime;
            view.skipBlock = ^{
                if ([self.delegate respondsToSelector:@selector(toatSkipOperation:)]) {
                    [self.delegate toatSkipOperation:self];
                }
            };
            [view show];
        }else if (self.displayType == QueenToastDisplayTypeInquriryInCenter){
            QueenCountdownView *view = [[QueenCountdownView alloc] initWithTitle:self.title content:self.message InView:self.context displayType:QueenCountdownTypeInquriry];
            view.showTime = self.showTime;
            view.inquriryBlock = ^(NSInteger index) {
                if ([self.delegate respondsToSelector:@selector(toatInquriryOperation:clickIndex:)]) {
                    [self.delegate toatInquriryOperation:self clickIndex:index];
                }
            };
            [view show];
        }else {
            QueenToastView *view = [[QueenToastView alloc] initWithTitle:self.title message:self.message icon:self.icon toastContent:nil inView:self.context autoDismiss:YES];
            view.displayType = self.displayType;
            view.showTime = self.showTime;
            [view show];
        }
    }else {
        QueenToastView *view = [[QueenToastView alloc] initWithTitle:self.title message:self.message icon:self.icon toastContent:nil inView:self.context autoDismiss:YES];
            view.displayType = self.displayType;
            view.showTime = self.showTime;
            [view show];
    }
}
- (NSInteger)showTime {
    if (!_showTime) {
        _showTime = 1.0;
    }
    return _showTime;
}
- (QueenToastDisplayType)displayType {
    if (!_displayType) {
        return QueenToastDisplayTypeDefault;
    }
    return _displayType;
}
@end
