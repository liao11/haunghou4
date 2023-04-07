#import <Foundation/Foundation.h>
@class QueenCHIGameInfo,QueenCHIUserInfo,QueenCHIResponseObject;
@protocol QueenSDKDelegates <NSObject>
- (void)QueenInitFinished:(QueenCHIResponseObject *)response;
- (void)QueenRegisterFinished:(QueenCHIResponseObject *)response;
- (void)QueenLoginFinished:(QueenCHIResponseObject *)response;
- (void)QueenEnterGameFinished:(QueenCHIResponseObject *)response;
- (void)QueenLogoutFinished:(QueenCHIResponseObject *)response;
- (void)QueenregisterServerInfoFinished:(QueenCHIResponseObject *)response;
- (void)QueencommitGameRoleLevelFinished:(QueenCHIResponseObject *)response;

- (void)QueenDeleteFinished:(QueenCHIResponseObject *)response;

- (void)QueenGetPriceOfProductsFinished:(QueenCHIResponseObject *)response;
- (void)QueenPurchaseFinished:(QueenCHIResponseObject *)response;
- (void)QueenVerifyPurchaseOrderFinished:(QueenCHIResponseObject *)response;




@end
@interface QueenConfigInfo : NSObject
@property (nonatomic, copy) NSString *gameID;
@property (nonatomic, copy) NSString *gameExtra;
@property (nonatomic, strong) UIViewController *context;
@property (nonatomic, weak) id<QueenSDKDelegates> delegate;
@property (nonatomic, copy) NSString *fbAppID;
@property (nonatomic, copy) NSString *adjustAppToken;
@property (nonatomic, copy) NSString *appleAppID;
@end


@interface QueenSDKMainApi : NSObject
@property (nonatomic, strong) QueenCHIGameInfo *qqgameInfo;
@property (nonatomic, strong) QueenCHIUserInfo *JPBaoFu_userInfo;
@property (nonatomic, strong) QueenConfigInfo *JPBaoFu_configInfo;
@property (nonatomic, copy) NSString *JPBaoFu_initialVersion;
+ (instancetype)QueensharedInstance;
+ (void)QueenOpenLog:(BOOL)isOpen;
+ (void)QueenlaunchSDKWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions isProductionEnvironment:(BOOL)isProductionEnvironment;
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;


+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;


+ (void)QueenactivateApp;
+ (void)QueeninitialSDK;
+ (void)QueenshowLoginView;
+ (void)QueenlogoutOperation:(BOOL)showAlertView;
+ (void)QueenenterGameObtainInfo:(NSDictionary *)gameInfo;
+ (void)QueengetPriceOfProductsWithShowHUD:(BOOL)showHUD;
+ (void)QueensendRequestOfPayment:(NSDictionary *)requestInfo;
+ (void)QueenregisterServerInfo:(NSDictionary *)serverInfo;
+ (void)QueencommitGameRoleLevel:(NSDictionary *)data;
+ (void)QueenfinishGameNewbieTask;
+ (BOOL)QueenclearHistoryAccount;

+ (void)QueenacdeleteAountOperation:(BOOL)showAlertView;
@end
