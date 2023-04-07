#import <Foundation/Foundation.h>
@interface QueenCHTHttpSigner : NSObject
+ (NSString *)JPBaoFu_deviceNO;
+ (NSMutableDictionary *)JPBaoFu_base64DataWithParameter:(NSDictionary *)dic;
+ (NSString *)JPBaoFu_stringBy32BitMD5EncryptWithSting:(NSString *)source;
+ (NSDictionary *)JPBaoFu_decryptResponseObjectWithBase64ASE128:(NSData *)responseObject;
@end
