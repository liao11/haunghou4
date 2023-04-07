#import <Foundation/Foundation.h>
typedef void(^Queen_HIRequestCompletionBlock)(QueenCHIResponseObject *response);
@interface QueenCHIAccountService : NSObject
- (void)facebookLoginOperationWithContext:(UIViewController *)context success:(Queen_HIRequestCompletionBlock)success failure:(Queen_HIRequestCompletionBlock)failure;
- (void)facebookAutoLoginOperationWithUserInfo:(QueenCHIGlobalUser *)userInfo success:(Queen_HIRequestCompletionBlock)success failure:(Queen_HIRequestCompletionBlock)failure;
@end
