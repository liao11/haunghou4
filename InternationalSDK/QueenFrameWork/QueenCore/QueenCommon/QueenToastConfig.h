#ifndef QueenToastConfig_h
#define QueenToastConfig_h
typedef NS_ENUM(NSInteger, QueenToastDisplayType) {
    QueenToastDisplayTypeDefault,
    QueenToastDisplayTypeCenter,
    QueenToastDisplayTypeSkipInCenter,
    QueenToastDisplayTypeInquriryInCenter,
    QueenToastDisplayTypeBottom
};
typedef NS_ENUM(NSInteger, QueenToastType) {
    QueenToastTypeDefault = 1,
    QueenToastTypeSuccess = 2,
    QueenToastTypeError = 3,
    QueenToastTypeWarning = 4,
    QueenToastTypeInfo = 5,
};
#endif 
