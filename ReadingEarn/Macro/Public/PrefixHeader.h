//
//  PrefixHeader.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

/**
     第三方库头文件
 */
#import "UIView+Frame.h"
#import <MJExtension/MJExtension.h>
#import "AFNetworking.h"
#import "FMDB.h"
#import "IQKeyboardManager.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "TTTAttributedLabel.h"
#import   "UIImageView+WebCache.h"
#import "CRBoxInputView.h"
#import "YQImageCompressTool.h"
#import "ZZPhotoKit.h"
#import "REHomeBookDetailViewController.h"
#import "UIScrollView+QFRefresh.h"

/**
    public头文件
*/
#import "DefaultServerRequest.h"
#import "OtherServerRequest.h"
#import "NSString+Add.h"
#import "RELoginViewController.h"
#import "ToolObject.h"
#import "RESingleton.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import "REHomeViewController.h"
#import "REClassificationViewController.h"
#import "REBookshelfViewController.h"
#import "REUserViewController.h"
#import "REReadingEarnPopupView.h"
#import "UILabel+String.h"

#define TagBackBtn 5555;


#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44.f
#define NavHeight (StatusBarHeight + NavBarHeight)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 接口------------正式
 */
//#define HomePageDomainName @"https://api.yuezapp.com"
/**
接口------------测试
 */
#define HomePageDomainName @"http://test.xiaocao4.cn"

//接口------------本地
//#define HomePageDomainName @"http://www.api.yuezhuang.com"

//随机色
#define RERandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//颜色
#define REColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//公用颜色
#define RECommonColor [UIColor colorWithRed:254/255.0 green:199/255.0 blue:0/255.0 alpha:1.0]

//背景色
#define REBackColor [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]
//线条颜色
#define RELineColor [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]

//白色
#define REWhiteColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define REFontColor REColor(51,51,51)
//默认图片
#define PlaceholderImage [UIImage imageNamed:@""]
#define PlaceholderHead_Image [UIImage imageNamed:@"re_default_head"]


//宽高比
#define AspectRatio REScreenWidth / REScreenHeight

//字体
#define REFont(num) [UIFont fontWithName:@"PingFang SC" size: num]

//等比适配宽
#define AdaptationW(left_a_right_edge,count,control_edge) (REScreenWidth - left_a_right_edge*2 - (count - 1)*control_edge)/count

//导航栏字体默认颜色
#define RENavigationFontDefaultColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]

//导航栏字体选中颜色
#define RENavigationFontSelectColor [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]

//导航栏标题字体大小
#define RENavigationFont  [UIFont fontWithName:@"PingFang SC" size: 18]

//导航栏标题按钮高度和边距
#define RENavigationItemOfTitleViewHeight 34
#define RENavigationItemMargin 10

//首页导航popmenu距离顶部高度
#define REPopMenuMarginTop 10

//是否为4inch
#define REFourInch ([UIScreen mainScreen].bounds.size.height >= 568.0)

//是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//是否为iOS8以上系统
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
//屏幕宽度
#define REScreenWidth [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define REScreenHeight [UIScreen mainScreen].bounds.size.height

//导航栏高度
#define RENavigationHeight CGRectGetMaxY([self.navigationController navigationBar].frame)

//标签栏高度
#define RETabBarHeight self.tabBarController.tabBar.frame.size.height

//状态栏高度
#define REStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//设置一个全局tableView的背景颜色
#define REGlobleTableViewBackgroundColor REColor(239,239,239)

//加载本地图片
#define REImageName(imageName) [UIImage imageNamed:imageName]

//请求方式
#define RequestModeWithFirst               @"1"  //正常第一次请求
#define RequestModeWithSecond              @"2"  //上拉加载更多
#define RequestModeWithThree               @"3"  //下拉刷新
#define RequestModeWithFour                @"4"  //非第一次请求

#define ratioH(H)   H * (REScreenHeight/667)
#define ratioW(W)   W * REScreenWidth/375
#import "ERouter.h"
#import "EReaderContainerController.h"
#import "HSUpdateApp.h"
#import "OpenShareHeader.h"

#define AppID @"com.yuezapp.readingEarn"
#import <AVFoundation/AVFoundation.h>
#ifndef __OPTIMIZE__

#define HXNSlog(...) NSLog(__VA_ARGS__)

#else

#define HXNSlog(...){}

#endif
#endif /* PrefixHeader_h */

