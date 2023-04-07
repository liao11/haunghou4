#import "QueenCHMainViewController.h"
#import "QueenCHILoginView.h"
#import "QueenCHIAutoLoginView.h"
#import "QueenCHISignUpView.h"
#import "QueenCHIDeleteView.h"
#import "QueenCHIFindAtOrPwView.h"
#import "QueenCHIForgotAtView.h"
#import "QueenCHIForgotPwView.h"
#import "QueenCHIApiRequest.h"
#import "QueenCHAlertManager.h"
#import "QueenCHIAccountService.h"
#import "QueenSDKMainApi.h"
#import "QueenCHIDiskCashe.h"
#import "QueenSignInAppleManager.h"
#import <AdjustSdk/Adjust.h>
#import <SafariServices/SafariServices.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#define kAccountMinL 6
#define kAccountMaxL 20
#define kPwdMinL 6
#define kPwdMaxL 20
@interface QueenCHMainViewController ()<QueenYAlerViewDelegate,Queen_HILoginViewDelegate,Queen_HISignUpViewDelegate,Queen_HIFindAtOrPwViewDelegate,Queen_HIForgotAtViewDelegate,Queen_HIForgotPwViewDelegate,Queen_HIAutoLoginViewDelegate,SFSafariViewControllerDelegate,Queen_HIDeleteViewDelegate>
@property (nonatomic, strong) QueenCHILoginView        *JPBaoFu_loginView;
@property (nonatomic, strong) QueenCHIAutoLoginView    *JPBaoFu_autoLoginView;
@property (nonatomic, strong) QueenCHISignUpView       *JPBaoFu_signUpView;
@property (nonatomic, strong) QueenCHIDeleteView       *JPBaoFu_deleteView;
@property (nonatomic, strong) QueenCHIFindAtOrPwView   *JPBaoFu_findAtOrPwView;
@property (nonatomic, strong) QueenCHIForgotAtView     *JPBaoFu_forgotAtView;
@property (nonatomic, strong) QueenCHIForgotPwView     *JPBaoFu_forgotPwView;
@property (nonatomic, strong) NSMutableArray                *JPBaoFu_serviceHistoryAccounts;
@property (nonatomic, assign) BOOL                           JPBaoFu_clickSwitch;
@property (nonatomic, strong) NSString                      *JPBaoFu_serviceEmail;
@property (nonatomic, strong) QueenCHIAccountService   *JPBaoFu_accountService;
@property (nonatomic, strong) QueenCHIResponseObject   *JPBaoFu_loginSuccessResponse;
@end
@implementation QueenCHMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Queen_HTDefaultContextBackgroundColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(JPBaoFu_tapView)];
    [self.view addGestureRecognizer:tap];
    [self JPBaoFu_defalutSetting];
}
#pragma mark - Initial_View
- (void)JPBaoFu_defalutSetting {
    JPBaoFu_YJLog(@"ch_展示登录界面");
    NSArray *historyAccounts = [QueenCHIDiskCashe loadAllHistoryAccountInformation];
    NSArray *chHistoryAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
    QueenCHIGlobalUser *lastLoginUser = historyAccounts.firstObject;
    NSDictionary *data = nil;
    if ([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isLogoutSuccess) {
        QueenCHIGlobalUser *chLastLoginUser = chHistoryAccounts.firstObject;
        if (chLastLoginUser) {
            data = @{
                     Queen_HILoginViewEmailData:chLastLoginUser.userName,
                     Queen_HILoginViewPasswordData:chLastLoginUser.password,
                     Queen_HILoginView_HistoryAccountData:chHistoryAccounts==nil?[NSArray array]:chHistoryAccounts
                     };
            self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
            _JPBaoFu_loginView.delegate = self;
            [_JPBaoFu_loginView Queen_refreshMainView];
        } else {
            data = @{
                     Queen_HILoginViewEmailData:@"",
                     Queen_HILoginViewPasswordData:@""
                     };
            self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
            _JPBaoFu_loginView.delegate = self;
            [_JPBaoFu_loginView Queen_refreshMainView];
        }
    } else {
        if (lastLoginUser) {
            if (lastLoginUser.accountType == Queen_HIAccountTypeCH || lastLoginUser.accountType == Queen_HIAccountTypeVT) {// 游客和账号
                [self Queen_HAutoLoginOperation:lastLoginUser];
            } else {
                [self JPBaoFu_autoLoginViewWithLastLoginUser:lastLoginUser];
            }
        } else {
            data = @{
                     Queen_HILoginViewEmailData:@"",
                     Queen_HILoginViewPasswordData:@"",
                     Queen_HILoginView_HistoryAccountData:chHistoryAccounts==nil?[NSArray array]:chHistoryAccounts
                     };
            self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
            _JPBaoFu_loginView.delegate = self;
            [_JPBaoFu_loginView Queen_refreshMainView];
        }
    }
}
#pragma mark - 自动登录
- (void)JPBaoFu_autoLoginViewWithLastLoginUser:(QueenCHIGlobalUser *)lastLoginUser {
    self.JPBaoFu_autoLoginView = [QueenCHIAutoLoginView QueenShowAutoLoginViewInContext:self.view account:lastLoginUser.userName];
    _JPBaoFu_autoLoginView.delegate = self;
    [_JPBaoFu_autoLoginView Queen_refreshMainView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.JPBaoFu_autoLoginView == nil) return ;
        [self.JPBaoFu_autoLoginView Queen_canClickSwitchButton:NO];
        Queen_HIAccountType accountType = lastLoginUser.accountType;
        [[QueenCHIApiRequest shareQueenCHIApiRequest] AutoLoginWithUsername:lastLoginUser.userName md5Password:lastLoginUser.password success:^(QueenCHIResponseObject *response) {
            if (self.JPBaoFu_clickSwitch) return;
            if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
                NSString *successAlert = [NSString stringWithFormat:@"%@%@",Queen_HLocalizedString(Queen_HIAlertLoginSuccessText),lastLoginUser.userName];
                QueenShowSuccessToast(successAlert)
                [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel = lastLoginUser;
                [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = NO;
                [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType = accountType;
                [QueenCHIGlobalInfo QueenparserLoginResponse:response.Queen_result];
                ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventLogin];
                [Adjust trackEvent:event];
                [FIRAnalytics logEventWithName:kFIREventLogin parameters:@{ @"登录来源": @"账号登录" }];
                self.JPBaoFu_dismissCallBack([response.Queen_result copy]);
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
            }
            else {
                QueenShowErrorToastt(response.JPBaoFu_msg)
                NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
                NSDictionary *data = @{
                         Queen_HILoginViewEmailData:lastLoginUser.userName,
                         Queen_HILoginViewPasswordData:lastLoginUser.password,
                         Queen_HILoginView_HistoryAccountData:historyAccounts
                         };
                self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
                _JPBaoFu_loginView.delegate = self;
                [_JPBaoFu_loginView Queen_refreshMainView];
            }
            response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
            response.Queen_result = nil;
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
            }
        } failure:^(QueenCHIResponseObject *response) {
            if (self.JPBaoFu_clickSwitch) return;
            QueenShowErrorToastt(response.JPBaoFu_msg)
            NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
            NSDictionary *data = @{
                                   Queen_HILoginViewEmailData:lastLoginUser.userName,
                                   Queen_HILoginViewPasswordData:lastLoginUser.password,
                                   Queen_HILoginView_HistoryAccountData:historyAccounts
                                   };
            self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
            _JPBaoFu_loginView.delegate = self;
            [_JPBaoFu_loginView Queen_refreshMainView];
            [self.JPBaoFu_autoLoginView removeFromSuperview];
            self.JPBaoFu_autoLoginView = nil;
            response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
            response.Queen_result = nil;
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
            }
        }];
    });
}
- (void)Queen_HAutoLoginOperation:(QueenCHIGlobalUser *)lastLoginUser {
    self.JPBaoFu_autoLoginView = [QueenCHIAutoLoginView QueenShowAutoLoginViewInContext:self.view account:lastLoginUser.userName];
    _JPBaoFu_autoLoginView.delegate = self;
    [_JPBaoFu_autoLoginView Queen_refreshMainView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.JPBaoFu_autoLoginView == nil) return ;
        [self.JPBaoFu_autoLoginView Queen_canClickSwitchButton:NO];
        Queen_HIAccountType accountType = lastLoginUser.accountType;
        [[QueenCHIApiRequest shareQueenCHIApiRequest] LogInGameWithUserName:lastLoginUser.userName Password:lastLoginUser.password success:^(QueenCHIResponseObject *response) {
            if (self.JPBaoFu_clickSwitch) return;
            if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
                NSString *successAlert = [NSString stringWithFormat:@"%@%@",Queen_HLocalizedString(Queen_HIAlertLoginSuccessText),lastLoginUser.userName];
                QueenShowSuccessToast(successAlert)
                [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel = lastLoginUser;
                [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = NO;
                [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType = accountType;
                [QueenCHIGlobalInfo QueenparserLoginResponse:response.Queen_result];
                ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventLogin];
                [Adjust trackEvent:event];
                [FIRAnalytics logEventWithName:kFIREventLogin parameters:@{ @"登录来源": @"账号登录" }];
                self.JPBaoFu_dismissCallBack([response.Queen_result copy]);
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
            } else {
                QueenShowErrorToastt(response.JPBaoFu_msg)
                NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
                NSDictionary *data = @{
                         Queen_HILoginViewEmailData:lastLoginUser.userName,
                         Queen_HILoginViewPasswordData:lastLoginUser.password,
                         Queen_HILoginView_HistoryAccountData:historyAccounts
                         };
                self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
                _JPBaoFu_loginView.delegate = self;
                [_JPBaoFu_loginView Queen_refreshMainView];
            }
            response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
            response.Queen_result = nil;
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
            }
        } failure:^(QueenCHIResponseObject *response) {
            if (self.JPBaoFu_clickSwitch) return;
            QueenShowErrorToastt(response.JPBaoFu_msg)
            NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
            NSDictionary *data = @{
                                   Queen_HILoginViewEmailData:lastLoginUser.userName,
                                   Queen_HILoginViewPasswordData:lastLoginUser.password,
                                   Queen_HILoginView_HistoryAccountData:historyAccounts
                                   };
            self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
            _JPBaoFu_loginView.delegate = self;
            [_JPBaoFu_loginView Queen_refreshMainView];
            [self.JPBaoFu_autoLoginView removeFromSuperview];
            self.JPBaoFu_autoLoginView = nil;
            response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
            response.Queen_result = nil;
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
            }
        }];
    });
}
#pragma mark - Queen_HILoginViewDelegate
- (void)JPBaoFu_loginViewClickSignUpEvent {
    JPBaoFu_YJWeakSelf
    self.JPBaoFu_signUpView = [QueenCHISignUpView QueenShowSignUpViewInContext:self.view];
    _JPBaoFu_signUpView.alpha = 0.0;
    _JPBaoFu_signUpView.delegate = self;
    [_JPBaoFu_signUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_loginView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_loginView.alpha = 0.0f;
        _JPBaoFu_signUpView.alpha = 1.0f;
        [_JPBaoFu_signUpView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    }];
}
- (void)JPBaoFu_loginViewClickAccountServiceEvent {
    JPBaoFu_YJWeakSelf
    self.JPBaoFu_findAtOrPwView = [QueenCHIFindAtOrPwView QueenShowFindAtOrPwViewInContext:self.view];
    _JPBaoFu_findAtOrPwView.alpha = 0.0;
    _JPBaoFu_findAtOrPwView.delegate = self;
    [_JPBaoFu_findAtOrPwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_loginView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_loginView.alpha = 0.0f;
        _JPBaoFu_findAtOrPwView.alpha = 1.0f;
        [_JPBaoFu_findAtOrPwView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    }];
}
- (void)JPBaoFu_loginViewClickLogInEvent:(NSString *)account password:(NSString *)password {
    if ([QueenCHHelper JPBaoFu_isBlankString:account]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissAccountText))
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:password]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissPasswordText))
        return;
    }
    QueenShowHUDInCurrentView
    [[QueenCHIApiRequest shareQueenCHIApiRequest] LogInGameWithUserName:account Password:password success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        NSString *successAlert = [NSString stringWithFormat:@"%@%@",Queen_HLocalizedString(Queen_HIAlertLoginSuccessText),account];
        QueenShowSuccessToast(successAlert)
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName = account;
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.password = password;
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType = Queen_HIAccountTypeCH;
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = YES;
        [QueenCHIGlobalInfo QueenparserLoginResponse:response.Queen_result];
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventLogin];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:kFIREventLogin parameters:@{ @"登录来源": @"账号登录" }];
        self.JPBaoFu_dismissCallBack([response.Queen_result copy]);
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowErrorToastt(response.JPBaoFu_msg)
        response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
        }
    }];
}
- (void)JPBaoFu_loginViewClickPlayAsGuestEvent {
    QueenShowHUDInCurrentView
    [[QueenCHIApiRequest shareQueenCHIApiRequest] GuestLogInSuccess:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        NSString *successAlert = [NSString stringWithFormat:@"%@%@",Queen_HLocalizedString(Queen_HIAlertLoginSuccessText),Queen_HLocalizedString(Queen_HIAlertGuestLoginSuccessText)];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName = [response.Queen_result objectForKey:@"username"];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.password = [response.Queen_result objectForKey:@"passwd"];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType = Queen_HIAccountTypeVT;
        BOOL isReg = [[response.Queen_result objectForKey:@"isReg"] boolValue];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = isReg;
        [QueenCHIGlobalInfo QueenparserLoginResponse:response.Queen_result];
        QueenShowSuccessToast(successAlert)
        self.JPBaoFu_dismissCallBack([response.Queen_result copy]);
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventLogin];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:kFIREventLogin parameters:@{ @"登录来源": @"账号登录" }];
        response.Queen_responseStyle = Queen_HResponseStyleGuestLoginStyle;
        response.Queen_result = nil;
        if (isReg) {
            ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventRegister];
            [Adjust trackEvent:event];
            ADJEvent *event1 = [ADJEvent eventWithEventToken:JPBaoFu_cEventAccRegister];
            [Adjust trackEvent:event1];
            [FIRAnalytics logEventWithName:kFIREventSignUp parameters:@{ @"注册来源": @"账号注册" }];
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenRegisterFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenRegisterFinished:response];
            }
        }else {
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
            }
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowErrorToastt(response.JPBaoFu_msg)
        response.Queen_responseStyle = Queen_HResponseStyleGuestLoginStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
        }
    }];
}
- (void)JPBaoFu_loginViewClickFacebookEvent {
    
    
    
    
    self.JPBaoFu_accountService = [[QueenCHIAccountService alloc] init];
    [_JPBaoFu_accountService facebookLoginOperationWithContext:self success:^(QueenCHIResponseObject *response) {
        NSString *nickName = [response.Queen_result objectForKey:@"nickName"];
        [self JPBaoFu_facebookCHLoginWithNickName:nickName];
    } failure:^(QueenCHIResponseObject *response) {
        [self JPBaoFu_facebookLoginFailure:response];
    }];
}
- (void)JPBaoFu_loginViewClickCellSelectedEvent:(NSInteger)deleteIndex {
    NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
    QueenCHIGlobalUser *user = historyAccounts[deleteIndex];
    NSDictionary *recentData = @{
                                 Queen_HILoginViewEmailData : user.userName,
                                 Queen_HILoginViewPasswordData : user.password
                                 };
    [self.JPBaoFu_loginView Queen_refreshMainViewInfo:recentData];
}
- (void)JPBaoFu_loginViewClickCellDeletedEvent:(NSInteger)deleteIndex {
    NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
    QueenCHIGlobalUser *user = historyAccounts[deleteIndex];
    NSString *currentEmail = user.userName;
    BOOL result = [QueenCHIDiskCashe deleteCureentUserInformation:user.userName];
    if (result) {
        NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
        [self.JPBaoFu_loginView JPBaoFu_refreshHistoryTableInfo:historyAccounts==nil?@[]:historyAccounts];
        if ([self.JPBaoFu_loginView.JPBaoFu_accountField.text isEqualToString:currentEmail]) {
            [self.JPBaoFu_loginView Queen_refreshMainViewInfo:@{
                                                  Queen_HILoginViewEmailData : @"",
                                                  Queen_HILoginViewPasswordData : @""
                                                  }];
        }
    }
}
- (void)JPBaoFu_loginViewClickProtoclBtnEvent {
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlProtocol];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:YES];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:YES completion:nil];
}
- (void)JPBaoFu_loginViewClickSignInWithAppleEvent {
    
    
    
    QueenShowHUDInCurrentView
    [[QueenSignInAppleManager sharedManager] handleAuthorizationAppleIDButtonPress:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        NSString *successAlert = [NSString stringWithFormat:@"%@AppleID",Queen_HLocalizedString(Queen_HIAlertLoginSuccessText)];
        QueenShowSuccessToast(successAlert)
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName = [response.Queen_result objectForKey:@"username"];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.password = [response.Queen_result objectForKey:@"passwd"];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType = Queen_HIAccountTypeApple;
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = [[response.Queen_result objectForKey:@"isReg"] boolValue];
        [QueenCHIGlobalInfo QueenparserLoginResponse:response.Queen_result];
        self.JPBaoFu_dismissCallBack([response.Queen_result copy]);
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventLogin];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:kFIREventLogin parameters:@{ @"登录来源": @"苹果登录" }];
        response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
        response.Queen_result = nil;
        if ([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg) {
            ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventRegister];
            [event addPartnerParameter:@"注册来源" value:@"苹果账号注册"];
            [Adjust trackEvent:event];
            ADJEvent *event1 = [ADJEvent eventWithEventToken:JPBaoFu_cEventAccRegister];
            [Adjust trackEvent:event1];
            [FIRAnalytics logEventWithName:kFIREventSignUp parameters:@{ @"注册来源": @"苹果账号注册" }];
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenRegisterFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenRegisterFinished:response];
            }
        } else {
            if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
            }
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowErrorToastt(response.JPBaoFu_msg)
        response.Queen_responseStyle = Queen_HResponseStyleNormalLoginStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
        }
    }];
}
#pragma mark - Queen_HIAutoLoginViewDelegate
- (void)JPBaoFu_autoLoginViewClickSwitchEvent {
    if (self.JPBaoFu_autoLoginView == nil) return;
    [self.JPBaoFu_autoLoginView removeFromSuperview];
    self.JPBaoFu_autoLoginView = nil;
    self.JPBaoFu_clickSwitch = YES;
    NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
    QueenCHIGlobalUser *lastLoginUser = historyAccounts.firstObject;
    NSDictionary *data = nil;
    if (lastLoginUser) {
        data = @{
                 Queen_HILoginViewEmailData:lastLoginUser.userName,
                 Queen_HILoginViewPasswordData:lastLoginUser.password,
                 Queen_HILoginView_HistoryAccountData:historyAccounts
                 };
    } else {
        data = @{
                 Queen_HILoginViewEmailData:@"",
                 Queen_HILoginViewPasswordData:@"",
                 };
    }
    self.JPBaoFu_loginView = [QueenCHILoginView QueenshowLoginViewInContext:self.view data:data];
    _JPBaoFu_loginView.delegate = self;
    [_JPBaoFu_loginView Queen_refreshMainView];
}
#pragma mark - Queen_HISignUpViewDelegate
- (void)JPBaoFu_signUpVeiwClickReturnEvent {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_signUpView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_signUpView.alpha = 0.0f;
        self.JPBaoFu_loginView.alpha = 1.0;
        [self.JPBaoFu_loginView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.JPBaoFu_signUpView removeFromSuperview];
        self.JPBaoFu_signUpView = nil;
    }];
}
- (void)JPBaoFu_signUpViewClickDetailProtocolInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlProtocol];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:YES];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:YES completion:nil];
}
- (void)JPBaoFu_signUpViewClickRegisterEvent:(NSString *)account password:(NSString *)password confirmP:(BOOL)confirmP{
    if ([QueenCHHelper JPBaoFu_isBlankString:account]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissAccountText))
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:password]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissPasswordText))
        return;
    }
    if (!confirmP) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissConfirmProtocal));
        return;
    }
    if (password.length < kPwdMinL) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPasswordTooShortText))
        return;
    }
    if (password.length > kPwdMaxL) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPasswordTooLongText))
        return;
    }
    if (![QueenCHHelper JPBaoFu_judgePassWordLegal:password]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPasswordFormatErrorText))
        return;
    }
    QueenShowHUDInCurrentView
    [[QueenCHIApiRequest shareQueenCHIApiRequest] RegisterAccountWithUserName:account Password:password success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventRegister];
        [event addPartnerParameter:@"注册来源" value:@"平台账户注册"];
        [Adjust trackEvent:event];
        ADJEvent *event1 = [ADJEvent eventWithEventToken:JPBaoFu_cEventAccRegister];
        [Adjust trackEvent:event1];
        [FIRAnalytics logEventWithName:kFIREventSignUp parameters:@{ @"注册来源": @"平台账户注册" }];
        NSString *successAlert = [NSString stringWithFormat:@"%@%@",Queen_HLocalizedString(Queen_HIAlertLoginSuccessText),account];
        QueenShowSuccessToast(successAlert)
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName = account;
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.password = password;
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType = Queen_HIAccountTypeCH;
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = YES;
        [QueenCHIGlobalInfo QueenparserLoginResponse:response.Queen_result];
        self.JPBaoFu_dismissCallBack([response.Queen_result copy]);
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        response.Queen_responseStyle = Queen_HResponseStyleRegisterStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenRegisterFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenRegisterFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowErrorToastt(response.JPBaoFu_msg)
        response.Queen_responseStyle = Queen_HResponseStyleRegisterStyle;
        response.Queen_result = nil;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenRegisterFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenRegisterFinished:response];
        }
    }];
}

-(void)JPBaoFu_ShowDeteleViewClickRegisterEvent{
    
    JPBaoFu_YJWeakSelf
    self.JPBaoFu_deleteView = [QueenCHIDeleteView QueenShowDeteleViewInContext:self.view];
    _JPBaoFu_deleteView.alpha = 0.0;
    _JPBaoFu_deleteView.delegate = self;
    [_JPBaoFu_deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_signUpView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_signUpView.alpha = 0.0f;
        _JPBaoFu_deleteView.alpha = 1.0f;
        [_JPBaoFu_deleteView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
//        [_JPBaoFu_forgotPwView QueenShowCountdownAnimation];
    }];
    
   
    
    
    
}

#pragma mark - Queen_HIDeleteViewDelegate
-(void)JPBaoFu_DeteleVeiwClickReturnEvent{
    
}



#pragma mark - Queen_HIFindAtOrPwViewDelegate
- (void)JPBaoFu_findAtOrPwViewClickReturnEvent {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_findAtOrPwView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_findAtOrPwView.alpha = 0.0f;
        self.JPBaoFu_loginView.alpha = 1.0;
        [self.JPBaoFu_loginView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.JPBaoFu_findAtOrPwView removeFromSuperview];
        self.JPBaoFu_findAtOrPwView = nil;
    }];
}
- (void)JPBaoFu_findAtOrPwViewClickForgotIDEvent {
    self.JPBaoFu_serviceHistoryAccounts = [NSMutableArray array];
    JPBaoFu_YJWeakSelf
    self.JPBaoFu_forgotAtView = [QueenCHIForgotAtView QueenShowForgotAtViewInContext:self.view];
    _JPBaoFu_forgotAtView.alpha = 0.0;
    _JPBaoFu_forgotAtView.delegate = self;
    [_JPBaoFu_forgotAtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_findAtOrPwView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_findAtOrPwView.alpha = 0.0f;
        _JPBaoFu_forgotAtView.alpha = 1.0f;
        [_JPBaoFu_forgotAtView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        QueenShowHUDInCurrentView
        [[QueenCHIApiRequest shareQueenCHIApiRequest] findAccountSuccess:^(QueenCHIResponseObject *response) {
            JPBaoFu_HideHUDInCurrentView
            if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
                NSArray *accouonts = [response.Queen_result objectForKey:@"account"];
                NSString *email = [response.Queen_result objectForKey:@"email"];
                for (NSDictionary *dict in accouonts) {
                    NSString *username = [dict objectForKey:@"username"]?:@"";
                    NSString *loginstate = [dict objectForKey:@"login_state"]?:@"";
                    NSString *lastlogin = [dict objectForKey:@"last_login"]?:@"";
                    NSMutableDictionary *historyAccount = [NSMutableDictionary dictionary];
                    [historyAccount setObject:username forKey:Queen_HIForgotAtViewEmailData];
                    [historyAccount setObject:loginstate forKey:Queen_HIForgotAtViewGameNameData];
                    [historyAccount setObject:lastlogin forKey:Queen_HIForgotAtViewLastTimeLoggedInData];
                    [self.JPBaoFu_serviceHistoryAccounts addObject:historyAccount];
                }
                [weakSelf.JPBaoFu_forgotAtView JPBaoFu_setData:@{ Queen_HIForgotAtViewAccountsData:self.JPBaoFu_serviceHistoryAccounts, Queen_HIForgotAtViewEmailData:email}];
            } else {
                QueenShowErrorToastt(response.JPBaoFu_msg)
            }
        } failure:^(QueenCHIResponseObject *response) {
            JPBaoFu_HideHUDInCurrentView
            QueenShowErrorToastt(response.JPBaoFu_msg)
        }];
    }];
}
- (void)JPBaoFu_findAtOrPwViewClickSubmitEvent:(NSString *)email inputCode:(NSString *)inputCode codeViewStr:(NSString *)codeViewStr {
    if ([QueenCHHelper JPBaoFu_isBlankString:email]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissAccountText))
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:inputCode]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissVerifyCodeText))
        return;
    }
    if (!([inputCode caseInsensitiveCompare:codeViewStr] == NSOrderedSame)) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissVerifyCodeMatchText));
        return;
    }
    QueenShowHUDInCurrentView
    [[QueenCHIApiRequest shareQueenCHIApiRequest] verifyEmailWithEmail:email success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        JPBaoFu_YJWeakSelf
        NSDictionary *data = @{
                               Queen_HIForgotPwViewEmailData : [response.Queen_result objectForKey:@"email"]
                               };
        self.JPBaoFu_forgotPwView = [QueenCHIForgotPwView QueenShowForgotPwViewInContext:self.view data:data];
        _JPBaoFu_forgotPwView.alpha = 0.0;
        _JPBaoFu_forgotPwView.delegate = self;
        [_JPBaoFu_forgotPwView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_findAtOrPwView);
        }];
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.4 animations:^{
            self.JPBaoFu_findAtOrPwView.alpha = 0.0f;
            _JPBaoFu_forgotPwView.alpha = 1.0f;
            [_JPBaoFu_forgotPwView Queen_refreshMainView];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_JPBaoFu_forgotPwView QueenShowCountdownAnimation];
        }];
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowErrorToastt(response.JPBaoFu_msg)
        [_JPBaoFu_findAtOrPwView JPBaoFu_freshVerCode];
        if (response.Queen_serviceCode == Queen_HServiceCodeUnboundMainbox) {
            self.JPBaoFu_serviceEmail = [response.Queen_result objectForKey:@"kf_email"];
            NSString *toastMessage = [NSString stringWithFormat:@"%@(%@)",Queen_HLocalizedString(Queen_HIAlertContactCustomerServiceText),self.JPBaoFu_serviceEmail];
             [QueenCHAlertManager showAlertViewWithTitle:Queen_HLocalizedString(Queen_HIAlertInquriryTitleText) message:toastMessage delegate:self tempData:nil buttonTitles:Queen_HLocalizedString(Queen_HIAlertInquriryCancelText),Queen_HLocalizedString(Queen_HIAlertInquriryConfirmText),nil];
        }
    }];
}
#pragma mark - Queen_HIForgotAtViewDelegate
- (void)JPBaoFu_forgotAtViewClickReturnEvents {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_findAtOrPwView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_forgotAtView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_forgotAtView.alpha = 0.0f;
        self.JPBaoFu_findAtOrPwView.alpha = 1.0f;
        [self.JPBaoFu_findAtOrPwView Queen_refreshMainView];
    } completion:^(BOOL finished) {
        [self.JPBaoFu_forgotAtView removeFromSuperview];
        self.JPBaoFu_forgotAtView = nil;
    }];
}
- (void)JPBaoFu_forgotAtViewClickAccountInfoOfIndex:(NSInteger)index {
    JPBaoFu_YJWeakSelf
    NSDictionary *selectData = self.JPBaoFu_serviceHistoryAccounts[index];
    NSArray *historyAccounts = [QueenCHIDiskCashe loadCHHistoryAccountInformation];
    NSString *password = @"";
    for (QueenCHIGlobalUser *userInfo in historyAccounts) {
        if ([userInfo.userName isEqualToString:[selectData objectForKey:Queen_HIForgotAtViewEmailData]]) {
            password = userInfo.password;
            break;
        }
    }
    NSDictionary *recentData = @{
                                 Queen_HILoginViewEmailData : [selectData objectForKey:Queen_HIForgotAtViewEmailData],
                                 Queen_HILoginViewPasswordData : password,
                                 Queen_HILoginView_HistoryAccountData:historyAccounts==nil?[NSArray array]:historyAccounts
                                 };
    [self.JPBaoFu_loginView Queen_refreshMainViewInfo:recentData];
    [self.JPBaoFu_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_forgotAtView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_forgotAtView.alpha = 0.0f;
        self.JPBaoFu_loginView.alpha = 1.0;
        [self.JPBaoFu_loginView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.JPBaoFu_forgotAtView removeFromSuperview];
        self.JPBaoFu_forgotAtView = nil;
        [self.JPBaoFu_findAtOrPwView removeFromSuperview];
        self.JPBaoFu_findAtOrPwView = nil;
    }];
}
#pragma mark - Queen_HIForgotPwViewDelegate
- (void)JPBaoFu_forgotPwViewClickReturnEvents {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_findAtOrPwView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_forgotPwView);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        self.JPBaoFu_forgotPwView.alpha = 0.0f;
        self.JPBaoFu_findAtOrPwView.alpha = 1.0;
        [self.JPBaoFu_findAtOrPwView Queen_refreshMainView];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.JPBaoFu_forgotPwView removeFromSuperview];
        self.JPBaoFu_forgotPwView = nil;
    }];
}
- (void)JPBaoFu_forgotPwViewClickSendCodeEvent:(NSString *)email callback:(void (^)())callback{
    QueenShowHUDInCurrentView
    [[QueenCHIApiRequest shareQueenCHIApiRequest] verifyEmailWithEmail:self.JPBaoFu_findAtOrPwView.JPBaoFu_accountField.text success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        if (callback) {
            callback();
        }
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowErrorToastt(response.JPBaoFu_msg)
    }];
}
- (void)JPBaoFu_forgotPwViewClickSubmitEvent:(NSString *)email inputCode:(NSString *)inputCode newPassword:(NSString *)newPassword {
    if ([QueenCHHelper JPBaoFu_isBlankString:inputCode]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissVerifyCodeText))
        return;
    }
    if ([QueenCHHelper JPBaoFu_isBlankString:newPassword]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissPasswordText))
        return;
    }
    if (newPassword.length < kPwdMinL) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPasswordTooShortText))
        return;
    }
    if (newPassword.length > kPwdMaxL) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPasswordTooLongText))
        return;
    }
    if (![QueenCHHelper JPBaoFu_judgePassWordLegal:newPassword]) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPasswordFormatErrorText))
        return;
    }
    QueenShowHUDInCurrentView
    [[QueenCHIApiRequest shareQueenCHIApiRequest] modifyPasswordWithEmail:self.JPBaoFu_findAtOrPwView.JPBaoFu_accountField.text verifyCode:inputCode newPassword:newPassword success:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowSuccessToast(Queen_HLocalizedString(Queen_HIAlertAmendPasswordSuccessText))
        JPBaoFu_YJWeakSelf
        NSDictionary *recentData = @{
                                     Queen_HILoginViewEmailData : self.JPBaoFu_findAtOrPwView.JPBaoFu_accountField.text ,
                                     Queen_HILoginViewPasswordData : newPassword
                                     };
        [self.JPBaoFu_loginView Queen_refreshMainViewInfo:recentData];
        [self.JPBaoFu_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.and.bottom.mas_equalTo(weakSelf.JPBaoFu_forgotPwView);
        }];
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.4 animations:^{
            self.JPBaoFu_forgotPwView.alpha = 0.0f;
            self.JPBaoFu_loginView.alpha = 1.0;
            [self.JPBaoFu_loginView Queen_refreshMainView];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.JPBaoFu_forgotPwView removeFromSuperview];
            self.JPBaoFu_forgotPwView = nil;
            [self.JPBaoFu_findAtOrPwView removeFromSuperview];
            self.JPBaoFu_findAtOrPwView = nil;
        }];
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_HideHUDInCurrentView
        QueenShowErrorToastt(response.JPBaoFu_msg);
    }];
}
#pragma mark - QueenYAlerViewDelegate
- (void)Queen_HAlertView:(QueenYJAlertView *)alertView transferredData:(NSDictionary *)data clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [UIPasteboard generalPasteboard].string = self.JPBaoFu_serviceEmail ;
        QueenShowSuccessToast(Queen_HLocalizedString(Queen_HIAlertCopySuccessText));
    }
}
#pragma mark - Private Func
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self JPBaoFu_hidExtraInterface];
}
- (void)JPBaoFu_hidExtraInterface {
    [self.view endEditing:YES];
}
- (void)JPBaoFu_tapView {
    if (self.JPBaoFu_loginView != nil && self.JPBaoFu_loginView.alpha != 0.0f) {
        [self.JPBaoFu_loginView JPBaoFu_hidHistoryTable];
    }
}
- (void)JPBaoFu_facebookCHLoginWithNickName:(NSString *)nickName {
    FBSDKAccessToken *fbToken = [FBSDKAccessToken currentAccessToken];
    [[QueenCHIApiRequest shareQueenCHIApiRequest] ThirdLogInWithPlatform:@"1" account:fbToken.userID success:^(QueenCHIResponseObject *response) {
        [self JPBaoFu_facebookLoginComplete:response nickName:nickName];
    } failure:^(QueenCHIResponseObject *response) {
        [self JPBaoFu_facebookLoginFailure:response];
    }];
}
- (void)JPBaoFu_facebookLoginComplete:(QueenCHIResponseObject *)response nickName:(NSString *)nickName{
    JPBaoFu_HideHUD
    BOOL isReg = [[response.Queen_result objectForKey:@"isReg"] boolValue];
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = isReg;
    NSString *successAlert = [NSString stringWithFormat:@"%@%@",Queen_HLocalizedString(Queen_HIAlertLoginSuccessText),nickName];
    QueenShowSuccessToast(successAlert)
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName = [response.Queen_result objectForKey:@"username"];
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.password = [response.Queen_result objectForKey:@"passwd"];
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.fbUserName = nickName;
    
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.isReg = [[response.Queen_result objectForKey:@"isReg"] boolValue];
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType = Queen_HIAccountTypeFB;
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.fbToken = [FBSDKAccessToken currentAccessToken];
    [QueenCHIGlobalInfo QueenparserLoginResponse:response.Queen_result];
    self.JPBaoFu_dismissCallBack([response.Queen_result copy]);
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventLogin];
    [Adjust trackEvent:event];
    [FIRAnalytics logEventWithName:kFIREventLogin parameters:@{ @"登录来源": @"Facebook登录" }];
    response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
    response.Queen_result = nil;
    if (isReg) {
        ADJEvent *event1 = [ADJEvent eventWithEventToken:JPBaoFu_cEventRegister];
        [event1 addPartnerParameter:@"注册来源" value:@"Facebook注册"];
        [Adjust trackEvent:event1];
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventFBRegister];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:kFIREventSignUp parameters:@{ @"注册来源": @"Facebook注册" }];
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenRegisterFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenRegisterFinished:response];
        }
    }else {
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
        }
    }
}
- (void)JPBaoFu_facebookLoginFailure:(QueenCHIResponseObject *)response {
    JPBaoFu_HideHUD
    if (response.Queen_serviceCode == Queen_HServiceCodeFacebookLoginCancel) {
        QueenShowWarningToast(response.JPBaoFu_msg);
    }else {
        QueenShowErrorToastt(response.JPBaoFu_msg);
    }
    [self JPBaoFu_autoLoginViewClickSwitchEvent];
    response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
    response.Queen_result = nil;
    if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenLoginFinished:)]) {
        [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenLoginFinished:response];
    }
}
#pragma mark - Lift Cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
