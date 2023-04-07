#import <UIKit/UIKit.h>
#import "QueenToastConfig.h"
@class QueenToast;
@protocol QueenToastDelegate <NSObject>
@optional
- (void)toatSkipOperation:(QueenToast *)toast;
- (void)toatInquriryOperation:(QueenToast *)toast clickIndex:(NSInteger)index;
@end
@interface QueenToast : NSObject
@property (nonatomic, strong) UIView *context;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) QueenToastDisplayType displayType;
@property (nonatomic, assign) NSInteger showTime;
@property (nonatomic, weak) id<QueenToastDelegate> delegate;
- (instancetype)initCustomToastWithView:(UIView *)customView autoDismiss:(BOOL)autoDismiss;
- (void)show;
@end
