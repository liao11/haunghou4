#import <Foundation/Foundation.h>
#import "QueenCHIApiRequest.h"
NS_ASSUME_NONNULL_BEGIN
@interface QueenSignInAppleManager : NSObject
+ (instancetype)sharedManager;
- (NSString *)currentAppleUserIdentifier;
- (void)handleAuthorizationAppleIDButtonPress:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)perfomExistingAccountSetupFlows:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
@end
NS_ASSUME_NONNULL_END
