#import "QueenCHIAccountService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "QueenSDKMainApi.h"
@interface QueenCHIAccountService ()
@property (nonatomic, strong) FBSDKLoginManager *loginManager;
@end
@implementation QueenCHIAccountService
- (void)facebookLoginOperationWithContext:(UIViewController *)context success:(Queen_HIRequestCompletionBlock)success failure:(Queen_HIRequestCompletionBlock)failure {
    self.loginManager = [[FBSDKLoginManager alloc] init];
    [self.loginManager logOut];
    [_loginManager logInWithPermissions:@[@"public_profile",@"email"] fromViewController:context handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        NSLog(@"facebook login result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
        if (error) {
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertLoginFailureText);
            response.Queen_serviceCode = Queen_HServiceCodeFacebookLoginFailure;
            response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
            failure(response);
        } else if (result.isCancelled) {
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertLoginCancelText);
            response.Queen_serviceCode = Queen_HServiceCodeFacebookLoginCancel;
            response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
            failure(response);
        } else {
            QueenShowHUD
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:result.token.userID
                                          parameters:nil
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                if (error) {
                    QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
                    response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertLoginFailureText);
                    response.Queen_serviceCode = Queen_HServiceCodeFacebookLoginFailure;
                    response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
                    failure(response);
                } else {
                    NSString *nickName = [result objectForKey:@"name"];
                    QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
                    response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertLoginSuccessMegText);
                    response.Queen_serviceCode = Queen_HServiceCodeSuccess;
                    response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
                    response.Queen_result = @{
                                        @"nickName" : nickName
                                        };
                    success(response);
                }
            }];
        }
    } ];
}
- (void)facebookAutoLoginOperationWithUserInfo:(QueenCHIGlobalUser *)userInfo success:(Queen_HIRequestCompletionBlock)success failure:(Queen_HIRequestCompletionBlock)failure {
    [FBSDKAccessToken setCurrentAccessToken:userInfo.fbToken];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:userInfo.fbToken.userID
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        if (error) {
            response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertAuthorizationExpiresText);
            response.Queen_serviceCode = Queen_HServiceCodeTokenFailureError;
            response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
            failure(response);
        }else{
            NSString *nickName = [result objectForKey:@"name"];
            response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertLoginSuccessMegText);
            response.Queen_serviceCode = Queen_HServiceCodeSuccess;
            response.Queen_responseStyle = Queen_HResponseStyleFacebookLoginStyle;
            response.Queen_result = @{
                                @"nickName" : nickName
                                };
            success(response);
        }
    }];
}
@end
