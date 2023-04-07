#import "QueenCHAlertManager.h"
@interface QueenCHAlertManager ()
@property (nonatomic, strong) NSMutableArray<QueenYJAlertView *> *QueenAlertViews;
@end
@implementation QueenCHAlertManager
+ (instancetype)JPBaoFu_shareInstance {
    static QueenCHAlertManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QueenCHAlertManager alloc] init];
        manager.QueenAlertViews = [NSMutableArray array];
    });
    return manager;
}
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id<QueenYAlerViewDelegate>)delegate tempData:(NSDictionary *)tempData buttonTitles:(NSString *)buttonTitles, ... {
    NSString *other = nil;
    va_list args;
    NSMutableArray *btnTitleArr = [NSMutableArray array];
    if(buttonTitles){
        [btnTitleArr addObject:buttonTitles];
        va_start(args, buttonTitles);
        while((other = va_arg(args, NSString*))){
            [btnTitleArr addObject:other];
        }
        va_end(args);
    }
    __weak typeof([QueenCHAlertManager JPBaoFu_shareInstance]) weakSelf = [QueenCHAlertManager JPBaoFu_shareInstance];
    QueenYJAlertView *view = [[QueenYJAlertView alloc] initWithTitle:title message:message delegate:delegate btnColors:@[] btnTitleColors:@[] buttonTitles:btnTitleArr];
    view.JPBaoFu_tempStorageData = tempData;
    view.JPBaoFu_callback = ^{
        [weakSelf JPBaoFu_newestHidCallback];
    };
    [[QueenCHAlertManager JPBaoFu_shareInstance] JPBaoFu_dealPreAlertView];
    [[QueenCHAlertManager JPBaoFu_shareInstance].QueenAlertViews addObject:view];
    [view QueenShow];
}
- (void)JPBaoFu_dealPreAlertView {
    for (QueenYJAlertView *preView in self.QueenAlertViews) {
        preView.alpha = 0.0;
    }
}
- (void)JPBaoFu_newestHidCallback {
    [self.QueenAlertViews removeLastObject];
    if (!self.QueenAlertViews.count) return;
    QueenYJAlertView *lastView = self.QueenAlertViews.lastObject;
    [lastView QueenShow];
}
@end
