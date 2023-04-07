#import <UIKit/UIKit.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0" 
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
typedef NS_ENUM(NSInteger,DeviceOrientationType){
    DeviceOrientationTypeVertical,
    DeviceOrientationTypeHorizontal,
    DeviceOrientationTypeUnknown
};
@interface UIDevice (YJExpand)
+ (NSString *)getCurrentDeviceModel;
+ (NSString *)getCurrentDeviceUUID;
+(NSString *)getCurrentDeviceModelProvider;
+ (NSString *)getCurrentDeviceNetworkingStates;
+ (DeviceOrientationType)deviceVerticalOrHorizontal;
+ (NSString *)gainIDFA;
+ (NSString *)gainAppVersion;
+ (NSString *)obtainChannel;
+ (NSString *)obtainSubChannel;
@end
