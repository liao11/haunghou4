#import <UIKit/UIKit.h>
@class QueenYJAlertView;
typedef void(^QueenAlertHidCallback)();
@protocol QueenYAlerViewDelegate <NSObject>
- (void)Queen_HAlertView:(QueenYJAlertView *)alertView transferredData:(NSDictionary *)data clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@interface QueenYJAlertView : UIView
@property (nonatomic, strong) NSDictionary *JPBaoFu_tempStorageData;
@property (nonatomic, copy) QueenAlertHidCallback JPBaoFu_callback;
@property (nonatomic, strong) NSString *JPBaoFu_message;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<QueenYAlerViewDelegate>)delegate btnColors:(NSArray *)btnColors btnTitleColors:(NSArray *)btnTitleColors buttonTitles:(NSArray *)buttonTitles;
- (void)QueenShow;
@end
