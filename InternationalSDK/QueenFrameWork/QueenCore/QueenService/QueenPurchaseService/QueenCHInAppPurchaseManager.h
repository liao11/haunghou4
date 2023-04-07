#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface QueenCHInAppPurchaseManager : NSObject
+ (instancetype)sharedManager;
- (void)Queen_getPurchaseProduces:(BOOL)isPurchase;
- (void)Queen_RequestPurchaseProduct:(NSDictionary *)purchaseOrder;
- (void)Queen_recheckCachePurchaseOrderReceipts;
@end
NS_ASSUME_NONNULL_END
