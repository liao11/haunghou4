#import <UIKit/UIKit.h>
typedef void(^VerCodeImageBlock)(NSString *codeStr);
@interface QueenVerCodeImageView : UIView
@property (nonatomic, strong) NSString *imageCodeStr;
@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, copy) VerCodeImageBlock bolck;
-(void)freshVerCode;
@end
