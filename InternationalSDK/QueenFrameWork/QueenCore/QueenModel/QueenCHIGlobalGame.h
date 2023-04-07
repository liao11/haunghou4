#import <Foundation/Foundation.h>
@interface QueenCHIGlobalGame : NSObject
@property (nonatomic, copy) NSString *gameID;
@property (nonatomic, copy) NSString *gameExtra;
@property (nonatomic, copy) NSString *CP_RoleID;
@property (nonatomic, copy) NSString *CP_RoleName;
@property (nonatomic, copy) NSString *CP_ServerID;
@property (nonatomic, copy) NSString *CP_ServerName;
@property (nonatomic, copy) NSString *CP_RoleLevel;
@property (nonatomic, copy) NSString *CH_RoleID;
@property (nonatomic, copy) NSString *CH_ServerID;
@property (nonatomic, copy) NSString *session_id;
@property (nonatomic, copy) NSString *CP_OrderNo;
@property (nonatomic, copy) NSString *CP_ExtraInfo;
@property (nonatomic, copy) NSString *applePayProductId;
@property (nonatomic, copy) NSString *gameCurrency;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *CH_OrderNO;
@property (nonatomic, strong) NSSet<NSString *> * productIdentifiers;
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) NSArray *purchaseProduces;
@end
