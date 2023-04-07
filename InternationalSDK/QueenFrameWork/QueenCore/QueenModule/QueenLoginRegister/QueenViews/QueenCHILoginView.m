#import "QueenCHILoginView.h"
#import "QueenCHAlertManager.h"
#import <AuthenticationServices/AuthenticationServices.h>
@interface Queen_HIHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel *JPBaoFu_accountLabel;
@property (nonatomic, strong) UIButton *JPBaoFu_deleteBtn;
@property (nonatomic, copy) void(^JPBaoFu_deleteCallback)(void);
@property (nonatomic, copy) void(^JPBaoFu_selectedCallback)(void);
+ (Queen_HIHistoryCell *)JPBaoFu_obtainCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;
@end
@implementation Queen_HIHistoryCell
+ (Queen_HIHistoryCell *)JPBaoFu_obtainCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    Queen_HIHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[Queen_HIHistoryCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
        cell.contentView.backgroundColor = Queen_HILucencyWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(JPBaoFu_selectAccount:)];
        [cell.contentView addGestureRecognizer:tap];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self JPBaoFu_setupViews];
        [self JPBaoFu_displayViews];
    }
    return self;
}
- (void)JPBaoFu_setupViews {
    self.JPBaoFu_accountLabel = [UILabel new];
    _JPBaoFu_accountLabel.font = Queen_HTBoldSmallFont;
    _JPBaoFu_accountLabel.textColor = Queen_HIDarkBlackColor;
    [self.contentView addSubview:_JPBaoFu_accountLabel];
    self.JPBaoFu_deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_deleteBtn setImage:[QueenUtils quImageWithName:@"btn_close"] forState:(UIControlStateNormal)];
    [_JPBaoFu_deleteBtn addTarget:self action:@selector(JPBaoFu_deleteHistoryAccount) forControlEvents:(UIControlEventTouchUpInside)];
    _JPBaoFu_deleteBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_JPBaoFu_deleteBtn];
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.contentView).offset(2*Queen_HMargin);
    }];
    [self.JPBaoFu_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(weakSelf.contentView);
        make.width.and.height.mas_equalTo(weakSelf.contentView.height);
    }];
    [self.JPBaoFu_deleteBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.JPBaoFu_deleteBtn);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}
- (void)JPBaoFu_deleteHistoryAccount {
    if (self.JPBaoFu_deleteCallback) {
        self.JPBaoFu_deleteCallback();
    }
}
- (void)JPBaoFu_selectAccount:(UITapGestureRecognizer *)recognizer {
    CGPoint fingerLocation =  [recognizer locationInView:self.contentView];
    if (fingerLocation.x < self.contentView.width - self.contentView.height) {
        if (self.JPBaoFu_selectedCallback) {
            self.JPBaoFu_selectedCallback();
        }
    }
}
@end
CGFloat const JPBaoFu_LoginViewsuitableW = 340;
@interface QueenCHILoginView ()  <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,QueenYAlerViewDelegate>
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) NSMutableDictionary *JPBaoFu_data;
@property (nonatomic, strong) UILabel *JPBaoFu_navTitle;
@property (nonatomic, strong) UIView *JPBaoFu_splitLine;
@property (nonatomic, strong) UIView *JPBaoFu_dividingLine1;
@property (nonatomic, strong) UIView *JPBaoFu_dividingLine2;
@property (nonatomic, strong) UIView *JPBaoFu_inputView;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView1;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView2;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextAccIcon;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextPwdIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_passwordField;
@property (nonatomic, strong) UIButton *JPBaoFu_signUpBtn;
@property (nonatomic, strong) UIButton *Queen_HLoginBtn;
@property (nonatomic, strong) UIButton *JPBaoFu_fbLoginBtn;
@property (nonatomic, strong) UIButton *JPBaoFu_vtLoginBtn;
@property (nonatomic, strong) UIButton *JPBaoFu_accountsBtn;
@property (nonatomic, strong) UIButton *JPBaoFu_aServiceBtn;
@property (nonatomic, strong) UIView *JPBaoFu_inputLine;
@property (nonatomic, strong) UIView *JPBaoFu_dividingLine;
@property (nonatomic, strong) UITableView *JPBaoFu_historyTable;
@property (nonatomic, strong) UIButton *JPBaoFu_protocolSureBtn;
@property (nonatomic, strong) UIButton *Queen_HeckoutProtoclBtn;
@property (nonatomic, strong) UIButton *JPBaoFu_signInAppleButton;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFT;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFB;
@property (nonatomic, assign) NSInteger JPBaoFu_willDeleteIndex;
@end
@implementation QueenCHILoginView
+ (instancetype)QueenshowLoginViewInContext:(UIView *)context data:(NSDictionary *)data {
    QueenCHILoginView *loginView = [[QueenCHILoginView alloc] init];
    [context addSubview:loginView];
    loginView.JPBaoFu_data = [data mutableCopy];
    loginView.JPBaoFu_context = context;
    [loginView JPBaoFu_setupViews];
    [loginView JPBaoFu_displayViews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:loginView action:@selector(JPBaoFu_tapView)];
    [loginView addGestureRecognizer:tap];
    return loginView;
}
#pragma mark - Config
- (void)JPBaoFu_setupViews {
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = Queen_HILucencyWhiteColor;
    self.JPBaoFu_navTitle = [UILabel new];
        _JPBaoFu_navTitle.font = Queen_HTSmallFont;
        _JPBaoFu_navTitle.textColor = Queen_HILightBlackColor;
        _JPBaoFu_navTitle.text = Queen_HLocalizedString(Queen_HILoginViewNavTitleText);
        [self addSubview:_JPBaoFu_navTitle];
//    self.JPBaoFu_splitLine = [UIView new];
//    _JPBaoFu_splitLine.backgroundColor = Queen_HILightBlackColor;
//    [self addSubview:_JPBaoFu_splitLine];
       self.JPBaoFu_dividingLine1 = [UIView new];
       _JPBaoFu_dividingLine1.backgroundColor = Queen_HILightBlackColor;
       [self addSubview:_JPBaoFu_dividingLine1];
        self.JPBaoFu_dividingLine2 = [UIView new];
        _JPBaoFu_dividingLine2.backgroundColor = Queen_HILightBlackColor;
        [self addSubview:_JPBaoFu_dividingLine2];
        self.JPBaoFu_inputView = [UIView new];
        [self addSubview:_JPBaoFu_inputView];
        _JPBaoFu_inputTextBgView1 = [[UIImageView alloc] init];
    _JPBaoFu_inputTextBgView1.backgroundColor = Queen_HIGreenColor;
//    _JPBaoFu_inputTextBgView1.layer.borderColor = Queen_HIGreenColorr;
//    _JPBaoFu_inputTextBgView1.layer.borderWidth = 1.0;
//    _JPBaoFu_inputTextBgView1.layer.cornerRadius = 7.0;
//    _JPBaoFu_inputTextBgView1.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextBgView1];
        _JPBaoFu_inputTextBgView2 = [[UIImageView alloc] init];
    _JPBaoFu_inputTextBgView2.backgroundColor = Queen_HIGreenColor;
//    _JPBaoFu_inputTextBgView2.layer.borderColor = Queen_HILineColor.CGColor;
//    _JPBaoFu_inputTextBgView2.layer.borderWidth = 1.0;
//    _JPBaoFu_inputTextBgView2.layer.cornerRadius = 7.0;
//    _JPBaoFu_inputTextBgView2.layer.masksToBounds = YES;
        [self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextBgView2];
        self.JPBaoFu_inputTextAccIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_yx_icon"]];
        [self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextAccIcon];
        self.JPBaoFu_accountField = [UITextField new];
        self.JPBaoFu_accountField.delegate = self;
        self.JPBaoFu_accountField.font = Queen_HTBoldMediaFont;
        self.JPBaoFu_accountField.textColor = Queen_HIDarkBlackColor;
        self.JPBaoFu_accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.JPBaoFu_accountField.keyboardType = UIKeyboardTypeEmailAddress;
        self.JPBaoFu_accountField.text = [self.JPBaoFu_data objectForKey:Queen_HILoginViewEmailData];
    self.JPBaoFu_accountField.placeholder = Queen_HLocalizedString(Queen_HILoginViewEmailText);
        [self.JPBaoFu_inputView addSubview:self.JPBaoFu_accountField];
        self.JPBaoFu_accountsBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _JPBaoFu_accountsBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_JPBaoFu_accountsBtn setImage:[QueenUtils quImageWithName:@"history_accounts"] forState:(UIControlStateNormal)];
        [_JPBaoFu_accountsBtn addTarget:self action:@selector(QueenShowHistoryAccounts:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountsBtn];
    NSArray *arr = [self.JPBaoFu_data objectForKey:Queen_HILoginView_HistoryAccountData];
        self.JPBaoFu_accountsBtn.hidden = (arr.count == 0);
    self.JPBaoFu_inputTextPwdIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
        [self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextPwdIcon];
        self.JPBaoFu_passwordField = [UITextField new];
        _JPBaoFu_passwordField.delegate = self;
        _JPBaoFu_passwordField.font = Queen_HTBoldMediaFont;
        _JPBaoFu_passwordField.textColor = Queen_HIDarkBlackColor;
        _JPBaoFu_passwordField.secureTextEntry = YES;
        _JPBaoFu_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_passwordField.placeholder = Queen_HLocalizedString(Queen_HILoginViewPasswordText);
        self.JPBaoFu_passwordField.text = [self.JPBaoFu_data objectForKey:Queen_HILoginViewPasswordData];
        [self.JPBaoFu_inputView addSubview:_JPBaoFu_passwordField];
        self.Queen_HLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _Queen_HLoginBtn.layer.cornerRadius = 19.0;
        _Queen_HLoginBtn.layer.masksToBounds = YES;
        _Queen_HLoginBtn.backgroundColor = Queen_HIGreenColor;
        _Queen_HLoginBtn.titleLabel.font = Queen_HTMediaFont;
        [_Queen_HLoginBtn setTitle:Queen_HLocalizedString(Queen_HILoginViewNavTitleText) forState:(UIControlStateNormal)];
        [_Queen_HLoginBtn addTarget:self action:@selector(JPBaoFu_logInOperation) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_Queen_HLoginBtn];
    self.JPBaoFu_signUpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _JPBaoFu_signUpBtn.titleLabel.font = Queen_HTSmallFont;
    [_JPBaoFu_signUpBtn setTitle:Queen_HLocalizedString(Queen_HILoginViewSignUpText) forState:(UIControlStateNormal)];
    [_JPBaoFu_signUpBtn setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
    [_JPBaoFu_signUpBtn addTarget:self action:@selector(QueenShowSignUpView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_signUpBtn];
        self.JPBaoFu_aServiceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_JPBaoFu_aServiceBtn setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
        _JPBaoFu_aServiceBtn.titleLabel.font = Queen_HTSmallFont;
        [_JPBaoFu_aServiceBtn setTitle:Queen_HLocalizedString(Queen_HILoginViewAccountServiceText) forState:(UIControlStateNormal)];
        [_JPBaoFu_aServiceBtn addTarget:self action:@selector(QueenShowAccountServiceView) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_JPBaoFu_aServiceBtn];
    
    
    
  
    self.JPBaoFu_fbLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_fbLoginBtn setImage:[QueenUtils quImageWithName:@"cnm_FB_login"] forState:UIControlStateNormal];
    [_JPBaoFu_fbLoginBtn addTarget:self action:@selector(JPBaoFu_facebookLogInOperation) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_fbLoginBtn];
    
    if (@available(iOS 13.0, *)) {
      
        self.JPBaoFu_signInAppleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_JPBaoFu_signInAppleButton setImage:[QueenUtils quImageWithName:@"cnm_apple_login"] forState:UIControlStateNormal];
        [_JPBaoFu_signInAppleButton addTarget:self action:@selector(JPBaoFu_onClickSignInWithAppleButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_JPBaoFu_signInAppleButton];
        
        
        if([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_loginStatus1 & JPBaoFu_SDKFlagApple ){
          
        }else{
            self.JPBaoFu_signInAppleButton.hidden=YES;
        }
    }
    
    self.JPBaoFu_vtLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_vtLoginBtn setImage:[QueenUtils quImageWithName:@"cnm_yk_login"] forState:(UIControlStateNormal)];
    [_JPBaoFu_vtLoginBtn addTarget:self action:@selector(JPBaoFu_playAsGuestOperation) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_vtLoginBtn];
    
    
    
    
    self.JPBaoFu_protocolSureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _JPBaoFu_protocolSureBtn.contentMode = UIViewContentModeScaleAspectFit;
    _JPBaoFu_protocolSureBtn.selected = YES;
    [_JPBaoFu_protocolSureBtn setImage:[QueenUtils quImageWithName:@"protocol"] forState:(UIControlStateNormal)];
    [_JPBaoFu_protocolSureBtn setImage:[QueenUtils quImageWithName:@"protocol_selected"] forState:(UIControlStateSelected)];
    [_JPBaoFu_protocolSureBtn addTarget:self action:@selector(JPBaoFu_protocolSelectOperation:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_protocolSureBtn];
    self.Queen_HeckoutProtoclBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _Queen_HeckoutProtoclBtn.titleLabel.font = [UIFont systemFontOfSize:11.5];
    _Queen_HeckoutProtoclBtn.titleLabel.numberOfLines = 0;
    _Queen_HeckoutProtoclBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _Queen_HeckoutProtoclBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _Queen_HeckoutProtoclBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    NSString * protocalNoti =  Queen_HLocalizedString(Queen_HIThirdPlatformLoginProtocolText);
    NSMutableAttributedString * notiString = [[NSMutableAttributedString alloc] initWithString:protocalNoti];
    [notiString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.5] range:NSMakeRange(0, protocalNoti.length)];
    [notiString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, protocalNoti.length)];
    [notiString addAttribute:NSForegroundColorAttributeName value:Queen_HIGreenColor range:NSMakeRange(40, protocalNoti.length-40)];
    [_Queen_HeckoutProtoclBtn setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:notiString] forState:UIControlStateNormal];
    [_Queen_HeckoutProtoclBtn addTarget:self action:@selector(QueenShowDetailProtoclInfo) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_Queen_HeckoutProtoclBtn];
    
    
    if([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_loginStatus1 & JPBaoFu_SDKFlagFB ){
      
    }else{
        self.JPBaoFu_fbLoginBtn.hidden=YES;
    }
    
//    if([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_loginStatus1==0){
//        self.JPBaoFu_fbLoginBtn.hidden=YES;
//
//    }
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(252, 105));
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(27);
    }];
    [self.JPBaoFu_inputTextBgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(JPBaoFu_cInputFieldHeight-1);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(1);
    }];
    [self.JPBaoFu_inputTextBgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(13.0+JPBaoFu_cInputFieldHeight-1);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(1);
    }];
    [self.JPBaoFu_inputTextAccIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1);
        make.top.mas_equalTo(JPBaoFu_cInputFieldHeight/2-9.5);
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
    }];
    [self.JPBaoFu_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputTextAccIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_accountsBtn.mas_left).offset(-Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_accountsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.and.width.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_inputTextPwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(JPBaoFu_cInputFieldHeight/2-9.5+13);
        
        
    }];
    [self.JPBaoFu_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputTextPwdIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_right).offset(-Queen_HMargin);
//        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2.mas_top);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(13);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    
    
    
    [self.Queen_HLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_bottom).offset(10);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_width);
        make.height.mas_equalTo(39);
        make.centerX.mas_equalTo(weakSelf);
    }];
    CGSize aServiceSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_aServiceBtn.titleLabel.text font:self.JPBaoFu_aServiceBtn.titleLabel.font maxW:JPBaoFu_SCREENWIDTH];
    [self.JPBaoFu_aServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(aServiceSize.width+Queen_HMargin, 30));
        make.top.mas_equalTo(weakSelf.Queen_HLoginBtn.mas_bottom).offset(8);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_right).offset(-5);
    }];
    [self.JPBaoFu_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.JPBaoFu_aServiceBtn);
        make.top.mas_equalTo(weakSelf.JPBaoFu_aServiceBtn);
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_left).offset(5);
    }];
    [self.JPBaoFu_navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.JPBaoFu_signUpBtn.mas_bottom).offset(8);
    }];
//    [self.JPBaoFu_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(0.5);
//        make.height.mas_equalTo(13);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_signUpBtn);
//        make.centerX.mas_equalTo(weakSelf.JPBaoFu_navTitle);
//    }];
    [self.JPBaoFu_dividingLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_left);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_navTitle);
    }];
    [self.JPBaoFu_dividingLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.JPBaoFu_dividingLine1);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_right);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_navTitle);
    }];
  

    
    CGFloat fbOffsetx = 60;
    if (@available(iOS 13.0, *)) {
        [self.JPBaoFu_signInAppleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(34, 34));
            
            make.centerX.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(60);
           
            make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(10);
        }];
        fbOffsetx = 0;
    }
    
    
    [self.JPBaoFu_fbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.centerX.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-60);
        make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(10);
    }];
    
    
    
    [self.JPBaoFu_vtLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.centerX.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(0);
        make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(10);
    }];
    
    
    
    
    
    [self.JPBaoFu_protocolSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(weakSelf.JPBaoFu_fbLoginBtn.mas_bottom).offset(10);
    }];
    [self.Queen_HeckoutProtoclBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_protocolSureBtn);
        make.left.mas_equalTo(weakSelf.JPBaoFu_protocolSureBtn.mas_right).offset(Queen_HMargin/4);
        make.right.mas_equalTo(weakSelf).offset(-20);
        make.height.mas_equalTo(40);
    }];
}
- (void)Queen_refreshMainView {
    JPBaoFu_YJWeakSelf
    CGFloat contentViewMaxW = 340;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if ([UIDevice deviceVerticalOrHorizontal] == DeviceOrientationTypeVertical) {
            contentViewMaxW = JPBaoFu_SCREENWIDTH*0.95;
        } else {
            contentViewMaxW = JPBaoFu_SCREENWIDTH*0.6;
        }
    }
    if (contentViewMaxW > 340) {
        contentViewMaxW = 340;
    }
    CGFloat height = 330;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(contentViewMaxW, height));
        make.center.mas_equalTo(weakSelf.JPBaoFu_context);
    }];
    [self layoutIfNeeded];
}
#pragma mark - Click Events
- (void)QueenShowSignUpView {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickSignUpEvent)]) {
        [self JPBaoFu_hidHistoryTable];
        [self.delegate JPBaoFu_loginViewClickSignUpEvent];
    }
}
- (void)QueenShowAccountServiceView {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickAccountServiceEvent)]) {
        [self JPBaoFu_hidHistoryTable];
        [self.delegate JPBaoFu_loginViewClickAccountServiceEvent];
    }
}
- (void)JPBaoFu_logInOperation {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickLogInEvent:password:)]) {
        [self JPBaoFu_hidHistoryTable];
        [self.delegate JPBaoFu_loginViewClickLogInEvent:self.JPBaoFu_accountField.text password:self.JPBaoFu_passwordField.text];
    }
}
- (void)JPBaoFu_facebookLogInOperation {
    if (!self.JPBaoFu_protocolSureBtn.selected) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissConfirmProtocal));
        return;
    }
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickFacebookEvent)]) {
        [self.delegate JPBaoFu_loginViewClickFacebookEvent];
    }
}
- (void)JPBaoFu_playAsGuestOperation {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickPlayAsGuestEvent)]) {
        [self JPBaoFu_hidHistoryTable];
        [self.delegate JPBaoFu_loginViewClickPlayAsGuestEvent];
    }
}
- (void)QueenShowHistoryAccounts:(UIButton *)sender {
    if (self.JPBaoFu_historyTable) {
        [self JPBaoFu_hidHistoryTable];
    }else {
        NSArray *arr = [self.JPBaoFu_data objectForKey:Queen_HILoginView_HistoryAccountData];
        if (arr.count == 0) return;
        UITableView *historyTable = [[UITableView alloc] initWithFrame:CGRectMake(self.JPBaoFu_inputView.x + 0.8, self.JPBaoFu_inputView.y + JPBaoFu_cInputFieldHeight, self.JPBaoFu_inputView.width- 0.8*2, 0.0) style:(UITableViewStylePlain)];
        historyTable.backgroundColor = Queen_HILucencyWhiteColor;
        historyTable.dataSource = self;
        historyTable.delegate = self;
        historyTable.layer.borderColor = Queen_HILightBlackColor.CGColor;
        historyTable.layer.borderWidth = 1.0;
        historyTable.layer.cornerRadius = 7.0;
        historyTable.layer.masksToBounds = YES;
        historyTable.separatorInset = UIEdgeInsetsZero;
        historyTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        historyTable.showsVerticalScrollIndicator = NO;
        historyTable.tableFooterView = [[UIView alloc]init];
        self.JPBaoFu_historyTable = historyTable;
        [self addSubview:historyTable];
        [UIView animateWithDuration:0.25 animations:^{
            self.JPBaoFu_historyTable.frame = CGRectMake(self.JPBaoFu_inputView.x + 0.8, self.JPBaoFu_inputView.y + JPBaoFu_cInputFieldHeight, self.JPBaoFu_inputView.width- 0.8*2, CGRectGetMaxY(self.JPBaoFu_signUpBtn.frame) - (self.JPBaoFu_inputView.y + JPBaoFu_cInputFieldHeight));
        }];
    }
}
- (void)JPBaoFu_protocolSelectOperation:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)QueenShowDetailProtoclInfo {
    if (self.JPBaoFu_protocolSureBtn.selected == NO) {
        self.JPBaoFu_protocolSureBtn.selected = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickProtoclBtnEvent)]) {
        [self.delegate JPBaoFu_loginViewClickProtoclBtnEvent];
    }
}
- (void)JPBaoFu_onClickSignInWithAppleButton:(id)sender
{
    if (!self.JPBaoFu_protocolSureBtn.selected) {
        QueenShowWarningToast(Queen_HLocalizedString(Queen_HIAlertMissConfirmProtocal));
        return;
    }
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickSignInWithAppleEvent)]) {
        [self.delegate JPBaoFu_loginViewClickSignInWithAppleEvent];
    }
}
#pragma mark - Public 
- (void)Queen_refreshMainViewInfo:(NSDictionary *)recentData {
    if (![QueenCHHelper JPBaoFu_isBlankString:[recentData objectForKey:Queen_HILoginViewEmailData]]) {
        self.JPBaoFu_accountField.text = [recentData objectForKey:Queen_HILoginViewEmailData];
    }else {
        self.JPBaoFu_accountField.text = nil;
    }
    if (![QueenCHHelper JPBaoFu_isBlankString:[recentData objectForKey:Queen_HILoginViewPasswordData]]) {
        self.JPBaoFu_passwordField.text = [recentData objectForKey:Queen_HILoginViewPasswordData];
    }else {
        self.JPBaoFu_passwordField.text = nil;
    }
}
- (void)JPBaoFu_refreshHistoryTableInfo:(NSArray *)historyArr {
    [self.JPBaoFu_data setObject:historyArr forKey:Queen_HILoginView_HistoryAccountData];
    if (self.JPBaoFu_historyTable) {
        [self.JPBaoFu_historyTable reloadData];
    }
}
- (void)JPBaoFu_hidHistoryTable {
    if (self.JPBaoFu_historyTable == nil) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.JPBaoFu_historyTable.frame = CGRectMake(self.JPBaoFu_inputView.x + 0.8, self.JPBaoFu_inputView.y + JPBaoFu_cInputFieldHeight, self.JPBaoFu_inputView.width- 0.8*2, 0.0);
    } completion:^(BOOL finished) {
        [self.JPBaoFu_historyTable removeFromSuperview];
        self.JPBaoFu_historyTable = nil;
    }];
}
#pragma mark - Private
- (void)JPBaoFu_tapView {
    [self JPBaoFu_hidHistoryTable];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.JPBaoFu_data objectForKey:Queen_HILoginView_HistoryAccountData];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Queen_HIHistoryCell *cell = [Queen_HIHistoryCell JPBaoFu_obtainCellWithTableView:tableView reuseIdentifier:@"historyCell"];
    NSArray *arr = [self.JPBaoFu_data objectForKey:Queen_HILoginView_HistoryAccountData];
    QueenCHIGlobalUser *userInfo = [arr objectAtIndex:indexPath.row];
    cell.JPBaoFu_accountLabel.text = userInfo.userName;
    JPBaoFu_YJWeakSelf
    cell.JPBaoFu_deleteCallback = ^{
        weakSelf.JPBaoFu_willDeleteIndex = indexPath.row;
        NSString *toastMessage = [NSString stringWithFormat:@"%@ %@",userInfo.userName,Queen_HLocalizedString(Queen_HIAlertAccountDeleteInquriryText)];
        [QueenCHAlertManager showAlertViewWithTitle:Queen_HLocalizedString(Queen_HIAlertInquriryTitleText) message:toastMessage delegate:self tempData:nil buttonTitles:Queen_HLocalizedString(Queen_HIAlertInquriryCancelText),Queen_HLocalizedString(Queen_HIAlertInquriryConfirmText),nil];
    };
    cell.JPBaoFu_selectedCallback = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickCellSelectedEvent:)]) {
            [weakSelf.delegate JPBaoFu_loginViewClickCellSelectedEvent:indexPath.row];
        }
        [weakSelf QueenShowHistoryAccounts:nil];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma mark - QueenYAlerViewDelegate
- (void)Queen_HAlertView:(QueenYJAlertView *)alertView transferredData:(NSDictionary *)data clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(JPBaoFu_loginViewClickCellDeletedEvent:)]) {
            [self.delegate JPBaoFu_loginViewClickCellDeletedEvent:self.JPBaoFu_willDeleteIndex];
        }
    }
}
@end
