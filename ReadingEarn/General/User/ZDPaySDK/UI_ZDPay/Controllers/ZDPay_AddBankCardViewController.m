//
//  ZDPay_AddBankCardViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_AddBankCardViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_AddBankCardSecondViewController.h"

@interface ZDPay_AddBankCardViewController ()

@end

@implementation ZDPay_AddBankCardViewController

- (void)viewDidLoad {
    self.naviTitle = @"添加银行卡";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTextField:@selector(textFieldAction:) andWithBtn:@selector(btnAction:)];
}

- (void)creatTextField:(SEL)textFieldAction andWithBtn:(SEL)btnAction {
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"卡号" withFont:ZD_Fout_Regular(ratioH(16))];
    label.textColor = COLORWITHHEXSTRING(@"#333333", 1);
    label.frame = CGRectMake(20, ratioH(54) + mcNavBarAndStatusBarHeight, rect.size.width, ratioH(16));
    label.text = @"卡号";
    label.font = ZD_Fout_Regular(ratioH(16));
    
    UITextField *textField = [UITextField new];
    [self.view addSubview:textField];
    [textField addTarget:self action:textFieldAction forControlEvents:UIControlEventValueChanged];
    textField.placeholder = @"请输入卡号";
    textField.frame = CGRectMake(72, ratioH(34)+mcNavBarAndStatusBarHeight, ScreenWidth-40-rect.size.width-10, ratioH(56));
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
    [self.view addSubview:lineView];
    lineView.frame = CGRectMake(20, ratioH(89)+mcNavBarAndStatusBarHeight, ScreenWidth-40, ratioH(1.0));
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", .5);
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = ZD_Fout_Medium(18);
    [nextBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(20, ratioH(130)+mcNavBarAndStatusBarHeight, ScreenWidth-40, ratioH(42));
    nextBtn.layer.cornerRadius = ratioH(21);
    nextBtn.layer.masksToBounds = YES;
}

- (void)textFieldAction:(UITextField *)textField {
    
}

- (void)btnAction:(UIButton *)sender {
    ZDPay_AddBankCardSecondViewController *vc = [ZDPay_AddBankCardSecondViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
