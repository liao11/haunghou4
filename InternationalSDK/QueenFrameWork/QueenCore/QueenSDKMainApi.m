#import "QueenSDKMainApi.h"
#import "QueenCHMainViewController.h"
#import "QueenCHIBindEmailView.h"
#import "QueenCHAlertManager.h"
#import "QueenCHIApiRequest.h"
#import "QueenCHIGameInfo.h"
#import "QueenCHIUserInfo.h"
#import "QueenCHIDiskCashe.h"
#import "QueenCHITimerDataService.h"
#import "QueenCHInAppPurchaseManager.h"
#import "QueenBindYKAccView.h"
#import "IQKeyboardManager.h"
#import <StoreKit/StoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AdjustSdk/Adjust.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
@implementation QueenConfigInfo
@end
@interface QueenSDKMainApi () <Queen_HIBindEmailViewDelegate,JPBaoFu_BindYKAccViewDelegate,QueenToastDelegate,QueenYAlerViewDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) QueenCHIBindEmailView *JPBaoFu_bindEmailView;
@property (nonatomic, strong) QueenBindYKAccView *JPBaoFu_bindYKAccView;
@property (nonatomic, strong) QueenCHIResponseObject *JPBaoFu_enterGmaeResponse;
@property (nonatomic, strong) QueenCHITimerDataService *JPBaoFu_timerService;
@property (nonatomic, assign) BOOL JPBaoFu_isEnterGame;
@property (nonatomic, assign) BOOL JPBaoFu_isShowedLoginView;
@end
@implementation QueenSDKMainApi
#pragma mark - Initial
+ (instancetype)QueensharedInstance {
    static QueenSDKMainApi* api = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        api = [[self alloc] init];
        api.qqgameInfo = [QueenCHIGameInfo new];
        api.JPBaoFu_userInfo = [QueenCHIUserInfo new];
        api.JPBaoFu_configInfo = [QueenConfigInfo new];
    });
    return api;
}
- (instancetype)init {
    if (self = [super init]) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(JPBaoFu_HandleLogTapAction:)];
        tapGesture.numberOfTapsRequired = 18;
        [[[UIApplication sharedApplication].windows lastObject] addGestureRecognizer:tapGesture];
    }
    return self;
}
- (void)JPBaoFu_HandleLogTapAction:(UITapGestureRecognizer *)recognizer {
    [QueenSDKMainApi QueenOpenLog:YES];
    QueenShowSuccessToast(@"打开SDK日志");
}
#pragma mark - Public
+ (void)QueenOpenLog:(BOOL)isOpen {
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isOpenLog = isOpen;
}
+ (void)QueenlaunchSDKWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions isProductionEnvironment:(BOOL)isProductionEnvironment {
    JPBaoFu_YJLog(@"ch_CAOHUA SDK version %@ started build",JPBaoFu_cSdkVersion);
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isOpenDevLog = NO;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_isEnterGame = NO;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.adjustAppToken environment:(isProductionEnvironment? ADJEnvironmentProduction:ADJEnvironmentSandbox)];
    [adjustConfig setLogLevel:ADJLogLevelVerbose];
    [Adjust appDidLaunch:adjustConfig];
    NSLog(@"初始化AdJustSDK参数 adjustAppToken=%@，environment=%@",[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.adjustAppToken, (isProductionEnvironment? ADJEnvironmentProduction:ADJEnvironmentSandbox));
    [FIRApp configure];
    [FIRAnalytics logEventWithName:@"App启动" parameters:nil];
    FBSDKLoginManager *fbManager = [[FBSDKLoginManager alloc] init];
    [fbManager logOut];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [[QueenCHIApiRequest shareQueenCHIApiRequest] Queen_deviceActiveRequest];
    [QueenCHIGlobalInfo QueenlaunchData];
}
+ (void)QueenactivateApp {
    [FBSDKAppEvents activateApp];
}
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [FBSDKAppEvents activateApp];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
    ];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    [FBSDKAppEvents activateApp];
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
}

#pragma mark -  初始化SDK
+ (void)QueeninitialSDK {
    QueenShowHUD
    [self JPBaoFu_initializeRequest];
}
static NSUInteger JPBaoFu_initialfailureCount = 0;
+ (void)JPBaoFu_initializeRequest {
    [[QueenCHIApiRequest shareQueenCHIApiRequest] QueeninitialSDKSuccess:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        JPBaoFu_initialfailureCount = 0;
        response.Queen_responseStyle = Queen_HResponseStyleInitalStyle;
        if ([response.Queen_result isKindOfClass:[NSDictionary class]]) {
            [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_loginStatus = [response.Queen_result[@"ctrl"] integerValue];
            [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_loginStatus1 = [response.Queen_result[@"v_ctrl"] integerValue];
            
            
        } else {
            [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_loginStatus = 0;
        }
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenInitFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenInitFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        if (response.Queen_serviceCode == Queen_HServiceCodeNetworkError && JPBaoFu_initialfailureCount < 6) {
            JPBaoFu_initialfailureCount += 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [QueenSDKMainApi JPBaoFu_initializeRequest];
            });
        } else {
            JPBaoFu_HideHUD
            JPBaoFu_initialfailureCount = 0;
            response.Queen_responseStyle = Queen_HResponseStyleInitalStyle;
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenInitFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenInitFinished:response];
            }
        }
    }];
}
#pragma mark - 展示登录界面
+ (void)QueenshowLoginView {
    if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_isShowedLoginView) return;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_isShowedLoginView = YES;
    QueenCHMainViewController* vc = [QueenCHMainViewController new];
    __weak typeof([QueenSDKMainApi QueensharedInstance]) weakMainApi = [QueenSDKMainApi QueensharedInstance];
    vc.JPBaoFu_dismissCallBack = ^(NSDictionary *result) {
        QueenCHIGlobalUser *globalUser = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
        weakMainApi.JPBaoFu_userInfo.userName = globalUser.userName;
        weakMainApi.JPBaoFu_userInfo.userID = globalUser.userID;
        weakMainApi.JPBaoFu_userInfo.token = globalUser.token;
        weakMainApi.JPBaoFu_userInfo.accountType = globalUser.accountType;
        weakMainApi.JPBaoFu_isShowedLoginView = NO;
        NSArray *products = [result objectForKey:@"product"];
        NSMutableSet *nsset = [NSMutableSet set];
        [nsset addObjectsFromArray:products];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.productIdentifiers = nsset;
        [QueenSDKMainApi QueensharedInstance].qqgameInfo.productIdentifiers = nsset;
        [QueenSDKMainApi QueengetPriceOfProductsWithShowHUD:NO];
    };
    [Queen_HIRootContorller addChildViewController:vc];
    [Queen_HIRootWindow addSubview:vc.view];
}
#pragma mark - 退出登录
+ (void)QueenlogoutOperation:(BOOL)showAlertView {
    if (showAlertView) {
        [QueenCHAlertManager showAlertViewWithTitle:Queen_HLocalizedString(Queen_HIAlertLogOutNavTitleText) message:Queen_HLocalizedString(Queen_HIAlertLogOutMessageText) delegate:[QueenSDKMainApi QueensharedInstance] tempData:nil buttonTitles:Queen_HLocalizedString(Queen_HIAlertInquriryCancelText),Queen_HLocalizedString(Queen_HIAlertInquriryConfirmText),nil];
    }else {
        [[QueenSDKMainApi QueensharedInstance] JPBaoFu_logoutRequest];
    }
}
#pragma mark - 删除账号
+ (void)QueenacdeleteAountOperation:(BOOL)showAlertView{
    
    if (showAlertView) {
        [QueenCHAlertManager showAlertViewWithTitle:@"Đăng xuất tài khoản" message:@"Bạn có muốn đăng xuất không" delegate:[QueenSDKMainApi QueensharedInstance] tempData:nil buttonTitles:Queen_HLocalizedString(Queen_HIAlertInquriryCancelText),Queen_HLocalizedString(Queen_HIAlertInquriryConfirmText),nil];
    }else {
        [[QueenSDKMainApi QueensharedInstance] JPBaoFu_deleteRequest];
    }
    
    
}

- (void)JPBaoFu_deleteRequest {
    
    NSString *nsername=[QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName;
    
    
    
    QueenShowHUD
    [[QueenCHIApiRequest shareQueenCHIApiRequest] userDeteleSuccess:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
            QueenShowSuccessToast(response.JPBaoFu_msg)
            [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isLogoutSuccess = YES;
            [[QueenSDKMainApi QueensharedInstance] QueenclearUselessInfo];
            BOOL result = [QueenCHIDiskCashe deleteCureentUserInformation:nsername];
            
        }else {
            QueenShowErrorToastt(response.JPBaoFu_msg)
        }
        response.Queen_responseStyle = Queen_HResponseStyleDeleteStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenDeleteFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenDeleteFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowErrorToastt(response.JPBaoFu_msg)
        response.Queen_responseStyle = Queen_HResponseStyleDeleteStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenDeleteFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenDeleteFinished:response];
        }
    }];
    
    
}
- (void)JPBaoFu_logoutRequest {
    QueenShowHUD
    [[QueenCHIApiRequest shareQueenCHIApiRequest] userLogoutSuccess:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
            QueenShowSuccessToast(response.JPBaoFu_msg)
            [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isLogoutSuccess = YES;
            [[QueenSDKMainApi QueensharedInstance] QueenclearUselessInfo];
        }else {
            QueenShowErrorToastt(response.JPBaoFu_msg)
        }
        response.Queen_responseStyle = Queen_HResponseStyleLoginOutStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLogoutFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLogoutFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowErrorToastt(response.JPBaoFu_msg)
        response.Queen_responseStyle = Queen_HResponseStyleLoginOutStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLogoutFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLogoutFinished:response];
        }
    }];
}
#pragma mark - 进入游戏
+ (void)QueenenterGameObtainInfo:(NSDictionary *)gameInfo {
    if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_isEnterGame) return;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_isEnterGame = YES;
    [[QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel setValuesForKeysWithDictionary:gameInfo];
    [[QueenSDKMainApi QueensharedInstance].qqgameInfo setValuesForKeysWithDictionary:gameInfo];
    QueenShowHUD
    [[QueenCHIApiRequest shareQueenCHIApiRequest] QueenenterGameObtainInfoSuccess:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        [QueenSDKMainApi QueensharedInstance].JPBaoFu_enterGmaeResponse = response;
        [[QueenSDKMainApi QueensharedInstance] JPBaoFu_judgeUserLoginCount];
    } failure:^(QueenCHIResponseObject *response) {
        [QueenSDKMainApi QueensharedInstance].JPBaoFu_isEnterGame = NO;
        JPBaoFu_HideHUD
        QueenShowErrorToastt(response.JPBaoFu_msg);
        response.Queen_responseStyle = Queen_HResponseStyleEnterGameStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenEnterGameFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate  QueenEnterGameFinished:response];
        }
    }];
}
#pragma mark - 获取内购产品的价格
+ (void)QueengetPriceOfProductsWithShowHUD:(BOOL)showHUD{
    if (showHUD) {
        QueenShowHUD
    }
    [[QueenCHInAppPurchaseManager sharedManager] Queen_getPurchaseProduces:NO];
    JPBaoFu_HideHUD
}
#pragma mark - 发送支付请求
+ (void)QueensendRequestOfPayment:(NSDictionary *)requestInfo {
    JPBaoFu_RunInMainQueue(^{
        [[QueenCHInAppPurchaseManager sharedManager] Queen_RequestPurchaseProduct:requestInfo];
    });
}
#pragma mark - 注册区服信息
+ (void)QueenregisterServerInfo:(NSDictionary *)serverInfo {
    [[QueenCHIApiRequest shareQueenCHIApiRequest] QueenregisterServerInfoWithData:serverInfo success:^(QueenCHIResponseObject *response) {
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenregisterServerInfoFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate  QueenregisterServerInfoFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenregisterServerInfoFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate  QueenregisterServerInfoFinished:response];
        }
    }];
}
#pragma mark - 角色等级提升
+ (void)QueencommitGameRoleLevel:(NSDictionary *)data {
    [[QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel setValuesForKeysWithDictionary:data];
    [[QueenSDKMainApi QueensharedInstance].qqgameInfo setValuesForKeysWithDictionary:data];
    [[QueenCHIApiRequest shareQueenCHIApiRequest] QueencommitGameRoleLevel:data success:^(QueenCHIResponseObject *response) {
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueencommitGameRoleLevelFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate  QueencommitGameRoleLevelFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueencommitGameRoleLevelFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate  QueencommitGameRoleLevelFinished:response];
        }
    }];
}
+ (void)QueenfinishGameNewbieTask {
    ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventFinishNewbieTask];
    [Adjust trackEvent:event];
    [FIRAnalytics logEventWithName:@"完成新手任务" parameters:nil];
}
#pragma mark - 清空历史账号
+ (BOOL)QueenclearHistoryAccount{
    return [QueenCHIDiskCashe deleteAllHistoryAccountInfomation];
}
#pragma mark - Queen_HIBindEmailViewDelegate
- (void)JPBaoFu_bindEmailViewClickReturnEvent {
    [self JPBaoFu_enterGameSuccess];
}
- (void)JPBaoFu_bindEmailViewClickSendCodeEvent:(NSString *)email callback:(void (^)())callback {
    QueenShowHUD
    [[QueenCHIApiRequest shareQueenCHIApiRequest] bindEmailSendCodeWithEmail:email success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        if (callback) {
            callback();
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowErrorToastt(response.JPBaoFu_msg)
    }];
}
- (void)JPBaoFu_bindEmailViewClickLinkEvent:(NSString *)email verifyCode:(NSString *)verifyCode {
    if ([QueenCHHelper JPBaoFu_isBlankString:email]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissAccountText))
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:verifyCode]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissVerifyCodeText))
        return;
    }
    QueenShowHUD
    [[QueenCHIApiRequest shareQueenCHIApiRequest] bindEmailWithEmail:email verifyCode:verifyCode success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowSuccessToast(Queen_HLocalizedString(Queen_HIAlertBindSuccessText))
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isBind = YES;
        [self JPBaoFu_enterGameSuccess];
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowErrorToastt(response.JPBaoFu_msg);
    }];
}
#pragma mark - JPBaoFu_BindYKAccViewDelegate
- (void)JPBaoFu_bindYKAccViewClickReturnEvent {
    [self JPBaoFu_enterGameSuccess];
}
- (void)JPBaoFu_bindYKAccViewClickSendCodeEvent:(NSString *)email callback:(void(^)(void))callback {
    if ([QueenCHHelper JPBaoFu_isBlankString:email]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissAccountText))
        return;
    }
    QueenShowHUD
    [[QueenCHIApiRequest shareQueenCHIApiRequest] bindYKAccEmailSendCodeWithEmail:email success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        if (callback) {
            callback();
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowErrorToastt(response.JPBaoFu_msg)
    }];
}
- (void)JPBaoFu_bindYKAccViewClickLinkEvent:(NSString *)email password:(NSString *)password password2:(NSString *)password2 verifyCode:(NSString *)verifyCode {
    if ([QueenCHHelper JPBaoFu_isBlankString:email]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissAccountText))
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:password]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissPasswordText))
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:password2]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissPasswordText))
        return;
    }
    if ([password isEqualToString:password2] == NO) {
        QueenShowWarningToast(@"Mật khẩu mới không giống nhau")
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:verifyCode]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissVerifyCodeText))
        return;
    }
    QueenShowHUD
    [[QueenCHIApiRequest shareQueenCHIApiRequest] bindYKAccEmailWithEmail:email password:password verifyCode:verifyCode success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowSuccessToast(Queen_HLocalizedString(Queen_HIAlertBindSuccessText))
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isBind = YES;
        [self JPBaoFu_enterGameSuccess];
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUD
        QueenShowErrorToastt(response.JPBaoFu_msg);
    }];
}
- (void)JPBaoFu_enterGameSuccess {
    [self.JPBaoFu_bindEmailView removeFromSuperview];
    [self.JPBaoFu_bindYKAccView removeFromSuperview];
    self.JPBaoFu_bindEmailView = nil;
    self.JPBaoFu_bindYKAccView = nil;
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.CH_RoleID = [self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"role_id"];
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.session_id = [self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"session_id"];
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.CH_ServerID = [self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"server_id"];
    if ([[self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"isFirstRole"] isEqualToString:@"1"]) {
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventCreateRoles];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:@"创建角色" parameters:nil];
    }
    [self.JPBaoFu_timerService Queen_refreshToken];
    [self.JPBaoFu_timerService Queen_startGameHeart];
    [[QueenCHInAppPurchaseManager sharedManager] Queen_recheckCachePurchaseOrderReceipts];
    self.JPBaoFu_enterGmaeResponse.Queen_responseStyle = Queen_HResponseStyleEnterGameStyle;
    self.JPBaoFu_enterGmaeResponse.Queen_result = nil;
    if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenEnterGameFinished:)]) {
        [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate  QueenEnterGameFinished:self.JPBaoFu_enterGmaeResponse];
    }
}
#pragma mark - QueenYAlerViewDelegate
- (void)Queen_HAlertView:(QueenYJAlertView *)alertView transferredData:(NSDictionary *)data clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.JPBaoFu_message isEqualToString:Queen_HLocalizedString(Queen_HIAlertLogOutMessageText)]) {
        if (buttonIndex == 1 ) {
            [self JPBaoFu_logoutRequest];
        }
    }
//    @"Đăng xuất tài khoản"
    if ([alertView.JPBaoFu_message isEqualToString:@"Bạn có muốn đăng xuất không"]) {
        if (buttonIndex == 1 ) {
            [self JPBaoFu_deleteRequest];
        }
    }
}
#pragma mark - Private
- (void)QueenclearUselessInfo {
    self.JPBaoFu_timerService = nil;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_isEnterGame = NO;
    [[QueenCHIGlobalInfo QueensharedInstance] QueenclearUselessInfo];
    self.JPBaoFu_userInfo = [QueenCHIUserInfo new];
    NSString *gameID = self.qqgameInfo.gameID;
    NSString *gameExtra = self.qqgameInfo.gameExtra;
    self.qqgameInfo = [QueenCHIGameInfo new];
    self.qqgameInfo.gameID = gameID;
    self.qqgameInfo.gameExtra = gameExtra;
}
- (void)JPBaoFu_judgeUserLoginCount {
    QueenCHIGlobalUser *currentUserInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
    if ((([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_loginStatus << 2) * 10) > 0 && currentUserInfo.loginCount >= 2 && currentUserInfo.isBind == NO) {
        if (currentUserInfo.accountType != Queen_HIAccountTypeVT) {
            self.JPBaoFu_bindEmailView = [QueenCHIBindEmailView QueenShowBindEmailViewInContext:self.JPBaoFu_configInfo.context.view email:currentUserInfo.userName];
            _JPBaoFu_bindEmailView.delegate = self;
            [_JPBaoFu_bindEmailView Queen_refreshMainView];
        } else {
            self.JPBaoFu_bindYKAccView = [QueenBindYKAccView QueenShowBindYKAccViewInContext:self.JPBaoFu_configInfo.context.view email:@""];
            _JPBaoFu_bindYKAccView.delegate = self;
            [_JPBaoFu_bindYKAccView Queen_refreshMainView];
        }
    } else {
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.CH_RoleID = [self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"role_id"];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.session_id = [self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"session_id"];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.CH_ServerID = [self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"server_id"];
        if ([[self.JPBaoFu_enterGmaeResponse.Queen_result objectForKey:@"isFirstRole"] intValue] == 1) {
            ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventCreateRoles];
            [Adjust trackEvent:event];
            [FIRAnalytics logEventWithName:@"创建角色" parameters:nil];
        }
        [self.JPBaoFu_timerService Queen_refreshToken];
        [self.JPBaoFu_timerService Queen_startGameHeart];
        [[QueenCHInAppPurchaseManager sharedManager] Queen_recheckCachePurchaseOrderReceipts];
        self.JPBaoFu_enterGmaeResponse.Queen_responseStyle = Queen_HResponseStyleEnterGameStyle;
        self.JPBaoFu_enterGmaeResponse.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenEnterGameFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate  QueenEnterGameFinished:self.JPBaoFu_enterGmaeResponse];
        }
    }
}
- (void)JPBaoFu_exitApplication {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}
#pragma mark - Setter && Getter
- (void)setJPBaoFu_configInfo:(QueenConfigInfo *)JPBaoFu_configInfo {
    _JPBaoFu_configInfo = JPBaoFu_configInfo;
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.gameID = JPBaoFu_configInfo.gameID;
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.gameExtra = JPBaoFu_configInfo.gameExtra;
    self.qqgameInfo.gameID = JPBaoFu_configInfo.gameID;
    self.qqgameInfo.gameExtra = JPBaoFu_configInfo.gameExtra;
    NSLog(@"%@",JPBaoFu_configInfo.fbAppID);
    [FBSDKSettings setAppID:JPBaoFu_configInfo.fbAppID];
}
- (QueenCHITimerDataService *)JPBaoFu_timerService {
    if (!_JPBaoFu_timerService) {
        _JPBaoFu_timerService = [[QueenCHITimerDataService alloc] init];
    }
    return _JPBaoFu_timerService;
}
@end
