//
//  ZDPay_SafetyCertificationViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_SafetyCertificationViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_SecurityVerificationSecondViewController.h"

@interface ZDPay_SafetyCertificationViewController ()

@property (strong, nonatomic)CountDown *countDownForBtn;
@property (nonatomic ,strong)UITextField *textField;
@property (nonatomic ,strong)UIButton *countDownBtn;
@end

@implementation ZDPay_SafetyCertificationViewController

- (void)viewDidLoad {
    self.naviTitle = @"安全认证";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];

    [self creatTextField:@selector(textFieldAction:) andWithBtn:@selector(btnAction:)];
}

- (void)creatTextField:(SEL)textFieldAction andWithBtn:(SEL)btnAction {
    _countDownForBtn = [[CountDown alloc] init];
    
    UILabel *titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    titleLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    titleLab.font = ZD_Fout_Regular(16);
    titleLab.text = @"请输入短信验证码";
    titleLab.frame = CGRectMake(0, ratioH(54)+mcNavBarAndStatusBarHeight, ScreenWidth, 16);
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *iphoneLab = [UILabel new];
    [self.view addSubview:iphoneLab];
    iphoneLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    iphoneLab.font = ZD_Fout_Regular(16);
    iphoneLab.text = @"+852 12338948990";
    iphoneLab.frame = CGRectMake(0, ratioH(80)+mcNavBarAndStatusBarHeight, ScreenWidth, 16);
    iphoneLab.textAlignment = NSTextAlignmentCenter;

    
    CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"53s" withFont:ZD_Fout_Medium(16)];
    UITextField *textField = [UITextField new];
    self.textField = textField;
    [self.view addSubview:textField];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:textFieldAction forControlEvents:UIControlEventEditingChanged];
    textField.placeholder = @"请输验证码";
    textField.frame = CGRectMake(20, ratioH(126)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
    [self.view addSubview:lineView];
    lineView.frame = CGRectMake(20, ratioH(181)+mcNavBarAndStatusBarHeight, ScreenWidth-40, .5);
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1);
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = ZD_Fout_Medium(18);
    [nextBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(20, ratioH(222)+mcNavBarAndStatusBarHeight, ScreenWidth-40, ratioH(42));
    nextBtn.layer.cornerRadius = ratioH(21);
    nextBtn.layer.masksToBounds = YES;


    UIButton *countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countDownBtn = countDownBtn;
    [countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1.0) forState:UIControlStateNormal];
    [self.view addSubview:countDownBtn];
    countDownBtn.titleLabel.font = ZD_Fout_Regular(16);
    countDownBtn.layer.cornerRadius = ratioH(13);
    countDownBtn.layer.masksToBounds = YES;
    countDownBtn.frame = CGRectMake(textField.right + 10, ratioH(140)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
    [countDownBtn addTarget:self action:@selector(countDownBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self startcountDown];
}

- (void)startcountDown {
    NSTimeInterval aMinutes = 4;
    [_countDownForBtn countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"重新获取验证码" withFont:ZD_Fout_Medium(16)];
            self.textField.frame = CGRectMake(20, ratioH(126)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
            self.countDownBtn.frame = CGRectMake(self.textField.right + 10, ratioH(140)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
            self.countDownBtn.enabled = YES;
            self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#999999", 1.0);
            [self.countDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.countDownBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        }else{
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"60s" withFont:ZD_Fout_Medium(16)];
            self.textField.frame = CGRectMake(20, ratioH(126)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
            self.countDownBtn.frame = CGRectMake(self.textField.right + 10, ratioH(140)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
            self.countDownBtn.backgroundColor = [UIColor clearColor];
            [self.countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1.0) forState:UIControlStateNormal];
            self.countDownBtn.enabled = NO;
            [self.countDownBtn setTitle:[NSString stringWithFormat:@"%lis",totoalSecond] forState:UIControlStateNormal];
        }
    }];
}

- (void)countDownBtnAction:(UIButton *)sender {
    [self startcountDown];
}

- (void)textFieldAction:(UITextField *)textField {
    
}

- (void)btnAction:(UIButton *)sender {
    if ([self.countDownBtn.titleLabel.text isEqualToString:@"重新获取验证码"]) {
        [self showMessage:@"验证码过期" target:nil];
    } else {
        ZDPay_SecurityVerificationSecondViewController *vc = [ZDPay_SecurityVerificationSecondViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealloc {
    [self.countDownForBtn destoryTimer];
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
