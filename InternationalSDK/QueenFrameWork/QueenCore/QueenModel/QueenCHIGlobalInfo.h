#import <Foundation/Foundation.h>






typedef NS_OPTIONS(NSUInteger, JPBaoFu_SDKFlagOptions) {
    JPBaoFu_SDKFlagNone         = 0,
    JPBaoFu_SDKFlagFB           = 1 << 0, //FB登录
    JPBaoFu_SDKFlagApple        = 1 << 1, //苹果登录
    JPBaoFu_SDKFlagShortcut     = 1 << 2, //快捷悬浮按钮
    JPBaoFu_SDKFlagBindemail    = 1 << 3, //绑定邮箱弹窗
    JPBaoFu_SDKFlagHeart        = 1 << 4, //心跳
};


@interface QueenCHIGlobalInfo : NSObject
@property (nonatomic, strong) QueenCHIGlobalGame *JPBaoFu_gameModel;
@property (nonatomic, strong) QueenCHIGlobalUser *JPBaoFu_userModel;
@property (nonatomic, assign) BOOL JPBaoFu_isLogoutSuccess;
@property (nonatomic, assign) NSInteger JPBaoFu_loginStatus;
@property (nonatomic, assign) JPBaoFu_SDKFlagOptions JPBaoFu_loginStatus1;
@property (nonatomic, assign) BOOL JPBaoFu_isOpenDevLog;
@property (nonatomic, assign) BOOL JPBaoFu_isOpenLog;
+ (instancetype)QueensharedInstance;
+ (void)QueenlaunchData;
+ (void)QueenparserLoginResponse:(NSDictionary *)result;
- (void)QueenclearUselessInfo;
@end
