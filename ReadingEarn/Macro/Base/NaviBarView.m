//
//  NaviBarView.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/19.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "NaviBarView.h"

@implementation NaviBarView

- (instancetype)initWithController:(RERootViewController *)controller {
    //_controller = controller;
    
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, StatusBarHeight + NavBarHeight)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.zPosition = 999999;
    
    // 最顶部的状态栏
    _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, StatusBarHeight)];
    _statusBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_statusBar];
    
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenWidth, NavBarHeight)];
    _navigationBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_navigationBar];

    //线条
    UIView *lineView = [[UIView alloc] init];
    lineView.tag = 1000;
    lineView.frame = CGRectMake(0,StatusBarHeight + NavBarHeight,ScreenWidth,1);
    lineView.backgroundColor = RELineColor;
    [self addSubview:lineView];
    
    //导航标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
//    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    titleLabel.frame = CGRectMake(50, StatusBarHeight+9, REScreenWidth-100, 25);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    return self;
}

// 返回按钮
- (void)addBackBtn {
    
    // 不能添加多个
    UIView *srcBack = [_navigationBar viewWithTag:5555];
    if (srcBack)
        return;
    
    UIImage *background = REImageName(@"class_navbar_icon_return_nor");
    UIImage *backgroundOn = REImageName(@"class_navbar_icon_return_nor");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAccessibilityIdentifier:@"TopBackBtn"];
    button.tag = TagBackBtn;
    //[button onTap:self action:@selector(doBackPrev)];
    [button addTarget:self action:@selector(doBackPrev) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:background forState:UIControlStateNormal];
    [button setImage:backgroundOn forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 20);
    [_navigationBar addSubview:button];
    //[button rtlToParent];
    _backBtn = button;
}

- (void)changeBackImage:(NSString *)imageStr {
    [_backBtn setImage:REImageName(imageStr) forState:UIControlStateNormal];
    [_backBtn setImage:REImageName(imageStr) forState:UIControlStateHighlighted];
}

// 添加顶部右边的文字类的按钮
//- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action {
//    //TagRightMenu
//    // 当重复添加时,移除旧的按钮
//    UILabel *srcLabel = (UILabel *)[_navigationBar viewWithTag:6666];
//    if (srcLabel) {
//        [srcLabel removeFromSuperview];
//    }
//    
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, 0, 100, 44)];
//    lb.backgroundColor = [UIColor clearColor];
//    lb.font = [UIFont systemFontOfSize:16];
//    lb.textColor = [UIColor blackColor];
//    lb.text = actionName;
//    lb.userInteractionEnabled = YES;
//    lb.textAlignment = NSTextAlignmentRight;
//    lb.tag = 6666;
//    //[lb onTap:_controller action:action];
//    [_navigationBar addSubview:lb];
//    //[lb rtlToParent];
//    //_rightMenuView = lb;
//    return lb;
//}

#pragma mark - set

- (void)clearNavBarBackgroundColor {
    _statusBar.backgroundColor = [UIColor clearColor];
    _navigationBar.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    [self removeChildByTag:1000];
}

- (void)removeChildByTag:(NSInteger)lineTag {
    UIView *lineView = [self viewWithTag:lineTag];
    [lineView removeFromSuperview];
}

- (void)setNavigationTitle:(NSString *)title {
    if (title.length>0) {
        self.titleLabel.text = title;
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
//        self.titleLabel.attributedText = string;
    }
}

- (void)setBackImage:(NSString *)imageName {
    UIImage *background = [UIImage imageNamed:imageName];
    UIImage *backgroundOn = [UIImage imageNamed:imageName];
    [_backBtn setImage:background forState:UIControlStateNormal];
    [_backBtn setImage:backgroundOn forState:UIControlStateHighlighted];
}

- (void)doBackPrev {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)addSearchBox {
    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(42, 4, REScreenWidth-62, 34))];
    customSearchBar.placeholder = @"请输入关键字";
    customSearchBar.delegate = self;
    customSearchBar.searchBarStyle = UISearchBarStyleDefault;
    self.customSearchBar = customSearchBar;
    self.customSearchBar.showsCancelButton = YES;
    customSearchBar.backgroundImage = [ToolObject imageWithColor:REWhiteColor size:CGSizeMake(1,1)];
    [_navigationBar addSubview:self.customSearchBar];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class],nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
}

#pragma mark - UISearchBarDelegate 协议
// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.searchBarShouldBeginEditingBlock) {
        self.searchBarShouldBeginEditingBlock(searchBar);
    }
    return YES;
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.customSearchBar resignFirstResponder];
    if (self.searchBarCancelButtonClickedBlock) {
        self.searchBarCancelButtonClickedBlock(searchBar);
    }
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    [self.customSearchBar resignFirstResponder];// 放弃第一响应者
    if (self.searchBarSearchButtonClickedBlock) {
        self.searchBarSearchButtonClickedBlock(searchBar);
    }
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    NSLog(@"textDidChange---%@",searchBar.text);
    if (self.searchBartextDidChangeBlock) {
        self.searchBartextDidChangeBlock(searchBar,searchText);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
