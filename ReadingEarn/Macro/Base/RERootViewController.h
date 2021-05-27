//
//  RERootViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RERootNavigationViewController.h"
#import "NaviBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RERootViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic ,assign)CGFloat leftMargin;
@property (nonatomic ,assign)CGFloat buttonWidth;
@property (nonatomic ,assign)NSInteger titleArrayCount;
@property (nonatomic ,assign)NSInteger btnTag;

#pragma mark - 自定义导航条相关
@property(nonatomic, assign)BOOL switchNavigationBarHidden;  // 标题
@property(nonatomic, copy)NSString *naviTitle;  // 标题
/** 导航条 */
@property(nonatomic, strong)NaviBarView *topNavBar;
/** 内容视图 */
@property (strong, nonatomic) UIView *containerView;

// 返回按钮点击操作
- (void)doBackPrev;
// 扫码和心愿单
//- (void)addScanAndWishList;
// 设置导航条透明
//- (void)clearNavBarBackgroundColor;

// 添加按钮
//- (UIButton *)addBtnWithTitle:(NSString *)title action:(SEL)action;

//- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action;

#pragma mark - 系统导航条
/**
 导航栏切换按钮封装
 1.titleArray 按钮文字内容数组
 2.leftMargin 第一个按钮的左边距
 3.topMargin 按钮的上边距
 3.buttonSpacing 按钮之间的空隙
 */
- (void)navigationBarButtonToggleArray:(NSArray *)titleArray leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin  buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight;
//按钮的点击事件
- (void)navButtonAction:(UIButton *)sender;

- (void)customNavigationBarButtonToggleArray:(NSArray *)titleArray leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin  buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight;
- (void)customNavButtonAction:(UIButton *)sender;

//提示框
-(void)showAlertMsg:(NSString *)message Duration:(float)duration;
- (void)showError:(NSString *)errorMsg;
@end

NS_ASSUME_NONNULL_END
