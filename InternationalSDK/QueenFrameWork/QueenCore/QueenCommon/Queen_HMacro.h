#ifndef Queen_HMacro_h
#define Queen_HMacro_h
#define JPBaoFu_YJLog(...) if ([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isOpenLog) { NSLog(__VA_ARGS__);}
#define JPBaoFu_YJDevLog(format, ...)  if ([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isOpenDevLog) {                                \
                                    do {                                                                        \
                                        fprintf(stderr, "----ChLog---\n");                                          \
                                        fprintf(stderr, "<%s : %d> %s\n",                                           \
                                        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
                                        __LINE__, __func__);                                                        \
                                        (NSLog)((format), ##__VA_ARGS__);                                           \
                                        fprintf(stderr, "----—-----—-\n");                                          \
                                    } while (0);                                                                \
                                }else {                                                                     \
                                    (NSLog)((format), ##__VA_ARGS__);                                           \
                                }
static inline void JPBaoFu_YJTestCode(void(^DevBlock)(void),void(^DisBlock)(void)) {
    if ([QueenCHIGlobalInfo QueensharedInstance].JPBaoFu_isOpenDevLog) {
        if (DevBlock) {
            DevBlock();
        }
    }else {
        if (DisBlock) {
            DisBlock();
        }
    }
}
static inline void JPBaoFu_RunInMainQueue(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
#define Queen_HSDKResourceBundleName   @"QueenBundle"
#define Queen_HLocalizedString(key) [QueenUtils qulocalizedStringForKey:key]
#define Queen_HLogMark(title) [NSString stringWithFormat:@"\n \n",title]
#define JPBaoFu_YJCHKeyWindow [JPBaoFu_CcaoHuaAPI sharedInstance].sdkConfig.context.view
#define JPBaoFu_YJCHRootController [JPBaoFu_CcaoHuaAPI sharedInstance].sdkConfig.context
#define Queen_HIRootContorller [QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.context
#define Queen_HIRootWindow [QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo.context.view
#define JPBaoFu_kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
#define Queen_HTJudgeParameter(Object,key)   if (![QueenCHHelper JPBaoFu_isBlankString:Object]) {[parameters setObject:Object forKey:key];}else {[parameters setObject:@"" forKey:key];JPBaoFu_YJLog(@"ch_参数:%@为空",key);}
#define Queen_HTJudgeCustomParameter(Name,Object,key)   if (![QueenCHHelper JPBaoFu_isBlankString:Object]) {[Name setObject:Object forKey:key];}else {[Name setObject:@"" forKey:key];JPBaoFu_YJLog(@"ch_参数:%@为空",key);}
#define JPBaoFu_YJColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define Queen_HTColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define Queen_HTDefaultContextBackgroundColor JPBaoFu_YJColorRGBA(0,0,0,0.5)
#define Queen_HIDarkBlackColor [QueenCHHelper JPBaoFu_colorWithHexString:@"#3d444a"]
#define Queen_HILightBlackColor [QueenCHHelper JPBaoFu_colorWithHexString:@"#62707b"]
#define Queen_HIGreenColor [QueenCHHelper JPBaoFu_colorWithHexString:@"#a37cfd"]
#define Queen_HIOrangeColor [QueenCHHelper JPBaoFu_colorWithHexString:@"#ffaf00"]
#define Queen_HILucencyWhiteColor JPBaoFu_YJColorRGBA(255,255,255,1.0)
#define Queen_HIWhiteColor JPBaoFu_YJColorRGBA(255,255,255,1.0)
#define Queen_HILineColor [QueenCHHelper JPBaoFu_colorWithHexString:@"#ced1d5"]
#define Queen_HIGrayColor Queen_HTColorRGB(234,239,244)
#define Queen_HILightGrayColor Queen_HTColorRGB(244,248,251)
#define Queen_HIBlueColor Queen_HTColorRGB(92,162,214)
#define QueenShowHUD [QueenProgressHUD QueenShowHUDAddedTo:Queen_HIRootWindow animated:YES];
#define JPBaoFu_HideHUD [QueenProgressHUD JPBaoFu_HideHUDForView:Queen_HIRootWindow animated:YES];
#define QueenShowHUDInCurrentView [QueenProgressHUD QueenShowHUDAddedTo:self.view animated:YES];
#define JPBaoFu_HideHUDInCurrentView [QueenProgressHUD JPBaoFu_HideHUDForView:self.view animated:YES];
#define QueenShowHUDInView(view) [QueenProgressHUD QueenShowHUDAddedTo:view animated:YES];
#define JPBaoFu_HideHUDInVeiw(view) [QueenProgressHUD JPBaoFu_HideHUDForView:view animated:YES];
#define QueenShowSuccessToast(message) [QueenCHToast JPBaoFu_displayToastWithMessage:message toastType:QueenToastTypeSuccess];
#define QueenShowErrorToastt(message) [QueenCHToast JPBaoFu_displayToastWithMessage:message toastType:QueenToastTypeError];
#define QueenShowWarningToast(message) [QueenCHToast JPBaoFu_displayToastWithMessage:message toastType:QueenToastTypeWarning];
#define JPBaoFu_Font(font)  [UIFont systemFontOfSize:font]
#define JPBaoFu_FontBold(font) [UIFont boldSystemFontOfSize:font]
#define JPBaoFu_YJMaximumFont [UIFont systemFontOfSize:15]
#define Queen_HINavTitleFont [UIFont boldSystemFontOfSize:17]
#define Queen_HTMediaFont [UIFont systemFontOfSize:14]
#define Queen_HTBoldAlertTitleFont JPBaoFu_FontBold(16)
#define Queen_HTBoldMediaFont JPBaoFu_FontBold(14)
#define Queen_HTBoldSmallFont JPBaoFu_FontBold(12)
#define Queen_HTSmallFont [UIFont systemFontOfSize:12]
#define Queen_HTLeastFont [UIFont systemFontOfSize:10]
#define JPBaoFu_YJFullScreenFrame CGRectMake(0, 0, JPBaoFu_SCREENWIDTH, JPBaoFu_SCREENHEIGHT)
#define JPBaoFu_SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define JPBaoFu_SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define JPBaoFu_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define JPBaoFu_iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f || [[UIScreen mainScreen] bounds].size.width == 736.0f
#define JPBaoFu_IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON) ||  (fabs((double)[[UIScreen mainScreen]bounds].size.width - (double)480) < DBL_EPSILON)
#define JPBaoFu_IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)||  (fabs((double)[[UIScreen mainScreen]bounds].size.width - (double)568) < DBL_EPSILON)
#define JPBaoFu_IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)||  (fabs((double)[[UIScreen mainScreen]bounds].size.width - (double)667) < DBL_EPSILON)
#define JPBaoFu_IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)||  (fabs((double)[[UIScreen mainScreen]bounds].size.width - (double)480) < DBL_EPSILON)
#define JPBaoFu_IS_IOS7_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
#define JPBaoFu_YJWeakSelf __weak typeof(self) weakSelf = self;
#define JPBaoFu_YJStrongSelf __strong typeof(self) strongSelf = weakSelf;
#define Queen_SingleH(name)  + (instancetype)share##name;
#if __has_feature(objc_arc)
#define JPBaoFu_SingleM(name) static name *_instant;\
+ (instancetype)share##name{\
return [[self alloc]init];\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instant = [super allocWithZone:zone];\
});\
return _instant;\
}\
- (id)copyWithZone:(NSZone *)zone{\
return _instant;\
}\
- (id)mutableCopyWithZone:(NSZone *)zone{\
return _instant;\
}
#else
#define JPBaoFu_SingleM(name) static name *_instant;\
+ (instancetype)share##name{\
return [[self alloc]init];\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instant = [super allocWithZone:zone];\
});\
return _instant;\
}\
- (id)copyWithZone:(NSZone *)zone{\
return _instant;\
}\
- (id)mutableCopyWithZone:(NSZone *)zone{\
return _instant;\
}\
- (oneway void)release{\
}\
- (instancetype)retain{\
return _instant;\
}\
- (NSUInteger)retainCount{\
return MAXFLOAT;\
}
#endif
#endif 
