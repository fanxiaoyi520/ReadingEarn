//
//  RERegisterNextViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERegisterNextViewController.h"
#import "RERegisterNextCertainViewController.h"

@interface RERegisterNextViewController ()

@property (nonatomic ,strong)UIButton *nextButton;
@property (nonatomic ,copy)NSString *payPassWoldStr;
@end

@implementation RERegisterNextViewController

- (void)viewDidLoad {
    self.switchNavigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REWhiteColor;
    [self re_loadUI];
}

- (void)re_loadUI {
    
    //1.返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:REImageName(@"class_navbar_icon_return_nor") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 20);
    //[self.view addSubview:backButton];

    //2.支付密码设置提示
    UILabel *payLabel = [UILabel new];
    payLabel.font = REFont(34);
    payLabel.text = @"支付密码设置";
    payLabel.textColor = REColor(51, 51, 51);
    payLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:payLabel];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RENavigationHeight+REStatusHeight+30);
        make.height.equalTo(@44);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    //3.支付提示
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.font = REFont(20);
    tishiLabel.text = @"为了您的账户安全,请设置交易密码";
    tishiLabel.textColor = REColor(158, 160, 165);
    tishiLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tishiLabel];
    [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RENavigationHeight+REStatusHeight+110);
        make.height.equalTo(@28);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    //4.输入框
    CRBoxInputView *boxInputView = [CRBoxInputView new];
    boxInputView.securityDelay = CRBoxSecurityCustomViewType;
    boxInputView.codeLength = 6;// 不设置时，默认4
    [boxInputView loadAndPrepareViewWithBeginEdit:YES]; // BeginEdit:是否自动启用编辑模式
    [self.view addSubview:boxInputView];
    [boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RENavigationHeight+REStatusHeight+110+28+30);
        make.height.equalTo(@50);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    __weak typeof (self)weekself = self;
    boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        __strong typeof (weekself)strongself = weekself;
        NSLog(@"text:%@", text);
        if (isFinished) {
            strongself.nextButton.backgroundColor = REColor(255, 86, 34);
            self.payPassWoldStr = text;
        } else {
            strongself.nextButton.backgroundColor = REColor(206, 206, 206);
        }
    };
    [boxInputView clearAllWithBeginEdit:YES]; // BeginEdit:清空后是否自动启用编辑模式
    
    //5.next按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.backgroundColor = REColor(206, 206, 206);
    nextButton.layer.cornerRadius = 22.5;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    nextButton.titleLabel.font = REFont(22);
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RENavigationHeight+REStatusHeight+110+28+30+60+60);
        make.height.equalTo(@55);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
}

#pragma mark - 事件
- (void) backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonAction:(UIButton *)sender {
    RERegisterNextCertainViewController *vc = [RERegisterNextCertainViewController new];
    vc.payPassWoldStr = self.payPassWoldStr;
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
