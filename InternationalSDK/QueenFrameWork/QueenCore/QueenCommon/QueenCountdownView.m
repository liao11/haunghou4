#import "QueenCountdownView.h"
#import "Queen_HMacro.h"
#import "QueenToastConst.h"
struct ViewHeight {
    CGFloat titleH;
    CGFloat contentH;
    CGFloat totleH;
};
CGFloat const skipWH = 28;
CGFloat const bottomH = 40;
CGFloat const suitableW = 340;
@interface QueenCountdownView ()<CAAnimationDelegate>
@property (nonatomic, strong) UIButton *skipBtn;
@property (strong, nonatomic) CAShapeLayer *shape;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) struct ViewHeight structHeight;
@property (nonatomic, assign) QueenCountdownType displayType;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@end
@implementation QueenCountdownView
- (instancetype)initWithTitle:(NSString *)titleInfo content:(NSString *)contentInfo InView:(UIView *)context displayType:(QueenCountdownType)displayType{
    self = [super init];
    if (self) {
        self.context = context;
        [context addSubview:self];
        self.displayType = displayType;
        [self setup];
        self.title.text = titleInfo;
        self.content.text = contentInfo;
    }
    return self;
}
- (void)setup {
    _contentView = [UIView new];
    _contentView.layer.cornerRadius = 7.0;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor = Queen_HIWhiteColor;
    _title = [UILabel new];
    _title.textColor = Queen_HIDarkBlackColor;
    _title.font = Queen_HINavTitleFont;
    _content = [UILabel new];
    _content.textColor = Queen_HILightBlackColor;
    _content.font = JPBaoFu_YJMaximumFont;
    _content.numberOfLines = 0;
    _content.textAlignment = NSTextAlignmentCenter;
    if (self.displayType == QueenCountdownTypeSkip) {
        _skipBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_skipBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
        [_skipBtn setTitleColor:Queen_HILightBlackColor forState:(UIControlStateNormal)];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_skipBtn addTarget:self action:@selector(hid) forControlEvents:(UIControlEventTouchUpInside)];
        CAShapeLayer *backLayer = [CAShapeLayer layer];
        backLayer.frame = CGRectMake(0, 0, skipWH, skipWH);
        backLayer.fillColor = [UIColor clearColor].CGColor;
        backLayer.lineWidth = 1.5;
        backLayer.strokeColor = Queen_HILineColor.CGColor;
        backLayer.strokeStart = 0.0f;
        backLayer.strokeEnd = 1.0f;
        backLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, skipWH, skipWH)].CGPath;
        self.shape = [CAShapeLayer layer];
        _shape.frame = CGRectMake(0, 0, skipWH, skipWH);
        _shape.fillColor = [UIColor clearColor].CGColor;
        _shape.lineWidth = 1.5;
        _shape.strokeColor = Queen_HIGreenColor.CGColor;
        _shape.strokeStart = 0.0f;
        _shape.strokeEnd = 0.0f;
        _shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, skipWH, skipWH)].CGPath;
        _shape.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
        [_skipBtn.layer addSublayer:backLayer];
        [_skipBtn.layer addSublayer:_shape];
    }else {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _cancelBtn.tag = 0;
        [_cancelBtn setTitle:Queen_HLocalizedString(Queen_HIAlertInquriryCancelText) forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _cancelBtn.titleLabel.font = Queen_HTBoldMediaFont;
        [_cancelBtn addTarget:self action:@selector(inquriryViewForClickOperation:) forControlEvents:(UIControlEventTouchUpInside)];
        [_cancelBtn setBackgroundColor:Queen_HIGreenColor];
        _cancelBtn.layer.cornerRadius = 2.0;
        _cancelBtn.layer.masksToBounds = YES;
        _confirmBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _confirmBtn.tag = 1;
        [_confirmBtn setTitle:Queen_HLocalizedString(Queen_HIAlertInquriryConfirmText) forState:(UIControlStateNormal)];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _confirmBtn.titleLabel.font = Queen_HTBoldMediaFont;
        [_confirmBtn addTarget:self action:@selector(inquriryViewForClickOperation:) forControlEvents:(UIControlEventTouchUpInside)];
        _confirmBtn.layer.cornerRadius = 2.0;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn setBackgroundColor:Queen_HIOrangeColor];
        [_contentView addSubview:_cancelBtn];
        [_contentView addSubview:_confirmBtn];
    }
    self.backgroundColor = JPBaoFu_YJColorRGBA(0,0,0,0.3);
    [self addSubview:_contentView];
    [_contentView addSubview:_title];
    [_contentView addSubview:_content];
    [_contentView addSubview:_skipBtn];
}
- (void)calculateInfo {
    CGSize titleSize = [self.title.text boundingRectWithSize:CGSizeMake(([self obtainMaxWidth]-bottomH - margin/2), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.title.font} context:nil].size;
    CGSize contentSize = [self.content.text boundingRectWithSize:CGSizeMake(([self obtainMaxWidth] - 3*Queen_HMargin), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.content.font} context:nil].size;
    CGFloat totleH = titleSize.height + contentSize.height;
    if (self.displayType == QueenCountdownTypeInquriry) {
        totleH += bottomH + 0.5 + 4.5*margin;
    }else {
        totleH += 4.5*margin;
    }
    struct ViewHeight height = {titleSize.height,contentSize.height,totleH};
    self.structHeight = height;
    if (self.displayType == QueenCountdownTypeInquriry && [self.content.text isEqualToString:Queen_HLocalizedString(Queen_HIAlertPayFunctionCloseText)]) {
        [_confirmBtn setTitle:Queen_HLocalizedString(Queen_HIAlertInquriryHeadForText) forState:(UIControlStateNormal)];
    }
}
- (void)layoutSubview {
    JPBaoFu_YJWeakSelf
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.context);
        make.size.mas_equalTo(CGSizeMake(JPBaoFu_SCREENWIDTH, JPBaoFu_SCREENHEIGHT));
    }];
    if (self.displayType == QueenCountdownTypeSkip) {
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake([self obtainMaxWidth], weakSelf.structHeight.totleH));
        }];
    }else {
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.width.mas_equalTo([self obtainMaxWidth]);
            make.bottom.mas_equalTo(weakSelf.cancelBtn.mas_bottom).offset(Queen_HMargin);
        }];
    }
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView).offset(1.5*Queen_HMargin);
        make.centerX.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(weakSelf.structHeight.titleH);
    }];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.title.mas_bottom).offset(Queen_HMargin);
        make.left.mas_equalTo(weakSelf.contentView).offset(1.5*Queen_HMargin);
        make.right.mas_equalTo(weakSelf.contentView).offset(-1.5*Queen_HMargin);
    }];
    if (self.displayType == QueenCountdownTypeSkip) {
        [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.title).offset(-margin/2);
            make.right.mas_equalTo(weakSelf.contentView).offset(-margin/2);
            make.size.mas_equalTo(CGSizeMake(skipWH, skipWH));
        }];
        _skipBtn.userInteractionEnabled = YES;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0.0f;
        animation.toValue = @1.0f;
        animation.repeatCount = 1;
        animation.duration = self.showTime;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [_shape addAnimation:animation forKey:@"strokeEndAnimation"];
    }else {
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.content.mas_bottom).offset(1.5*Queen_HMargin);
            make.height.mas_equalTo(JPBaoFu_cInputButtonHeight);
            make.width.mas_equalTo(weakSelf.confirmBtn);
            make.left.mas_equalTo(weakSelf.contentView).offset(2*Queen_HMargin);
            make.right.mas_equalTo(weakSelf.confirmBtn.mas_left).offset(-2*Queen_HMargin);
        }];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.and.top.mas_equalTo(weakSelf.cancelBtn);
            make.right.mas_equalTo(weakSelf.contentView).offset(-2*Queen_HMargin);
        }];
    }
}
- (void)displaySubView {
    if (!self.content.text || self.content.text.length <= 0) {
        [NSException raise:@"QueenCountdownViewIsNillException"
                    format:@"The content used in the QueenCountdownView initializer is nil."];
        return;
    }
    if (!self.context) {
        self.context = [UIApplication sharedApplication].keyWindow;
    }
    [self.context addSubview:self];
    [self calculateInfo];
    [self layoutSubview];
}
- (void)show {
    [self displaySubView];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self hid];
}
- (void)hid {
    _skipBtn.userInteractionEnabled = NO;
    CFTimeInterval interval = [_shape convertTime:CACurrentMediaTime() fromLayer:nil];
    _shape.timeOffset = interval;
    _shape.speed = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.skipBlock) {
            self.skipBlock();
        }
        [self removeFromSuperview];
    }];
}
- (void)inquriryViewForClickOperation:(UIButton *)sender {
    if (self.inquriryBlock) {
        self.inquriryBlock(sender.tag);
        [self hid];
    }
}
#pragma mark - Private
- (CGFloat)obtainMaxWidth {
    CGFloat contentViewMaxW = 0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if ([UIDevice deviceVerticalOrHorizontal] == DeviceOrientationTypeVertical) {
            contentViewMaxW = JPBaoFu_SCREENWIDTH*0.9;
        }else {
            contentViewMaxW = JPBaoFu_SCREENWIDTH*0.6;
        }
        if (contentViewMaxW > suitableW) {
            contentViewMaxW = suitableW;
        }
        return contentViewMaxW;
    }else {
        return suitableW;
    }
}
#pragma mark - LifeCycle
- (void)dealloc {
    _skipBtn.userInteractionEnabled = NO;
    CFTimeInterval interval = [_shape convertTime:CACurrentMediaTime() fromLayer:nil];
    _shape.timeOffset = interval;
    _shape.speed = 0.0f;
}
@end
