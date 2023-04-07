

#import "ViewController.h"
#import "CHTRoleOfInforView.h"
#import "QueenSDKHeader.h"
#define CHColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kMark(title) [NSString stringWithFormat:@"\n /****** %@ ******/\n",title]
@interface ViewController () <QueenSDKDelegates>
@property (weak, nonatomic) IBOutlet UIScrollView *backgroudView;
@property (nonatomic, strong) UITextField *levelField;
@property (nonatomic, strong) UITextField *versionField;
@property (nonatomic, strong) UITextView *verifyResult;
@property (nonatomic, strong) NSMutableArray<UIButton *> *btnArr;
@property (nonatomic, strong) NSArray *titleColorArr;
@property (nonatomic, strong) NSDictionary *callInfo;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.delegate = self;
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.context = self;
    [self initUI];
}

#pragma mark - QueenSDKDelegates
//初始化结束回调
- (void)QueenInitFinished:(QueenCHIResponseObject *)response {
    if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
        [self changeBtn1];
    }
    
    NSLog(@"======%@",response.Queen_result);
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"初始化"),response.JPBaoFu_msg,kMark(@"初始化")];
    [self chVerifyOrder:str];
}
//注册结束回调
- (void)QueenRegisterFinished:(QueenCHIResponseObject *)response {
    
    if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
        [self changeBtn2];
        NSLog(@"注册结束回调");
        NSLog(@"%@",[QueenSDKMainApi QueensharedInstance]. JPBaoFu_userInfo.userName);
        NSLog(@"%@",[QueenSDKMainApi QueensharedInstance]. JPBaoFu_userInfo.userID);
        NSLog(@"%@",[QueenSDKMainApi QueensharedInstance]. JPBaoFu_userInfo.token);
    }
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"注册"),response.JPBaoFu_msg,kMark(@"注册")];
    [self chVerifyOrder:str];
}
//登录结束回调
- (void)QueenLoginFinished:(QueenCHIResponseObject *)response {
    
    if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
        [self changeBtn3];
        NSLog(@"登录结束回调");
        NSLog(@"%@",[QueenSDKMainApi QueensharedInstance]. JPBaoFu_userInfo.userName);
        NSLog(@"%@",[QueenSDKMainApi QueensharedInstance]. JPBaoFu_userInfo.userID);
        NSLog(@"%@",[QueenSDKMainApi QueensharedInstance]. JPBaoFu_userInfo.token);
    }
   
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"登录"),response.JPBaoFu_msg,kMark(@"登录")];
    [self chVerifyOrder:str];
    
   
    
}


//进入游戏结束回调
- (void)QueenEnterGameFinished:(QueenCHIResponseObject *)response{
    
    if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
        [self changeBtn4];
    }
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"进入游戏"),response.JPBaoFu_msg,kMark(@"进入游戏")];
    [self chVerifyOrder:str];
}

//获取商品价格结束回调
- (void)QueenGetPriceOfProductsFinished:(QueenCHIResponseObject *)response {
    
    id result = nil;
    if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
        result = [response.Queen_result objectForKey:@"prices"];
    }else {
        result = @"获取商品价格失败";
    }
    NSString *str = [NSString stringWithFormat:@"%@Prices=%@ status=%ld%@",kMark(@"商品价格"),result,(long)response.Queen_serviceCode,kMark(@"商品价格")];
    [self chVerifyOrder:str];
}

//支付结束回调
- (void)QueenPurchaseFinished:(QueenCHIResponseObject *)response {
    NSString *result = nil;
    if (response.Queen_serviceCode == Queen_HServiceCodeAppleTryAgainLater) {
        result = @"之前相同金额的商品未能完成验证";
    }else {
        result = [self convertToJsonData:response.Queen_result];
    }
    if (response.Queen_result ==nil) {
       
    }else{
        NSString *str = [NSString stringWithFormat:@"%@国际订单号=%@,status=%ld\n%@%@",kMark(@"支付"),[response.Queen_result objectForKey:@"chOrderNO"],(long)response.Queen_serviceCode,result,kMark(@"支付")];
        [self chVerifyOrder:str];
    }
   
}

//订单验证结束回调
- (void)QueenVerifyPurchaseOrderFinished:(QueenCHIResponseObject *)response {
    
    NSString *result = [self convertToJsonData:response.Queen_result];
    
    NSString *str = [NSString stringWithFormat:@"%@国际订单号=%@,status=%ld\n%@%@",kMark(@"支付订单验证"),[response.Queen_result objectForKey:@"chOrderNO"],(long)response.Queen_serviceCode,result,kMark(@"支付订单验证")];
    [self chVerifyOrder:str];
}

//退出登录结束回调
- (void)QueenLogoutFinished:(QueenCHIResponseObject *)response {
    
    if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
        self.callInfo = nil;
        [self changeBtn5];
    }
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"退出登录"),response.JPBaoFu_msg,kMark(@"退出登录")];
    [self chVerifyOrder:str];
}
-(void)QueenDeleteFinished:(QueenCHIResponseObject *)response{
    
    if (response.Queen_serviceCode == Queen_HServiceCodeSuccess) {
        self.callInfo = nil;
        [self changeBtn5];
    }
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"删除账号"),response.JPBaoFu_msg,kMark(@"退删除账号")];
    [self chVerifyOrder:str];
    
   
}
//注册区服信息结束回调
- (void)QueenregisterServerInfoFinished:(QueenCHIResponseObject *)response {
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"注册区服信息"),response.JPBaoFu_msg,kMark(@"注册区服信息")];
    [self chVerifyOrder:str];
}

//角色等级提升结束回调
- (void)QueencommitGameRoleLevelFinished:(QueenCHIResponseObject *)response {
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",kMark(@"提升角色等级"),response.JPBaoFu_msg,kMark(@"提升角色等级")];
    [self chVerifyOrder:str];
}
#pragma mark - Click_Action
- (void)pushTo:(id)sender {
    
    UIButton* btn = sender;
    switch (btn.tag) {
        case 0: {
            //初始化SDK
            [QueenSDKMainApi QueensharedInstance].JPBaoFu_initialVersion = self.versionField.text;
            [QueenSDKMainApi QueeninitialSDK];
        }
            break;
        case 1: {
           //显示登录界面
            [QueenSDKMainApi QueenshowLoginView];
        }
            break;
        case 2: {
            //进入游戏
            NSDictionary *info = nil;
            if (self.callInfo) {
                info = @{
                         @"CP_ServerName" : @"爱莎丽雅",//cp服务器名
                         @"CP_ServerID" : @"000002",//Cp服务器ID
                         @"CP_RoleName" : [self.callInfo objectForKey:@"CP_RoleName"],//Cp角色名
                         @"CP_RoleID" : [self.callInfo objectForKey:@"CP_RoleID"],//Cp角色ID
                         @"CP_RoleLevel" : [self.callInfo objectForKey:@"CP_RoleLevel"]//角色等级
                         };
                
            }else {
                info = @{
                         @"CP_ServerName" : @"爱莎丽雅",
                         @"CP_ServerID" : @"000002",
                         @"CP_RoleName" : @"德玛西亚1",
                         @"CP_RoleID" : @"000005",
                         @"CP_RoleLevel" : @"7"
                         };
            }
            [QueenSDKMainApi QueenenterGameObtainInfo:info];
        }
            break;
        case 3: {
            //弹出创建角色
            CHTRoleOfInforView *view = [[[NSBundle mainBundle] loadNibNamed:@"CHTRoleOfInforView" owner:nil options:nil] lastObject];
            view.frame = self.view.bounds;
            [view setup];
            __weak typeof(self) weakSelf = self;
            view.callInfo = ^(NSDictionary *info) {
                weakSelf.callInfo = info;
            };
            [self.view addSubview:view];
        }
            break;
        case 4: {
            //发送支付请求
            NSInteger randomNum = arc4random() / 1000000;
            [QueenSDKMainApi QueensendRequestOfPayment:@{
                                              @"CP_OrderNo" : [NSString stringWithFormat:@"%ld", (long)randomNum],
                                              @"CP_ExtraInfo" : @"demo-测试充值-1",
                                              @"applePayProductId" : @"pay.empire.dqph.1",
                                              @"gameCurrency" : @"60",
                                              @"productName" : @"2600kc"
                                              }];
        }
            break;
        case 5: {
            //发送支付请求
            NSInteger randomNum = arc4random() / 1000000;
            [QueenSDKMainApi QueensendRequestOfPayment:@{
                                              @"CP_OrderNo" : [NSString stringWithFormat:@"%ld", (long)randomNum],
                                              @"CP_ExtraInfo" : @"demo-测试充值-2",
                                              @"applePayProductId" : @"pay.qytc.as.30",
                                              @"gameCurrency" : @"1200",
                                              @"productName" : @"400kc"
                                              }];
        }
            break;
        case 6: {
            //等级提升
            if (_levelField.text.length == 0) {
                [self chVerifyOrder:@"请输入正确的等级"];
                return;
            }
            [QueenSDKMainApi QueencommitGameRoleLevel:@{
                                             @"CP_RoleName" : [QueenSDKMainApi QueensharedInstance].qqgameInfo.CP_RoleName,
                                             @"CP_RoleLevel" : _levelField.text
                                             }];
        }
            break;
        case 7: {
            //退出登录
            [QueenSDKMainApi QueenlogoutOperation:NO];
        }
            break;
        case 8: {
            //获取商品价格
            [QueenSDKMainApi QueengetPriceOfProductsWithShowHUD:YES];
        }
            break;
        case 9: {
            //清理历史账号
            BOOL result = [QueenSDKMainApi QueenclearHistoryAccount];
            NSString *str = result?@"清除成功":@"清除失败或无历史账号";
            [self chVerifyOrder:str];
        }
            break;
        case 10: {
            //删除账号
           [QueenSDKMainApi QueenacdeleteAountOperation:NO];
           
        }
            break;
        case 11: {
            //删除账号
           [QueenSDKMainApi QueenacdeleteAountOperation:NO];
           
        }
            break;
        default:
            break;
    }
}

- (void)QueenregisterServerInfo {
    //创建角色
    [QueenSDKMainApi QueenregisterServerInfo:@{
                                    @"CP_ServerName" : @"爱莎丽雅",
                                    @"CP_ServerID" : @"000002"
                                    }];
}

#pragma mark - 初始化设置
- (void)initUI {
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSArray *titleArray =@[@"初始化",@"展示登录界面",@"进入游戏",@"创建角色",@"支付1",@"支付2",@"更新角色等级",@"退出登录",@"获取商品价格",@"清空历史账号",@"删除账号",@"删除账号"];
    self.titleColorArr = @[CHColorRGB(26    , 125, 133),CHColorRGB(24    ,123,187),CHColorRGB(92,43,84),CHColorRGB(26    , 125, 133),CHColorRGB(241,127,67),CHColorRGB(89,226,196),CHColorRGB(248,228,55),CHColorRGB(156,53,56),CHColorRGB(112,52,41),CHColorRGB(26    , 125, 133),CHColorRGB(241,127,67),CHColorRGB(241,127,67)];
    self.btnArr = [NSMutableArray array];
    for (int i = 0; i < titleArray.count + 2; i++) {
        CGFloat bW = (self.view.bounds.size.width - 15*3)/2;
        CGFloat bH = 50;
        CGFloat bX = 15 + i%2 * (bW + 15);
        CGFloat bY = i/2 * (15 + bH) + 100;
        
        if (i == titleArray.count) {
            self.levelField = [[UITextField alloc] initWithFrame:CGRectMake(bX, bY, bW, bH)];
            _levelField.placeholder = @"角色等级";
            _levelField.borderStyle = UITextBorderStyleRoundedRect;
            _levelField.backgroundColor = [UIColor whiteColor];
            _levelField.textColor = [UIColor blackColor];
            _levelField.keyboardType = UIKeyboardTypeNumberPad;
            _levelField.font = [UIFont systemFontOfSize:12];
            _levelField.layer.borderColor = CHColorRGB(98,154,198).CGColor;
            _levelField.layer.borderWidth = 0.5;
            [self.backgroudView addSubview:self.levelField];
        }else if (i == titleArray.count + 1) {
#warning the test case
            self.versionField = [[UITextField alloc] initWithFrame:CGRectMake(bX, bY, bW, bH)];
            _versionField.placeholder = @"初始化版本号";
            _versionField.borderStyle = UITextBorderStyleRoundedRect;
            _versionField.backgroundColor = [UIColor whiteColor];
            _versionField.textColor = [UIColor blackColor];
            _versionField.keyboardType = UIKeyboardTypeDecimalPad;
            _versionField.font = [UIFont systemFontOfSize:12];
            _versionField.layer.borderColor = CHColorRGB(98,154,198).CGColor;
            _versionField.layer.borderWidth = 0.5;
            [self.backgroudView addSubview:self.versionField];
        }else {
            UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(bX, bY,bW, bH)];
            btn.tag = i;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pushTo:) forControlEvents:UIControlEventTouchUpInside
             ];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            if (i == titleArray.count - 1 || i == 0) {
                [btn setBackgroundColor:_titleColorArr[i]];
            }else {
                [btn setBackgroundColor:[UIColor lightGrayColor]];
                btn.enabled = NO;
            }
            [self.backgroudView addSubview:btn];
            [self.btnArr addObject:btn];
        }
    }
    self.verifyResult = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.levelField.frame) + 15, self.view.bounds.size.width, 300)];
    _verifyResult.font = [UIFont systemFontOfSize:15];
    _verifyResult.textColor = [UIColor orangeColor];
    _verifyResult.layer.borderColor = CHColorRGB(98,154,198).CGColor;
    _verifyResult.layer.borderWidth = 0.5;
    [self.backgroudView addSubview:_verifyResult];
    
    self.backgroudView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(_verifyResult.frame));
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBorder)];
    [self.backgroudView addGestureRecognizer:tap];}

- (void)chVerifyOrder:(NSString *)str {
    _verifyResult.text = [NSString stringWithFormat:@"%@\n%@",_verifyResult.text,str];
    CGFloat offset = self.verifyResult.contentSize.height - self.verifyResult.frame.size.height;
    if (offset < 0) {
        offset = 0;
    }
    [_verifyResult setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (void)closeKeyBorder {
    [self.view endEditing:YES];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    
    if (dict ==nil) {
        return @"";
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changeBtn1 {
    [self.btnArr[0] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[0].enabled = NO;
    [self.btnArr[1] setBackgroundColor:self.titleColorArr[1]];
    self.btnArr[1].enabled = YES;
}

- (void)changeBtn2 {
    [self.btnArr[1] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[1].enabled = NO;
    [self.btnArr[7] setBackgroundColor:self.titleColorArr[7]];
    self.btnArr[7].enabled = YES;
    [self.btnArr[9] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[9].enabled = NO;
    [self.btnArr[2] setBackgroundColor:self.titleColorArr[2]];
    self.btnArr[2].enabled = YES;
    [self.btnArr[3] setBackgroundColor:self.titleColorArr[3]];
    self.btnArr[3].enabled = YES;
    [self.btnArr[6] setBackgroundColor:self.titleColorArr[6]];
    self.btnArr[6].enabled = YES;
}

- (void)changeBtn3 {
    [self.btnArr[1] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[1].enabled = NO;
    [self.btnArr[7] setBackgroundColor:self.titleColorArr[7]];
    self.btnArr[7].enabled = YES;
    [self.btnArr[9] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[9].enabled = NO;
    [self.btnArr[2] setBackgroundColor:self.titleColorArr[2]];
    self.btnArr[2].enabled = YES;
    [self.btnArr[3] setBackgroundColor:self.titleColorArr[3]];
    self.btnArr[3].enabled = YES;
    [self.btnArr[6] setBackgroundColor:self.titleColorArr[6]];
    self.btnArr[6].enabled = YES;
}

- (void)changeBtn4 {
    [self.btnArr[2] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[2].enabled = NO;
    [self.btnArr[3] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[3].enabled = NO;
    [self.btnArr[4] setBackgroundColor:self.titleColorArr[4]];
    self.btnArr[4].enabled = YES;
    [self.btnArr[5] setBackgroundColor:self.titleColorArr[5]];
    self.btnArr[5].enabled = YES;
    [self.btnArr[6] setBackgroundColor:self.titleColorArr[6]];
    self.btnArr[6].enabled = YES;
    [self.btnArr[8] setBackgroundColor:self.titleColorArr[8]];
    self.btnArr[8].enabled = YES;
}

- (void)changeBtn5 {
    [self.btnArr[2] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[2].enabled = NO;
    [self.btnArr[3] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[3].enabled = NO;
    [self.btnArr[4] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[4].enabled = NO;
    [self.btnArr[5] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[5].enabled = NO;
    [self.btnArr[6] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[6].enabled = NO;
    [self.btnArr[7] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[7].enabled = NO;
    [self.btnArr[8] setBackgroundColor:[UIColor lightGrayColor]];
    self.btnArr[8].enabled = NO;
    [self.btnArr[1] setBackgroundColor:self.titleColorArr[1]];
    self.btnArr[1].enabled = YES;
    [self.btnArr[9] setBackgroundColor:self.titleColorArr[8]];
    self.btnArr[9].enabled = YES;
}
@end
