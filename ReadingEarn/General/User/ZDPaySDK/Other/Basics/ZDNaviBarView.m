//
//  ZDNaviBarView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDNaviBarView.h"
#import "ZDPayFuncTool.h"

@implementation ZDNaviBarView

- (instancetype)initWithController:(UIViewController *)controller {
    
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, mcStatusBarHeight + mcNavBarHeight)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.zPosition = 999999;
    
    // 最顶部的状态栏
    _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, mcStatusBarHeight)];
//    _statusBar.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
    [self addSubview:_statusBar];
    
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, mcStatusBarHeight, ScreenWidth, mcNavBarHeight)];
//    _navigationBar.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
    [self addSubview:_navigationBar];

    //线条
    UIView *lineView = [[UIView alloc] init];
    lineView.tag = 1000;
    lineView.frame = CGRectMake(0,mcStatusBarHeight + mcNavBarHeight,ScreenWidth,1);
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
    [self addSubview:lineView];
    
    //导航标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = ZD_Fout_Medium(ratioH(17));
    titleLabel.frame = CGRectMake(50, mcStatusBarHeight+9, REScreenWidth-100, 25);
    titleLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    return self;
}

- (void)setNavAndStatusBarColor:(UIColor *)color {
    _statusBar.backgroundColor = color;
    _navigationBar.backgroundColor = color;
}

// 返回按钮
- (void)addBackBtn {

    UIView *srcBack = [_navigationBar viewWithTag:5555];
    if (srcBack)
        return;
    
    UIImage *background = REImageName(@"class_navbar_icon_return_nor");
    UIImage *backgroundOn = REImageName(@"class_navbar_icon_return_nor");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAccessibilityIdentifier:@"TopBackBtn"];
    button.tag = TagBackBtn;
    [button addTarget:self action:@selector(doBackPrev) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:background forState:UIControlStateNormal];
    [button setImage:backgroundOn forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 20);
    [_navigationBar addSubview:button];
    _backBtn = button;
}

- (void)addBankCardBTnTitle:(NSString *__nullable)title
                   btnImage:(NSString *__nullable)imageStr
              BankJumpBlock:(void (^)(UIButton *sender))bankJumpBlock  {
    
    self.bankJumpBlock = bankJumpBlock;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(bankJumpAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.width-15-44, mcStatusBarHeight, 44, 44);
    [self addSubview:button];
    _backBtn = button;

    if (imageStr) {
        UIImage *background = REImageName(imageStr);
        UIImage *backgroundOn = REImageName(imageStr);
        [button setImage:background forState:UIControlStateNormal];
        [button setImage:backgroundOn forState:UIControlStateHighlighted];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = ZD_Fout_Medium(15);
        [button setTitleColor:COLORWITHHEXSTRING(@"#666666", 1.0) forState:UIControlStateNormal];
    }
}

- (void)bankJumpAction:(UIButton *)sender {
    if (self.bankJumpBlock) {
        self.bankJumpBlock(sender);
    }
}

- (void)changeBackImage:(NSString *)imageStr {
    [_backBtn setImage:REImageName(imageStr) forState:UIControlStateNormal];
    [_backBtn setImage:REImageName(imageStr) forState:UIControlStateHighlighted];
}

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

@end
