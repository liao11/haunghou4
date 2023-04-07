#ifndef Queen_HServiceCodeDefines_h
#define Queen_HServiceCodeDefines_h


typedef NS_ENUM(NSInteger,Queen_HIAccountType) {
    Queen_HIAccountTypeCH,
    Queen_HIAccountTypeFB,
    Queen_HIAccountTypeVT,
    Queen_HIAccountTypeApple
};




typedef NS_ENUM(NSInteger, Queen_HServiceCode) {
    Queen_HServiceCodeUnknownCode = 110,
    Queen_HServiceCodeNetworkError = 111,
    Queen_HServiceCodeSuccess = 200,
    Queen_HServiceCodeParameterError = 201,
    Queen_HServiceCodeIllegalError = 202,
    Queen_HServiceCodeVerifyError = 203,
    Queen_HServiceCodeSystemError = 204,
    Queen_HServiceCodeTokenError = 205,
    Queen_HServiceCodeTokenFailureError = 206,
    Queen_HServiceCodeHandleError = 207,
    Queen_HServiceCodeReLoginError = 208,
    Queen_HServiceCodeAccountFormatError = 300,
    Queen_HServiceCodeAccountExisting = 301,
    Queen_HServiceCodeForbiddenPhoneForNor = 302,
    Queen_HServiceCodeAccountLimit = 303,
    Queen_HServiceCodeQuickRegistrationError = 304,
    Queen_HServiceCodeCellPhoneNumberError = 305,
    Queen_HServiceCodeSendVerificationCodeError = 306,
    Queen_HServiceCodeAccountInexistenceError = 307,
    Queen_HServiceCodeAccountAbnormityError = 308,
    Queen_HServiceCodeVerificationCodeError = 309,
    Queen_HServiceCodeSendInitailPwdError = 310,
    Queen_HServiceCodeAccountLocked = 311,
    Queen_HServiceCodePwdError = 312,
    Queen_HServiceCodeVerificationCodeFailure = 313,
    Queen_HServiceCodeVisitorsAccountRegisteredFTD = 314,
    Queen_HServiceCodeUnboundMainbox = 320,
    Queen_HServiceCodeGenerateOrderError = 400,
    Queen_HServiceCodeOrderInexistenceError = 401,
    Queen_HServiceCodeOrderMoneyError = 402,
    Queen_HServiceCodeBindedAccount = 500,
    Queen_HServiceCodeGainVerificationCode = 501,
    Queen_HServiceCodeBindedAccountFailure = 502,
    Queen_HServiceCodeAlterPwdfailure = 503,
    Queen_HServiceCodeApplePayFailureError = 600,
    Queen_HServiceCodeApplePayCancel = 601,
    Queen_HServiceCodeApplePayNoGoods = 602,
    Queen_HServiceCodeApplePayRestored = 603,
    Queen_HServiceCodeApplePayNotAblePayments = 604,
    Queen_HServiceCodeAppleTryAgainLater = 605,
    Queen_HServiceCodeApplePayRequestFailure = 606,
    Queen_HServiceCodeApplePayReceiptInvalid = 607,
    Queen_HServiceCodeGetPriceOfProductsFailure = 608,
    Queen_HServiceCodeFacebookLoginFailure = 700,
    Queen_HServiceCodeFacebookLoginCancel = 701,
    Queen_HServiceCodenetfail = 1005,
};
typedef NS_ENUM(NSInteger, Queen_HResponseStyle) {
    Queen_HResponseStyleUnknownStyle,
    Queen_HResponseStyleInitalStyle,
    Queen_HResponseStyleRegisterStyle,
    Queen_HResponseStyleLoginOutStyle,
    Queen_HResponseStyleEnterGameStyle,
    Queen_HResponseStyleApplePayStyle,
    Queen_HResponseStyleNormalLoginStyle,
    Queen_HResponseStyleFacebookLoginStyle,
    Queen_HResponseStyleGuestLoginStyle,
    Queen_HResponseStyleDeleteStyle,
};
#endif 
