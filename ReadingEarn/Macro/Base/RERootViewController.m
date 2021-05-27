//
//  RERootViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

@interface RERootViewController ()
@end

@implementation RERootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.height == 0) {
        _topNavBar.alpha = 0;
    }
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
        forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.clipsToBounds = YES;

    // 将导航放到最顶部,不然后面有其它的层会被覆盖
    [self.view bringSubviewToFront:_topNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = REWhiteColor;
    self.navigationController.navigationBar.backgroundColor = REWhiteColor;
    // Do any additional setup after loading the view.
     [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    // 所有界面隐藏导航栏,用自定义的导航栏代替
    //self.fd_prefersNavigationBarHidden = YES;
    // drawUI
    [self drawTopNaviBar];
    if (self.switchNavigationBarHidden == NO) {
        self.topNavBar.hidden = NO;
    } else {
        self.topNavBar.hidden = YES;
    }
}

#pragma mark - 自定义导航栏
/// 在旋转界面时重新构造导航条
- (void)drawTopNaviBar {
    if (_topNavBar) {
        [_topNavBar removeFromSuperview];
    }
    // 添加自定义的导航条
    NaviBarView *naviBar = [[NaviBarView alloc] initWithController:self];
    [self.view addSubview:naviBar];
    self.topNavBar = naviBar;
    //返回点击事件
    naviBar.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    if (![self isKindOfClass:[REHomeViewController class]] && ![self isKindOfClass:[REClassificationViewController class]] && ![self isKindOfClass:[REBookshelfViewController class]]  && ![self isKindOfClass:[REUserViewController class]]) {
        // 添加返回按钮
        [_topNavBar addBackBtn];
        [_topNavBar setNavigationTitle:self.naviTitle];
        // 添加底部分割线 - 如果不需要添加,这里处理即可
        //[_topNavBar addBottomSepLine];
    }
    
    /**
    // 自动放一个容器在下面,如果全屏的界面就往 self.view 加子,非全屏的往 container 加
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    */
}

#pragma mark - 弹出框
- (void)showError:(NSString *)errorMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)show:(NSString *)errorMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}


#pragma mark - 提示框
-(void)showAlertMsg:(NSString *)message Duration:(float)duration
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(REScreenWidth-50, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0; //
    
    [showview addSubview:label];
    showview.frame = CGRectMake((REScreenWidth - LabelSize.width)/2, REScreenHeight/2 +50+LabelSize.height, LabelSize.width+10, LabelSize.height+10);
    [UIView animateWithDuration:duration animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma mark - 自定义导航栏--------导航按钮
- (void)customNavigationBarButtonToggleArray:(NSArray *)titleArray leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin  buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.buttonWidth = buttonWidth;
    self.leftMargin = leftMargin;
    self.titleArrayCount = titleArray.count;
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
        navButton.frame = CGRectMake(leftMargin+i*(buttonWidth+(REScreenWidth-2*leftMargin-(titleArray.count*buttonWidth))/(titleArray.count-1)), topMargin, buttonWidth, buttonHeight);
        navButton.tag = 100+i;
        self.btnTag = 100;
        [navButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [navButton setTitleColor:RENavigationFontDefaultColor forState:UIControlStateNormal];
        [navButton setTitleColor:RENavigationFontSelectColor forState:UIControlStateSelected];
        navButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [navButton addTarget:self action:@selector(customNavButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *underLine = [[UIView alloc] init];
        underLine.tag = 200;
        underLine.frame = CGRectMake(leftMargin, NavHeight-3, buttonWidth, 3);
        underLine.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
        if (i==0) {
            navButton.selected = YES;
            [self.topNavBar addSubview:underLine];
            //self.navigationController.title = @"1";
        }
        //self.navigationController.title = @"1";
        [self.topNavBar addSubview:navButton];
    }
}

- (void)customNavButtonAction:(UIButton *)sender {
    UIButton *btn = [self.topNavBar viewWithTag:self.btnTag];
    UIView *underLine = [self.topNavBar viewWithTag:200];
    underLine.frame = CGRectMake(self.leftMargin+(sender.tag-100)*(self.buttonWidth+(REScreenWidth-2*self.leftMargin-self.titleArrayCount*self.buttonWidth)/(self.titleArrayCount-1)), NavHeight -3, self.buttonWidth, 3);
    if (sender.selected == YES) {
        self.btnTag = sender.tag;
    } else {
        sender.selected = YES;
        btn.selected = NO;
        [btn setTitleColor:RENavigationFontDefaultColor forState:UIControlStateNormal];
        [sender setTitleColor:RENavigationFontSelectColor forState:UIControlStateSelected];
        self.btnTag = sender.tag;
    }
}


#pragma mark - 模块系统导航栏------------切换按钮封装
- (void)navigationBarButtonToggleArray:(NSArray *)titleArray leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin  buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.buttonWidth = buttonWidth;
    self.leftMargin = leftMargin;
    self.titleArrayCount = titleArray.count;
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
        navButton.frame = CGRectMake(leftMargin+i*(buttonWidth+(REScreenWidth-2*leftMargin-(titleArray.count*buttonWidth))/(titleArray.count-1)), topMargin, buttonWidth, buttonHeight);
        navButton.tag = 100+i;
        self.btnTag = 100;
        [navButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [navButton setTitleColor:RENavigationFontDefaultColor forState:UIControlStateNormal];
        [navButton setTitleColor:RENavigationFontSelectColor forState:UIControlStateSelected];
        navButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [navButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *underLine = [[UIView alloc] init];
        underLine.tag = 200;
        underLine.frame = CGRectMake(leftMargin, self.navigationController.navigationBar.frame.size.height-3, buttonWidth, 3);
        underLine.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
        if (i==0) {
            navButton.selected = YES;
            [self.navigationController.navigationBar addSubview:underLine];
            self.navigationController.title = @"1";
        }
        self.navigationController.title = @"1";
        [self.navigationController.navigationBar addSubview:navButton];
    }
}

- (void)navButtonAction:(UIButton *)sender {
    UIButton *btn = [self.navigationController.navigationBar viewWithTag:self.btnTag];
    UIView *underLine = [self.navigationController.navigationBar viewWithTag:200];
    underLine.frame = CGRectMake(self.leftMargin+(sender.tag-100)*(self.buttonWidth+(REScreenWidth-2*self.leftMargin-self.titleArrayCount*self.buttonWidth)/(self.titleArrayCount-1)), self.navigationController.navigationBar.frame.size.height-3, self.buttonWidth, 3);
    if (sender.selected == YES) {
        self.btnTag = sender.tag;
    } else {
        sender.selected = YES;
        btn.selected = NO;
        [btn setTitleColor:RENavigationFontDefaultColor forState:UIControlStateNormal];
        [sender setTitleColor:RENavigationFontSelectColor forState:UIControlStateSelected];
        self.btnTag = sender.tag;
    }
}


#pragma mark - 隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    //BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
