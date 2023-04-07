#import "QueenCHIDiskCashe.h"
#import "QueenCHIKeyChain.h"
NSString *const JPBaoFu_KeyInternationHistoryAccounts = @"www.sdk1.com.key.InternationHistoryAccounts1";
NSInteger const JPBaoFu_KeySaveAccountMax = 10;
NSString *const JPBaoFu_KeyInternationSampleInfo = @"www.sdk.com.key.InternationSampleInfo1";
@implementation QueenCHIDiskCashe
+ (void)saveUserInformation:(QueenCHIGlobalUser *)userInfo {
    
    
     NSArray *historyAccount = [QueenCHIDiskCashe loadAllHistoryAccountInformation];
    if (historyAccount.count == JPBaoFu_KeySaveAccountMax) {
        QueenCHIGlobalUser *lasteUserInfo = historyAccount.lastObject;
        [QueenCHIDiskCashe deleteCureentUserInformation:lasteUserInfo.userName];
    }
    
    
    BOOL isExsit = NO;
    for (QueenCHIGlobalUser *historyUser in historyAccount) {
        if ([historyUser.userID isEqualToString:userInfo.userID]) {
            userInfo.loginCount = historyUser.loginCount;
            userInfo.loginCount += 1;
            isExsit = YES;
            BOOL result = [QueenCHIDiskCashe deleteCureentUserInformation:userInfo.userName];
            break;
        }
    }
    if (!isExsit) {
        userInfo.loginCount = 1;
    }
    
    NSLog(@"保存的账号%@",userInfo.userName);
    BOOL result = [QueenCHIKeyChain JPBaoFu_setComplexData:userInfo account:userInfo.userName forService:JPBaoFu_KeyInternationHistoryAccounts];
    if (result) {
        JPBaoFu_YJDevLog(@"ch_用户信息保存成功");
    }else {
        JPBaoFu_YJDevLog(@"ch_用户信息保存失败");
    }
}
+ (void)saveSampleInfomation:(NSString *)infomation account:(NSString *)account{
    [QueenCHIKeyChain JPBaoFu_setPassword:infomation account:account forService:JPBaoFu_KeyInternationSampleInfo];
}
+ (NSString *)loadSomeSampleInfomation:(NSString *)account {
   NSArray<Queen_HIKeyChainResult *> *arr = [QueenCHIKeyChain JPBaoFu_loadInfoForService:JPBaoFu_KeyInternationSampleInfo account:account resultType:0];
    if (arr.count) {
        return arr.firstObject.password;
    }else {
        return nil;
    }
}
+ (NSArray *)loadAllHistoryAccountInformation {
    NSArray *keychainResult = [QueenCHIKeyChain JPBaoFu_loadAllInfoForService:JPBaoFu_KeyInternationHistoryAccounts resultType:1];
    if (keychainResult.count == 0) return nil;
    NSMutableArray *historyAccounts = [NSMutableArray array];
    for (Queen_HIKeyChainResult *result in keychainResult) {
        if (!result.codingData) continue;
        [historyAccounts addObject:result.codingData];
    }
    return historyAccounts;
}
+ (NSArray *)loadCHHistoryAccountInformation {
    NSArray *keychainResult = [QueenCHIKeyChain JPBaoFu_loadAllInfoForService:JPBaoFu_KeyInternationHistoryAccounts resultType:1];
    if (keychainResult.count == 0) return nil;
    NSMutableArray *historyAccounts = [NSMutableArray array];
    for (Queen_HIKeyChainResult *result in keychainResult) {
        if (!result.codingData) continue;
        QueenCHIGlobalUser *userInfo = (QueenCHIGlobalUser *)result.codingData;
        if (userInfo.accountType != Queen_HIAccountTypeCH) continue;
        [historyAccounts addObject:result.codingData];
    }
    return historyAccounts;
}
+ (QueenCHIGlobalUser *)obtainUserInfoFromHistory:(NSString *)userName {
    NSArray<Queen_HIKeyChainResult *> *arr = [QueenCHIKeyChain JPBaoFu_loadInfoForService:JPBaoFu_KeyInternationHistoryAccounts account:userName resultType:1];
    if (arr.count == 0) return nil;
    return (QueenCHIGlobalUser *)arr.lastObject.codingData;
}
+ (BOOL)deleteCureentUserInformation:(NSString *)account {
   return [QueenCHIKeyChain JPBaoFu_deleteInfoForService:JPBaoFu_KeyInternationHistoryAccounts account:account];
}
+ (BOOL)deleteAllHistoryAccountInfomation {
    return [QueenCHIKeyChain JPBaoFu_deleteAllInfoForService:JPBaoFu_KeyInternationHistoryAccounts];
}
@end
