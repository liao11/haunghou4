#import "QueenCHIUserInfo.h"
@implementation QueenCHIUserInfo
- (NSString *)userName {
    if (!_userName) {
        _userName = @"";
    }
    _userName = [_userName lowercaseString];
    return _userName;
}
@end
