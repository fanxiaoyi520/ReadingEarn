//
//  ZDPay_SecurityVerificationSecondViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_SecurityVerificationSecondViewController.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_SecurityVerificationSecondViewController ()

@end

@implementation ZDPay_SecurityVerificationSecondViewController

- (void)viewDidLoad {
    self.naviTitle = @"安全验证";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];

    [self creatForgetPassSel:@selector(forgetPassAction:)];
}

- (void)creatForgetPassSel:(SEL)forgetPassAction {
    
    UILabel *titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    titleLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    titleLab.font = ZD_Fout_Regular(16);
    titleLab.text = @"请输入支付密码，已验证身份";
    titleLab.frame = CGRectMake(0, ratioH(54)+mcNavBarAndStatusBarHeight, ScreenWidth, 16);
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    CRBoxInputView *boxInputView = [CRBoxInputView new];
    boxInputView.codeLength = 6;
    [boxInputView loadAndPrepareViewWithBeginEdit:YES]; // BeginEdit:是否自动启用编辑模式
    [self.view addSubview:boxInputView];
    boxInputView.ifNeedSecurity = YES;
    boxInputView.securityDelay = CRBoxSecurityCustomViewType;
    boxInputView.frame = CGRectMake(41, mcNavBarAndStatusBarHeight + ratioH(110), ScreenWidth-82, 50);
    //@WeakObj(self)
    boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        //@StrongObj(self)

    };
    [boxInputView clearAllWithBeginEdit:YES]; // BeginEdit:清空后是否自动启用编辑模式

    CGRect forgetPassRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"忘记密码" withFont:ZD_Fout_Regular(ratioH(14))];
    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:forgetPassBtn];
    [forgetPassBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPassBtn.titleLabel.font = ZD_Fout_Regular(ratioH(14));
    [forgetPassBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", .7) forState:UIControlStateNormal];
    forgetPassBtn.frame = CGRectMake(ScreenWidth - 41 - forgetPassRect.size.width, ratioH(180)+mcNavBarAndStatusBarHeight, forgetPassRect.size.width, ratioH(14));
    [forgetPassBtn addTarget:self action:forgetPassAction forControlEvents:UIControlEventTouchUpInside];
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
