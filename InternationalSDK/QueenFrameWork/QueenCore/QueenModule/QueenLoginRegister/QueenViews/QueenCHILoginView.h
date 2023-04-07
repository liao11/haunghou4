#import <UIKit/UIKit.h>
@protocol Queen_HILoginViewDelegate <NSObject>
- (void)JPBaoFu_loginViewClickSignUpEvent;
- (void)JPBaoFu_loginViewClickAccountServiceEvent;
- (void)JPBaoFu_loginViewClickLogInEvent:(NSString *)account password:(NSString *)password;
- (void)JPBaoFu_loginViewClickFacebookEvent;
- (void)JPBaoFu_loginViewClickPlayAsGuestEvent;
- (void)JPBaoFu_loginViewClickCellDeletedEvent:(NSInteger)deleteIndex;
- (void)JPBaoFu_loginViewClickCellSelectedEvent:(NSInteger)deleteIndex;
- (void)JPBaoFu_loginViewClickProtoclBtnEvent;
- (void)JPBaoFu_loginViewClickSignInWithAppleEvent;
@end
@interface QueenCHILoginView : UIView
@property (nonatomic, strong) UITextField *JPBaoFu_accountField;
@property (nonatomic, weak) id<Queen_HILoginViewDelegate> delegate;
+ (instancetype)QueenshowLoginViewInContext:(UIView *)context data:(NSDictionary *)data;
- (void)JPBaoFu_hidHistoryTable;
- (void)Queen_refreshMainView;
- (void)Queen_refreshMainViewInfo:(NSDictionary *)recentData;
- (void)JPBaoFu_refreshHistoryTableInfo:(NSArray *)historyArr;
@end
