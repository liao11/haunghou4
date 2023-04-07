

#import "AppDelegate.h"
#import "QueenSDKHeader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configSDKSettings];
    QueenConfigInfo *config = [[QueenConfigInfo alloc] init];
    config.gameID = @"33";
    config.gameExtra = @"D53A17E72E38C05BCFCC9EEAEC4F152F";
//    config.gameID = @"88";
//    config.gameExtra = @"48EDC5FB3EF3A7AEABADDF5D9DCB21FC";
//
//    config.fbAppID = @"2135038443344260";
    config.fbAppID = @"1912120749119216";
    config.adjustAppToken = @"dt9z7c5aescg";
    config.appleAppID = @"6444477674";
    
    [QueenSDKMainApi QueensharedInstance].JPBaoFu_configInfo = config;
    [QueenSDKMainApi QueenOpenLog:YES];
    [QueenSDKMainApi QueenlaunchSDKWithApplication:application didFinishLaunchingWithOptions:launchOptions isProductionEnvironment:NO];
    return YES;
}

- (void)configSDKSettings {
    //SDK配置
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return [QueenSDKMainApi application:application
                              openURL:url
                    sourceApplication:sourceApplication
                           annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [QueenSDKMainApi application:app openURL:url options:options ];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [QueenSDKMainApi QueenactivateApp];
}


@end
