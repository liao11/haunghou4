#import "QueenCHIForgotAtView.h"
@interface Queen_HIFtHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel *JPBaoFu_accountLabel;
@property (nonatomic, strong) UILabel *JPBaoFu_gnameLabel;
@property (nonatomic, strong) UILabel *JPBaoFu_lastLoggedLabel;
@property (nonatomic, strong) UIButton *JPBaoFu_clickBtn;
@property (nonatomic, copy) void(^clickCallback)();
@property (nonatomic, strong) NSDictionary *data;
+ (Queen_HIFtHistoryCell *)JPBaoFu_obtainCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;
+ (CGFloat)JPBaoFu_obtainCellHeightWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier config:(JPBaoFu_FtConfigBlock)config;
@end
@implementation Queen_HIFtHistoryCell
+ (Queen_HIFtHistoryCell *)JPBaoFu_obtainCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    Queen_HIFtHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[Queen_HIFtHistoryCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
        cell.backgroundColor = Queen_HILightGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self JPBaoFu_setupViews];
    }
    return self;
}
- (void)JPBaoFu_setupViews {
    self.JPBaoFu_accountLabel = [UILabel new];
    _JPBaoFu_accountLabel.font = Queen_HTLeastFont;
    _JPBaoFu_accountLabel.textColor = Queen_HILightBlackColor;
    [self addSubview:_JPBaoFu_accountLabel];
    self.JPBaoFu_gnameLabel = [UILabel new];
    _JPBaoFu_gnameLabel.font = Queen_HTLeastFont;
    _JPBaoFu_gnameLabel.textColor = Queen_HILightBlackColor;
    [self addSubview:_JPBaoFu_gnameLabel];
    self.JPBaoFu_lastLoggedLabel = [UILabel new];
    _JPBaoFu_lastLoggedLabel.font = Queen_HTLeastFont;
    _JPBaoFu_lastLoggedLabel.textColor = Queen_HILightBlackColor;
    [self addSubview:_JPBaoFu_lastLoggedLabel];
    self.JPBaoFu_clickBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_JPBaoFu_clickBtn addTarget:self action:@selector(selectHistoryAccount) forControlEvents:(UIControlEventTouchUpInside)];
    _JPBaoFu_clickBtn.contentMode = UIViewContentModeScaleAspectFit;
    _JPBaoFu_clickBtn.titleLabel.font = Queen_HTSmallFont;
    [_JPBaoFu_clickBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_JPBaoFu_clickBtn setBackgroundColor:Queen_HIGreenColor];
    _JPBaoFu_clickBtn.layer.cornerRadius = 2;
    _JPBaoFu_clickBtn.layer.masksToBounds = YES;
    [self addSubview:_JPBaoFu_clickBtn];
}
- (void)JPBaoFu_displayViews {
    JPBaoFu_YJWeakSelf
    CGSize clickSize = [QueenCHHelper JPBaoFu_sizeWithText:self.JPBaoFu_clickBtn.titleLabel.text font:self.JPBaoFu_clickBtn.titleLabel.font maxW:JPBaoFu_SCREENWIDTH];
    [self.JPBaoFu_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(Queen_HMargin);
        make.top.mas_equalTo(weakSelf).offset(Queen_HMargin/2);
    }];
    [self.JPBaoFu_gnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_accountLabel);
        make.top.mas_equalTo(weakSelf.JPBaoFu_accountLabel.mas_bottom).offset(Queen_HMargin/3);
    }];
    [self.JPBaoFu_lastLoggedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JPBaoFu_accountLabel);
        make.top.mas_equalTo(weakSelf.JPBaoFu_gnameLabel.mas_bottom).offset(Queen_HMargin/3);
    }];
    [self.JPBaoFu_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(clickSize.width + Queen_HMargin/2, clickSize.height + Queen_HMargin/2));
        make.right.mas_equalTo(weakSelf).offset(-Queen_HMargin);
    }];
}
+ (CGFloat)JPBaoFu_obtainCellHeightWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier config:(JPBaoFu_FtConfigBlock)config {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    if (config) {
        config(cell);
    }
    return [(Queen_HIFtHistoryCell *)cell privateObtainCellHeight];
}
- (CGFloat)privateObtainCellHeight {
    return CGRectGetMaxY(self.JPBaoFu_lastLoggedLabel.frame) + Queen_HMargin/2;
}
- (void)setData:(NSDictionary *)data {
    _data = data;
    [self changeTextColor:Queen_HLocalizedString(Queen_HIForgotAtViewCellEmailText) changeTitle:[data objectForKey:Queen_HIForgotAtViewEmailData] changeLabel:self.JPBaoFu_accountLabel];
    [self changeTextColor:Queen_HLocalizedString(Queen_HIForgotAtViewCellGameNameText) changeTitle:[data objectForKey:Queen_HIForgotAtViewGameNameData] changeLabel:self.JPBaoFu_gnameLabel];
    [self changeTextColor:Queen_HLocalizedString(Queen_HIForgotAtViewCellLastTimeLoggedInText) changeTitle:[data objectForKey:Queen_HIForgotAtViewLastTimeLoggedInData] changeLabel:self.JPBaoFu_lastLoggedLabel];
    [self.JPBaoFu_clickBtn setTitle:Queen_HLocalizedString(Queen_HIForgotAtViewCellClickText) forState:(UIControlStateNormal)];
    [self JPBaoFu_displayViews];
    [self layoutIfNeeded];
}
- (void)changeTextColor:(NSString *)normalTitle changeTitle:(NSString *)changeTitle changeLabel:(UILabel *)changeLabel {
    NSString *finalTitle =  [NSString stringWithFormat:@"%@: %@",normalTitle,changeTitle];
    NSRange changeRange = NSMakeRange([finalTitle rangeOfString:changeTitle].location, changeTitle.length);
    NSMutableAttributedString * notiString = [[NSMutableAttributedString alloc]initWithString:finalTitle];
    [notiString addAttribute:NSForegroundColorAttributeName value:Queen_HIDarkBlackColor range:changeRange];
    [notiString addAttribute:NSFontAttributeName value:JPBaoFu_FontBold(10) range:changeRange];
    [changeLabel setAttributedText:notiString];
}
- (void)selectHistoryAccount {
    if (self.clickCallback) {
        self.clickCallback();
    }
}
@end
CGFloat const JPBaoFu_ForgotAtViewsuitableW = 340;
@interface QueenCHIForgotAtView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *JPBaoFu_context;
@property (nonatomic, strong) UILabel *JPBaoFu_navTitle;
@property (nonatomic, strong) UIButton *JPBaoFu_navBtn;
@property (nonatomic, strong) UIView *JPBaoFu_navLine;
@property (nonatomic, strong) UILabel *JPBaoFu_selectTitle;
@property (nonatomic, strong) UITableView *JPBaoFu_historyTable;
@property (nonatomic, strong) UILabel *JPBaoFu_serviceInfo;
@property (nonatomic, strong) NSArray *JPBaoFu_dataArr;
@end
@implementation QueenCHIForgotAtView
+ (instancetype)QueenShowForgotAtViewInContext:(UIView *)context {
    QueenCHIForgotAtView *forgotAtView = [[QueenCHIForgotAtView alloc] init];
    [context addSubview:forgotAtView];
    forgotAtView.JPBaoFu_context = context;
    [forgotAtView JPBaoFu_setupViews];
    [forgotAtView JPBaoFu_configViews];
    [forgotAtView JPBaoFu_displayViews];
    return forgotAtView;
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
    self.JPBaoFu_selectTitle = [UILabel new];
    _JPBaoFu_selectTitle.font = Queen_HTBoldMediaFont;
    _JPBaoFu_selectTitle.textColor = Queen_HIDarkBlackColor;
    [self addSubview:_JPBaoFu_selectTitle];
    UITableView *historyTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    historyTable.backgroundColor = Queen_HILightGrayColor;
    historyTable.dataSource = self;
    historyTable.delegate = self;
    historyTable.separatorInset = UIEdgeInsetsZero;
    historyTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    historyTable.tableFooterView = [[UIView alloc] init];
    historyTable.layer.cornerRadius = 7;
    historyTable.layer.cornerRadius = 3;
    historyTable.layer.masksToBounds = YES;
    historyTable.layer.borderWidth = 0.5;
    historyTable.layer.borderColor = Queen_HILineColor.CGColor;
    self.JPBaoFu_historyTable = historyTable;
    [self addSubview:historyTable];
    self.JPBaoFu_serviceInfo = [UILabel new];
    _JPBaoFu_serviceInfo.textAlignment = NSTextAlignmentCenter;
    _JPBaoFu_serviceInfo.font = Queen_HTBoldSmallFont;
    _JPBaoFu_serviceInfo.textColor = Queen_HILightBlackColor;
    [self addSubview:_JPBaoFu_serviceInfo];
}
- (void)JPBaoFu_configViews {
    self.JPBaoFu_navTitle.text = Queen_HLocalizedString(Queen_HIForgotAtViewNavTitleText);
    [self.JPBaoFu_navBtn setImage:[QueenUtils quImageWithName:@"arrowLeft"] forState:(UIControlStateNormal)];
    self.JPBaoFu_selectTitle.text = Queen_HLocalizedString(Queen_HIForgotAtViewSelectTitleText);
    self.JPBaoFu_serviceInfo.text = Queen_HLocalizedString(Queen_HIForgotAtViewServiceMailbox);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QueenShowVersion)];
    tap.numberOfTapsRequired = 10;
    [self.JPBaoFu_historyTable addGestureRecognizer:tap];
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
        make.top.mas_equalTo(weakSelf).offset(1.5*Queen_HMargin);
    }];
    [self.JPBaoFu_navLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_navTitle.mas_bottom).offset(Queen_HMargin);
        make.left.mas_equalTo(weakSelf).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf).offset(-2*Queen_HMargin);
        make.height.mas_equalTo(0.5);
    }];
    [self.JPBaoFu_selectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_navLine).offset(Queen_HMargin);
        make.centerX.mas_equalTo(weakSelf);
    }];
    [self.JPBaoFu_historyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_selectTitle.mas_bottom).offset(Queen_HMargin);
        make.left.mas_equalTo(weakSelf).offset(2*Queen_HMargin);
        make.right.mas_equalTo(weakSelf).offset(-2*Queen_HMargin);
        make.height.mas_equalTo(130);
    }];
    [self.JPBaoFu_serviceInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JPBaoFu_historyTable.mas_bottom).offset(Queen_HMargin);
        make.left.and.right.mas_equalTo(weakSelf).offset(Queen_HMargin);
    }];
}
- (void)Queen_refreshMainView {
    JPBaoFu_YJWeakSelf
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.JPBaoFu_context);
        make.width.mas_equalTo([weakSelf JPBaoFu_obtainMaxWidth]);
        make.bottom.mas_equalTo(weakSelf.JPBaoFu_serviceInfo.mas_bottom).offset(2*Queen_HMargin);
    }];
}
#pragma mark - Click Events
- (void)JPBaoFu_returnBack {
    if ([self.delegate respondsToSelector:@selector(JPBaoFu_forgotAtViewClickReturnEvents)]) {
        [self.delegate JPBaoFu_forgotAtViewClickReturnEvents];
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
        if (contentViewMaxW > JPBaoFu_ForgotAtViewsuitableW) {
            contentViewMaxW = JPBaoFu_ForgotAtViewsuitableW;
        }
        return contentViewMaxW;
    }else {
        return JPBaoFu_ForgotAtViewsuitableW;
    }
}
- (void)QueenShowVersion {
    NSString *version = [NSString stringWithFormat:@"SDK Version = %@\nGame Version = %@", JPBaoFu_cSdkVersion,[UIDevice gainAppVersion]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:version delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alertView show];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.JPBaoFu_dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Queen_HIFtHistoryCell *cell = [Queen_HIFtHistoryCell JPBaoFu_obtainCellWithTableView:tableView reuseIdentifier:@"ftHistoryCell"];
    cell.data = self.JPBaoFu_dataArr[indexPath.row];
    cell.clickCallback = ^{
        if ([self.delegate respondsToSelector:@selector(JPBaoFu_forgotAtViewClickAccountInfoOfIndex:)]) {
            [self.delegate JPBaoFu_forgotAtViewClickAccountInfoOfIndex:indexPath.row];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Queen_HIFtHistoryCell JPBaoFu_obtainCellHeightWithTableView:tableView reuseIdentifier:@"ftHistoryCell" config:^(UITableViewCell *sourceCell) {
        Queen_HIFtHistoryCell *cell = (Queen_HIFtHistoryCell *)sourceCell;
        cell.data = self.JPBaoFu_dataArr[indexPath.row];
    }];;
}
- (void)JPBaoFu_setData:(NSDictionary *)data {
    self.JPBaoFu_serviceInfo.text = [NSString stringWithFormat:@"%@:%@",Queen_HLocalizedString(Queen_HIForgotAtViewServiceMailbox),[data objectForKey:Queen_HIForgotAtViewEmailData]];
    self.JPBaoFu_dataArr = [data objectForKey:Queen_HIForgotAtViewAccountsData];
    [self.JPBaoFu_historyTable reloadData];
}
@end
