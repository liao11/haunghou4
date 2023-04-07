#import "QueenCHISignUpView.h"
CGFloat const JPBaoFu_SignUpViewsuitableW = 340;
@interface QueenCHISignUpView () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) UILabel *JPBaoFu_navTitle;
@property (nonatomic, strong) UIButton *JPBaoFu_navBtn;
@property (nonatomic, strong) UIView *JPBaoFu_inputView;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView1;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView2;
@property (nonatomic, strong) UIImageView *JPBaoFu_accountIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_accountField;
@property (nonatomic, strong) UIImageView *JPBaoFu_passwordIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_passwordField;
@property (nonatomic, strong) UIButton *JPBaoFu_protocolSureBtn;
@property (nonatomic, strong) UIButton *Queen_HeckoutProtoclBtn;
@property (nonatomic, strong) UIButton *JPBaoFu_registerBtn;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFT;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFB;

@property (nonatomic, strong) UIButton *JPBaoFu_signUpBtn;

@end
@implementation QueenCHISignUpView
+ (instancetype)QueenShowSignUpViewInContext:(UIView *)context {
    QueenCHISignUpView *signUpView = [[QueenCHISignUpView alloc] init];
    [context addSubview:signUpView];
    signUpView.JPBaoFu_context = context;
    [signUpView JPBaoFu_setupViews];
    [signUpView JPBaoFu_configViews];
    [signUpView JPBaoFu_displayViews];
    return signUpView;
}
#pragma mark - Config
- (void)JPBaoFu_setupViews {
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = Queen_HILucencyWhiteColor;
    
    
    
    self.JPBaoFu_navBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _JPBaoFu_navBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_JPBaoFu_navBtn addTarget:self action:@selector(JPBaoFu_returnBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_navBtn];
    self.JPBaoFu_navTitle = [UILabel new];
    _JPBaoFu_navTitle.font = Queen_HINavTitleFont;
    _JPBaoFu_navTitle.textColor = Queen_HIDarkBlackColor;
    [self addSubview:_JPBaoFu_navTitle];
    self.JPBaoFu_inputView = [UIView new];
    [self addSubview:_JPBaoFu_inputView];
    _JPBaoFu_inputTextBgView1 = [[UIImageView alloc] init];
_JPBaoFu_inputTextBgView1.backgroundColor = Queen_HIGreenColor;
//_JPBaoFu_inputTextBgView1.layer.borderColor = Queen_HILineColor.CGColor;
//_JPBaoFu_inputTextBgView1.layer.borderWidth = 1.0;
//_JPBaoFu_inputTextBgView1.layer.cornerRadius = 7.0;
//_JPBaoFu_inputTextBgView1.layer.masksToBounds = YES;
[self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextBgView1];
    _JPBaoFu_inputTextBgView2 = [[UIImageView alloc] init];
_JPBaoFu_inputTextBgView2.backgroundColor = Queen_HIGreenColor;
//_JPBaoFu_inputTextBgView2.layer.borderColor = Queen_HILineColor.CGColor;
//_JPBaoFu_inputTextBgView2.layer.borderWidth = 1.0;
//_JPBaoFu_inputTextBgView2.layer.cornerRadius = 7.0;
//_JPBaoFu_inputTextBgView2.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextBgView2];
    self.JPBaoFu_accountIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_yx_icon"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountIcon];
    self.JPBaoFu_accountField = [UITextField new];
    _JPBaoFu_accountField.delegate = self;
    _JPBaoFu_accountField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_accountField.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_accountField.keyboardType = UIKeyboardTypeEmailAddress;
    _JPBaoFu_accountField.placeholder = Queen_HLocalizedString(Queen_HILoginViewEmailText);
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountField];
    self.JPBaoFu_passwordIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_passwordIcon];
    self.JPBaoFu_passwordField = [UITextField new];
    _JPBaoFu_passwordField.delegate = self;
    _JPBaoFu_passwordField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_passwordField.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_passwordField.secureTextEntry = YES;
    _JPBaoFu_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_passwordField.placeholder = Queen_HLocalizedString(Queen_HILoginViewPasswordText);
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_passwordField];
    self.JPBaoFu_protocolSureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _JPBaoFu_protocolSureBtn.contentMode = UIViewContentModeScaleAspectFit;
    _JPBaoFu_protocolSureBtn.selected = YES;
    [_JPBaoFu_protocolSureBtn addTarget:self action:@selector(JPBaoFu_protocolSelectOperation:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_protocolSureBtn];
    self.Queen_HeckoutProtoclBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _Queen_HeckoutProtoclBtn.contentMode = UIViewContentModeScaleAspectFit;
    _Queen_HeckoutProtoclBtn.titleLabel.font = Queen_HTSmallFont;
    [_Queen_HeckoutProtoclBtn addTarget:self action:@selector(QueenShowDetailProtoclInfo) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_Queen_HeckoutProtoclBtn];
    self.JPBaoFu_registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_registerBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_JPBaoFu_registerBtn setBackgroundColor:Queen_HIGreenColor];
    _JPBaoFu_registerBtn.titleLabel.font = Queen_HTBoldMediaFont;
    _JPBaoFu_registerBtn.layer.cornerRadius = 7.0;
    _JPBaoFu_registerBtn.layer.masksToBounds = YES;
    [_JPBaoFu_registerBtn addTarget:self action:@selector(JPBaoFu_registerAccountOperation) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_registerBtn];
    
    
    
//
//    self.JPBaoFu_signUpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _JPBaoFu_signUpBtn.titleLabel.font = Queen_HTSmallFont;
//    [_JPBaoFu_signUpBtn setTitle:@"Đăng xuất tài khoản" forState:(UIControlStateNormal)];
//    [_JPBaoFu_signUpBtn setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
//    [_JPBaoFu_signUpBtn addTarget:self action:@selector(QueenShowDeteleView) forControlEvents:(UIControlEventTouchUpInside)];
//    [self addSubview:_JPBaoFu_signUpBtn];
    
    
    
}
- (void)JPBaoFu_configViews {
    self.JPBaoFu_navTitle.text = Queen_HLocalizedString(Queen_HISignUpViewNavTitleText);
    [self.JPBaoFu_navBtn setImage:[QueenUtils quImageWithName:@"arrowLeft"] forState:(UIControlStateNormal)];
    [self.JPBaoFu_registerBtn setTitle:Queen_HLocalizedString(Queen_HISignUpViewRegisterText) forState:(UIControlStateNormal)];
    [_JPBaoFu_protocolSureBtn setImage:[QueenUtils quImageWithName:@"protocol"] forState:(UIControlStateNormal)];
    [_JPBaoFu_protocolSureBtn setImage:[QueenUtils quImageWithName:@"protocol_selected"] forState:(UIControlStateSelected)];
    NSString * protocalNoti =  Queen_HLocalizedString(Queen_HISignUpViewCheckProtocolText);
    NSMutableAttributedString * notiString = [[NSMutableAttributedString alloc]initWithString:protocalNoti];
#warning 这个range在不同语言的情况下会导致奔溃
    [notiString addAttribute:NSForegroundColorAttributeName value:Queen_HIGreenColor range:[self obtainAttributeStringRange]];
    [_Queen_HeckoutProtoclBtn setAttributedTitle:[[NSAttributedString alloc]initWithAttributedString:notiString] forState:UIControlStateNormal];
}
- (NSRange)obtainAttributeStringRange {
        return NSMakeRange(9, 12);
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(Queen_HMargin);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_navTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.JPBaoFu_navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf).offset(1.5*Queen_HMargin);
    }];
    [self.JPBaoFu_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf).offset(-2*Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(1.5*Queen_HMargin);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight*2 + 15);
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
    [self.JPBaoFu_accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1);
        make.top.mas_equalTo(JPBaoFu_cInputFieldHeight/2-9.5);
//        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(JPBaoFu_cInputFieldHeight/2-9.5+13);
        
        
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
    }];
    [self.JPBaoFu_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_accountIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(JPBaoFu_cInputFieldHeight/2-9.5+13);
    }];
    [self.JPBaoFu_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_passwordIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_right).offset(-Queen_HMargin);
//        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(13);
        make.bottom.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_bottom);
    }];
    [self.JPBaoFu_protocolSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(3*Queen_HMargin, 3*Queen_HMargin));
    }];
    [self.Queen_HeckoutProtoclBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_protocolSureBtn);
        make.left.mas_equalTo(weakSelf.JPBaoFu_protocolSureBtn.mas_right).offset(Queen_HMargin/2);
    }];
    [self.JPBaoFu_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_protocolSureBtn.mas_bottom);
        make.left.and.right.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputButtonHeight);
    }];
    
//    [self.JPBaoFu_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(120, 30));
//        make.top.mas_equalTo(weakSelf.JPBaoFu_registerBtn.mas_bottom).offset(8);
//        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_right).offset(-5);
//    }];
}


-(void)QueenShowDeteleView{
    
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_ShowDeteleViewClickRegisterEvent)]) {
        [self.delegate JPBaoFu_ShowDeteleViewClickRegisterEvent];
    }
    
}

- (void)Queen_refreshMainView {
    JPBaoFu_YJWeakSelf
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.JPBaoFu_context);
        make.width.mas_equalTo([weakSelf JPBaoFu_obtainMaxWidth]);
        make.bottom.mas_equalTo(weakSelf.JPBaoFu_registerBtn.mas_bottom).offset(2*Queen_HMargin);
    }];
}
#pragma mark - Click Events
- (void)JPBaoFu_returnBack {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_signUpVeiwClickReturnEvent)]) {
        [self.delegate JPBaoFu_signUpVeiwClickReturnEvent];
    }
}
- (void)JPBaoFu_protocolSelectOperation:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)JPBaoFu_registerAccountOperation {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_signUpViewClickRegisterEvent:password:confirmP:)]) {
        [self.delegate JPBaoFu_signUpViewClickRegisterEvent:self.JPBaoFu_accountField.text password:self.JPBaoFu_passwordField.text confirmP:self.JPBaoFu_protocolSureBtn.selected];
    }
}
- (void)QueenShowDetailProtoclInfo {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_signUpViewClickDetailProtocolInfo)]) {
        [self.delegate JPBaoFu_signUpViewClickDetailProtocolInfo];
    }
}
#pragma mark - Private
- (CGFloat)JPBaoFu_obtainMaxWidth {
    CGFloat contentViewMaxW = 0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if ([UIDevice deviceVerticalOrHorizontal] == DeviceOrientationTypeVertical) {
            contentViewMaxW = JPBaoFu_SCREENWIDTH*0.95;
        }else {
            contentViewMaxW = JPBaoFu_SCREENWIDTH*0.6;
        }
        if (contentViewMaxW > JPBaoFu_SignUpViewsuitableW) {
            contentViewMaxW = JPBaoFu_SignUpViewsuitableW;
        }
        return contentViewMaxW;
    } else {
        return JPBaoFu_SignUpViewsuitableW;
    }
}
@end
