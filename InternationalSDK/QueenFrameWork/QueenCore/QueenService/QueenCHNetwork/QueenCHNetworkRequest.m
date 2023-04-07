#import "QueenCHNetworkRequest.h"
#import "AFNetworking.h"
#import "QueenCHTHttpSigner.h"
#import "QueenCHIResponseObject.h"
#import "QueenCHIApiRequest.h"
#import "QueenSDKMainApi.h"
#import "QueenCHIUserInfo.h"
#import <AdjustSdk/Adjust.h>
@interface QueenCHNetworkRequest ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *code_1005_method_count_dic;
@end
@implementation QueenCHNetworkRequest
- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"application/xml",@"application/xhtml+xml",@"text/xml",@"*/*", nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:YES];
        _manager.securityPolicy = securityPolicy;
    }
    return self;
}
#pragma mark - Base_Post_Request
- (void)QueenSendRequestWithURLExtend:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary *originParameter = [[self JPBaoFu_parametersOfTheFilter:parameters requestURL:URL] mutableCopy];
    NSMutableDictionary * signedParameter = [QueenCHTHttpSigner JPBaoFu_base64DataWithParameter:originParameter];

    NSString *method= [URL stringByReplacingOccurrencesOfString:JPBaoFu_cBaseTestUrl withString:@""];
    
    [_manager POST:URL parameters:signedParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [QueenCHTHttpSigner JPBaoFu_decryptResponseObjectWithBase64ASE128:responseObject];
//        JPBaoFu_YJLog(@"请求的URL = %@, params=%@, responseObject=%@\n", URL, originParameter, responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *message = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        NSDictionary *data = [responseObject objectForKey:@"data"];
        Queen_HServiceCode serviceCode = [self matQueen_HServiceCode:code];
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.JPBaoFu_msg = message;
        response.Queen_serviceCode = serviceCode;
        response.Queen_result = data;
        if (serviceCode == Queen_HServiceCodeSuccess) {
            if (success) {
                success(response);
            }
        } else if ((serviceCode == Queen_HServiceCodeTokenError || serviceCode == Queen_HServiceCodeTokenFailureError)) {
            [self JPBaoFu_refreshNewTokenWithOriginUrl:URL parameter:originParameter success:success failure:failure];
        } else {
            if (failure) {
                failure(response);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == -1005) {
                    
                    NSLog(@"等待5S将重新请求任务");
                   //这是定义的一个字典，用来记录请求错误的的接口名以及错误的次数
                    self.code_1005_method_count_dic = [[NSMutableDictionary alloc] init];
                    [self.code_1005_method_count_dic setObject:@(1) forKey:method];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                        dispatch_group_t downloadGroup = dispatch_group_create();
                        dispatch_group_enter(downloadGroup);
                        dispatch_group_wait(downloadGroup, dispatch_time(DISPATCH_TIME_NOW, 5000000000)); // Wait 5 seconds before trying again.
                        dispatch_group_leave(downloadGroup);
                        dispatch_async(dispatch_get_main_queue(), ^{
                           //重新请求的方法
                            
                            [self re_QueenSendRequestWithURLExtend:URL parameters:parameters success:^(QueenCHIResponseObject *response) {
                                
                                if (success) {
                                    success(response);
                                }
                                
                                                            
                                                        } failure:^(QueenCHIResponseObject *response) {
                                                            
                                                            if (failure) {
                                                                failure(response);
                                                            }
                                                            
                                                            
                                                        }];
                           
                        });
                    });
                    
                }
                else
                {
                    QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
                    response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertNetworkErrorText);
                    response.Queen_serviceCode = Queen_HServiceCodeNetworkError;
                    response.Queen_result = nil;
                   
                    if (error.code == -1005) {
                        NSLog(@"1005===失败");
//                        response.Queen_serviceCode=Queen_HServiceCodenetfail;
                    }
                    if (failure) {
                        failure(response);
                    }
                }
                
        
        
        
        
        
       
    }];
}

- (void)re_QueenSendRequestWithURLExtend:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    NSMutableDictionary *originParameter = [[self JPBaoFu_parametersOfTheFilter:parameters requestURL:URL] mutableCopy];
    NSMutableDictionary * signedParameter = [QueenCHTHttpSigner JPBaoFu_base64DataWithParameter:originParameter];
    
    NSString *method= [URL stringByReplacingOccurrencesOfString:JPBaoFu_cBaseTestUrl withString:@""];
       int recount =  [self.code_1005_method_count_dic[method] intValue];
       recount++;
       [self.code_1005_method_count_dic setObject:@(recount) forKey:method];
    
    
    [_manager POST:URL parameters:signedParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [QueenCHTHttpSigner JPBaoFu_decryptResponseObjectWithBase64ASE128:responseObject];
//        JPBaoFu_YJLog(@"请求的URL = %@, params=%@, responseObject=%@\n", URL, originParameter, responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *message = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        NSDictionary *data = [responseObject objectForKey:@"data"];
        Queen_HServiceCode serviceCode = [self matQueen_HServiceCode:code];
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.JPBaoFu_msg = message;
        response.Queen_serviceCode = serviceCode;
        response.Queen_result = data;
        if (serviceCode == Queen_HServiceCodeSuccess) {
            if (success) {
                success(response);
            }
        } else if ((serviceCode == Queen_HServiceCodeTokenError || serviceCode == Queen_HServiceCodeTokenFailureError)) {
            [self JPBaoFu_refreshNewTokenWithOriginUrl:URL parameter:originParameter success:success failure:failure];
        } else {
            if (failure) {
                failure(response);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == -1005) {
                       int count =  [self.code_1005_method_count_dic[method] intValue];
                     if (count >= 5) {
                         
                         QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
                         response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertNetworkErrorText);
                         response.Queen_serviceCode = Queen_HServiceCodeNetworkError;
                         response.Queen_result = nil;
                         if (failure) {
                             failure(response);
                         }
                        
                         return ;
                     }
                     else
                     {
                         
                         [self re_QueenSendRequestWithURLExtend:URL parameters:parameters success:^(QueenCHIResponseObject *response) {
                             
                             if (success) {
                                 success(response);
                             }
                             
                                                         
                                                     } failure:^(QueenCHIResponseObject *response) {
                                                         
                                                         if (failure) {
                                                             failure(response);
                                                         }
                                                         
                                                         
                                                     }];
                        
                         
                         //return ;
                     }
            
            
            
        }else{
            QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
            response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertNetworkErrorText);
            response.Queen_serviceCode = Queen_HServiceCodeNetworkError;
            response.Queen_result = nil;
            if (failure) {
                failure(response);
            }
        }
       
    }];
}



- (void)JPBaoFu_refreshNewTokenWithOriginUrl:(NSString *)originUrl parameter:(NSDictionary *)parameter success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure
{
    NSMutableDictionary *originParameter = [parameter mutableCopy];
    [originParameter removeObjectForKey:[QueenUtils qudecryptString:Queen_HSign]];
    JPBaoFu_YJDevLog(@"ch_刷新前的待签名参数%@",parameter);
    [[QueenCHIApiRequest shareQueenCHIApiRequest] refreshTokenSuccess:^(QueenCHIResponseObject *response) {
        if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
            NSString * token = [response.Queen_result objectForKey:@"token"];
            JPBaoFu_YJDevLog(@"ch_新的令牌%@",token);
            [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_userModel.token = token;
            [QueenSDKMainApi QueensharedInstance].JPBaoFu_userInfo.token = token;
            [originParameter setValue:token forKey:[QueenUtils qudecryptString:Queen_HToken]];
            [self QueenSendRequestWithURLExtend:originUrl parameters:originParameter success:success failure:^(QueenCHIResponseObject *response) {
                response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertNetworkReLoginText);
                response.Queen_serviceCode = Queen_HServiceCodeReLoginError;
                response.Queen_result = nil;
                if (failure) {
                    failure(response);
                }
            }];
        }else {
            if (failure) {
                failure(response);
            }
        }
    } failure:^(QueenCHIResponseObject *response) {
        response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertNetworkReLoginText);;
        response.Queen_serviceCode = Queen_HServiceCodeReLoginError;
        response.Queen_result = nil;
        if (failure) {
            failure(response);
        }
    }];
}
- (void)QueenNoExtraSendRequestWithURLExtend:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(QueenRequestCompletionBlock)success failure:(QueenRequestCompletionBlock)failure {
    [_manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\n~~~~noExtra返回的结果  responseObject =%@",responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *message = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        NSDictionary *data = [responseObject objectForKey:@"data"];
        Queen_HServiceCode serviceCode = [self matQueen_HServiceCode:code];
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.JPBaoFu_msg = message;
        response.Queen_serviceCode = serviceCode;
        response.Queen_result = data;
        if (serviceCode == Queen_HServiceCodeSuccess) {
            if (success) {
                success(response);
            }
        }else {
            if (failure) {
                failure(response);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QueenCHIResponseObject *response = [[QueenCHIResponseObject alloc] init];
        response.JPBaoFu_msg = Queen_HLocalizedString(Queen_HIAlertNetworkReLoginText);;
        response.Queen_serviceCode = Queen_HServiceCodeReLoginError;
        response.Queen_result = nil;
        if (failure) {
            failure(response);
        }
    }];
}
#pragma mark - Private Func 
- (NSMutableDictionary *)JPBaoFu_parametersOfTheFilter:(NSMutableDictionary *)originParameters requestURL:(NSString *)requestURL {
    Queen_HTJudgeCustomParameter(originParameters, [QueenUtils qutimeStamp], [QueenUtils qudecryptString:Queen_HTimeStamp])
    Queen_HTJudgeCustomParameter(originParameters, JPBaoFu_cSdkVersion, [QueenUtils qudecryptString:Queen_HSDKVersion])
    Queen_HTJudgeCustomParameter(originParameters, [QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_gameModel.gameID, [QueenUtils qudecryptString:Queen_HGameId])
    Queen_HTJudgeCustomParameter(originParameters, @"2", @"pf")
    Queen_HTJudgeCustomParameter(originParameters,[UIDevice obtainChannel], [QueenUtils qudecryptString:Queen_HChannel])
    Queen_HTJudgeCustomParameter(originParameters,[UIDevice obtainSubChannel], [QueenUtils qudecryptString:Queen_HSubChannel])
    Queen_HTJudgeCustomParameter(originParameters,Adjust.idfa, @"idfa")
    return originParameters;
}
- (Queen_HServiceCode)matQueen_HServiceCode:(NSInteger)code{
    Queen_HServiceCode serviceCode = code;
    return serviceCode;
}
@end
