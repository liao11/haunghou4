#import "QueenBindYKAccView.h"
CGFloat const JPBaoFu_BindEmailViewsuitableW1 = 340;
NSInteger const BbindCountdownTime = 60;
@interface QueenBindYKAccView () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) UIView *JPBaoFu_contentView;
@property (nonatomic, strong) UILabel *JPBaoFu_navTitle;
@property (nonatomic, strong) UIButton *JPBaoFu_navBtn;
@property (nonatomic, strong) UIView *JPBaoFu_inputView;
@property (nonatomic, strong) UIImageView *JPBaoFu_accountInputBgIV;
@property (nonatomic, strong) UIImageView *JPBaoFu_accountIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_accountField;
@property (nonatomic, strong) UIImageView *JPBaoFu_codeInputBgIV;
@property (nonatomic, strong) UIImageView *JPBaoFu_verifyIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_verifyField;
@property (nonatomic, strong) UIImageView *JPBaoFu_pwdInputBgIV;
@property (nonatomic, strong) UIImageView *JPBaoFu_pwdIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_pwdField;
@property (nonatomic, strong) UIImageView *JPBaoFu_pwd1InputBgIV;
@property (nonatomic, strong) UIImageView *JPBaoFu_pwd1Icon;
@property (nonatomic, strong) UITextField *JPBaoFu_pwd1Field;
@property (nonatomic, strong) UIButton *JPBaoFu_sendBtn;
@property (nonatomic, strong) CAShapeLayer *JPBaoFu_bindShape;
@property (nonatomic, strong) CAShapeLayer *JPBaoFu_bindBackLayer;
@property (nonatomic, strong) UIButton *JPBaoFu_linkBtn;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFT;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFB;
@property (nonatomic, copy) NSString *JPBaoFu_bindEmail;
@property (nonatomic, strong) NSDate *JPBaoFu_goBackgroundDate;
@property (nonatomic, assign) NSInteger JPBaoFu_currentNumber;
@end
@implementation QueenBindYKAccView
+ (instancetype)QueenShowBindYKAccViewInContext:(UIView *)context email:(NSString *)email{
    QueenBindYKAccView *bindYKAccView = [[QueenBindYKAccView alloc] init];
    [context addSubview:bindYKAccView];
    bindYKAccView.JPBaoFu_context = context;
    bindYKAccView.JPBaoFu_bindEmail = email;
    [bindYKAccView JPBaoFu_setupViews];
    [bindYKAccView JPBaoFu_configViews];
    [bindYKAccView JPBaoFu_displayViews];
    [[NSNotificationCenter defaultCenter] addObserver:bindYKAccView selector:@selector(JPBaoFu_appGoBackgroud) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:bindYKAccView selector:@selector(JPBaoFu_appGoForegroud) name:UIApplicationWillEnterForegroundNotification object:nil];
    return bindYKAccView;
}
#pragma mark - Config
- (void)JPBaoFu_setupViews {
    self.backgroundColor = Queen_HTDefaultContextBackgroundColor;
    self.JPBaoFu_contentView = [UIView new];
    _JPBaoFu_contentView.layer.cornerRadius = 7.0;
    _JPBaoFu_contentView.layer.masksToBounds = YES;
    _JPBaoFu_contentView.backgroundColor = Queen_HILucencyWhiteColor;
    [self addSubview:_JPBaoFu_contentView];
    self.JPBaoFu_navBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _JPBaoFu_navBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_JPBaoFu_navBtn addTarget:self action:@selector(JPBaoFu_closeView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.JPBaoFu_contentView addSubview:_JPBaoFu_navBtn];
    self.JPBaoFu_navTitle = [UILabel new];
    _JPBaoFu_navTitle.font = Queen_HINavTitleFont;
    _JPBaoFu_navTitle.textColor = Queen_HIDarkBlackColor;
    [self.JPBaoFu_contentView addSubview:_JPBaoFu_navTitle];
    self.JPBaoFu_inputView = [UIView new];
    [self.JPBaoFu_contentView addSubview:_JPBaoFu_inputView];
    _JPBaoFu_accountInputBgIV = [[UIImageView alloc] init];
    _JPBaoFu_accountInputBgIV.backgroundColor = Queen_HIGreenColor;
//    _JPBaoFu_accountInputBgIV.layer.borderColor = Queen_HILineColor.CGColor;
//    _JPBaoFu_accountInputBgIV.layer.borderWidth = 0.8;
//    _JPBaoFu_accountInputBgIV.layer.cornerRadius = 7.0;
//    _JPBaoFu_accountInputBgIV.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountInputBgIV];
    _JPBaoFu_codeInputBgIV = [[UIImageView alloc] init];
    _JPBaoFu_codeInputBgIV.backgroundColor = Queen_HIGreenColor;
//    _JPBaoFu_codeInputBgIV.layer.borderColor = Queen_HILineColor.CGColor;
//    _JPBaoFu_codeInputBgIV.layer.borderWidth = 0.8;
//    _JPBaoFu_codeInputBgIV.layer.cornerRadius = 7.0;
//    _JPBaoFu_codeInputBgIV.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_codeInputBgIV];
    _JPBaoFu_pwdInputBgIV = [[UIImageView alloc] init];
    _JPBaoFu_pwdInputBgIV.backgroundColor =Queen_HIGreenColor;
//    _JPBaoFu_pwdInputBgIV.layer.borderColor = Queen_HILineColor.CGColor;
//    _JPBaoFu_pwdInputBgIV.layer.borderWidth = 0.8;
//    _JPBaoFu_pwdInputBgIV.layer.cornerRadius = 7.0;
//    _JPBaoFu_pwdInputBgIV.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_pwdInputBgIV];
    _JPBaoFu_pwd1InputBgIV = [[UIImageView alloc] init];
    _JPBaoFu_pwd1InputBgIV.backgroundColor =Queen_HIGreenColor;
//    _JPBaoFu_pwd1InputBgIV.layer.borderColor = Queen_HILineColor.CGColor;
//    _JPBaoFu_pwd1InputBgIV.layer.borderWidth = 0.8;
//    _JPBaoFu_pwd1InputBgIV.layer.cornerRadius = 7.0;
//    _JPBaoFu_pwd1InputBgIV.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_pwd1InputBgIV];
    self.JPBaoFu_accountIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_yx_icon"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountIcon];
    self.JPBaoFu_accountField = [UITextField new];
    _JPBaoFu_accountField.delegate = self;
    _JPBaoFu_accountField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_accountField.textColor = Queen_HIDarkBlackColor;\
    _JPBaoFu_accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_accountField.keyboardType = UIKeyboardTypeEmailAddress;
    _JPBaoFu_accountField.placeholder = Queen_HLocalizedString(Queen_HIBindEmailViewEmailText);
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountField];
    self.JPBaoFu_verifyIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_verifyIcon];
    self.JPBaoFu_verifyField = [UITextField new];
    _JPBaoFu_verifyField.delegate = self;
    _JPBaoFu_verifyField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_verifyField.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_verifyField.placeholder = Queen_HLocalizedString(Queen_HIBindEmailViewVerificationCodeText);
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_verifyField];
    self.JPBaoFu_pwdIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_pwdIcon];
    self.JPBaoFu_pwdField = [UITextField new];
    _JPBaoFu_pwdField.delegate = self;
    _JPBaoFu_pwdField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_pwdField.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_pwdField.placeholder = @"Pass mới";
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_pwdField];
    self.JPBaoFu_pwd1Icon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_pwd1Icon];
    self.JPBaoFu_pwd1Field = [UITextField new];
    _JPBaoFu_pwd1Field.delegate = self;
    _JPBaoFu_pwd1Field.font = Queen_HTBoldMediaFont;
    _JPBaoFu_pwd1Field.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_pwd1Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_pwd1Field.placeholder = @"Nhập lại Pass";
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_pwd1Field];
    self.JPBaoFu_sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_sendBtn  setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_JPBaoFu_sendBtn setBackgroundColor:Queen_HIGreenColor];
    _JPBaoFu_sendBtn.titleLabel.font = Queen_HTSmallFont;
    _JPBaoFu_sendBtn.layer.cornerRadius = 2.0;
    _JPBaoFu_sendBtn.layer.masksToBounds = YES;
    [_JPBaoFu_sendBtn addTarget:self action:@selector(JPBaoFu_obtainVerificationCode) forControlEvents:(UIControlEventTouchUpInside)];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_sendBtn];
    self.JPBaoFu_linkBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_linkBtn  setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_JPBaoFu_linkBtn setBackgroundColor:Queen_HIGreenColor];
    _JPBaoFu_linkBtn.titleLabel.font = Queen_HTBoldMediaFont;
    _JPBaoFu_linkBtn.layer.cornerRadius = 7.0;
    _JPBaoFu_linkBtn.layer.masksToBounds = YES;
    [_JPBaoFu_linkBtn addTarget:self action:@selector(JPBaoFu_linkOperation) forControlEvents:(UIControlEventTouchUpInside)];
    [self.JPBaoFu_contentView addSubview:_JPBaoFu_linkBtn];
}
- (void)JPBaoFu_configViews {
    [self.JPBaoFu_navBtn setImage:[QueenUtils quImageWithName:@"View_close"] forState:(UIControlStateNormal)];
    self.JPBaoFu_navTitle.text = Queen_HLocalizedString(Queen_HIBindEmailViewNavTtileText);
    [self.JPBaoFu_sendBtn setTitle:Queen_HLocalizedString(Queen_HIBindEmailViewSendText) forState:(UIControlStateNormal)];
    [self.JPBaoFu_linkBtn setTitle:Queen_HLocalizedString(Queen_HIBindEmailViewLinkText) forState:(UIControlStateNormal)];
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
        make.width.mas_equalTo([weakSelf JPBaoFu_obtainMaxWidth]);
        make.bottom.mas_equalTo(weakSelf.JPBaoFu_linkBtn.mas_bottom).offset(2*Queen_HMargin);
    }];
    [self.JPBaoFu_navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(-Queen_HMargin);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_navTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.JPBaoFu_navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(15);
        make.top.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(1.5*Queen_HMargin);
    }];
    [self.JPBaoFu_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(-2*Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(1.5*Queen_HMargin);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight*4 + 10*3);
    }];
    [self.JPBaoFu_accountInputBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(JPBaoFu_cInputFieldHeight-1);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(1);
    }];
    [self.JPBaoFu_codeInputBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_accountInputBgIV.mas_bottom).offset(10.0+JPBaoFu_cInputFieldHeight);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(1);
    }];
    [self.JPBaoFu_pwdInputBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_codeInputBgIV.mas_bottom).offset(10.0+JPBaoFu_cInputFieldHeight);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(1);
    }];
    [self.JPBaoFu_pwd1InputBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_pwdInputBgIV.mas_bottom).offset(10.0+JPBaoFu_cInputFieldHeight);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(1);
    }];
    [self.JPBaoFu_accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_accountInputBgIV);
        
        make.top.mas_equalTo(JPBaoFu_cInputFieldHeight/2-9.5);
    }];
    [self.JPBaoFu_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_accountIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_sendBtn.mas_left).offset(-Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_top).offset(JPBaoFu_cInputFieldHeight/2);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
        make.size.mas_equalTo(CGSizeMake(45, 20));
    }];
    
    
    [self.JPBaoFu_verifyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_codeInputBgIV);
        
        make.top.mas_equalTo(weakSelf.JPBaoFu_accountInputBgIV.mas_bottom).offset(JPBaoFu_cInputFieldHeight/2-9.5+13);
    }];
    [self.JPBaoFu_verifyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_verifyIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
//        make.top.mas_equalTo(weakSelf.JPBaoFu_codeInputBgIV);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_verifyIcon);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_pwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_pwdInputBgIV);
        
        make.top.mas_equalTo(weakSelf.JPBaoFu_codeInputBgIV.mas_bottom).offset(JPBaoFu_cInputFieldHeight/2-9.5+13);
    }];
    [self.JPBaoFu_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_pwdIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
//        make.top.mas_equalTo(weakSelf.JPBaoFu_pwdInputBgIV);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_pwdIcon);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_pwd1Icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
//        make.centerY.mas_equalTo(weakSelf.JPBaoFu_pwd1InputBgIV);
        make.top.mas_equalTo(weakSelf.JPBaoFu_pwdInputBgIV.mas_bottom).offset(JPBaoFu_cInputFieldHeight/2-9.5+13);
    }];
    [self.JPBaoFu_pwd1Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_pwd1Icon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
//        make.top.mas_equalTo(weakSelf.JPBaoFu_pwd1InputBgIV);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_pwd1Icon);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_bottom).offset(1.5*Queen_HMargin);
        make.height.mas_equalTo(JPBaoFu_cInputButtonHeight);
    }];
    [self layoutIfNeeded];
}
- (void)Queen_refreshMainView {
    JPBaoFu_YJWeakSelf
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.JPBaoFu_context);
        make.size.mas_equalTo(CGSizeMake(JPBaoFu_SCREENWIDTH, JPBaoFu_SCREENHEIGHT));
    }];
}
#pragma mark - Click Events
- (void)JPBaoFu_closeView {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_bindYKAccViewClickReturnEvent)]) {
        [self.delegate JPBaoFu_bindYKAccViewClickReturnEvent];
    }
}
- (void)JPBaoFu_linkOperation {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_bindYKAccViewClickLinkEvent:password:password2:verifyCode:)]) {
        [self.delegate JPBaoFu_bindYKAccViewClickLinkEvent:self.JPBaoFu_accountField.text password:self.JPBaoFu_pwdField.text password2:self.JPBaoFu_pwd1Field.text verifyCode:self.JPBaoFu_verifyField.text];
    }
}
- (void)JPBaoFu_obtainVerificationCode {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_bindYKAccViewClickSendCodeEvent:callback:)]) {
        [self.delegate JPBaoFu_bindYKAccViewClickSendCodeEvent:self.JPBaoFu_accountField.text callback:^{
            [UIView animateWithDuration:0.25 animations:^{
                self.JPBaoFu_sendBtn.userInteractionEnabled = NO;
                self.JPBaoFu_sendBtn.layer.cornerRadius = 0.0;
                self.JPBaoFu_sendBtn.layer.masksToBounds = NO;
                [self.JPBaoFu_sendBtn setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
                [self.JPBaoFu_sendBtn setBackgroundColor:[UIColor clearColor]];
                [self.JPBaoFu_sendBtn setTitle:[NSString stringWithFormat:@"%ziS",BbindCountdownTime] forState:(UIControlStateNormal)];
                [self.JPBaoFu_sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(30,30));
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self QueenShowCountdownAnimation];
            }];
        }];
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
        if (contentViewMaxW > JPBaoFu_BindEmailViewsuitableW1) {
            contentViewMaxW = JPBaoFu_BindEmailViewsuitableW1;
        }
        return contentViewMaxW;
    }else {
        return JPBaoFu_BindEmailViewsuitableW1;
    }
}
- (void)QueenShowCountdownAnimation {
    [self JPBaoFu_drawbackViewForCountdownView];
    self.JPBaoFu_currentNumber = BbindCountdownTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    int64_t interval = (int64_t)(1 * NSEC_PER_SEC);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_timer(source, start, interval, 0);
    dispatch_source_set_event_handler(source, ^{
        self.JPBaoFu_currentNumber--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.JPBaoFu_sendBtn setTitle:[NSString stringWithFormat:@"%ziS",self.JPBaoFu_currentNumber] forState:(UIControlStateNormal)];
            self.JPBaoFu_bindShape.strokeEnd = 1.0 - (self.JPBaoFu_currentNumber*1.0/BbindCountdownTime);
        });
        if (self.JPBaoFu_currentNumber <= 0) {
            dispatch_source_cancel(source);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.JPBaoFu_bindBackLayer removeFromSuperlayer];
                [self.JPBaoFu_bindShape removeFromSuperlayer];
                [UIView animateWithDuration:0.25 animations:^{
                    self.JPBaoFu_sendBtn.layer.cornerRadius = 2.0;
                    self.JPBaoFu_sendBtn.layer.masksToBounds = YES;
                    [self.JPBaoFu_sendBtn setTitle:@"Send" forState:(UIControlStateNormal)];
                    [self.JPBaoFu_sendBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    [self.JPBaoFu_sendBtn setBackgroundColor:Queen_HIGreenColor];
                    CGSize resendSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_sendBtn.titleLabel.text font:self.JPBaoFu_sendBtn.titleLabel.font maxW:JPBaoFu_SCREENWIDTH];
                    [self.JPBaoFu_sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(resendSize.width + Queen_HMargin, resendSize.height + Queen_HMargin/2));
                    }];
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.JPBaoFu_sendBtn.userInteractionEnabled = YES;
                }];
            });
        }
    });
    dispatch_resume(source);
}
- (void)JPBaoFu_drawbackViewForCountdownView {
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    self.JPBaoFu_bindBackLayer = backLayer;
    backLayer.frame = CGRectMake(0, 0, 30, 30);
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.lineWidth = 1.5;
    backLayer.strokeColor = Queen_HILineColor.CGColor;
    backLayer.strokeStart = 0.0f;
    backLayer.strokeEnd = 1.0f;
    backLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 30, 30)].CGPath;
    self.JPBaoFu_bindShape = [CAShapeLayer layer];
    _JPBaoFu_bindShape.frame = backLayer.frame;
    _JPBaoFu_bindShape.fillColor = [UIColor clearColor].CGColor;
    _JPBaoFu_bindShape.lineWidth = backLayer.lineWidth;
    _JPBaoFu_bindShape.strokeColor = Queen_HIGreenColor.CGColor;
    _JPBaoFu_bindShape.strokeStart = 0.0f;
    _JPBaoFu_bindShape.strokeEnd = 0.0f;
    _JPBaoFu_bindShape.path = backLayer.path;
    _JPBaoFu_bindShape.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    [self.JPBaoFu_sendBtn.layer addSublayer:backLayer];
    [self.JPBaoFu_sendBtn.layer addSublayer:_JPBaoFu_bindShape];
}
- (void)JPBaoFu_appGoBackgroud{
    self.JPBaoFu_goBackgroundDate = [NSDate date];
}
- (void)JPBaoFu_appGoForegroud{
    NSTimeInterval timeGone = [[NSDate date] timeIntervalSinceDate:self.JPBaoFu_goBackgroundDate];
    self.JPBaoFu_currentNumber = self.JPBaoFu_currentNumber - timeGone;
    if (self.JPBaoFu_currentNumber <= 0) {
        self.JPBaoFu_currentNumber = 0;
    }
    if (![self.JPBaoFu_sendBtn.titleLabel.text isEqualToString:@"Send"]) {
        [self.JPBaoFu_sendBtn setTitle:[NSString stringWithFormat:@"%ziS",self.JPBaoFu_currentNumber] forState:(UIControlStateNormal)];
        self.JPBaoFu_bindShape.strokeEnd = 1.0 - (self.JPBaoFu_currentNumber*1.0/BbindCountdownTime);
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
