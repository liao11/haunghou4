#import "QueenCHIFindAtOrPwView.h"
#import "QueenVerCodeImageView.h"
CGFloat const JPBaoFu_FindAtOrPwViewsuitableW = 340;
@interface QueenCHIFindAtOrPwView () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) UILabel *JPBaoFu_navTitle;
@property (nonatomic, strong) UIButton *JPBaoFu_navBtn;
@property (nonatomic, strong) UIView *JPBaoFu_navLine;
@property (nonatomic, strong) UILabel *JPBaoFu_inputTitle;
@property (nonatomic, strong) UIView *JPBaoFu_inputView;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView1;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView2;
@property (nonatomic, strong) UIImageView *JPBaoFu_accountIcon;
@property (nonatomic, strong) UIButton *JPBaoFu_forgotID;
@property (nonatomic, strong) UIImageView *JPBaoFu_verifyIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_verifyField;
@property (nonatomic, strong) QueenVerCodeImageView *JPBaoFu_verifyCode;
@property (nonatomic, strong) UIButton *JPBaoFu_submitBtn;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFT;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFB;
@property (nonatomic, strong) NSString *JPBaoFu_verifyCodeStr;
@end
@implementation QueenCHIFindAtOrPwView
+ (instancetype)QueenShowFindAtOrPwViewInContext:(UIView *)context {
    QueenCHIFindAtOrPwView *findAtOrPwView = [[QueenCHIFindAtOrPwView alloc] init];
    [context addSubview:findAtOrPwView];
    findAtOrPwView.JPBaoFu_context = context;
    [findAtOrPwView JPBaoFu_setupViews];
    [findAtOrPwView JPBaoFu_configViews];
    [findAtOrPwView JPBaoFu_displayViews];
    return findAtOrPwView;
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
    self.JPBaoFu_navLine = [UIView new];
    _JPBaoFu_navLine.backgroundColor = Queen_HILineColor;
    [self addSubview:_JPBaoFu_navLine];
    self.JPBaoFu_inputTitle = [UILabel new];
    _JPBaoFu_inputTitle.font = Queen_HTBoldMediaFont;
    _JPBaoFu_inputTitle.textColor = Queen_HIDarkBlackColor;
    [self addSubview:_JPBaoFu_inputTitle];
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
_JPBaoFu_inputTextBgView2.backgroundColor =Queen_HIGreenColor;
//_JPBaoFu_inputTextBgView2.layer.borderColor = Queen_HILineColor.CGColor;
//_JPBaoFu_inputTextBgView2.layer.borderWidth = 1.0;
//_JPBaoFu_inputTextBgView2.layer.cornerRadius = 7.0;
//_JPBaoFu_inputTextBgView2.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextBgView2];
    self.JPBaoFu_accountIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_yx_icon"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountIcon];
    self.JPBaoFu_accountField = [UITextField new];
    self.JPBaoFu_accountField.delegate = self;
    self.JPBaoFu_accountField.font = Queen_HTBoldMediaFont;
    self.JPBaoFu_accountField.textColor = Queen_HIDarkBlackColor;\
    self.JPBaoFu_accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.JPBaoFu_accountField.keyboardType = UIKeyboardTypeEmailAddress;
    self.JPBaoFu_accountField.placeholder = Queen_HLocalizedString(Queen_HILoginViewEmailText);
    [self.JPBaoFu_inputView addSubview:self.JPBaoFu_accountField];
    self.JPBaoFu_verifyIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_verifyIcon];
    self.JPBaoFu_verifyField = [UITextField new];
    _JPBaoFu_verifyField.delegate = self;
    _JPBaoFu_verifyField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_verifyField.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_verifyField.placeholder = Queen_HLocalizedString(Queen_HIFindAtOrPwViewVerificationText);
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_verifyField];
    self.JPBaoFu_forgotID = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_forgotID setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
    _JPBaoFu_forgotID.titleLabel.font = Queen_HTMediaFont;
    [_JPBaoFu_forgotID addTarget:self action:@selector(QueenShowForgotAtView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_forgotID];
    self.JPBaoFu_verifyCode = [QueenVerCodeImageView new];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_verifyCode];
    
    
    
    self.JPBaoFu_submitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_submitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_JPBaoFu_submitBtn setBackgroundColor:Queen_HIGreenColor];
    _JPBaoFu_submitBtn.titleLabel.font = Queen_HTBoldMediaFont;
    _JPBaoFu_submitBtn.layer.cornerRadius = 19;
    _JPBaoFu_submitBtn.layer.masksToBounds = YES;
    [_JPBaoFu_submitBtn addTarget:self action:@selector(QueenShowForgotPwView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_submitBtn];
}
- (void)JPBaoFu_configViews {
    self.JPBaoFu_navTitle.text = Queen_HLocalizedString(Queen_HIFindAtOrPwViewNavTitleText);
    [self.JPBaoFu_navBtn setImage:[QueenUtils quImageWithName:@"arrowLeft"] forState:(UIControlStateNormal)];
    self.JPBaoFu_inputTitle.text = Queen_HLocalizedString(Queen_HIFindAtOrPwViewInputTitleText);
    [self.JPBaoFu_forgotID setTitle:Queen_HLocalizedString(Queen_HIFindAtOrPwViewForgotIDText) forState:(UIControlStateNormal)];
    JPBaoFu_YJWeakSelf
    self.JPBaoFu_verifyCode.bolck = ^(NSString *codeStr) {
        weakSelf.JPBaoFu_verifyCodeStr = codeStr;
    };
    [self.JPBaoFu_submitBtn setTitle:Queen_HLocalizedString(Queen_HIFindAtOrPwViewSubmitText) forState:(UIControlStateNormal)];
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    CGSize forgotIDSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_forgotID.titleLabel.text font:self.JPBaoFu_forgotID.titleLabel.font maxW:JPBaoFu_SCREENWIDTH];
    [self.JPBaoFu_navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(Queen_HMargin);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_navTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.JPBaoFu_navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf).offset(15);
        make.top.mas_equalTo(weakSelf).offset(1.5*Queen_HMargin);
    }];
    [self.JPBaoFu_navLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(Queen_HMargin);
        make.left.mas_equalTo(weakSelf).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf).offset(-2*Queen_HMargin);
        make.height.mas_equalTo(0.5);
    }];
    [self.JPBaoFu_inputTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_navLine).offset(Queen_HMargin);
        make.centerX.mas_equalTo(weakSelf);
    }];
    [self.JPBaoFu_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf).offset(-2*Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTitle.mas_bottom).offset(Queen_HMargin);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight*2+15);
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
        
        
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
    }];
    [self.JPBaoFu_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_accountIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_forgotID.mas_left).offset(-Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_forgotID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
        make.width.mas_equalTo(forgotIDSize.width + Queen_HMargin);
    }];
    [self.JPBaoFu_verifyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(JPBaoFu_cInputFieldHeight/2-9.5+13);
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
    }];
    [self.JPBaoFu_verifyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_verifyIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_verifyCode.mas_left).offset(-Queen_HMargin);
//        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(13);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(13+7.5);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    [self.JPBaoFu_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_bottom).offset(1.5*Queen_HMargin);
        make.left.and.right.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputButtonHeight);
    }];
}
- (void)Queen_refreshMainView {
    JPBaoFu_YJWeakSelf
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.JPBaoFu_context);
        make.width.mas_equalTo([weakSelf JPBaoFu_obtainMaxWidth]);
        make.bottom.mas_equalTo(weakSelf.JPBaoFu_submitBtn.mas_bottom).offset(2*Queen_HMargin);
    }];
    [self.JPBaoFu_context layoutIfNeeded];
    [self JPBaoFu_freshVerCode];
}
#pragma mark - Click Events
- (void)JPBaoFu_returnBack {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_findAtOrPwViewClickReturnEvent)]) {
        [self.delegate JPBaoFu_findAtOrPwViewClickReturnEvent];
    }
}
- (void)QueenShowForgotAtView {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_findAtOrPwViewClickForgotIDEvent)]) {
        [self.delegate JPBaoFu_findAtOrPwViewClickForgotIDEvent];
    }
}
- (void)QueenShowForgotPwView {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_findAtOrPwViewClickSubmitEvent:inputCode:codeViewStr:)]) {
        [self.delegate JPBaoFu_findAtOrPwViewClickSubmitEvent:self.JPBaoFu_accountField.text inputCode:self.JPBaoFu_verifyField.text codeViewStr:self.JPBaoFu_verifyCodeStr];
    }
}
#pragma mark - Public
- (void)JPBaoFu_freshVerCode {
    [self.JPBaoFu_verifyCode freshVerCode];
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
        if (contentViewMaxW > JPBaoFu_FindAtOrPwViewsuitableW) {
            contentViewMaxW = JPBaoFu_FindAtOrPwViewsuitableW;
        }
        return contentViewMaxW;
    }else {
        return JPBaoFu_FindAtOrPwViewsuitableW;
    }
}
@end
