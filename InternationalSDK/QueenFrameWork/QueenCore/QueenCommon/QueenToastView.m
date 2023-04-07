#import "QueenToastView.h"
#import "Queen_HMacro.h"
#import "QueenToastConst.h"
CGFloat const toastSuitableW = 600;
@interface QueenToastView ()
{
    CGAffineTransform rotationTransform;
}
@property (nonatomic, strong) UIView *context;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) UIView *toastContent;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) CGSize messageSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) BOOL isCustomView;
@property (nonatomic, strong) dispatch_semaphore_t signal;
@property (nonatomic, assign, getter=isAutoDismiss) BOOL autoDismiss;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *messageLabel;
@end
@implementation QueenToastView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message icon:(NSString *)icon toastContent:(UIView *)toastContent inView:(UIView *)context autoDismiss:(BOOL)autoDismiss
{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.icon = icon;
        self.context = context;
        self.autoDismiss = autoDismiss;
        if (!toastContent) {
            self.toastContent = [[UIView alloc] init];
            _toastContent.layer.borderWidth = 1.0;
            _toastContent.layer.borderColor = Queen_HTColorRGB(245, 245, 245).CGColor;
            self.isCustomView = NO;
            [self addSubviews];
        }else {
            self.toastContent = toastContent;
            self.isCustomView = YES;
            self.contentSize = toastContent.size;
        }
    }
    return self;
}
- (void)addSubviews{
    self.topView = [UIView new];
    _topView.backgroundColor = Queen_HTColorRGB(245, 245, 245);
    [self.toastContent addSubview:_topView];
    self.topImageView = [UIImageView new];
    [self.toastContent addSubview:_topImageView];
    self.iconImageView = [UIImageView new];
    [self.toastContent addSubview:_iconImageView];
    self.messageLabel = [UILabel new];
    [self.toastContent addSubview:_messageLabel];
}
- (void)calculateInfo {
    CGFloat toastViewW = 0;
    CGFloat toastViewH = 0;
    CGFloat labelMaxw = 0;
    if (self.displayType != QueenToastDisplayTypeCenter) {
        labelMaxw = [self obtainMaxWidth] - imageWH - 3*margin;
    }else {
        labelMaxw = [self obtainMaxWidth];
    }
    CGSize titleSize = [self.title boundingRectWithSize:CGSizeMake(labelMaxw, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JPBaoFu_Font(titleFont)} context:nil].size;
    CGSize messageSize = [self.message boundingRectWithSize:CGSizeMake(labelMaxw, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JPBaoFu_Font(messageFont)} context:nil].size;
    toastViewH = titleSize.height + messageSize.height;
    if (self.displayType != QueenToastDisplayTypeCenter) {
        if (toastViewH <= imageWH) {
            toastViewH = imageWH;
        }
        toastViewH += 3*margin;
        toastViewW = [self obtainMaxWidth] ;
    }else {
        toastViewH += imageWH + 4*margin;
        toastViewW = messageSize.width>titleSize.width? (messageSize.width>imageWH? messageSize.width : imageWH) : (titleSize.width>imageWH? titleSize.width : imageWH);
        toastViewW += (2*margin);
    }
    self.titleSize = titleSize;
    self.messageSize = messageSize;
    self.contentSize = CGSizeMake(toastViewW, toastViewH);
}
- (void)layoutToastView {
    JPBaoFu_YJWeakSelf
    self.toastContent.layer.masksToBounds = YES;
    self.toastContent.layer.cornerRadius = 5;
    switch (self.displayType) {
        case QueenToastDisplayTypeDefault:
        {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.context.mas_top).offset(-weakSelf.contentSize.height);
                make.centerX.mas_equalTo(weakSelf.context);
                make.width.mas_equalTo([weakSelf obtainMaxWidth]);
                make.height.mas_equalTo(weakSelf.contentSize.height);
            }];
        }
            break;
        case QueenToastDisplayTypeCenter:
        {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(weakSelf.context);
                make.center.mas_equalTo(weakSelf.context);
            }];
        }
            break;
        case QueenToastDisplayTypeBottom:
        {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(weakSelf.context.mas_bottom).offset(weakSelf.contentSize.height);
                make.right.mas_equalTo(weakSelf.context.mas_right).offset(-margin);
                make.left.mas_equalTo(weakSelf.context.mas_left).offset(margin);
                make.height.mas_equalTo(weakSelf.contentSize.height);
            }];
        }
            break;
        default:
            break;
    }
    if (self.displayType != QueenToastDisplayTypeCenter) {
        [_toastContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(weakSelf.contentSize.width);
            make.height.mas_equalTo(weakSelf.contentSize.height);
        }];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.mas_equalTo(weakSelf.toastContent).offset(Queen_HMargin/2);
            make.size.mas_equalTo(CGSizeMake(topImageWH*3, topImageWH));
        }];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.mas_equalTo(weakSelf.toastContent);
            make.bottom.mas_equalTo(weakSelf.topImageView.mas_bottom).offset(Queen_HMargin/2);
        }];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageWH, imageWH));
            make.centerY.mas_equalTo(weakSelf.toastContent).offset((Queen_HMargin+topImageWH)/2);
            make.left.mas_equalTo(weakSelf.toastContent).offset(Queen_HMargin);
        }];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.iconImageView);
            make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(Queen_HMargin);
            make.right.mas_equalTo(weakSelf.toastContent).offset(-1.5*Queen_HMargin);
        }];
    }else {
        [_toastContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(weakSelf.contentSize.width);
            make.height.mas_equalTo(weakSelf.contentSize.height);
        }];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.mas_equalTo(weakSelf.toastContent).offset(Queen_HMargin);
            make.size.mas_equalTo(CGSizeMake(topImageWH, topImageWH*3));
        }];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.mas_equalTo(weakSelf.toastContent);
            make.bottom.mas_equalTo(weakSelf.topImageView.bottom).offset(-Queen_HMargin/2);
        }];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageWH, imageWH));
            make.top.mas_equalTo(weakSelf.topView.mas_top).offset(1.5*Queen_HMargin);
        }];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.iconImageView.mas_top).offset(imageWH*0.4);
            make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(2*Queen_HMargin);
            make.right.mas_equalTo(weakSelf.toastContent).offset(-1.5*Queen_HMargin);
        }];
    }
    [self.context layoutIfNeeded];
}
- (void)loadToastViewData {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChange:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil
     ];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.image = [QueenUtils quImageWithName:self.icon];
    _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    _topImageView.image = [QueenUtils quImageWithName:@"Toast_new_top"];
    _messageLabel.text = self.message;
    _messageLabel.font = JPBaoFu_Font(13);
    _messageLabel.numberOfLines = 0;
    switch (self.displayType) {
        case QueenToastDisplayTypeDefault:
        case QueenToastDisplayTypeBottom:
        {
            _messageLabel.textAlignment = NSTextAlignmentLeft;
            _messageLabel.textColor = [UIColor blackColor];
            self.toastContent.backgroundColor = [UIColor whiteColor];
        }
            break;
        case QueenToastDisplayTypeCenter:
        {
            _messageLabel.textColor = [UIColor blackColor];
            _messageLabel.textAlignment = NSTextAlignmentLeft;
            self.toastContent.backgroundColor = [UIColor whiteColor];
            self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.35];
        }
            break;
        default:
            break;
    }
}
- (void)displayToastView {
    if (!self.message || self.message.length <= 0) {
        [NSException raise:@"QueenToastViewIsNillException"
                    format:@"The message used in the QueenToastView initializer is nil."];
        return;
    }
    if (!self.context) {
        self.context = [UIApplication sharedApplication].keyWindow;
    }
    [self addSubview:self.toastContent];
    [self.context addSubview:self];
    [self calculateInfo];
    [self loadToastViewData];
    [self layoutToastView];
}
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    JPBaoFu_YJWeakSelf
    [self calculateInfo];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(JPBaoFu_SCREENWIDTH);
        make.height.mas_equalTo(weakSelf.contentSize.height);
    }];
}
#pragma mark - 显示、隐藏动画
- (void)show {
    JPBaoFu_YJWeakSelf
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
    [self displayToastView];
    switch (self.displayType) {
        case QueenToastDisplayTypeDefault:
        {
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear  animations:^{
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakSelf.context.mas_top).offset(statusBarHeight);
                }];
                [self.context layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self performSelector:@selector(hid) withObject:nil afterDelay:self.showTime];
            }];
        }
            break;
        case QueenToastDisplayTypeBottom:
        {
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear  animations:^{
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(weakSelf.context.mas_bottom).offset(-4*margin);
                }];
                [self.context layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
            [self performSelector:@selector(hid) withObject:nil afterDelay:self.showTime];
        }
            break;
        case QueenToastDisplayTypeCenter:
        {
            self.toastContent.alpha = 0.4;
            self.toastContent.transform = CGAffineTransformMakeScale(0.7, 0.7);
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
                self.toastContent.alpha = 1.0;
                self.toastContent.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (self.autoDismiss) {
                    [self performSelector:@selector(hid) withObject:nil afterDelay:self.showTime];
                }
            }];
        }
            break;
        default:
            break;
    }
}
- (void)hid {
    switch (self.displayType) {
        case QueenToastDisplayTypeDefault:
        {
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
        case QueenToastDisplayTypeBottom:
        case QueenToastDisplayTypeCenter:
        {
            [UIView animateWithDuration:0.25 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - Private
- (CGFloat)obtainMaxWidth {
    CGFloat maxWidth = 0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        maxWidth = JPBaoFu_SCREENWIDTH - 2*Queen_HMargin;
        if (maxWidth > toastSuitableW) {
            maxWidth = toastSuitableW;
        }
        return maxWidth;
    }else {
        return toastSuitableW;
    }
}
#pragma mark - LifeCycle
- (void)dealloc {
    self.context = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Lazy
- (dispatch_semaphore_t)signal {
    if (!_signal) {
        _signal = dispatch_semaphore_create(1);
    }
    return _signal;
}
@end
