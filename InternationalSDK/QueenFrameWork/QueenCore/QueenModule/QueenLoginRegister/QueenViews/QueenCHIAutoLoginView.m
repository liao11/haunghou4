#import "QueenCHIAutoLoginView.h"
@interface QueenCHIAutoLoginView ()
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) UILabel *JPBaoFu_viewLabel;
@property (nonatomic, strong) UIButton *JPBaoFu_switchBtn;
@property (nonatomic, strong) UIImageView *JPBaoFu_loadingRotateView;
@property (nonatomic, copy) NSString *JPBaoFu_account;
@end
@implementation QueenCHIAutoLoginView
+ (instancetype)QueenShowAutoLoginViewInContext:(UIView *)context account:(NSString *)account {
    QueenCHIAutoLoginView *autoLoginView = [[QueenCHIAutoLoginView alloc] init];
    [context addSubview:autoLoginView];
    autoLoginView.JPBaoFu_context = context;
    autoLoginView.JPBaoFu_account = account;
    [autoLoginView JPBaoFu_setupViews];
    [autoLoginView JPBaoFu_configViews];
    [autoLoginView JPBaoFu_displayViews];
    return autoLoginView;
}
#pragma mark - Config
- (void)JPBaoFu_setupViews {
    self.layer.cornerRadius = 7.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = Queen_HILucencyWhiteColor;
    self.JPBaoFu_viewLabel = [UILabel new];
    _JPBaoFu_viewLabel.font = Queen_HTBoldMediaFont;
    _JPBaoFu_viewLabel.textColor = Queen_HILightBlackColor;
    _JPBaoFu_viewLabel.numberOfLines = 0;
    [self addSubview:_JPBaoFu_viewLabel];
    self.JPBaoFu_switchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _JPBaoFu_switchBtn.titleLabel.font = Queen_HINavTitleFont;
    [_JPBaoFu_switchBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_JPBaoFu_switchBtn setBackgroundColor:Queen_HIGreenColor];
    _JPBaoFu_switchBtn.layer.cornerRadius = 5.0;
    _JPBaoFu_switchBtn.layer.masksToBounds = YES;
//    [_JPBaoFu_switchBtn setBackgroundImage:[QueenUtils quImageWithName:@"cnm_btn_image"] forState:UIControlStateNormal];
    [_JPBaoFu_switchBtn addTarget:self action:@selector(JPBaoFu_switchAccountWithLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_JPBaoFu_switchBtn];
    self.JPBaoFu_loadingRotateView = [UIImageView new];
    _JPBaoFu_loadingRotateView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_JPBaoFu_loadingRotateView];
}
- (void)JPBaoFu_configViews {
    NSString *labelText = [NSString stringWithFormat:@"%@\n%@",Queen_HLocalizedString(Queen_HIAutoLoginViewNavTitleText),self.JPBaoFu_account];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:Queen_HMargin];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    [attributedString addAttribute:NSFontAttributeName value:self.JPBaoFu_viewLabel.font range:NSMakeRange(0, [labelText length])];
    self.JPBaoFu_viewLabel.attributedText = attributedString;
    [self.JPBaoFu_switchBtn setTitle:Queen_HLocalizedString(Queen_HIAutoLoginViewSwitchText) forState:(UIControlStateNormal)];
    self.JPBaoFu_loadingRotateView.image = [QueenUtils quImageWithName:@"Hud_Rotation"];
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    [self.JPBaoFu_viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(1.5*Queen_HMargin);
        make.left.and.right.mas_equalTo(weakSelf);
    }];
    [self.JPBaoFu_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_viewLabel.mas_bottom).offset(1.5*Queen_HMargin);
        make.centerX.mas_equalTo(weakSelf.JPBaoFu_viewLabel);
        make.size.mas_equalTo(CGSizeMake(168, 30));
    }];
    [self.JPBaoFu_loadingRotateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.JPBaoFu_switchBtn);
        make.right.mas_equalTo(weakSelf.JPBaoFu_switchBtn.mas_left).offset(-1.5*Queen_HMargin);
        make.size.mas_equalTo(CGSizeMake(20,20));
    }];
    [self layoutIfNeeded];
}
- (void)Queen_refreshMainView {
    JPBaoFu_YJWeakSelf
    CGSize switchSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_switchBtn.titleLabel.text font:self.JPBaoFu_switchBtn.titleLabel.font maxW:JPBaoFu_SCREENWIDTH];
    if (switchSize.height > self.JPBaoFu_loadingRotateView.height) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf.JPBaoFu_context);
            make.width.mas_equalTo([weakSelf JPBaoFu_obtainMaxWidth]);
            make.bottom.mas_equalTo(weakSelf.JPBaoFu_switchBtn.mas_bottom).offset(2*Queen_HMargin);
        }];
    }else {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf.JPBaoFu_context);
            make.width.mas_equalTo([weakSelf JPBaoFu_obtainMaxWidth]);
            make.bottom.mas_equalTo(weakSelf.JPBaoFu_loadingRotateView.mas_bottom).offset(2*Queen_HMargin);
        }];
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.repeatCount = HUGE;
    rotationAnimation.duration = 1.0;
    [self.JPBaoFu_loadingRotateView.layer addAnimation:rotationAnimation forKey:@"KCBasicAnimation_Rotation_AutoLoginView"];
}
#pragma mark - Click Events
- (void)JPBaoFu_switchAccountWithLogin {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_autoLoginViewClickSwitchEvent)]) {
        [self.delegate JPBaoFu_autoLoginViewClickSwitchEvent];
    }
}
#pragma mark - Public
- (void)Queen_canClickSwitchButton:(BOOL)isEnable {
    if (isEnable) {
        [self.JPBaoFu_switchBtn setBackgroundColor:Queen_HIGreenColor];
        self.JPBaoFu_switchBtn.enabled = YES;
    }else {
        [self.JPBaoFu_switchBtn setBackgroundColor:Queen_HILineColor];
        self.JPBaoFu_switchBtn.enabled = NO;
    }
}
#pragma mark - Private
- (CGFloat)JPBaoFu_obtainMaxWidth {
    CGFloat contentViewMaxW = 0;
    CGFloat accountSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_account font:self.JPBaoFu_viewLabel.font maxW:JPBaoFu_SCREENWIDTH].width;
    CGFloat bottomSize = self.JPBaoFu_switchBtn.width + (self.JPBaoFu_loadingRotateView.width+1.5*Queen_HMargin)*2;
    if (accountSize > bottomSize) {
        contentViewMaxW = accountSize;
    }else {
        contentViewMaxW = bottomSize;
    }
    contentViewMaxW += 4*Queen_HMargin;
    return contentViewMaxW;
}
@end
