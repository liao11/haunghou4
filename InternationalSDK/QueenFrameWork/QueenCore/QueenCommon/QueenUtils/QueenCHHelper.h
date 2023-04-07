#import <Foundation/Foundation.h>
@interface QueenCHHelper : NSObject
+ (BOOL)JPBaoFu_isBlankString:(id)string;
+ (CGSize)JPBaoFu_sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;
+ (CGSize)JPBaoFu_sizeWithAttributedText:(NSMutableAttributedString *)text maxW:(CGFloat)maxW;
+ (CGSize)JPBaoFu_getTextSize:(NSString *)title textMaxSize:(CGSize)maxSize Font:(NSInteger)font;
+  (UIColor *)JPBaoFu_getColor:(NSString *)hexColor;
+ (UIColor *)JPBaoFu_colorWithHexString:(NSString *)stringToConver;
+ (BOOL)JPBaoFu_isMobile:(NSString*)mobileNumbel;
+ (BOOL)JPBaoFu_validateVerifycode:(NSString *)verifyCode;
+ (BOOL)JPBaoFu_judgePassWordLegal:(NSString *)text;
+ (BOOL)JPBaoFu_judgeAccountWordLegal:(NSString *)text;
+ (void)JPBaoFu_setCornerRadiusForView:(UIView *)view withCorner:(UIRectCorner)corner cornerRadius:(CGFloat)CornerRadius hasBorderLine:(BOOL)hasBorderLine borderLineColor:(UIColor *)borderLineColor borderLineWidth:(CGFloat)borderLineWidth;
+ (NSString *)JPBaoFu_convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)JPBaoFu_dictionaryWithJsonString:(NSString *)jsonString;
@end
