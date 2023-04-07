#import "QueenCHIBindEmailView.h"
CGFloat const JPBaoFu_BindEmailViewsuitableW = 340;
NSInteger const JPBaoFu_bindCountdownTime = 60;
@interface QueenCHIBindEmailView () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) UIView *JPBaoFu_contentView;
@property (nonatomic, strong) UILabel *JPBaoFu_navTitle;
@property (nonatomic, strong) UIButton *JPBaoFu_navBtn;
@property (nonatomic, strong) UIView *JPBaoFu_inputView;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView1;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView2;
@property (nonatomic, strong) UIImageView *JPBaoFu_accountIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_accountField;
@property (nonatomic, strong) UIImageView *JPBaoFu_verifyIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_verifyField;
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
@implementation QueenCHIBindEmailView
+ (instancetype)QueenShowBindEmailViewInContext:(UIView *)context email:(NSString *)email{
    QueenCHIBindEmailView *bindEmailView = [[QueenCHIBindEmailView alloc] init];
    [context addSubview:bindEmailView];
    bindEmailView.JPBaoFu_context = context;
    bindEmailView.JPBaoFu_bindEmail = email;
    [bindEmailView JPBaoFu_setupViews];
    [bindEmailView JPBaoFu_configViews];
    [bindEmailView JPBaoFu_displayViews];
    [[NSNotificationCenter defaultCenter] addObserver:bindEmailView selector:@selector(JPBaoFu_appGoBackgroud) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:bindEmailView selector:@selector(JPBaoFu_appGoForegroud) name:UIApplicationWillEnterForegroundNotification object:nil];
    return bindEmailView;
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
    _JPBaoFu_inputTextBgView1 = [[UIImageView alloc] init];
_JPBaoFu_inputTextBgView1.backgroundColor = [UIColor whiteColor];
_JPBaoFu_inputTextBgView1.layer.borderColor = Queen_HILineColor.CGColor;
_JPBaoFu_inputTextBgView1.layer.borderWidth = 1.0;
_JPBaoFu_inputTextBgView1.layer.cornerRadius = 7.0;
_JPBaoFu_inputTextBgView1.layer.masksToBounds = YES;
[self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextBgView1];
    _JPBaoFu_inputTextBgView2 = [[UIImageView alloc] init];
_JPBaoFu_inputTextBgView2.backgroundColor = [UIColor whiteColor];
_JPBaoFu_inputTextBgView2.layer.borderColor = Queen_HILineColor.CGColor;
_JPBaoFu_inputTextBgView2.layer.borderWidth = 1.0;
_JPBaoFu_inputTextBgView2.layer.cornerRadius = 7.0;
_JPBaoFu_inputTextBgView2.layer.masksToBounds = YES;
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_inputTextBgView2];
    self.JPBaoFu_accountIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_yx_icon"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_accountIcon];
    self.JPBaoFu_accountField = [UITextField new];
    _JPBaoFu_accountField.delegate = self;
    _JPBaoFu_accountField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_accountField.textColor = Queen_HIDarkBlackColor;\
    _JPBaoFu_accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_accountField.keyboardType = UIKeyboardTypeEmailAddress;
    self.JPBaoFu_accountField.placeholder = Queen_HLocalizedString(Queen_HILoginViewEmailText);
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
    self.JPBaoFu_accountField.text = self.JPBaoFu_bindEmail;
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
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight*2+15);
    }];
    [self.JPBaoFu_inputTextBgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_inputTextBgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1.mas_bottom).offset(13.0);
        make.width.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1);
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
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
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
    }];
    [self.JPBaoFu_verifyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_verifyIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
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
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_bindEmailViewClickReturnEvent)]) {
        [self.delegate JPBaoFu_bindEmailViewClickReturnEvent];
    }
}
- (void)JPBaoFu_linkOperation {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_bindEmailViewClickLinkEvent:verifyCode:)]) {
        [self.delegate JPBaoFu_bindEmailViewClickLinkEvent:self.JPBaoFu_accountField.text verifyCode:self.JPBaoFu_verifyField.text];
    }
}
- (void)JPBaoFu_obtainVerificationCode {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_bindEmailViewClickSendCodeEvent:callback:)]) {
        [self.delegate JPBaoFu_bindEmailViewClickSendCodeEvent:self.JPBaoFu_accountField.text callback:^{
            [UIView animateWithDuration:0.25 animations:^{
                self.JPBaoFu_sendBtn.userInteractionEnabled = NO;
                self.JPBaoFu_sendBtn.layer.cornerRadius = 0.0;
                self.JPBaoFu_sendBtn.layer.masksToBounds = NO;
                [self.JPBaoFu_sendBtn setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
                [self.JPBaoFu_sendBtn setBackgroundColor:[UIColor clearColor]];
                [self.JPBaoFu_sendBtn setTitle:[NSString stringWithFormat:@"%ziS",JPBaoFu_bindCountdownTime] forState:(UIControlStateNormal)];
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
        if (contentViewMaxW > JPBaoFu_BindEmailViewsuitableW) {
            contentViewMaxW = JPBaoFu_BindEmailViewsuitableW;
        }
        return contentViewMaxW;
    }else {
        return JPBaoFu_BindEmailViewsuitableW;
    }
}
- (void)QueenShowCountdownAnimation {
    [self JPBaoFu_drawbackViewForCountdownView];
    self.JPBaoFu_currentNumber = JPBaoFu_bindCountdownTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    int64_t interval = (int64_t)(1 * NSEC_PER_SEC);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_timer(source, start, interval, 0);
    dispatch_source_set_event_handler(source, ^{
        self.JPBaoFu_currentNumber--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.JPBaoFu_sendBtn setTitle:[NSString stringWithFormat:@"%ziS",self.JPBaoFu_currentNumber] forState:(UIControlStateNormal)];
            self.JPBaoFu_bindShape.strokeEnd = 1.0 - (self.JPBaoFu_currentNumber*1.0/JPBaoFu_bindCountdownTime);
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
        self.JPBaoFu_bindShape.strokeEnd = 1.0 - (self.JPBaoFu_currentNumber*1.0/JPBaoFu_bindCountdownTime);
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
