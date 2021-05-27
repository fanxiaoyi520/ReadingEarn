//
//  RERegisterNextCertainViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERegisterNextCertainViewController.h"

@interface RERegisterNextCertainViewController ()

@property (nonatomic ,strong)UIButton *completeButton;
@property (nonatomic, strong) DefaultServerRequest *requestPay;
@end

@implementation RERegisterNextCertainViewController

- (void)viewDidLoad {
    self.switchNavigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self re_loadUI];
}

- (void)re_loadUI {
    //1.返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:REImageName(@"class_navbar_icon_return_nor") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, StatusBarHeight, 60, 44);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 20);
    [self.view addSubview:backButton];
    
    //2.支付密码设置提示
    UILabel *payLabel = [UILabel new];
    payLabel.font = REFont(34);
    payLabel.text = @"确认支付密码";
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
    tishiLabel.text = @"请确认支付密码";
    tishiLabel.textColor = REColor(158, 160, 165);
    tishiLabel.textAlignment = NSTextAlignmentCenter;
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
        if (isFinished) {
            strongself.completeButton.backgroundColor = REColor(255, 86, 34);
        } else {
            strongself.completeButton.backgroundColor = REColor(206, 206, 206);
        }
    };
    [boxInputView clearAllWithBeginEdit:YES]; // BeginEdit:清空后是否自动启用编辑模式
    
    //5.next按钮
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    completeButton.backgroundColor = REColor(206, 206, 206);
    [completeButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    completeButton.titleLabel.font = REFont(22);
    [completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    completeButton.layer.cornerRadius = 22.5;
    [self.view addSubview:completeButton];
    self.completeButton = completeButton;
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RENavigationHeight+REStatusHeight+110+28+30+60+60);
        make.height.equalTo(@55);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];

}

#pragma mark - 事件text
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 请求数据
- (void)registerRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestPay startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestPay = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self showError:response.responseObject[@"msg"]];
        } else {
            NSLog(@"设置支付密码成功");
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            tabbar.selectedIndex = 3;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestPay = nil;
    }];
}

#pragma mark - getter
- (DefaultServerRequest *)requestPay {
    if (!_requestPay) {
        _requestPay = [[DefaultServerRequest alloc] init];
        _requestPay.requestMethod = YCRequestMethodPOST;
        _requestPay.requestURI = [NSString stringWithFormat:@"%@/user/get_reg_code",HomePageDomainName];
        _requestPay.requestParameter = @{
                                       @"token":@"mobile",
                                       @"mobile":@""
                                      };
    }
    return _requestPay;
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
