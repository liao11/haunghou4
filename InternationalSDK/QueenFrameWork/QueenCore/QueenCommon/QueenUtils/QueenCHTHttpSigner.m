#import "QueenCHTHttpSigner.h"
#import <CommonCrypto/CommonDigest.h>
#import "QueenBase64.h"
#import "QueenCHIDiskCashe.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#define KeyDeviceNumAccount @"www.sdk.com.deviceId.UUID"
@implementation QueenCHTHttpSigner
+ (NSString *)JPBaoFu_deviceNO {
    NSString *uid = [self JPBaoFu_localLoadCcaoHuaCFID];
    if (!uid || [uid isEqualToString:@""]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        uid = [NSString stringWithFormat:@"%@", uuidStr];
        [QueenCHIDiskCashe saveSampleInfomation:uid account:KeyDeviceNumAccount];
        CFRelease(uuidStr);
        CFRelease(uuid);
    }
    return uid;
}
#pragma mark - save or load info from local
+ (NSString *)JPBaoFu_localLoadCcaoHuaCFID {
    return [QueenCHIDiskCashe loadSomeSampleInfomation:KeyDeviceNumAccount];
}
#pragma mark - 生成MD5签名
+ (NSString *)JPBaoFu_md5SignWithParamter:(NSDictionary *)dic APPKey:(NSString *)appKey {
    NSMutableString * sign = [NSMutableString string];
    NSArray * allkeys = [dic allKeys];
    NSArray * sortKeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    for (int i = 0; i < allkeys.count; i++) {
        NSString * temp = [NSString stringWithFormat:@"%@=%@&",sortKeys[i],[dic objectForKey:sortKeys[i]]];
        [sign appendString:temp];
    }
    [sign deleteCharactersInRange:NSMakeRange(sign.length-1, 1)];
    [sign appendString:appKey];
    NSString * md5Sign = [self JPBaoFu_stringBy32BitMD5EncryptWithSting:sign];
    return md5Sign;
}
+ (NSMutableDictionary *)JPBaoFu_base64DataWithParameter:(NSDictionary *)dic {
    NSString * md5Sign = [self JPBaoFu_md5SignWithParamter:dic APPKey:[QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.gameExtra];
    [dic setValue:md5Sign forKey:[QueenUtils qudecryptString:Queen_HSign]];
    NSString * data = [self JPBaoFu_base64Encode:dic];
    NSMutableDictionary * signedParameter = [NSMutableDictionary dictionary];
    [signedParameter setObject:data forKey:@"data"];
    return signedParameter;
}
#pragma mark - md5 base64 加密算法
+ (NSString *)JPBaoFu_stringBy32BitMD5EncryptWithSting:(NSString *)source {
    const char *destination = [source UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(destination, (CC_LONG)strlen(destination), digest);
    __autoreleasing NSMutableString *result = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result uppercaseString];
}
+ (NSString *)JPBaoFu_base64Encode:(NSDictionary *)originDic {
    NSData * data = [NSJSONSerialization dataWithJSONObject:originDic options:0 error:nil];
    data = [QueenUtils quAES128operation:kCCEncrypt data:data key:JPBaoFu_cBase64ASE128Key iv:JPBaoFu_cBase64ASE128_iv];
    data = [QueenBase64 encodeData:data];
    NSString * encodedStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return encodedStr;
}
+ (NSDictionary *)JPBaoFu_decryptResponseObjectWithBase64ASE128:(NSData *)responseObject {
    if (!responseObject) {
        return nil;
    }
    NSData *responseData = responseObject;
    responseData = [QueenBase64 decodeData:responseData];
    responseData = [QueenUtils quAES128operation:kCCDecrypt data:responseData key:JPBaoFu_cBase64ASE128Key iv:JPBaoFu_cBase64ASE128_iv];
    NSDictionary *dataDict = nil;
    if (responseData) {
        dataDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    }
    return dataDict;
}
@end
