#import "QueenCHITimerDataService.h"
#import "QueenCHIApiRequest.h"
#import "QueenSDKMainApi.h"
#import "QueenCHIUserInfo.h"
@interface QueenCHITimerDataService ()
@property (nonatomic, strong) NSDate  *JPBaoFu_heartStartDate;
@property (nonatomic, strong) NSTimer *JPBaoFu_heartTimer;
@property (nonatomic, strong) NSTimer *JPBaoFu_refreshTimer;
@end
@implementation QueenCHITimerDataService
#pragma mark - Token刷新
- (void)Queen_refreshToken {
    [self.JPBaoFu_refreshTimer invalidate];
    self.JPBaoFu_refreshTimer = nil;
    self.JPBaoFu_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5*60 target:[QueenCHWeakProxy proxyWithTarget:self] selector:@selector(LXMM_refreshTokenOperation_SGBY) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.JPBaoFu_refreshTimer forMode:NSRunLoopCommonModes];
}
- (void)LXMM_refreshTokenOperation_SGBY {
    [[QueenCHIApiRequest shareQueenCHIApiRequest] refreshTokenSuccess:^(QueenCHIResponseObject *response) {
        JPBaoFu_YJDevLog(@"ch_token刷新成功");
        [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token = [response.Queen_result objectForKey:@"token"];
        [QueenSDKMainApi QueensharedInstance].JPBaoFu_userInfo.token = [response.Queen_result objectForKey:@"token"];
    } failure:nil];
}
#pragma mark - 心跳
- (void)Queen_startGameHeart {
    self.JPBaoFu_heartStartDate = [NSDate date];
    [self.JPBaoFu_heartTimer invalidate];
    self.JPBaoFu_heartTimer = nil;
    self.JPBaoFu_heartTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:[QueenCHWeakProxy proxyWithTarget:self] selector:@selector(LXMM_earlyLaunchGameHeart_SGBY) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.JPBaoFu_heartTimer forMode:NSRunLoopCommonModes];
    [self.JPBaoFu_heartTimer fire];
}
- (void)LXMM_earlyLaunchGameHeart_SGBY {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:type fromDate:self.JPBaoFu_heartStartDate toDate:[NSDate date] options:0];
    if (cmps.minute > 5) {
        [self.JPBaoFu_heartTimer invalidate];
        self.JPBaoFu_heartTimer = nil;
        self.JPBaoFu_heartTimer = [NSTimer scheduledTimerWithTimeInterval:5*60 target:[QueenCHWeakProxy proxyWithTarget:self] selector:@selector(LXMM_launchGameHeart_SGBY) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.JPBaoFu_heartTimer forMode:NSRunLoopCommonModes];
        [self.JPBaoFu_heartTimer fire];
    } else {
        [self LXMM_launchGameHeart_SGBY];
    }
}
- (void)LXMM_launchGameHeart_SGBY {
    [[QueenCHIApiRequest shareQueenCHIApiRequest] commitGameHeartInfoSuccess:^(QueenCHIResponseObject *response) {
        JPBaoFu_YJLog(@"ch_CAOHUA SDK: sent information to server, status = %ld",(long)response.Queen_serviceCode);
    } failure:^(QueenCHIResponseObject *response) {
        JPBaoFu_YJLog(@"ch_CAOHUA SDK: sent information to server, status = %ld",(long)response.Queen_serviceCode);
    }];
}
- (void)dealloc {
    [self.JPBaoFu_refreshTimer invalidate];
    self.JPBaoFu_refreshTimer = nil;
    [self.JPBaoFu_heartTimer invalidate];
    self.JPBaoFu_heartTimer = nil;
}
@end
