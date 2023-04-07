#import <Foundation/Foundation.h>
#import "Queen_HServiceCodeDefines.h"
@interface QueenCHIResponseObject : NSObject
@property (nonatomic, copy) NSString *JPBaoFu_msg;
@property (nonatomic, assign) Queen_HServiceCode Queen_serviceCode;
@property (nonatomic, strong) NSDictionary *Queen_result;
@property (nonatomic, assign) Queen_HResponseStyle Queen_responseStyle;
@end
