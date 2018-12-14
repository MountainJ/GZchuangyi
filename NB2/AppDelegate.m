//
//  AppDelegate.m
//  NB2
//
//  Created by kohn on 13-11-16.
//  Copyright (c) 2013年 Kohn. All rights reserved.
//

#import "AppDelegate.h"
#import "FristViewController.h"
#import "TabViewController.h"
#import "NavViewController.h"
#import "AFNetworking.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];


    NavViewController *nav;
    if (![ConvertValue isNULL:UID]&&![ConvertValue isNULL:MD5])
    {
        TabViewController *rootVC = [[TabViewController alloc]init];
        nav=[[NavViewController alloc] initWithRootViewController:rootVC];
    }else
    {
        FristViewController *rootVC = [[FristViewController alloc]init];
        nav=[[NavViewController alloc] initWithRootViewController:rootVC];
    }
    nav.navigationBarHidden=YES;
    //配置工程基本的基本配置
    self.window.rootViewController = nav;
    //[self performSelector:@selector(test) withObject:nil afterDelay:0.35f];
    
    return YES;
}

- (void)test {
   
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status==AFNetworkReachabilityStatusReachableViaWWAN||status==AFNetworkReachabilityStatusReachableViaWiFi)
        {
            [ToolControl showBlockHudWithResult:NO andTip:@"已连接网络"];
        }else
        {
            [ToolControl showBlockHudWithResult:NO andTip:@"网络已断开"];

        }
        
    }];
    
}
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

@end
