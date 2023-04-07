#import "QueenYJAlertView.h"
#import "Masonry.h"
#define JPBaoFu_YJTColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JPBaoFu_YJTDarkBlackColor [self JPBaoFu_colorWithHexString:@"#3d444a"]
#define JPBaoFu_YJTLightBlackColor [self JPBaoFu_colorWithHexString:@"#62707b"]
#define JPBaoFu_YJTGreenColor [self JPBaoFu_colorWithHexString:@"#ec404c"]
#define JPBaoFu_YJTOrangeColor [self JPBaoFu_colorWithHexString:@"#ffaf00"]
CGFloat const JPBaoFu_YJTSuitableW = 600;
@interface QueenYJAlertView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString *JPBaoFu_navTitle;
@property (nonatomic, strong) NSMutableArray *JPBaoFu_btnTitles;
@property (nonatomic, strong) NSMutableArray *JPBaoFu_btnColors;
@property (nonatomic, strong) NSMutableArray *JPBaoFu_btnTitleColors;
@property (nonatomic, weak) id<QueenYAlerViewDelegate> delegate;
@property (nonatomic, strong) UIView *JPBaoFu_contentView;
@property (nonatomic, strong) UILabel *JPBaoFu_navLabel;
@property (nonatomic, strong) UILabel *JPBaoFu_messageLabel;
@property (nonatomic, strong) NSMutableArray<UIButton *> *JPBaoFu_buttons;
@property (nonatomic, strong) UITableView *JPBaoFu_buttonList;
@end
@implementation QueenYJAlertView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<QueenYAlerViewDelegate>)delegate btnColors:(NSArray *)btnColors btnTitleColors:(NSArray *)btnTitleColors buttonTitles:(NSArray * )buttonTitles {
    QueenYJAlertView *alertView = [[QueenYJAlertView alloc] init];
    alertView.JPBaoFu_navTitle = title;
    alertView.JPBaoFu_btnTitles = [buttonTitles mutableCopy];
    alertView.JPBaoFu_btnColors = [btnColors mutableCopy];
    alertView.JPBaoFu_btnTitleColors = [btnTitleColors mutableCopy];
    alertView.delegate = delegate;
    alertView.JPBaoFu_message = message;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [alertView JPBaoFu_parserViewsInfo];
    [alertView JPBaoFu_setupViews];
    [alertView JPBaoFu_displayViews];
    return alertView;
}
#pragma mark - Config
- (void)JPBaoFu_setupViews {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.JPBaoFu_contentView = [UIView new];
    _JPBaoFu_contentView.layer.cornerRadius = 7.0;
    _JPBaoFu_contentView.layer.masksToBounds = YES;
    [self addSubview:_JPBaoFu_contentView];
    self.JPBaoFu_navLabel = [UILabel new];
    _JPBaoFu_navLabel.textColor = JPBaoFu_YJTDarkBlackColor;
    _JPBaoFu_navLabel.font = [UIFont boldSystemFontOfSize:17];
    _JPBaoFu_navLabel.text = self.JPBaoFu_navTitle;
    [self.JPBaoFu_contentView addSubview:_JPBaoFu_navLabel];
    self.JPBaoFu_messageLabel = [UILabel new];
    _JPBaoFu_messageLabel.textColor = JPBaoFu_YJTLightBlackColor;
    _JPBaoFu_messageLabel.font = [UIFont systemFontOfSize:15];
    _JPBaoFu_messageLabel.numberOfLines = 0;
    _JPBaoFu_messageLabel.textAlignment = NSTextAlignmentCenter;
    _JPBaoFu_messageLabel.text = self.JPBaoFu_message;
    [self.JPBaoFu_contentView addSubview:_JPBaoFu_messageLabel];
    if (self.JPBaoFu_btnTitles.count == 0) {
        _JPBaoFu_contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        UITapGestureRecognizer *tapSuper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(JPBaoFu_hid)];
        UITapGestureRecognizer *tapSub = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(JPBaoFu_hid)];
        [self addGestureRecognizer:tapSuper];
        [self.JPBaoFu_contentView addGestureRecognizer:tapSub];
        return;
    }
    if (self.JPBaoFu_btnTitles.count <= 2) {
        self.JPBaoFu_buttons = [NSMutableArray array];
        _JPBaoFu_contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        for (NSInteger index = 0; index < self.JPBaoFu_btnTitles.count; index++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.tag = index;
            NSString *title = self.JPBaoFu_btnTitles[index];
            UIColor *titleColor = self.JPBaoFu_btnTitleColors[index];
            UIColor *backgroudColor = self.JPBaoFu_btnColors[index];
            [button setTitle:title forState:(UIControlStateNormal)];
            [button setTitleColor:titleColor forState:(UIControlStateNormal)];
            [button setBackgroundColor:backgroudColor];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            button.layer.cornerRadius = 2.0;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(QueenAlertViewClickOperation:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.JPBaoFu_contentView addSubview:button];
            [self.JPBaoFu_buttons addObject:button];
        }
    }else {
        _JPBaoFu_contentView.backgroundColor = [UIColor whiteColor];
        self.JPBaoFu_buttonList = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _JPBaoFu_buttonList.backgroundColor = [UIColor whiteColor];
        _JPBaoFu_buttonList.dataSource = self;
        _JPBaoFu_buttonList.delegate = self;
        _JPBaoFu_buttonList.separatorInset = UIEdgeInsetsZero;
        _JPBaoFu_buttonList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _JPBaoFu_buttonList.tableFooterView = [[UIView alloc]init];
        _JPBaoFu_buttonList.scrollEnabled = NO;
        _JPBaoFu_buttonList.showsVerticalScrollIndicator = NO;
        _JPBaoFu_buttonList.showsHorizontalScrollIndicator = NO;
        [self.JPBaoFu_contentView addSubview:_JPBaoFu_buttonList];
    }
}
- (void)JPBaoFu_displayViews {
    __weak typeof(self) weakSelf = self;
    [self.JPBaoFu_navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(15);
        make.centerX.mas_equalTo(weakSelf.JPBaoFu_contentView);
    }];
    [self.JPBaoFu_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_navLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(15);
        make.right.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(-15);
    }];
    if (self.JPBaoFu_btnTitles.count == 1) {
        [self.JPBaoFu_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.width.mas_equalTo([self JPBaoFu_obtainMaxWidth]);
            make.bottom.mas_equalTo(weakSelf.JPBaoFu_buttons.lastObject.mas_bottom);
        }];
        [self JPBaoFu_displayOneButton];
    }else if (self.JPBaoFu_btnTitles.count == 2) {
        [self.JPBaoFu_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.width.mas_equalTo([self JPBaoFu_obtainMaxWidth]);
            make.bottom.mas_equalTo(weakSelf.JPBaoFu_buttons.lastObject.mas_bottom).offset(15);
        }];
        [self JPBaoFu_displayTwoButton];
    }else if (self.JPBaoFu_btnTitles.count > 2) {
        [self.JPBaoFu_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.width.mas_equalTo([self JPBaoFu_obtainMaxWidth]);
            make.bottom.mas_equalTo(weakSelf.JPBaoFu_buttonList.mas_bottom);
        }];
        [self.JPBaoFu_buttonList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf.JPBaoFu_contentView);
            make.top.mas_equalTo(weakSelf.JPBaoFu_messageLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(weakSelf.JPBaoFu_btnTitles.count*40);
        }];
    }else {
        [self.JPBaoFu_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.width.mas_equalTo([self JPBaoFu_obtainMaxWidth]);
            make.bottom.mas_equalTo(weakSelf.JPBaoFu_messageLabel.mas_bottom).offset(15);
        }];
    }
}
- (void)JPBaoFu_displayOneButton {
    __weak typeof(self) weakSelf = self;
    UIButton *button = self.JPBaoFu_buttons.firstObject;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.JPBaoFu_contentView);
        make.top.mas_equalTo(weakSelf.JPBaoFu_messageLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
}
- (void)JPBaoFu_displayTwoButton {
    __weak typeof(self) weakSelf = self;
    UIButton *firstBtn = self.JPBaoFu_buttons.firstObject;
    UIButton *lastBtn = self.JPBaoFu_buttons.lastObject;
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_messageLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(lastBtn);
        make.left.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(20);
        make.right.mas_equalTo(lastBtn.mas_left).offset(-20);
    }];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.and.top.mas_equalTo(firstBtn);
        make.right.mas_equalTo(weakSelf.JPBaoFu_contentView).offset(-20);
    }];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.JPBaoFu_btnTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Yj_AlertCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Yj_AlertCell"];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(cell.contentView);
        }];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.JPBaoFu_btnTitles[indexPath.row];
    cell.textLabel.textColor = self.JPBaoFu_btnTitleColors[indexPath.row];
    cell.contentView.backgroundColor = self.JPBaoFu_btnColors[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(Queen_HAlertView:transferredData:clickedButtonAtIndex:)]) {
        [self.delegate Queen_HAlertView:self transferredData:self.JPBaoFu_tempStorageData clickedButtonAtIndex:indexPath.row];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - Click Events
- (void)QueenAlertViewClickOperation:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(Queen_HAlertView:transferredData:clickedButtonAtIndex:)]) {
        [self.delegate Queen_HAlertView:self transferredData:self.JPBaoFu_tempStorageData clickedButtonAtIndex:sender.tag];
    }
    [self JPBaoFu_hid];
}
#pragma mark - Public
- (void)QueenShow {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
        make.size.mas_equalTo(CGSizeMake(JPBaoFu_SCREENWIDTH, JPBaoFu_SCREENHEIGHT));
    }];
    [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
}
- (void)JPBaoFu_hid {
    self.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.JPBaoFu_callback) {
            self.JPBaoFu_callback();
        }
    }];
}
#pragma mark - Private
- (void)JPBaoFu_parserViewsInfo {
    if (self.JPBaoFu_btnTitles.count == 0) return;
    if (self.JPBaoFu_btnColors == nil) {
        self.JPBaoFu_btnColors = [NSMutableArray array];
    }
    if (self.JPBaoFu_btnTitleColors == nil) {
        self.JPBaoFu_btnTitleColors = [NSMutableArray array];
    }
    switch (self.JPBaoFu_btnTitles.count) {
        case 1:
        {
            if (self.JPBaoFu_btnTitleColors.count != 1) {
                [self.JPBaoFu_btnTitleColors addObject:[UIColor whiteColor]];
            }
            if (self.JPBaoFu_btnColors.count != 1) {
                [self.JPBaoFu_btnColors addObject:JPBaoFu_YJTGreenColor];
            }
        }
            break;
        case 2:
        {
            if (self.JPBaoFu_btnTitleColors.count != 2) {
                [self.JPBaoFu_btnTitleColors addObject:[UIColor whiteColor]];
                [self.JPBaoFu_btnTitleColors addObject:[UIColor whiteColor]];
            }
            if (self.JPBaoFu_btnColors.count != 2) {
                [self.JPBaoFu_btnColors addObject:JPBaoFu_YJTGreenColor];
                [self.JPBaoFu_btnColors addObject:JPBaoFu_YJTOrangeColor];
            }
        }
            break;
        default:
        {
            if (self.JPBaoFu_btnTitleColors.count != self.JPBaoFu_btnTitles.count) {
                for (NSInteger index = 0; index < self.JPBaoFu_btnTitles.count; index++) {
                    [self.JPBaoFu_btnTitleColors addObject:JPBaoFu_YJTDarkBlackColor];
                }
            }
            if (self.JPBaoFu_btnColors.count != self.JPBaoFu_btnTitles.count) {
                for (NSInteger index = 0; index < self.JPBaoFu_btnTitles.count; index++) {
                    [self.JPBaoFu_btnColors addObject:[UIColor whiteColor]];
                }
            }
        }
            break;
    }
}
- (CGFloat)JPBaoFu_obtainMaxWidth {
    CGFloat maxWidth = 0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        maxWidth = JPBaoFu_SCREENWIDTH - 40;
        if (maxWidth > JPBaoFu_YJTSuitableW) {
            maxWidth = JPBaoFu_YJTSuitableW;
        }
        return maxWidth;
    }else {
        return JPBaoFu_YJTSuitableW;
    }
}
- (UIColor *)JPBaoFu_colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return JPBaoFu_YJTColorRGB(r, g, b);
}
@end
