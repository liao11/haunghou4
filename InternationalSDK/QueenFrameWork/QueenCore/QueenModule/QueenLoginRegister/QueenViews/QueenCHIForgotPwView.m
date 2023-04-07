#import "QueenCHIForgotPwView.h"
CGFloat const JPBaoFu_ForgotPwViewsuitableW = 340;
NSInteger const JPBaoFu_countdownTime = 60;
@interface QueenCHIForgotPwView () <UITextFieldDelegate,CAAnimationDelegate>
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) UILabel *JPBaoFu_navTitle;
@property (nonatomic, strong) UIButton *JPBaoFu_navBtn;
@property (nonatomic, strong) UIView *JPBaoFu_navLine;
@property (nonatomic, strong) UILabel *JPBaoFu_inputTitle;
@property (nonatomic, strong) UIView *JPBaoFu_inputView;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView1;
@property (nonatomic, strong) UIImageView *JPBaoFu_inputTextBgView2;
@property (nonatomic, strong) UIImageView *JPBaoFu_verifyIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_verifyField;
@property (nonatomic, strong) UIImageView *JPBaoFu_passwordIcon;
@property (nonatomic, strong) UITextField *JPBaoFu_passwordField;
@property (nonatomic, strong) UIButton *JPBaoFu_countdownBtn;
@property (nonatomic, strong) CAShapeLayer *JPBaoFu_countdownShape;
@property (nonatomic, strong) CAShapeLayer *JPBaoFu_countdownBackLayer;
@property (nonatomic, strong) UIButton *JPBaoFu_submitBtn;
@property (nonatomic, strong) NSDictionary *JPBaoFu_data;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFT;
@property (nonatomic, assign) BOOL JPBaoFu_isActivityFB;
@property (nonatomic, strong) NSDate *JPBaoFu_goBackgroundDate;
@property (nonatomic, assign) NSInteger JPBaoFu_currentNumber;
@end
@implementation QueenCHIForgotPwView
+ (instancetype)QueenShowForgotPwViewInContext:(UIView *)context data:(NSDictionary *)data {
    QueenCHIForgotPwView *forgotPwView = [[QueenCHIForgotPwView alloc] init];
    [context addSubview:forgotPwView];
    forgotPwView.JPBaoFu_context = context;
    forgotPwView.JPBaoFu_data = data;
    [forgotPwView JPBaoFu_setupViews];
    [forgotPwView JPBaoFu_configViews];
    [forgotPwView JPBaoFu_displayViews];
    [[NSNotificationCenter defaultCenter] addObserver:forgotPwView selector:@selector(JPBaoFu_appGoBackgroud) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:forgotPwView selector:@selector(JPBaoFu_appGoForegroud) name:UIApplicationWillEnterForegroundNotification object:nil];
    return forgotPwView;
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
    _JPBaoFu_inputTitle.font = Queen_HTBoldSmallFont;
    _JPBaoFu_inputTitle.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_inputTitle.numberOfLines = 0;
    [self addSubview:_JPBaoFu_inputTitle];
    self.JPBaoFu_countdownBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _JPBaoFu_countdownBtn.titleLabel.font = Queen_HTSmallFont;
    _JPBaoFu_countdownBtn.backgroundColor = [UIColor clearColor];
    [_JPBaoFu_countdownBtn setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
    _JPBaoFu_countdownBtn.userInteractionEnabled = NO;
    [_JPBaoFu_countdownBtn addTarget:self action:@selector(JPBaoFu_obtainVerificationCode) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_countdownBtn];
    self.JPBaoFu_inputView = [UIView new];
    [self addSubview:_JPBaoFu_inputView];
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
    self.JPBaoFu_verifyIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_verifyIcon];
    self.JPBaoFu_verifyField = [UITextField new];
    _JPBaoFu_verifyField.delegate = self;
    _JPBaoFu_verifyField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_verifyField.textColor = Queen_HIDarkBlackColor;\
    _JPBaoFu_verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_verifyField.keyboardType = UIKeyboardTypeEmailAddress;
    _JPBaoFu_verifyField.placeholder = Queen_HLocalizedString(Queen_HIForgotPwViewVerificationText);
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_verifyField];
    self.JPBaoFu_passwordIcon = [[UIImageView alloc] initWithImage:[QueenUtils quImageWithName:@"cnm_pwd_lock"]];
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_passwordIcon];
    self.JPBaoFu_passwordField = [UITextField new];
    _JPBaoFu_passwordField.delegate = self;
    _JPBaoFu_passwordField.font = Queen_HTBoldMediaFont;
    _JPBaoFu_passwordField.textColor = Queen_HIDarkBlackColor;
    _JPBaoFu_passwordField.secureTextEntry = YES;
    _JPBaoFu_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _JPBaoFu_passwordField.placeholder = Queen_HLocalizedString(Queen_HIForgotPwViewPasswordText);
    [self.JPBaoFu_inputView addSubview:_JPBaoFu_passwordField];
    self.JPBaoFu_submitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_submitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_JPBaoFu_submitBtn setBackgroundColor:Queen_HIGreenColor];
    _JPBaoFu_submitBtn.titleLabel.font = Queen_HTBoldMediaFont;
    _JPBaoFu_submitBtn.layer.cornerRadius = 7.0;
    _JPBaoFu_submitBtn.layer.masksToBounds = YES;
    [_JPBaoFu_submitBtn addTarget:self action:@selector(JPBaoFu_submitOperation) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_submitBtn];
}
- (void)JPBaoFu_configViews {
    self.JPBaoFu_navTitle.text = Queen_HLocalizedString(Queen_HIForgotPwViewNavTitleText);
    [self.JPBaoFu_navBtn setImage:[QueenUtils quImageWithName:@"arrowLeft"] forState:(UIControlStateNormal)];
    self.JPBaoFu_inputTitle.text = [NSString stringWithFormat:@"%@%@",Queen_HLocalizedString(Queen_HIForgotPwViewInputTitleText),[self.JPBaoFu_data objectForKey:Queen_HIForgotPwViewEmailData]];
    [self.JPBaoFu_submitBtn setTitle:Queen_HLocalizedString(Queen_HIForgotPwViewSubmitText) forState:(UIControlStateNormal)];
    [self.JPBaoFu_countdownBtn setTitle:[NSString stringWithFormat:@"%ziS",JPBaoFu_countdownTime] forState:(UIControlStateNormal)];
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(Queen_HMargin);
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_navTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.JPBaoFu_navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf).offset(15);
        make.top.mas_equalTo(weakSelf).offset(2.5*Queen_HMargin);
    }];
    [self.JPBaoFu_navLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(Queen_HMargin);
        make.left.mas_equalTo(weakSelf).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf).offset(-2*Queen_HMargin);
        make.height.mas_equalTo(0.5);
    }];
    [self.JPBaoFu_inputTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_navLine).offset(Queen_HMargin);
        make.left.mas_equalTo(weakSelf.JPBaoFu_navLine).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_countdownBtn.mas_left).offset(-Queen_HMargin);
    }];
    [self.JPBaoFu_countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTitle);
        make.right.mas_equalTo(weakSelf.JPBaoFu_navLine).mas_equalTo(-Queen_HMargin);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.JPBaoFu_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf).offset(-2*Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTitle.mas_bottom).offset(Queen_HMargin);
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
    [self.JPBaoFu_verifyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView1);
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
    }];
    [self.JPBaoFu_verifyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_verifyIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputView);
        make.height.mas_equalTo(JPBaoFu_cInputFieldHeight);
    }];
    [self.JPBaoFu_passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 19));
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        make.left.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(Queen_HMargin);
    }];
    [self.JPBaoFu_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_passwordIcon.mas_right).offset(Queen_HMargin);
        make.right.mas_equalTo(weakSelf.JPBaoFu_inputView).offset(-Queen_HMargin);
        make.top.mas_equalTo(weakSelf.JPBaoFu_inputTextBgView2);
        make.bottom.mas_equalTo(weakSelf.JPBaoFu_inputView.mas_bottom);
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
}
#pragma mark - Click Events
- (void)JPBaoFu_returnBack {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_forgotPwViewClickReturnEvents)]) {
        [self.delegate JPBaoFu_forgotPwViewClickReturnEvents];
    }
}
- (void)JPBaoFu_submitOperation {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_forgotPwViewClickSubmitEvent:inputCode:newPassword:)]) {
        [self.delegate JPBaoFu_forgotPwViewClickSubmitEvent:[self.JPBaoFu_data objectForKey:Queen_HIForgotPwViewEmailData] inputCode:self.JPBaoFu_verifyField.text newPassword:self.JPBaoFu_passwordField.text];
    }
}
- (void)JPBaoFu_obtainVerificationCode {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_forgotPwViewClickSendCodeEvent:callback:)]) {
        [self.delegate JPBaoFu_forgotPwViewClickSendCodeEvent:[self.JPBaoFu_data objectForKey:Queen_HIForgotPwViewEmailData] callback:^{
            [UIView animateWithDuration:0.25 animations:^{
                self.JPBaoFu_countdownBtn.userInteractionEnabled = NO;
                self.JPBaoFu_countdownBtn.layer.cornerRadius = 0.0;
                self.JPBaoFu_countdownBtn.layer.masksToBounds = NO;
                [self.JPBaoFu_countdownBtn setTitleColor:Queen_HIGreenColor forState:(UIControlStateNormal)];
                [self.JPBaoFu_countdownBtn setBackgroundColor:[UIColor clearColor]];
                [self.JPBaoFu_countdownBtn setTitle:[NSString stringWithFormat:@"%ziS",JPBaoFu_countdownTime] forState:(UIControlStateNormal)];
                [self.JPBaoFu_countdownBtn mas_updateConstraints:^(MASConstraintMaker *make) {
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
        if (contentViewMaxW > JPBaoFu_ForgotPwViewsuitableW) {
            contentViewMaxW = JPBaoFu_ForgotPwViewsuitableW;
        }
        return contentViewMaxW;
    }else {
        return JPBaoFu_ForgotPwViewsuitableW;
    }
}
- (void)JPBaoFu_drawbackViewForCountdownView {
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    self.JPBaoFu_countdownBackLayer = backLayer;
    backLayer.frame = CGRectMake(0, 0, 30, 30);
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.lineWidth = 1.5;
    backLayer.strokeColor = Queen_HILineColor.CGColor;
    backLayer.strokeStart = 0.0f;
    backLayer.strokeEnd = 1.0f;
    backLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 30, 30)].CGPath;
    self.JPBaoFu_countdownShape = [CAShapeLayer layer];
    _JPBaoFu_countdownShape.frame = backLayer.frame;
    _JPBaoFu_countdownShape.fillColor = [UIColor clearColor].CGColor;
    _JPBaoFu_countdownShape.lineWidth = backLayer.lineWidth;
    _JPBaoFu_countdownShape.strokeColor = Queen_HIGreenColor.CGColor;
    _JPBaoFu_countdownShape.strokeStart = 0.0f;
    _JPBaoFu_countdownShape.strokeEnd = 0.0f;
    _JPBaoFu_countdownShape.path = backLayer.path;
    _JPBaoFu_countdownShape.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    [self.JPBaoFu_countdownBtn.layer addSublayer:backLayer];
    [self.JPBaoFu_countdownBtn.layer addSublayer:_JPBaoFu_countdownShape];
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
    if (![self.JPBaoFu_countdownBtn.titleLabel.text isEqualToString:@"Resend"]) {
        [self.JPBaoFu_countdownBtn setTitle:[NSString stringWithFormat:@"%ziS",self.JPBaoFu_currentNumber] forState:(UIControlStateNormal)];
        self.JPBaoFu_countdownShape.strokeEnd = 1.0 - (self.JPBaoFu_currentNumber*1.0/JPBaoFu_countdownTime);
    }
}
#pragma mark - Public
- (void)QueenShowCountdownAnimation {
    [self JPBaoFu_drawbackViewForCountdownView];
    self.JPBaoFu_currentNumber = JPBaoFu_countdownTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    int64_t interval = (int64_t)(1 * NSEC_PER_SEC);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_timer(source, start, interval, 0);
    dispatch_source_set_event_handler(source, ^{
        self.JPBaoFu_currentNumber--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.JPBaoFu_countdownBtn setTitle:[NSString stringWithFormat:@"%ziS",self.JPBaoFu_currentNumber] forState:(UIControlStateNormal)];
            self.JPBaoFu_countdownShape.strokeEnd = 1.0 - (self.JPBaoFu_currentNumber*1.0/JPBaoFu_countdownTime);
        });
        if (self.JPBaoFu_currentNumber <= 0) {
            dispatch_source_cancel(source);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.JPBaoFu_countdownBackLayer removeFromSuperlayer];
                [self.JPBaoFu_countdownShape removeFromSuperlayer];
                [UIView animateWithDuration:0.25 animations:^{
                    self.JPBaoFu_countdownBtn.layer.cornerRadius = 2.0;
                    self.JPBaoFu_countdownBtn.layer.masksToBounds = YES;
                    [self.JPBaoFu_countdownBtn setTitle:@"Resend" forState:(UIControlStateNormal)];
                    [self.JPBaoFu_countdownBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    [self.JPBaoFu_countdownBtn setBackgroundColor:Queen_HIGreenColor];
                    CGSize resendSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_countdownBtn.titleLabel.text font:self.JPBaoFu_countdownBtn.titleLabel.font maxW:JPBaoFu_SCREENWIDTH];
                    [self.JPBaoFu_countdownBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(resendSize.width + Queen_HMargin, resendSize.height + Queen_HMargin/2));
                    }];
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.JPBaoFu_countdownBtn.userInteractionEnabled = YES;
                }];
            });
        }
    });
    dispatch_resume(source);
}
#pragma mark - CAAnimationDelegate
- (void)JPBaoFu_animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.JPBaoFu_countdownShape removeAllAnimations];
    [self.JPBaoFu_countdownBackLayer removeFromSuperlayer];
    [self.JPBaoFu_countdownShape removeFromSuperlayer];
    [self.JPBaoFu_countdownBtn setTitle:@"Resend" forState:(UIControlStateNormal)];
    [self.JPBaoFu_countdownBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.JPBaoFu_countdownBtn setBackgroundColor:Queen_HIGreenColor];
    CGSize resendSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_countdownBtn.titleLabel.text font:self.JPBaoFu_countdownBtn.titleLabel.font maxW:JPBaoFu_SCREENWIDTH];
     [UIView animateWithDuration:0.25 animations:^{
         [self.JPBaoFu_countdownBtn mas_updateConstraints:^(MASConstraintMaker *make) {
             make.size.mas_equalTo(CGSizeMake(resendSize.width + Queen_HMargin, resendSize.height + Queen_HMargin/2));
         }];
         [self layoutIfNeeded];
     } completion:^(BOOL finished) {
         self.JPBaoFu_countdownBtn.userInteractionEnabled = YES;
     }];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
