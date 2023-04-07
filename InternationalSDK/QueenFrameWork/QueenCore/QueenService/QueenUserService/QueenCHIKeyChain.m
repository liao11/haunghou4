#import "QueenCHIKeyChain.h"
static JPBaoFu_YJSynStrategies synStrategiesType = JPBaoFu_YJSynStrategiesWhenUnlocked;
#pragma mark - Queen_HIKeyChainResult
@implementation Queen_HIKeyChainResult
@end
#pragma mark - Queen_HIKeyChainService
@interface Queen_HIKeyChainService : NSObject
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, strong) NSData *saveData;
@property (nonatomic, strong) id<NSCoding> codingData;
@property (nonatomic, assign) JPBaoFu_YJSynStrategies synStrategies;
@end
@implementation Queen_HIKeyChainService
#pragma mark - 保存操作
- (BOOL)normalSaveFunc {
    synStrategiesType = JPBaoFu_YJSynStrategiesWhenUnlocked;
    if (!self.serviceName || !self.account || !self.saveData) {
        JPBaoFu_YJDevLog(@"参数不能为nil");
        return NO;
    }
    return [self saveOperation];
}
- (BOOL)codingSaveFunc {
    synStrategiesType = JPBaoFu_YJSynStrategiesWhenUnlocked;
    if (![(id)self.codingData conformsToProtocol:@protocol(NSCoding)]) {
        JPBaoFu_YJDevLog(@"当前保存数据不符合<NSCoding>协议");
        return NO;
    }
    if (!self.serviceName || !self.account || !self.codingData) {
        JPBaoFu_YJDevLog(@"参数不能为nil");
        return NO;
    }
    self.saveData = [NSKeyedArchiver archivedDataWithRootObject:self.codingData];
    return [self saveOperation];
}
- (BOOL)saveOperation {
    NSMutableDictionary *updateQuery = nil;
    NSMutableDictionary *searchQuery = [self keyChainItemQuery];
    
    
    OSStatus status =  SecItemCopyMatching((__bridge CFDictionaryRef) searchQuery, nil);
    if (status == errSecSuccess) {
        updateQuery = [NSMutableDictionary dictionary];
        [updateQuery setObject:self.saveData forKey:(__bridge id)kSecValueData];
#if TARGET_OS_IPHONE
        [updateQuery setObject:(__bridge id)[self synStr] forKey:(__bridge id)kSecAttrAccessible];
#endif
        status = SecItemUpdate((__bridge CFDictionaryRef)searchQuery, (__bridge CFDictionaryRef)updateQuery);
    }else if (status == errSecItemNotFound) {
        updateQuery = [self keyChainItemQuery];
        [updateQuery setObject:self.saveData forKey:(__bridge id)kSecValueData];
        status = SecItemAdd((__bridge CFDictionaryRef)updateQuery, NULL);
    }
    return status == errSecSuccess;
}
#pragma mark - 抓取数据
- (nullable NSArray *)fetchAllInfo:(int)saveType {
    NSArray *importantArr = [self fetchImportantData];
    NSArray *otherArr = [self fetchAttachedInformation];
    NSMutableArray *finalResult = [NSMutableArray arrayWithCapacity:importantArr.count];
    if (importantArr.count == 0|| otherArr.count == 0) {
        JPBaoFu_YJDevLog(@"无数据");
        return nil;
    }
    if (importantArr.count != otherArr.count) {
        JPBaoFu_YJDevLog(@"主要信息与附属信息数量不对等");
        return nil;
    }
    for (int i = 0; i < importantArr.count; i++) {
        NSDictionary *dict = otherArr[i];
        Queen_HIKeyChainResult *resultModel = [[Queen_HIKeyChainResult alloc] init];
        resultModel.account = [dict objectForKey:@"acct"];
        resultModel.serviceName = [dict objectForKey:@"svce"];
        resultModel.creatDate = [dict objectForKey:@"cdat"];
        resultModel.finalModificationDate = [dict objectForKey:@"mdat"];
        if (saveType == 0) {
            NSString *passwordData = [[NSString alloc] initWithData:importantArr[i] encoding:NSUTF8StringEncoding];
            resultModel.password = passwordData;
        }else if (saveType == 1) {
            resultModel.codingData = [NSKeyedUnarchiver unarchiveObjectWithData:importantArr[i]];
        }else {
            resultModel.data = importantArr[i];
        }
        [finalResult addObject:resultModel];
    }
    for (int i = 0; i < finalResult.count; i++) {
        for (int j = 0; j < finalResult.count -1; j++) {
            Queen_HIKeyChainResult *result1 = finalResult[j];
            Queen_HIKeyChainResult *result2 = finalResult[j+1];
            NSComparisonResult compareResult =[result1.finalModificationDate compare:result2.finalModificationDate];
            if (compareResult == NSOrderedAscending) {
                [finalResult exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return [finalResult copy];
}
- (NSArray *)fetchImportantData {
    NSMutableDictionary *fetchQuery = [self keyChainItemQuery];
    [fetchQuery setObject:@YES forKey:(id)kSecReturnData];
    [fetchQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef)fetchQuery, (CFTypeRef *)&result);
    if (status != errSecSuccess) {
        JPBaoFu_YJDevLog(@"主体信息获取数据失败");
        return nil;
    }
    return (__bridge_transfer NSArray *)result;
}
- (NSArray *)fetchAttachedInformation {
    NSMutableDictionary *fetchQuery = [self keyChainItemQuery];
    [fetchQuery setObject:@YES forKey:(id)kSecReturnAttributes];
    [fetchQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef)fetchQuery, (CFTypeRef *)&result);
    if (status != errSecSuccess) {
        JPBaoFu_YJDevLog(@"附属信息获取数据失败");
        return nil;
    }
    return (__bridge_transfer NSArray *)result;
}
#pragma mark - 删除操作
- (BOOL)deleteAllInfo {
    if (!self.serviceName) {
        JPBaoFu_YJDevLog(@"参数不能为nil");
        return NO;
    }
    return [self deleteInfo];
}
- (BOOL)deleteSpecialInfo {
    if (!self.serviceName || !self.account) {
        JPBaoFu_YJDevLog(@"参数不能为nil");
        return NO;
    }
    return [self deleteInfo];
}
- (BOOL)deleteInfo {
    NSMutableDictionary *dict = [self keyChainItemQuery];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef) dict);
    return (status == errSecSuccess);
}
#pragma mark - NSDictionaty
- (NSMutableDictionary *)keyChainItemQuery {
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    if (self.serviceName) {
        [query setObject:self.serviceName forKey:(__bridge id)kSecAttrService];
    }
    if (self.account) {
        [query setObject:self.account forKey:(__bridge id)kSecAttrAccount];
    }
#if TARGET_OS_IPHONE
    [query setObject:(__bridge id)[self synStr] forKey:(__bridge id)kSecAttrAccessible];
#endif
    return query;
}
- (void)setPassword:(NSString *)password {
    _password = password;
    self.saveData = [password dataUsingEncoding:NSUTF8StringEncoding];
}
- (CFStringRef)synStr {
    switch (self.synStrategies) {
        case JPBaoFu_YJSynStrategiesAlwaysThisDeviceOnly:
            return kSecAttrAccessibleAlwaysThisDeviceOnly;
            break;
        case JPBaoFu_YJSynStrategiesAlways:
            return kSecAttrAccessibleAlways;
            break;
        case JPBaoFu_YJSynStrategiesWhenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly;
            break;
        case JPBaoFu_YJSynStrategiesAfterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
            break;
        case JPBaoFu_YJSynStrategiesWhenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
            break;
        case JPBaoFu_YJSynStrategiesAfterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock;
            break;
        default:
            return kSecAttrAccessibleWhenUnlocked;
            break;
    }
}
@end
#pragma mark - QueenCHIKeyChain
@interface QueenCHIKeyChain ()
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *serviceName;
@end
@implementation QueenCHIKeyChain
#pragma mark - 保存数据
+ (BOOL)JPBaoFu_setPassword:(NSString *)password account:(NSString *)account forService:(NSString *)serviceName {
    Queen_HIKeyChainService *service = [[Queen_HIKeyChainService alloc] init];
    service.password = password;
    service.account = account;
    service.serviceName = serviceName;
    service.synStrategies = synStrategiesType;
    return [service normalSaveFunc];
}
+ (BOOL)JPBaoFu_setComplexData:(id<NSCoding>)data account:(NSString *)account forService:(NSString *)serviceName {
    Queen_HIKeyChainService *service = [[Queen_HIKeyChainService alloc] init];
    service.codingData = data;
    service.account = account;
    service.serviceName = serviceName;
    service.synStrategies = synStrategiesType;
    NSLog(@"保存的账号%@",account);
    return [service codingSaveFunc];
}
+ (BOOL)JPBaoFu_setNormalData:(NSData *)data account:(NSString *)account forService:(NSString *)serviceName {
    Queen_HIKeyChainService *service = [[Queen_HIKeyChainService alloc] init];
    service.saveData = data;
    service.account = account;
    service.serviceName = serviceName;
    service.synStrategies = synStrategiesType;
    return [service normalSaveFunc];
}
#pragma mark - 获取数据
+ (NSArray<Queen_HIKeyChainResult *> *)JPBaoFu_loadAllInfoForService:(NSString *)serviceName resultType:(int)returnType {
    Queen_HIKeyChainService *service = [[Queen_HIKeyChainService alloc] init];
    service.serviceName = serviceName;
    service.synStrategies = synStrategiesType;
    return [service fetchAllInfo:returnType];
}
+ (NSArray<Queen_HIKeyChainResult *> *)JPBaoFu_loadInfoForService:(NSString *)serviceName account:(NSString *)account resultType:(int)returnType {
    Queen_HIKeyChainService *service = [[Queen_HIKeyChainService alloc] init];
    service.serviceName = serviceName;
    service.account = account;
    service.synStrategies = synStrategiesType;
    return [service fetchAllInfo:returnType];
}
#pragma mark - 删除数据
+ (BOOL)JPBaoFu_deleteAllInfoForService:(NSString *)serviceName {
    Queen_HIKeyChainService *service = [[Queen_HIKeyChainService alloc] init];
    service.serviceName = serviceName;
    return [service deleteAllInfo];
}
+ (BOOL)JPBaoFu_deleteInfoForService:(NSString *)serviceName account:(NSString *)account {
    Queen_HIKeyChainService *service = [[Queen_HIKeyChainService alloc] init];
    service.serviceName = serviceName;
    service.account = account;
    return [service deleteSpecialInfo];
}
+ (void)JPBaoFu_setSynStrategies:(JPBaoFu_YJSynStrategies)synStrategies {
    synStrategiesType = synStrategies;
}
+ (NSMutableDictionary *)JPBaoFu_P_CHGetKeychainQuery:(NSString *)service andAccount:(NSString *)account {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            account, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}
+ (id)Queen_HKeychainObjectForService:(NSString *)service andAccount:(NSString *)account {
    if (!account || account.length <= 0) {
        return nil;
    }
    NSMutableDictionary *keychainQuery = [self JPBaoFu_P_CHGetKeychainQuery:service andAccount:account];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    id ret = nil;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == errSecSuccess) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (BOOL)Queen_HKeychainSaveObject:(id)objectData forService:(NSString *)service andAccount:(NSString *)account {
    if (!account || account.length <= 0) {
        return NO;
    }
    NSMutableDictionary *keychainQuery = [self JPBaoFu_P_CHGetKeychainQuery:service andAccount:account];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:objectData] forKey:(id)kSecValueData];
    OSStatus saveState = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    return (saveState == errSecSuccess);
}
@end
