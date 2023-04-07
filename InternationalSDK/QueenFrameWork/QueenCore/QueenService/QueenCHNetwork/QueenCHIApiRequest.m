#import "QueenCHIApiRequest.h"
#import "QueenSDKMainApi.h"
 #import <AdjustSdk/Adjust.h>
@implementation QueenCHIApiRequest
static NSUInteger failureCount = 0;
JPBaoFu_SingleM(QueenCHIApiRequest)
- (void)QueeninitialSDKSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(@"1", @"ra")
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice gainAppVersion], [QueenUtils qudecryptString:Queen_HAppVersion])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cInitialUrl];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)Queen_deviceActiveRequest {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModel], [QueenUtils qudecryptString:Queen_HDeviceType])
    Queen_HTJudgeParameter([UIDevice currentDevice].systemVersion, [QueenUtils qudecryptString:Queen_HSystemIdentity])
    Queen_HTJudgeParameter(Adjust.adid, [QueenUtils qudecryptString:Queen_HAdjustDeviceID])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlDeviceActive];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:^(QueenCHIResponseObject *response) {
        failureCount = 0;
    } failure:^(QueenCHIResponseObject *response) {
        if (response.Queen_serviceCode == Queen_HServiceCodeNetworkError && failureCount < 6) {
            failureCount += 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self Queen_deviceActiveRequest];
            });
        }else {
            failureCount = 0;
        }
    }];
}
- (void)RegisterAccountWithUserName:(NSString *)userName Password:(NSString *)password success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_stringBy32BitMD5EncryptWithSting:password], [QueenUtils qudecryptString:Queen_HPassWord])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlNormalReg];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)LogInGameWithUserName:(NSString *)userName Password:(NSString *)password success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_stringBy32BitMD5EncryptWithSting:password], [QueenUtils qudecryptString:Queen_HPassWord])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModel], [QueenUtils qudecryptString:Queen_HDeviceType])
    Queen_HTJudgeParameter([UIDevice currentDevice].systemVersion, [QueenUtils qudecryptString:Queen_HSystemIdentity])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlNormalLogin];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)AutoLoginWithUsername:(NSString *)userName md5Password:(NSString *)password success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter(password, [QueenUtils qudecryptString:Queen_HPassWord])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModel], [QueenUtils qudecryptString:Queen_HDeviceType])
    Queen_HTJudgeParameter([UIDevice currentDevice].systemVersion, [QueenUtils qudecryptString:Queen_HSystemIdentity])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlNormalLogin];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)GuestLogInSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModel], [QueenUtils qudecryptString:Queen_HDeviceType])
    Queen_HTJudgeParameter([UIDevice currentDevice].systemVersion, [QueenUtils qudecryptString:Queen_HSystemIdentity])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlGuestLogin];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)ThirdLogInWithPlatform:(NSString *)platform account:(NSString *)account success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(platform, [QueenUtils qudecryptString:Queen_HThirdPlatform]);
    Queen_HTJudgeParameter(account, [QueenUtils qudecryptString:Queen_HThirdAccount]);
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModel], [QueenUtils qudecryptString:Queen_HDeviceType])
    Queen_HTJudgeParameter([UIDevice currentDevice].systemVersion, [QueenUtils qudecryptString:Queen_HSystemIdentity])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlThirdLogin];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)logInWithAppleID:(NSString *)userId
                             email:(NSString *)email
                 authorizationCode:(NSString *)authorizationCode
                     identityToken:(NSString *)identityToken
                           success:(QueenRequestCompletionBlock)success
                           failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(userId, [QueenUtils qudecryptString:Queen_HThirdAccount]);
    Queen_HTJudgeParameter(email, [QueenUtils qudecryptString:Queen_HEamil]);
    Queen_HTJudgeParameter(authorizationCode, [QueenUtils qudecryptString:Queen_HAppleAuthorizationCode]);
    Queen_HTJudgeParameter(identityToken, [QueenUtils qudecryptString:Queen_HAppleIdentityToken]);
    Queen_HTJudgeParameter(@"3", [QueenUtils qudecryptString:Queen_HThirdPlatform]);
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModel], [QueenUtils qudecryptString:Queen_HDeviceType])
    Queen_HTJudgeParameter([UIDevice currentDevice].systemVersion, [QueenUtils qudecryptString:Queen_HSystemIdentity])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlVerifySignInWithAppleId];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)userLogoutSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlUserLogout];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)userDeteleSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure{
    
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlUserDelete];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)findAccountSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlFindAccounts];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)verifyEmailWithEmail:(NSString *)email success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(email, [QueenUtils qudecryptString:Queen_HEamil])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlVerifyEmail];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)modifyPasswordWithEmail:(NSString *)email verifyCode:(NSString *)verifyCode newPassword:(NSString *)newPassword success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure; {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter(email, [QueenUtils qudecryptString:Queen_HEamil])
    Queen_HTJudgeParameter(verifyCode, [QueenUtils qudecryptString:Queen_HAccountCode])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_stringBy32BitMD5EncryptWithSting:newPassword], [QueenUtils qudecryptString:Queen_HNewPwd]);
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlModifyPassword];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)bindEmailSendCodeWithEmail:(NSString *)email success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    Queen_HTJudgeParameter(email, [QueenUtils qudecryptString:Queen_HEamil])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlBindVerifyCode];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)bindEmailWithEmail:(NSString *)email verifyCode:(NSString *)verifyCode success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    Queen_HTJudgeParameter(email, [QueenUtils qudecryptString:Queen_HEamil])
    Queen_HTJudgeParameter(verifyCode, [QueenUtils qudecryptString:Queen_HAccountCode])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlBindEmail];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)bindYKAccEmailSendCodeWithEmail:(NSString *)email success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    Queen_HTJudgeParameter(email, [QueenUtils qudecryptString:Queen_HEamil])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlBindYHCode];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)bindYKAccEmailWithEmail:(NSString *)email password:(NSString *)password verifyCode:(NSString *)verifyCode success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    Queen_HTJudgeParameter(email, [QueenUtils qudecryptString:Queen_HEamil])
    Queen_HTJudgeParameter(verifyCode, [QueenUtils qudecryptString:Queen_HAccountCode])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_stringBy32BitMD5EncryptWithSting:password], [QueenUtils qudecryptString:Queen_HPassWord])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlBindYHName];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)QueenenterGameObtainInfoSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    QueenCHIGlobalGame *gameInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel;
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter(gameInfo.CP_ServerID, [QueenUtils qudecryptString:Queen_HCpServiceID])
    Queen_HTJudgeParameter(gameInfo.CP_ServerName, [QueenUtils qudecryptString:Queen_HCpServiceName])
    Queen_HTJudgeParameter(gameInfo.CP_RoleLevel, [QueenUtils qudecryptString:Queen_HCpRoleLevel])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter(gameInfo.CP_RoleID, [QueenUtils qudecryptString:Queen_HRoleID])
    Queen_HTJudgeParameter(gameInfo.CP_RoleName, [QueenUtils qudecryptString:Queen_HCpRoleName])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlEnjoyGame];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)QueenregisterServerInfoWithData:(NSDictionary *)serverInfo success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([serverInfo objectForKey:@"CP_ServerID"], [QueenUtils qudecryptString:Queen_HCpServiceID])
    Queen_HTJudgeParameter([serverInfo objectForKey:@"CP_ServerName"], [QueenUtils qudecryptString:Queen_HCpServiceName])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlregisterServerInfo];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)QueencommitGameRoleLevel:(NSDictionary *)data success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.CH_ServerID, [QueenUtils qudecryptString:Queen_HServiceID])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.CH_RoleID, [QueenUtils qudecryptString:Queen_HRoleID])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.CP_RoleID, [QueenUtils qudecryptString:Queen_HCpRoleId])
    Queen_HTJudgeParameter([data objectForKey:@"CP_RoleName"], [QueenUtils qudecryptString:Queen_HCpRoleName])
    Queen_HTJudgeParameter([data objectForKey:@"CP_RoleLevel"], [QueenUtils qudecryptString:Queen_HCpRoleLevel])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token, [QueenUtils qudecryptString:Queen_HToken])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlCommitRoleLevel];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)refreshTokenSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.autoToken, [QueenUtils qudecryptString:Queen_HRefreshToken])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlRefreshToken];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)commitGameHeartInfoSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    QueenCHIGlobalUser *userInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
    QueenCHIGlobalGame *gameInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel;
    Queen_HTJudgeParameter(userInfo.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter(userInfo.userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter(gameInfo.CH_ServerID, [QueenUtils qudecryptString:Queen_HServiceID])
    Queen_HTJudgeParameter(gameInfo.session_id, [QueenUtils qudecryptString:Queen_HSessionID])
    Queen_HTJudgeParameter(gameInfo.CH_RoleID, [QueenUtils qudecryptString:Queen_HRoleID])
    Queen_HTJudgeParameter(gameInfo.CP_RoleID, [QueenUtils qudecryptString:Queen_HCpRoleId])
    Queen_HTJudgeParameter(gameInfo.CP_RoleName, [QueenUtils qudecryptString:Queen_HCpRoleName])
    Queen_HTJudgeParameter(gameInfo.CP_RoleLevel, [QueenUtils qudecryptString:Queen_HCpRoleLevel])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceNetworkingStates], [QueenUtils qudecryptString:Queen_HDeviceNetwork])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModelProvider], [QueenUtils qudecryptString:Queen_HDeviceModelProvider])
    Queen_HTJudgeParameter([UIDevice getCurrentDeviceModel], [QueenUtils qudecryptString:Queen_HDeviceType])
    Queen_HTJudgeParameter([UIDevice currentDevice].systemVersion, [QueenUtils qudecryptString:Queen_HSystemIdentity])
    Queen_HTJudgeParameter(userInfo.token, [QueenUtils qudecryptString:Queen_HToken])
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlHeartbeat];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)CreatCHOrderInfo:(NSDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlOrderInfo];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
- (void)purchaseWithParameters:(NSMutableDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",JPBaoFu_cBaseTestUrl,JPBaoFu_cUrlAppleOrderVerify];
    [self QueenSendRequestWithURLExtend:url parameters:parameters success:success failure:failure];
}
@end
