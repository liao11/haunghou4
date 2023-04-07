#import <Foundation/Foundation.h>
#import "QueenCHTHttpSigner.h"
@class QueenCHIResponseObject;
typedef void(^QueenRequestCompletionBlock)(QueenCHIResponseObject *response);
@interface QueenCHNetworkRequest : NSObject
- (void)QueenSendRequestWithURLExtend:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
- (void)QueenNoExtraSendRequestWithURLExtend:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure;
@end
