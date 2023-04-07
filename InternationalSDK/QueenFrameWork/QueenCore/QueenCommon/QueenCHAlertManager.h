#import <Foundation/Foundation.h>
#import "QueenYJAlertView.h"
@interface QueenCHAlertManager : NSObject
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id<QueenYAlerViewDelegate>)delegate tempData:(NSDictionary *)tempData buttonTitles:(NSString *)buttonTitles, ...;
@end
