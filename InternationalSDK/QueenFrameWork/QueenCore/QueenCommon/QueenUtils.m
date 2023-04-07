#import "QueenUtils.h"
@implementation QueenUtils
+ (NSBundle *)qumainBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:QueenSDKResourceBundleName ofType:@"bundle"]];
    }
    return refreshBundle;
}
+ (NSString *)qulocalizedStringForKey:(NSString *)key {
    NSBundle *bundle = [NSBundle bundleWithPath:[[self qumainBundle] pathForResource:@"en" ofType:@"lproj"]];
    return [bundle localizedStringForKey:key value:nil table:nil];
}
+ (UIImage *)quImageWithName:(NSString *)name {
    if (!name || name.length <= 0) {
        return nil;
    }
    NSString * queryString = [NSString stringWithFormat:@"%@.bundle/%@@2x",QueenSDKResourceBundleName,name];
    NSString * path = [[NSBundle mainBundle] pathForResource:queryString ofType:@".png"];
    UIImage * image = [UIImage imageNamed:path];
    if (image == nil) {
        image = [[UIImage alloc]initWithContentsOfFile:path];
    }
    if (image == nil) {
        NSString * queryString = [NSString stringWithFormat:@"%@.bundle/%@",QueenSDKResourceBundleName,name];
        NSString * path = [[NSBundle mainBundle] pathForResource:queryString ofType:@".png"];
        image = [UIImage imageNamed:path];
    }
    return image;
}
+ (NSString *)qutimeStamp {
    return [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970]];
}
+ (NSString *)qudecryptString:(NSString *)ostring {
    if (!ostring || ostring.length <= 0) {
        return @"";
    }
    unichar res[ostring.length];
    const unichar *buffer = res;
    for (int i = 0; i < ostring.length; i++) {
        unsigned char f = [ostring characterAtIndex:i] - 1;
        res[i] = f;
    }
    return [NSString stringWithCharacters:buffer length:ostring.length];
}
+ (NSData *)quAES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
        NSLog(@"Error");
    }
    free(buffer);
    return nil;
}
@end
