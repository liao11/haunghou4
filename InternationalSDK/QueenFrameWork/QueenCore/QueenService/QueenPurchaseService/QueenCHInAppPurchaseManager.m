#import "QueenCHInAppPurchaseManager.h"
#import "QueenCHIApiRequest.h"
#import "QueenSDKMainApi.h"
#import "QueenCHIKeyChain.h"
#import <StoreKit/StoreKit.h>
#import <AdjustSdk/Adjust.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
@interface QueenCHInAppPurchaseManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) NSMutableDictionary *jpbf_purchaseOrderDict;
@property (nonatomic, assign) BOOL jpbf_is_geting_products;
@property (nonatomic, strong) NSMutableDictionary *code_1005_method_count_dic;
@end
@implementation QueenCHInAppPurchaseManager
+ (instancetype)sharedManager {
    static QueenCHInAppPurchaseManager *purchaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        purchaseManager = [[QueenCHInAppPurchaseManager alloc] init];
    });
    return purchaseManager;
}
- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (instancetype)init {
    self = [super init];
    if(self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.jpbf_is_geting_products = NO;
    }
    return self;
}
- (void)Queen_getPurchaseProduces:(BOOL)isPurchase {
    if([SKPaymentQueue canMakePayments]) {
        if ([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.productIdentifiers && [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.productIdentifiers.count > 0) {
            if (self.jpbf_is_geting_products == NO) {
                self.jpbf_is_geting_products = YES;
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.productIdentifiers];
                request.delegate = self;
                [request start];
            } else {
                JPBaoFu_YJLog(@"已经有一个获取商品的请求，不再发起。");
            }
        } else {
            JPBaoFu_RunInMainQueue(^{
                QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
                response.Queen_serviceCode = Queen_HServiceCodeApplePayNoGoods;
                response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
                response.JPBaoFu_msg = @"没有程序内付费商品可购买";
                if (isPurchase) {
                    [self jpbf_p_EndOfPurchase];
                    if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenPurchaseFinished:)]) {
                        [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenPurchaseFinished:response];
                    }
                } else {
                    if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenGetPriceOfProductsFinished:)]) {
                        [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenGetPriceOfProductsFinished:response];
                    }
                }
            });
        }
    } else {
        JPBaoFu_YJLog(@"您的手机没有打开程序内付费购买");
        JPBaoFu_RunInMainQueue(^{
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.Queen_serviceCode = Queen_HServiceCodeApplePayNotAblePayments;
            response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
            response.JPBaoFu_msg = @"您的手机没有打开程序内付费购买";
            if (isPurchase) {
                [self jpbf_p_EndOfPurchase];
                if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenPurchaseFinished:)]) {
                    [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenPurchaseFinished:response];
                }
            } else {
                if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenGetPriceOfProductsFinished:)]) {
                    [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenGetPriceOfProductsFinished:response];
                }
            }
        });
    }
}
- (void)Queen_RequestPurchaseProduct:(NSDictionary *)purchaseOrder {
    NSLog(@"请求的订单：%@",purchaseOrder);
    NSString *purchaseProductid = purchaseOrder[JPBaoFu_cPayConst_ApplePayProductId];
    if (!purchaseProductid || purchaseProductid.length <= 0) {
        NSString *msg = [NSString stringWithFormat:@"发起内购的参数有误，purchaseOrder：%@", purchaseOrder];
        QueenShowErrorToastt(msg)
        return;
    }
    if (self.jpbf_purchaseOrderDict == nil) {
        [[QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel setValuesForKeysWithDictionary:purchaseOrder];
        [[QueenSDKMainApi QueensharedInstance].qqgameInfo setValuesForKeysWithDictionary:purchaseOrder];
        self.jpbf_purchaseOrderDict = [NSMutableDictionary dictionaryWithDictionary:purchaseOrder];
        QueenCHIGlobalGame *gameInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel;
        Queen_HTJudgeCustomParameter(self.jpbf_purchaseOrderDict, gameInfo.CP_RoleID, JPBaoFu_cPayConst_CpRoleId)
        Queen_HTJudgeCustomParameter(self.jpbf_purchaseOrderDict, gameInfo.CP_RoleName, JPBaoFu_cPayConst_CpRoleName)
    } else {
        QueenShowErrorToastt(@"已有存在一个订单，未完成支付。")
        return;
    }
    NSLog(@"请求的订单self.jpbf_purchaseOrderDict：%@", self.jpbf_purchaseOrderDict);
    JPBaoFu_RunInMainQueue(^{
        QueenShowHUD
    });
    NSSet<NSString *> * productIdentifiers = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.productIdentifiers;
    if (productIdentifiers && [productIdentifiers containsObject:purchaseProductid] == NO) {
        NSMutableSet *new_set = [[NSMutableSet alloc] initWithSet:productIdentifiers];
        [new_set addObject:purchaseProductid];
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.productIdentifiers = new_set;
        [self Queen_getPurchaseProduces:YES];
    } else {
        if ([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.prices) {
            [self jpbf_p_GetProductAndStartPurchaseForCPOrder:self.jpbf_purchaseOrderDict];
        } else {
            [self Queen_getPurchaseProduces:YES];
        }
    }
}
- (void)Queen_recheckCachePurchaseOrderReceipts {
    NSArray *dictList = [self JPBaoFu_getAllSaveNoVerTransaction];
    if (dictList && dictList.count > 0) {
        for (NSDictionary *dict in dictList) {
            NSDictionary *order_dict = dict[@"orderDict"];
            NSString *receipt = dict[@"receipt"];
            NSString *appleOrderNO = dict[@"appleOrderNO"];
            JPBaoFu_YJLog(@"启动验证本地存在未完成的购买订单 %@", order_dict);
            if (order_dict && (receipt && receipt.length > 0)) {
                NSString *order_userid = order_dict[JPBaoFu_cPayConst_UserID];
                QueenCHIGlobalUser *userInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
                if ([order_userid isEqualToString:userInfo.userID]) {
                    [self jpbf_checkOrder:order_dict withReceipt:receipt addAppleOrderid:appleOrderNO flag:200 msg:nil];
                } else {
                    JPBaoFu_YJLog(@"下单用户：(%@)和验单用户:(%@)不一致，先不验此单。", order_userid, userInfo.userID);
                }
            }
        }
    }
    for (SKPaymentTransaction *transaction in [[SKPaymentQueue defaultQueue] transactions]) {
        JPBaoFu_YJLog(@"启动内购模块时队列中存在未完成的购买订单 transaction.payment.applicationUsername =%@,transaction.payment.productIdentifier=%@, transaction.transactionState=%ld, transaction.transactionIdentifier=%@",transaction.payment.applicationUsername,transaction.payment.productIdentifier, (long)transaction.transactionState, transaction.transactionIdentifier);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                [self jpbf_p_verifyReceiptWithTransaction:transaction flag:100];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored: {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            default:
                break;
        }
    }
}
#pragma mark - Private API
- (void)jpbf_p_EndOfPurchase {
    self.jpbf_purchaseOrderDict = nil;
    JPBaoFu_RunInMainQueue(^{
        JPBaoFu_HideHUD
    });
}
- (void)jpbf_p_GetProductAndStartPurchaseForCPOrder:(NSMutableDictionary *)purchaseOrderDict {
    NSLog(@"jpbf_p_GetProductAndStartPurchaseForCPOrder:%@",purchaseOrderDict);
    SKProduct *purchaseOrder_product = nil;
    NSString *purchase_productid = purchaseOrderDict[JPBaoFu_cPayConst_ApplePayProductId];
    
    NSArray *array =[QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.purchaseProduces;
    if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
        
        for (SKProduct *product in [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.purchaseProduces) {
            if ([purchase_productid isEqualToString:product.productIdentifier]) {
                Queen_HTJudgeCustomParameter(purchaseOrderDict, [product.priceLocale objectForKey:NSLocaleCurrencyCode], JPBaoFu_cPayConst_CurrencyType)
                Queen_HTJudgeCustomParameter(purchaseOrderDict, product.price, JPBaoFu_cPayConst_Price)
                purchaseOrder_product = product;
                break;
            }
        }
       
    }else{
        NSLog(@"myProduct");
    }
    
    if (purchaseOrder_product != nil) {
        [self jpbf_p_createPurchaseOrder:purchaseOrderDict withProduct:purchaseOrder_product];
    } else {
        JPBaoFu_RunInMainQueue(^{
            [self jpbf_p_EndOfPurchase];
            NSString *msg = [NSString stringWithFormat:@"không tồn tại hoặc lỗi ID：%@", purchase_productid];
            QueenShowErrorToastt(msg);
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.Queen_serviceCode = Queen_HServiceCodeApplePayNoGoods;
            response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
            response.JPBaoFu_msg = msg;
            if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenPurchaseFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenPurchaseFinished:response];
            }
        });
    }
}
- (void)jpbf_p_createPurchaseOrder:(NSMutableDictionary *)purchaseOrderDict withProduct:(SKProduct *)product {
    NSLog(@"获取订单号的:%@",purchaseOrderDict);
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    QueenCHIGlobalUser *userInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
    QueenCHIGlobalGame *gameInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel;
    Queen_HTJudgeParameter(userInfo.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeParameter(userInfo.userName, [QueenUtils qudecryptString:Queen_HUserName])
    Queen_HTJudgeParameter(userInfo.token, [QueenUtils qudecryptString:Queen_HToken])
    Queen_HTJudgeParameter(gameInfo.CH_ServerID, [QueenUtils qudecryptString:Queen_HServiceID])
    Queen_HTJudgeParameter(gameInfo.CH_RoleID, [QueenUtils qudecryptString:Queen_HRoleID])
    Queen_HTJudgeParameter(gameInfo.CP_RoleID, [QueenUtils qudecryptString:Queen_HCpRoleId])
    Queen_HTJudgeParameter(gameInfo.CP_RoleName, [QueenUtils qudecryptString:Queen_HCpRoleName])
    Queen_HTJudgeParameter(gameInfo.CP_RoleLevel, [QueenUtils qudecryptString:Queen_HCpRoleLevel])
    Queen_HTJudgeParameter(@"2", [QueenUtils qudecryptString:Queen_HPayType])
    Queen_HTJudgeParameter([UIDevice gainIDFA], [QueenUtils qudecryptString:Queen_HDeviceIDFA])
    Queen_HTJudgeParameter([QueenCHTHttpSigner JPBaoFu_deviceNO], [QueenUtils qudecryptString:Queen_HDeviceNO])
    Queen_HTJudgeParameter(purchaseOrderDict[JPBaoFu_cPayConst_CpOrderNo], [QueenUtils qudecryptString:Queen_HCpOrderNum])
    Queen_HTJudgeParameter(purchaseOrderDict[JPBaoFu_cPayConst_ApplePayProductId], [QueenUtils qudecryptString:Queen_HPayProductID])
    Queen_HTJudgeParameter(purchaseOrderDict[JPBaoFu_cPayConst_GameCurrency], [QueenUtils qudecryptString:Queen_HGameMoney])
    Queen_HTJudgeParameter(purchaseOrderDict[JPBaoFu_cPayConst_ProductName], [QueenUtils qudecryptString:Queen_HProductName])
    Queen_HTJudgeParameter(purchaseOrderDict[JPBaoFu_cPayConst_ExtraInfo], [QueenUtils qudecryptString:Queen_HPayExtra])
    Queen_HTJudgeParameter(purchaseOrderDict[JPBaoFu_cPayConst_Price], [QueenUtils qudecryptString:Queen_HRealPa])
    Queen_HTJudgeParameter(purchaseOrderDict[JPBaoFu_cPayConst_CurrencyType], [QueenUtils qudecryptString:Queen_HCurrencyty])
    [[QueenCHIApiRequest shareQueenCHIApiRequest] CreatCHOrderInfo:parameters success:^(QueenCHIResponseObject *response) {
        Queen_HTJudgeCustomParameter(purchaseOrderDict, response.Queen_result[@"sdk_orderno"], JPBaoFu_cPayConst_CHOrderNO)
        [self jpbf_p_hikeApplePurchaseOrder:purchaseOrderDict withProduct:product];
    } failure:^(QueenCHIResponseObject *response) {
        [self jpbf_p_EndOfPurchase];
        QueenShowErrorToastt(response.JPBaoFu_msg)
        if (response.Queen_serviceCode != Queen_HServiceCodeNetworkError) {
            response.Queen_serviceCode = Queen_HServiceCodeGenerateOrderError;
        }
        response.Queen_result = purchaseOrderDict;
        if ([[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenPurchaseFinished:)] && [QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && response.Queen_serviceCode != Queen_HServiceCodeUnknownCode) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenPurchaseFinished:response];
        }
    }];
}
- (void)jpbf_p_hikeApplePurchaseOrder:(NSMutableDictionary *)purchaseOrderDict withProduct:(SKProduct *)product {
    NSString *chOrderNO = purchaseOrderDict[JPBaoFu_cPayConst_CHOrderNO];
    if (!chOrderNO || [chOrderNO isKindOfClass:[NSString class]] == NO || chOrderNO.length <= 0) {
        JPBaoFu_RunInMainQueue(^{
            [self jpbf_p_EndOfPurchase];
            QueenShowErrorToastt(@"生成订单失败，订单号为空！");
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.Queen_serviceCode = Queen_HServiceCodeApplePayFailureError;
            response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
            response.JPBaoFu_msg = @"生成订单失败，订单号为空！";
            response.Queen_result = @{@"order" : purchaseOrderDict?:@""};
            if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenPurchaseFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenPurchaseFinished:response];
            }
        });
    } else {
        if (product == nil) {
            [self jpbf_p_EndOfPurchase];
            QueenShowErrorToastt(@"出鬼了参数在传递过程消失了");
            return;
        }
        QueenCHIGlobalUser *userInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
        Queen_HTJudgeCustomParameter(purchaseOrderDict, userInfo.userID, JPBaoFu_cPayConst_UserID)
        NSString *order_jsonString = [QueenCHHelper JPBaoFu_convertToJsonData:purchaseOrderDict];
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        payment.applicationUsername = order_jsonString;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [self JPBaoFu_SaveStartOrderToKeychain:purchaseOrderDict];
    }
}
- (void)jpbf_checkOrder:(NSDictionary *)orderDict withReceipt:(NSString *)receiptStr addAppleOrderid:(NSString *)appleOrderid flag:(NSInteger)flag msg:(NSString *)msg {
    JPBaoFu_YJLog(@"发起服务验证的购买订单 = %@,\n苹果交易id = %@,\n标识flag = %ld,\n凭证 = %@\n", orderDict, appleOrderid, (long)flag, receiptStr);
    if (!receiptStr || receiptStr.length <= 0) {
        if (flag == 0) {
            [self jpbf_p_EndOfPurchase];
        }
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.Queen_serviceCode = Queen_HServiceCodeApplePayReceiptInvalid;
        response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertPayFailureText);
        response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
        response.Queen_result = @{@"purchaseOrder": orderDict?:@""};
        if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenVerifyPurchaseOrderFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenVerifyPurchaseOrderFinished:response];
        }
        return;
    }
    NSString *orderNum = orderDict[JPBaoFu_cPayConst_CHOrderNO];
    if (!orderNum || orderNum.length <= 0) {
        if (flag == 0) {
            [self jpbf_p_EndOfPurchase];
        }
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.Queen_serviceCode = Queen_HServiceCodeApplePayReceiptInvalid;
        response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertPayFailureText);
        response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
        response.Queen_result = @{@"purchaseOrder": orderDict?:@""};
        if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenVerifyPurchaseOrderFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenVerifyPurchaseOrderFinished:response];
        }
        return;
    }
    QueenCHIGlobalUser * userInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    Queen_HTJudgeCustomParameter(params, userInfo.userID, [QueenUtils qudecryptString:Queen_HUId])
    Queen_HTJudgeCustomParameter(params, userInfo.token, [QueenUtils qudecryptString:Queen_HToken])
    Queen_HTJudgeCustomParameter(params, receiptStr, [QueenUtils qudecryptString:Queen_HProof])
    Queen_HTJudgeCustomParameter(params, orderNum, [QueenUtils qudecryptString:Queen_HOrderNum])
    Queen_HTJudgeCustomParameter(params, appleOrderid, [QueenUtils qudecryptString:Queen_HAppleOrderNum])
    if (msg) {
        NSString *str = [NSString stringWithFormat:@"%@  msg:%@", @(flag), msg];
        Queen_HTJudgeCustomParameter(params, str, @"flag")
    } else {
        Queen_HTJudgeCustomParameter(params, @(flag), @"flag")
    }
    
    
    [[QueenCHIApiRequest shareQueenCHIApiRequest] purchaseWithParameters:params success:^(QueenCHIResponseObject *response) {
        if (flag == 0) {
            [self jpbf_p_EndOfPurchase];
        }
        
        
        [self JPBaoFu_RemoveFinishOderFromKeychain:orderDict];
        if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenVerifyPurchaseOrderFinished:)]) {
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.Queen_serviceCode = Queen_HServiceCodeSuccess;
            response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertPayValidationSuccessText);
            response.Queen_result = @{@"purchaseOrder": orderDict?:@""};
            response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenVerifyPurchaseOrderFinished:response];
        }
    } failure:^(QueenCHIResponseObject *response) {
        if (flag == 0) {
            [self jpbf_p_EndOfPurchase];
        }
        
//        if(response.Queen_serviceCode == Queen_HServiceCodenetfail){
//                  //重新请求的方法
//            [self jpbf_checkOrder:orderDict withReceipt:receiptStr addAppleOrderid:appleOrderid flag:flag msg:msg];
//
//        }else{
            if (response.Queen_serviceCode != Queen_HServiceCodeNetworkError && response.Queen_serviceCode != Queen_HServiceCodeTokenFailureError && response.Queen_serviceCode != Queen_HServiceCodeTokenError && response.Queen_serviceCode != Queen_HServiceCodeReLoginError) {
                [self JPBaoFu_RemoveFinishOderFromKeychain:orderDict];
            }
            if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenVerifyPurchaseOrderFinished:)]) {
                response.Queen_result = @{@"purchaseOrder": orderDict?:@""};
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenVerifyPurchaseOrderFinished:response];
            }
//        }
       
    }];
}
- (void)jpbf_p_verifyReceiptWithTransaction:(SKPaymentTransaction *)transaction flag:(NSInteger)flag {
    NSString *base64_receipt = nil;
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if(receiptData){
        base64_receipt = [receiptData base64EncodedStringWithOptions:0];
    } else {
        JPBaoFu_YJLog(@"获取苹果凭据失败！");
    }
    NSDictionary *order_dict = nil;
    NSString *produceId = transaction.payment.productIdentifier;
    NSString *transactionId = transaction.transactionIdentifier;
    if (flag == 0) {
        NSString *order_productid = self.jpbf_purchaseOrderDict[JPBaoFu_cPayConst_ApplePayProductId];
        if (self.jpbf_purchaseOrderDict && self.jpbf_purchaseOrderDict.count > 0 && [order_productid isEqualToString:produceId]) {
            order_dict = self.jpbf_purchaseOrderDict;
        }
    }
    NSString *msg = nil;
    if (order_dict == nil) {
        NSString *order_json = transaction.payment.applicationUsername;
        if (order_json && order_json.length > 0) {
            order_dict = [QueenCHHelper JPBaoFu_dictionaryWithJsonString:order_json];
        }
        if (order_dict == nil) {
            order_dict = [self JPBaoFu_GetStartOrderFromKeychain:produceId];
            msg = [NSString stringWithFormat:@"透传失败，使用的是本地的，订单：%@, productid=%@\n",order_dict, produceId];
        }
    }
    [self JPBaoFu_SaveFinishOderToKeychain:order_dict wtihReceipt:base64_receipt andAppleOrderNO:transaction.transactionIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self JPBaoFu_RemoveStartOrderToKeychain:order_dict];
    double order_price = [order_dict[JPBaoFu_cPayConst_Price] doubleValue];
    if (order_price > 0) {
        NSString *currency_type = order_dict[JPBaoFu_cPayConst_CurrencyType]?:@"VND";
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventPurchase];
        [event setRevenue:order_price currency:currency_type];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:@"充值金额" parameters:@{kFIRParameterPrice : @(order_price), kFIRParameterCurrency : currency_type}];
        [self jpbf_p_SendAdjustARPUEvent:order_price currency:currency_type];
    }
    [self jpbf_checkOrder:order_dict withReceipt:base64_receipt addAppleOrderid:transactionId flag:flag msg:msg];
}
- (void)jpbf_p_SendAdjustARPUEvent:(double)price currency:(NSString *)currency {
    NSArray *arpu_level = @[@(2199000),@(1199000),@(709000),@(219000),@(109000)];
    if (currency) {
        if ([currency isEqualToString:@"USD"]) {
            arpu_level = @[@(99.99),@(49.99),@(29.99),@(9.99),@(4.99)];
        } else if ([currency isEqualToString:@"CNY"]) {
            arpu_level = @[@(648),@(348),@(208),@(68),@(30)];
        } else if ([currency isEqualToString:@"THB"]) {
            arpu_level = @[@(3000),@(1700),@(929),@(299),@(149)];
        }
    }
    if (price >= [arpu_level[0] doubleValue]) {
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventPurchaseARPU100];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:@"充值_99_99" parameters:nil];
    }
    if (price >= [arpu_level[1] doubleValue]) {
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventPurchaseARPU50];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:@"充值_49_99" parameters:nil];
    }
    if (price >= [arpu_level[2] doubleValue]) {
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventPurchaseARPU30];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:@"充值_29_99" parameters:nil];
    }
    if (price >= [arpu_level[3] doubleValue]) {
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventPurchaseARPU10];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:@"充值_9_99" parameters:nil];
    }
    if (price >= [arpu_level[4] doubleValue]) {
        ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventPurchaseARPU5];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:@"充值_4_99" parameters:nil];
    }
    ADJEvent *event = [ADJEvent eventWithEventToken:JPBaoFu_cEventPurchaseARPU1];
    [Adjust trackEvent:event];
    [FIRAnalytics logEventWithName:@"充值_0_99" parameters:nil];
}
#pragma mark - Orders data manager
- (NSString *)JPBaoFu_KeychainServiceOfStartOrder {
    return @"com.muugame.sdk1.startOrder_jsonstring";
}
- (NSString *)JPBaoFu_KeychainServiceOfFinishButNotVerifyOrder {
    return @"com.muugame.sdk1.purchaseOrder_receipt";
}
- (void)JPBaoFu_SaveStartOrderToKeychain:(NSDictionary *)order_dict {
    JPBaoFu_YJLog(@"保存发起支付的购买订单：%@", order_dict);
    if (order_dict) {
        NSString *productid = order_dict[JPBaoFu_cPayConst_ApplePayProductId];
        if (productid) {
            NSString *keychainServiceAndAccount = [self JPBaoFu_KeychainServiceOfStartOrder];
            NSDictionary *savedDict = [QueenCHIKeyChain Queen_HKeychainObjectForService:keychainServiceAndAccount andAccount:keychainServiceAndAccount];
            NSMutableDictionary *newDict = savedDict?[savedDict mutableCopy]:[[NSMutableDictionary alloc] init];
            [newDict setObject:order_dict forKey:productid];
            [QueenCHIKeyChain Queen_HKeychainSaveObject:newDict forService:keychainServiceAndAccount andAccount:keychainServiceAndAccount];
        } else {
            NSString *msg = [NSString stringWithFormat:@"保存失败发起支付订单计费的为空：%@", productid];
            QueenShowErrorToastt(msg)
        }
    } else {
        NSString *msg = [NSString stringWithFormat:@"保存失败发起支付订单为空：%@", order_dict];
        QueenShowErrorToastt(msg)
    }
}
- (void)JPBaoFu_RemoveStartOrderToKeychain:(NSDictionary *)order_dict {
    JPBaoFu_YJLog(@"移除发起支付的购买订单：%@", order_dict);
    if (order_dict) {
        NSString *productid = order_dict[JPBaoFu_cPayConst_ApplePayProductId];
        if (productid) {
            NSString *keychainServiceAndAccount = [self JPBaoFu_KeychainServiceOfStartOrder];
            NSDictionary *savedDict = [QueenCHIKeyChain Queen_HKeychainObjectForService:keychainServiceAndAccount andAccount:keychainServiceAndAccount];
            if (savedDict && savedDict.count > 0) {
                NSMutableDictionary *newDict = [savedDict mutableCopy];
                [newDict removeObjectForKey:productid];
                [QueenCHIKeyChain Queen_HKeychainSaveObject:newDict forService:keychainServiceAndAccount andAccount:keychainServiceAndAccount];
            }
        }
    }
}
- (NSDictionary *)JPBaoFu_GetStartOrderFromKeychain:(NSString *)productid {
    NSString *keychainServiceAndAccount = [self JPBaoFu_KeychainServiceOfStartOrder];
    NSDictionary *savedDict = [QueenCHIKeyChain Queen_HKeychainObjectForService:keychainServiceAndAccount andAccount:keychainServiceAndAccount];
    return [savedDict objectForKey:productid];
}
- (void)JPBaoFu_SaveFinishOderToKeychain:(NSDictionary *)order_dict wtihReceipt:(NSString *)receiptStr andAppleOrderNO:(NSString *)appleOrderNO {
    JPBaoFu_YJLog(@"保存到本地已完成支付的购买订单 = %@", order_dict);
    NSString *key = order_dict[JPBaoFu_cPayConst_CHOrderNO];
    NSString *order_userid = order_dict[JPBaoFu_cPayConst_UserID];
    if (key) {
        NSString *keychainService = [self JPBaoFu_KeychainServiceOfFinishButNotVerifyOrder];
        NSDictionary *savedDict = [QueenCHIKeyChain Queen_HKeychainObjectForService:keychainService andAccount:order_userid];
        JPBaoFu_YJLog(@"本地存储的购买订单 = %@", savedDict.allKeys);
        NSMutableDictionary *newDict = savedDict?[savedDict mutableCopy]:[[NSMutableDictionary alloc] init];
        [newDict setObject:@{@"orderDict": order_dict, @"receipt":receiptStr?:@"", @"appleOrderNO":appleOrderNO?:@""} forKey:key];
        JPBaoFu_YJLog(@"保存后本地存储的购买订单 = %@",newDict.allKeys);
        [QueenCHIKeyChain Queen_HKeychainSaveObject:newDict forService:keychainService andAccount:order_userid];
    } else {
        JPBaoFu_YJLog(@"购买订单号为空: %@，无法操作保存。", key);
    }
}
- (void)JPBaoFu_RemoveFinishOderFromKeychain:(NSDictionary *)order_dict {
    JPBaoFu_YJLog(@"移除本地存储的本地已完成支付的购买订单 = %@", order_dict);
    NSString *key = order_dict[JPBaoFu_cPayConst_CHOrderNO];
    NSString *order_userid = order_dict[JPBaoFu_cPayConst_UserID];
    if (key) {
        NSString *keychainService = [self JPBaoFu_KeychainServiceOfFinishButNotVerifyOrder];
        NSDictionary *savedDict = [QueenCHIKeyChain Queen_HKeychainObjectForService:keychainService andAccount:order_userid];
        JPBaoFu_YJLog(@"本地存储的购买订单 = %@", savedDict.allKeys);
        if (savedDict && savedDict.count > 0) {
            NSMutableDictionary *newDict = [savedDict mutableCopy];
            [newDict removeObjectForKey:key];
            JPBaoFu_YJLog(@"移除后本地存储的购买订单 = %@", newDict.allKeys);
            [QueenCHIKeyChain Queen_HKeychainSaveObject:newDict forService:keychainService andAccount:order_userid];
        }
    }
}
- (NSArray *)JPBaoFu_getAllSaveNoVerTransaction {
    QueenCHIGlobalUser * userInfo = [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel;
    NSDictionary *savedDict = [QueenCHIKeyChain Queen_HKeychainObjectForService:[self JPBaoFu_KeychainServiceOfFinishButNotVerifyOrder] andAccount:userInfo.userID];
    return savedDict.allValues;
}
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    JPBaoFu_YJLog(@"向苹果服务器请求产品结果 invalidProductIdentifiers:%@ 产品付费数量: %d",response.invalidProductIdentifiers, (int)myProduct.count);
    NSMutableArray *productsPrices = [[NSMutableArray alloc] initWithCapacity:myProduct.count];
    for(SKProduct *product in myProduct){
        JPBaoFu_YJLog(@"\n\n Product id: %@ \n 描述信息: %@ \n 产品标题: %@\n 产品描述信息: %@\n 价格: %@\n 货币类型: %@\n",
                   product.productIdentifier, product.description,
                   product.localizedTitle, product.localizedDescription,
                   product.price, [product.priceLocale objectForKey:NSLocaleCurrencyCode]);
        NSMutableDictionary *productInfo = [NSMutableDictionary dictionary];
        [productInfo setObject:product.price?:@"" forKey:JPBaoFu_cPayConst_Price];
        [productInfo setObject:[product.priceLocale objectForKey:NSLocaleCurrencyCode]?:@"" forKey:JPBaoFu_cPayConst_CurrencyType];
        [productInfo setObject:product.productIdentifier?:@"0" forKey:JPBaoFu_cPayConst_ApplePayProductId];
        [productsPrices addObject:productInfo];
    }
    [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.purchaseProduces = myProduct;
    self.jpbf_is_geting_products = NO;
    if (self.jpbf_purchaseOrderDict) {
        [self jpbf_p_GetProductAndStartPurchaseForCPOrder:self.jpbf_purchaseOrderDict];
    } else {
        JPBaoFu_RunInMainQueue(^{
            QueenCHIResponseObject *priceResponse = [[QueenCHIResponseObject alloc] init];
            priceResponse.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
            if (myProduct.count <= 0) {
                priceResponse.Queen_serviceCode = Queen_HServiceCodeGetPriceOfProductsFailure;
            }else {
                priceResponse.Queen_serviceCode = Queen_HServiceCodeSuccess;
                priceResponse.Queen_result = @{ @"prices" : productsPrices };
            }
            if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenGetPriceOfProductsFinished:)]) {
                [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenGetPriceOfProductsFinished:priceResponse];
            }
        });
    }
}
#pragma mark - SKRequestDelegate
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    JPBaoFu_YJLog(@"向苹果服务器请求产品失败 error=%@",error.localizedDescription);
    self.jpbf_is_geting_products = NO;
    JPBaoFu_RunInMainQueue(^{
        if (self.jpbf_purchaseOrderDict) {
            [self jpbf_p_EndOfPurchase];
            QueenShowErrorToastt(error.localizedDescription);
        }
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.Queen_serviceCode = Queen_HServiceCodeApplePayRequestFailure;
        response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
        response.Queen_result = @{
                            @"ErrorCode": [NSNumber numberWithInteger:error.code],
                            @"ErrorDescription":error.localizedDescription
                            };
        if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenGetPriceOfProductsFinished:)]) {
            [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenGetPriceOfProductsFinished:response];
        }
    });
}
- (void)requestDidFinish:(SKRequest *)request {
    self.jpbf_is_geting_products = NO;
}
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        JPBaoFu_YJLog(@"监听购买结果(paymentQueue) transactionState=%ld, transactionIdentifier=%@, 订单json = %@", (long)transaction.transactionState, transaction.transactionIdentifier, transaction.payment.applicationUsername);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                [self jpbf_p_verifyReceiptWithTransaction:transaction flag:0];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                JPBaoFu_RunInMainQueue(^{
                    [self jpbf_p_EndOfPurchase];
                    QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
                    response.Queen_responseStyle = Queen_HResponseStyleApplePayStyle;
                    response.Queen_result = [QueenCHHelper JPBaoFu_dictionaryWithJsonString:transaction.payment.applicationUsername];
                    if (transaction.error.code == SKErrorPaymentCancelled) {
                        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPayCancelText))
                        response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertPayCancelText);
                        response.Queen_serviceCode = Queen_HServiceCodeApplePayCancel;
                    } else {
                        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertPayFailureText))
                        response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertPayFailureText);
                        response.Queen_serviceCode = Queen_HServiceCodeApplePayFailureError;
                    }
                    if ([QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate && [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate respondsToSelector:@selector(QueenPurchaseFinished:)]) {
                        [[QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate QueenPurchaseFinished:response];
                    }
                });
            }
                break;
            case SKPaymentTransactionStateRestored: {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self jpbf_p_EndOfPurchase];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            default:
                break;
        }
    }
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        JPBaoFu_YJLog(@"移除购买队列 => transaction.payment.applicationUsername =%@,transaction.payment.productIdentifier=%@, transaction.transactionState=%ld, transaction.transactionIdentifier=%@",transaction.payment.applicationUsername,transaction.payment.productIdentifier, (long)transaction.transactionState, transaction.transactionIdentifier);
    }
}
@end
