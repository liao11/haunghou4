#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#define QueenSDKResourceBundleName   @"QueenBundle"
NS_ASSUME_NONNULL_BEGIN
@interface QueenUtils : NSObject
+ (NSString *)qulocalizedStringForKey:(NSString *)key;
+ (UIImage *)quImageWithName:(NSString *)name;
+ (NSString *)qutimeStamp;
+ (NSString *)qudecryptString:(NSString *)ostring;
+ (NSData *)quAES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv;
@end
NS_ASSUME_NONNULL_END
