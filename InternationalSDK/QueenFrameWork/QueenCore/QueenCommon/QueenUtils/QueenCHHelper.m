#import "QueenCHHelper.h"
@implementation QueenCHHelper
+ (BOOL)JPBaoFu_isBlankString:(id)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]]) {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return YES;
        }
    }
    return NO;
}
+ (CGSize)JPBaoFu_sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    return  [text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}
+ (CGSize)JPBaoFu_sizeWithAttributedText:(NSMutableAttributedString *)text maxW:(CGFloat)maxW {
        return  [text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesFontLeading context:nil].size;
}
+ (CGSize)JPBaoFu_getTextSize:(NSString *)title textMaxSize:(CGSize)maxSize Font:(NSInteger)font{
    CGSize textSize = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return textSize;
}
+  (UIColor *)JPBaoFu_getColor:(NSString *)hexColor {
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
+ (UIColor *)JPBaoFu_colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return Queen_HTColorRGB(r, g, b);
}
+ (BOOL)JPBaoFu_isMobile:(NSString*)mobileNumbel{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNumbel];
}
+ (BOOL)JPBaoFu_validateVerifycode:(NSString *)verifyCode
{
    BOOL result = NO;
    NSString * regex = @"^[0-9]{4,6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:verifyCode];
    return result;
}
+ (BOOL)JPBaoFu_judgePassWordLegal:(NSString *)text {
    BOOL result = false;
    if ([text length] >= 6){
        NSString * regex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:text];
    }
    return result;
}
+ (BOOL)JPBaoFu_judgeAccountWordLegal:(NSString *)text {
    BOOL result = false;
    if ([text length] >= 6){
        NSString * regex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:text];
    }
    return result;
}
+ (void)JPBaoFu_setCornerRadiusForView:(UIView *)view withCorner:(UIRectCorner)corner cornerRadius:(CGFloat)CornerRadius hasBorderLine:(BOOL)hasBorderLine borderLineColor:(UIColor *)borderLineColor borderLineWidth:(CGFloat)borderLineWidth{
    UIBezierPath *radiusPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(CornerRadius, CornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = radiusPath.CGPath;
    if (hasBorderLine) {
        maskLayer.lineWidth = borderLineWidth;
        maskLayer.strokeColor = borderLineColor.CGColor;
    }
    view.layer.mask = maskLayer;
}
+ (NSString *)JPBaoFu_convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        JPBaoFu_YJDevLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
+ (NSDictionary *)JPBaoFu_dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        JPBaoFu_YJDevLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
