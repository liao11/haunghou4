#import "QueenCHIGlobalInfo.h"
#import "QueenCHIDiskCashe.h"
#import "QueenSDKMainApi.h"
#import <FirebaseAnalytics/FirebaseAnalytics.h>
@implementation QueenCHIGlobalInfo
+ (instancetype)QueensharedInstance {
    static QueenCHIGlobalInfo *api = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        api = [[self alloc] init];
        api.JPBaoFu_gameModel = [QueenCHIGlobalGame new];
        api.JPBaoFu_userModel = [QueenCHIGlobalUser new];
        api.JPBaoFu_isLogoutSuccess = NO;
    });
    return api;
}
+ (void)QueenlaunchData {
}
+ (void)QueenparserLoginResponse:(NSDictionary *)result {
    QueenCHIGlobalUser *userModel = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
    userModel.userID = [result objectForKey:@"userid"];
    userModel.token = [result objectForKey:@"token"];
    userModel.autoToken = [result objectForKey:@"auto_token"];
    userModel.isBind = [[result objectForKey:@"isBind"] boolValue];
    if (userModel.userID) {
        [FIRAnalytics setUserID:userModel.userID];
    }
    [QueenCHIDiskCashe saveUserInformation:userModel];
    [self JPBaoFu_externalUserInfoChange];
}
- (void)QueenclearUselessInfo {
    self.JPBaoFu_userModel = [QueenCHIGlobalUser new];
    NSString *gameID = self.JPBaoFu_gameModel.gameID;
    NSString *gameExtra = self.JPBaoFu_gameModel.gameExtra;
    self.JPBaoFu_gameModel = [QueenCHIGlobalGame new];
    self.JPBaoFu_gameModel.gameID = gameID;
    self.JPBaoFu_gameModel.gameExtra = gameExtra;
}
+ (void)JPBaoFu_externalUserInfoChange {
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_userInfo.userName = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_userInfo.userID = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_userInfo.token =  [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_userInfo.accountType = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.accountType;
}
@end
