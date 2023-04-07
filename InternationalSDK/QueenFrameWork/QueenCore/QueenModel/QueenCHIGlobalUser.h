#import <Foundation/Foundation.h>
//#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

@interface QueenCHIGlobalUser : NSObject <NSCoding>
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *token;
@property (nonatomic, copy) NSString *autoToken;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, assign) BOOL isBind;
@property (nonatomic, assign) BOOL isReg;
@property (nonatomic, assign) NSInteger loginCount;
@property (nonatomic, assign) Queen_HIAccountType accountType;
@property (nonatomic, strong) FBSDKAccessToken *fbToken;
@property (nonatomic, strong) NSString *fbUserName;
@end
