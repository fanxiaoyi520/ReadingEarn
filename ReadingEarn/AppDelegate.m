//
//  AppDelegate.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "AppDelegate.h"
#import "AxcAE_TabBarDefine.h"
#import "RELoginViewController.h"
#import "REHomeViewController.h"
#import "REUserModel.h"
#import "JWLaunchAd.h"
#import <WXApi.h>

@interface AppDelegate ()


@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) REUserModel *userModel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1.微信分享33cf77e076237a42284151745219bf39
    //[OpenShare connectWeixinWithAppId:@"" miniAppId:@"wx5e3f807c9ec46bbd"];
    //[WXApi registerApp:@"wx5e3f807c9ec46bbd" universalLink:@"https://api.yuezapp.com/"];
    [self re_Initialization];
    return YES;
}
 
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //（如果OpenShare能处理这个局部，就调用块中的方法，如果不能处理，就交给其他（支付支付宝）。）
    if ([url.scheme isEqualToString:@"readingearn"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_TABLEVIEW" object:nil];
    }
    
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{

    NSLog(@"userActivity : %@",userActivity.webpageURL.description);
    return YES;
}

- (void)re_Initialization {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    NSString *VCName = @"CustomImageTabBarVC";
    Class class = NSClassFromString(VCName);
    self.tabbar = [[class alloc]init];
    
    //隐藏第一次启动标签栏第一个标签文字重叠问题，第三方框架的hiden方法没有调用到
    if ([self.tabbar.tabBar isKindOfClass:[UITabBar class]]) {
        dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIView *btn in self.tabbar.tabBar.subviews) {
                    if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                        btn.hidden = YES;
                    }
                }
            });
        });
    }
    
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    
//    UIImageView *d = [UIImageView new];
//    d.image = REImageName(@"DefaultLaunch828x1792");
//    [JWLaunchAd initImageWithAttribute:6.0 showSkipType:SkipShowTypeAnimation setLaunchAd:^(JWLaunchAd *launchAd) {
//        __block JWLaunchAd * weakSelf = launchAd;
//        [weakSelf setAnimationSkipWithAttribute:[UIColor redColor] lineWidth:3.0 backgroundColor:nil textColor:nil];
//        [launchAd setLaunchAdImgView:d];
//    }];
}

@end
