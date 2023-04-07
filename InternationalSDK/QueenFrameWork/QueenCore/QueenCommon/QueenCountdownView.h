#import <UIKit/UIKit.h>
typedef void(^SkipNotificatBlock)();
typedef void(^InquriryNotificatBlock)(NSInteger index);
typedef NS_ENUM(NSInteger,QueenCountdownType){
    QueenCountdownTypeSkip,
    QueenCountdownTypeInquriry
};
@interface QueenCountdownView : UIView
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *context;
@property (nonatomic, assign) NSInteger showTime;
@property (nonatomic, copy) SkipNotificatBlock skipBlock;
@property (nonatomic, copy) InquriryNotificatBlock inquriryBlock;
- (instancetype)initWithTitle:(NSString *)titleInfo content:(NSString *)contentInfo InView:(UIView *)context displayType:(QueenCountdownType)displayType;
- (void)show;
- (void)hid;
@end
