#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, JPBaoFu_YJSynStrategies){
    JPBaoFu_YJSynStrategiesWhenUnlocked,
    JPBaoFu_YJSynStrategiesAfterFirstUnlock,
    JPBaoFu_YJSynStrategiesAlways,
    JPBaoFu_YJSynStrategiesWhenPasscodeSetThisDeviceOnly,
    JPBaoFu_YJSynStrategiesWhenUnlockedThisDeviceOnly,
    JPBaoFu_YJSynStrategiesAfterFirstUnlockThisDeviceOnly,
    JPBaoFu_YJSynStrategiesAlwaysThisDeviceOnly
};
#pragma mark - Queen_HIKeyChainResult
@interface Queen_HIKeyChainResult : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) id<NSCoding> codingData;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSDate *creatDate;
@property (nonatomic, copy) NSDate *finalModificationDate;
@end
#pragma mark - QueenCHIKeyChain
@interface QueenCHIKeyChain : NSObject
+ (void)JPBaoFu_setSynStrategies:(JPBaoFu_YJSynStrategies)synStrategies;
+ (BOOL)JPBaoFu_setPassword:(NSString *)password account:(NSString *)account forService:(NSString *)serviceName;
+ (BOOL)JPBaoFu_setComplexData:(id<NSCoding>)data account:(NSString *)account forService:(NSString *)serviceName;
+ (BOOL)JPBaoFu_setNormalData:(NSData *)data account:(NSString *)account forService:(NSString *)serviceName;
+ (NSArray<Queen_HIKeyChainResult *> *)JPBaoFu_loadAllInfoForService:(NSString *)serviceName resultType:(int)returnType;
+ (NSArray<Queen_HIKeyChainResult *> *)JPBaoFu_loadInfoForService:(NSString *)serviceName account:(NSString *)account resultType:(int)returnType;
+ (BOOL)JPBaoFu_deleteAllInfoForService:(NSString *)serviceName;
+ (BOOL)JPBaoFu_deleteInfoForService:(NSString *)serviceName account:(NSString *)account;
+ (id)Queen_HKeychainObjectForService:(NSString *)service andAccount:(NSString *)account;
+ (BOOL)Queen_HKeychainSaveObject:(id)value forService:(NSString *)service andAccount:(NSString *)account;
@end
