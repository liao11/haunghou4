#import <Foundation/Foundation.h>
@interface QueenCHIDiskCashe : NSObject
+ (void)saveUserInformation:(QueenCHIGlobalUser *)userInfo;
+ (void)saveSampleInfomation:(NSString *)infomation account:(NSString *)account;
+ (NSString *)loadSomeSampleInfomation:(NSString *)infomation;
+ (NSArray *)loadAllHistoryAccountInformation;
+ (NSArray *)loadCHHistoryAccountInformation;
+ (QueenCHIGlobalUser *)obtainUserInfoFromHistory:(NSString *)userName;
+ (BOOL)deleteCureentUserInformation:(NSString *)account;
+ (BOOL)deleteAllHistoryAccountInfomation;
@end
