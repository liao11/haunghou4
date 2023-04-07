#import "QueenCHNetworkRequest.h"
#import <StoreKit/StoreKit.h>
@interface QueenCHIApiRequest : QueenCHNetworkRequest
Queen_SingleH(QueenCHIApiRequest)
- (void)QueeninitialSDKSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)Queen_deviceActiveRequest;
- (void)RegisterAccountWithUserName:(NSString *)userName Password:(NSString *)password success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)LogInGameWithUserName:(NSString *)userName Password:(NSString *)password success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)AutoLoginWithUsername:(NSString *)userName md5Password:(NSString *)password success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)GuestLogInSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)ThirdLogInWithPlatform:(NSString *)platform account:(NSString *)account success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)logInWithAppleID:(NSString *)userId email:(NSString *)email authorizationCode:(NSString *)authorizationCode identityToken:(NSString *)identityToken success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)userLogoutSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;

- (void)userDeteleSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)findAccountSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)verifyEmailWithEmail:(NSString *)email success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)modifyPasswordWithEmail:(NSString *)email verifyCode:(NSString *)verifyCode newPassword:(NSString *)newPassword success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)bindEmailSendCodeWithEmail:(NSString *)email success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)bindEmailWithEmail:(NSString *)email verifyCode:(NSString *)verifyCode success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)bindYKAccEmailSendCodeWithEmail:(NSString *)email success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)bindYKAccEmailWithEmail:(NSString *)email password:(NSString *)password verifyCode:(NSString *)verifyCode success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)QueenenterGameObtainInfoSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)QueenregisterServerInfoWithData:(NSDictionary *)serverInfo success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)QueencommitGameRoleLevel:(NSDictionary *)data success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)refreshTokenSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)commitGameHeartInfoSuccess:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)CreatCHOrderInfo:(NSDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)purchaseWithParameters:(NSMutableDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
@end
