#import "QueenSignInAppleManager.h"
#import <AuthenticationServices/AuthenticationServices.h>
NSString *const cKeychainServiceForAppleCurrentUserIdentifier = @"www.muugame.com.AppleCurrentUserIdentifier";
@interface QueenSignInAppleManager () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, copy) QueenRequestCompletionBlock successBlock;
@property (nonatomic, copy) QueenRequestCompletionBlock failureBlock;
@end
@implementation QueenSignInAppleManager
+ (instancetype)sharedManager {
    static QueenSignInAppleManager *signInAppleManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signInAppleManager = [[QueenSignInAppleManager alloc] init];
    });
    return signInAppleManager;
}
- (instancetype)init {
    if (self = [super init]) {
        [self JPBaoFu_observeAppleSignInState];
    }
    return self;
}
- (void)JPBaoFu_observeAppleSignInState
{
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(JPBaoFu_handleSignInWithAppleStateChanged:)
                                                     name:ASAuthorizationAppleIDProviderCredentialRevokedNotification
                                                   object:nil];
    }
}
- (void)JPBaoFu_handleSignInWithAppleStateChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
}
- (NSString *)currentAppleUserIdentifier {
    return nil;
}
- (void)handleAuthorizationAppleIDButtonPress:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    if (@available(iOS 13.0, *)) {
        self.successBlock = success;
        self.failureBlock = failure;
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
    }
}
- (void)perfomExistingAccountSetupFlows:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    if (@available(iOS 13.0, *)) {
        self.successBlock = success;
        self.failureBlock = failure;
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        ASAuthorizationPasswordProvider *passwordProvider = [[ASAuthorizationPasswordProvider alloc] init];
        ASAuthorizationPasswordRequest *passwordRequest = [passwordProvider createRequest];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest, passwordRequest]];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
    }
}
#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    return [UIApplication sharedApplication].windows.lastObject;
}
#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential * credential = authorization.credential;
        NSString * userID = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString * email = credential.email;
        NSString * authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString * identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        NSLog(@"************苹果登录授权完成***************");
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        NSLog(@"************苹果登录授权完成***************");
        [[QueenCHIApiRequest shareQueenCHIApiRequest] logInWithAppleID:userID email:email authorizationCode:authorizationCode identityToken:identityToken success:^(QueenCHIResponseObject *response) {
            if (self.successBlock) {
                self.successBlock(response);
                self.successBlock = nil;
                self.failureBlock = nil;
            }
        } failure:^(QueenCHIResponseObject *response) {
            if (self.failureBlock) {
                self.failureBlock(response);
                self.successBlock = nil;
                self.failureBlock = nil;
            }
        }];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *user = passwordCredential.user;
        NSString *password = passwordCredential.password;
        NSLog(@"************用户登录使用现有的密码凭证***************");
        NSLog(@"user: %@", user);
        NSLog(@"password: %@", password);
        NSLog(@"authorization.credential: %@", authorization.credential);
        NSLog(@"************用户登录使用现有的密码凭证***************");
    } else {
        NSLog(@"授权信息均不符");
        if (self.failureBlock) {
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.JPBaoFu_msg = @"Thông tin ủy quyền không phù hợp ";
            response.Queen_serviceCode = Queen_HServiceCodeVerifyError;
            JPBaoFu_RunInMainQueue(^{
                self.failureBlock(response);
                self.successBlock = nil;
                self.failureBlock = nil;
            });
        }
    }
}
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"Người dùng hủy yêu cầu ủy quyền ";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"Yêu cầu ủy quyền không thành công ";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"Phản hồi yêu cầu ủy quyền không hợp lệ ";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"Không xử lý yêu cầu ủy quyền";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"Yêu cầu ủy quyền thất bại Không rõ nguyên nhân ";
            break;
        default:
            break;
    }
    NSLog(@"苹果登录授权失败 controller=%@ \n error：%@ \n errorMsg = %@", controller, error, errorMsg);
    if (self.failureBlock) {
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.JPBaoFu_msg = errorMsg;
        response.Queen_serviceCode = Queen_HServiceCodeVerifyError;
        JPBaoFu_RunInMainQueue(^{
            self.failureBlock(response);
            self.successBlock = nil;
            self.failureBlock = nil;
        });
    }
}
@end
