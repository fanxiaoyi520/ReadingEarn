//
//  NaviBarView.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/19.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RERootViewController;

NS_ASSUME_NONNULL_BEGIN

typedef void(^BackBlock)(void);
typedef void (^SearchBarShouldBeginEditingBlock)(UISearchBar *searchBar);
typedef void (^SearchBarCancelButtonClickedBlock)(UISearchBar *searchBar);
typedef void (^SearchBarSearchButtonClickedBlock)(UISearchBar *searchBar);
typedef void (^SearchBartextDidChangeBlock)(UISearchBar *searchBar,NSString *searchText);

@interface NaviBarView : UIView<UISearchBarDelegate>
@property (copy, nonatomic) SearchBarShouldBeginEditingBlock searchBarShouldBeginEditingBlock;
@property (copy, nonatomic) SearchBarCancelButtonClickedBlock searchBarCancelButtonClickedBlock;
@property (copy, nonatomic) SearchBarSearchButtonClickedBlock searchBarSearchButtonClickedBlock;
@property (copy, nonatomic) SearchBartextDidChangeBlock searchBartextDidChangeBlock;


@property (strong, nonatomic) UIView *statusBar;    // 状态栏
@property (strong, nonatomic) UIView *navigationBar;    // 导航条
@property (strong, nonatomic) UIButton *rightWishBtn;   // 右侧分享按钮
@property (strong, nonatomic) UIButton *leftMenuBtn;    // 左侧菜单栏
@property (strong, nonatomic) UIButton *backBtn;    // 返回按钮
@property (strong, nonatomic) UILabel *titleLabel;  // 标题
@property(nonatomic, strong)UIView *lineView;   // 底部分割线
@property(nonatomic, strong)UISearchBar *customSearchBar;   // 底部分割线

@property (nonatomic, copy) BackBlock backBlock;
- (instancetype)initWithController:(RERootViewController *)controller;

// 搜索
- (void)addSearchBox;
// 添加返回按钮
- (void)addBackBtn;
// 添加底部分割线
- (void)addBottomSepLine;
// 设置标题
- (void)setNavigationTitle:(NSString *)title;
// 设置导航条透明
- (void)clearNavBarBackgroundColor;
// 设置导航条透明
- (void)changeBackImage:(NSString *)imageStr;
// 右侧添加按钮
//- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action;
@end

NS_ASSUME_NONNULL_END
