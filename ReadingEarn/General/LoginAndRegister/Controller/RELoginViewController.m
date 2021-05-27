//
//  RELoginViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RELoginViewController.h"
#import "RERegisterViewController.h"
#import "RELoginModel.h"
#import "REForgetPassWordViewController.h"

@interface RELoginViewController ()

@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic, strong) DefaultServerRequest *requestLogin;
@property (nonatomic, strong) RELoginModel *loginModel;
@property (nonatomic, strong) NSMutableDictionary *mutableDic;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, copy) NSString *imageStr;
@end

@implementation RELoginViewController

- (void)viewDidLoad {
    self.switchNavigationBarHidden = YES;
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.mutableDic = [NSMutableDictionary dictionary];
    self.view.backgroundColor = REWhiteColor;
    
    //[self re_loadUI];
    [self requestNetworkC];
}

#pragma mark - 网络请求-------登陆
- (void)requestNetworkC {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"1"]) {
            //register
            self.imageStr = response.responseObject[@"data"][@"login"];
            
            [self re_loadUI];
        } else {
            [self showAlertMsg:msg Duration:2];
        }

    } failure:^(YCNetworkResponse * _Nonnull response) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
    }];

}

- (DefaultServerRequest *)requestC {
//    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestC) {
        _requestC = [[DefaultServerRequest alloc] init];
        _requestC.requestMethod = YCRequestMethodGET;
        _requestC.requestURI = [NSString stringWithFormat:@"%@/ucenter/user_log",HomePageDomainName];
    }
    return _requestC;
}


#pragma mark - 加载UI
- (void)re_loadUI {
    
    //1.bg
    [self bgImageView];
    CGFloat bgH = REScreenWidth * 224/375;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(bgH);
    }];
    //2.账户密码
    NSArray *placeholderArray = @[@"请输入手机号码",@"请输入6-8位密码"];
    for (int i=0; i<2; i++) {
        UITextField *accAndPassTextField = [UITextField new];
        accAndPassTextField.tag = 100+i;
        accAndPassTextField.placeholder = placeholderArray[i];
        accAndPassTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        accAndPassTextField.frame = CGRectMake(20, bgH+20+i*(56), REScreenWidth-2*20, 56);
        accAndPassTextField.borderStyle = UITextBorderStyleNone;
        [accAndPassTextField addTarget:self action:@selector(accAndPassTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:accAndPassTextField];
        
        UIView *lineView = [UIView new];
        lineView.frame = CGRectMake(20, bgH+20+56+i*(1+56), REScreenWidth-2*20, 0.5);
        lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [self.view addSubview:lineView];
        if (i==1) {
            accAndPassTextField.secureTextEntry = YES;
        }
    }
    
    //3.忘记密码
    UIButton *forgetPassbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPassbutton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPassbutton addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPassbutton setTitleColor:[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0] forState:UIControlStateNormal];
    forgetPassbutton.titleLabel.font = REFont(14);
    [self.view addSubview:forgetPassbutton];
    [forgetPassbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(bgH+156);
    }];
    
    //4.登陆
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    loginButton.layer.cornerRadius = 23;
    [loginButton setTitle:@"登 陆" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    loginButton.titleLabel.font = REFont(18);
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.bottom.mas_equalTo(self.bgImageView).offset(202+46);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.equalTo(@46);
    }];
    
    //5.返回首页
    UIButton *backHomePageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backHomePageButton setTitle:@"< 返回首页" forState:UIControlStateNormal];
    [backHomePageButton addTarget:self action:@selector(backHomePageAction:) forControlEvents:UIControlEventTouchUpInside];
    [backHomePageButton setTitleColor:[UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0] forState:UIControlStateNormal];
    backHomePageButton.titleLabel.font = REFont(14);
    [self.view addSubview:backHomePageButton];
    [backHomePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.top.mas_equalTo(bgH+268);
        make.height.equalTo(@20);
    }];
    
    //6.登陆注册
    UILabel *loginLabel = [UILabel new];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"登录" attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    loginLabel.attributedText = string;
    loginLabel.textColor = REWhiteColor;
    [self.bgImageView addSubview:loginLabel];
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(55);
        make.height.equalTo(@25);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.titleLabel.font = REFont(14);
    [self.bgImageView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.view).with.offset(59);
       make.height.equalTo(@20);
        make.right.mas_equalTo(self.view).offset(-24);
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        //_bgImageView.image = [UIImage imageNamed:@"bg"];
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"bg"]];
        _bgImageView.userInteractionEnabled = YES;
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}

#pragma mark - 点击事件
- (void)accAndPassTextFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"mobile"];
    } else {
        [self.mutableDic setValue:textField.text forKey:@"password"];
    }
}

- (void)loginButtonAction:(UIButton *)sender {
    RELoginModel *loginModel = [RELoginModel mj_objectWithKeyValues:self.mutableDic];
    self.loginModel = loginModel;
    if ([loginModel.mobile isKindOfClass:[NSNull class]] || loginModel.mobile == NULL) {
        [self showError:@"手机号不能为空"];
    } else {
        if ([loginModel.password isKindOfClass:[NSNull class]] || loginModel.password == NULL) {
            [self showError:@"密码不能为空"];
        } else {
            if ([NSString valiMobile:loginModel.mobile] == NO) {
                [self showError:@"手机号格式不正确"];
            } else {
                [self loginRequest];
            }
        }
    }
}

- (void)forgetPasswordAction:(UIButton *)sender {
    REForgetPassWordViewController *vc = [REForgetPassWordViewController new];
    __weak typeof (self)weekself = self;
    vc.forgetPasswordBlock = ^(NSString * _Nonnull msg) {
        __strong typeof (weekself)strongself = weekself;
        [strongself showAlertMsg:msg Duration:2];
    };
    vc.naviTitle = @"忘记密码";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backHomePageAction:(UIButton *)sender {
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    tabbar.selectedIndex = 0;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)registerButtonAction:(UIButton *)sender {
    NSLog(@"注册");
    RERegisterViewController *vc = [RERegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络请求
- (void)loginRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestLogin = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *token = [NSString stringWithFormat:@"%@",response.responseObject[@"token"]];
        if ([code isEqualToString:@"0"]) {
            [self showError:response.responseObject[@"msg"]];
        } else {
            NSLog(@"登陆成功");
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:token forKey:@"token"];
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            tabbar.selectedIndex = 3;
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self loginRequest];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestLogin = nil;
    }];
}

#pragma mark - getter
- (DefaultServerRequest *)requestA {
    if (!_requestLogin) {
        _requestLogin = [[DefaultServerRequest alloc] init];
        _requestLogin.requestMethod = YCRequestMethodPOST;
        _requestLogin.requestURI = [NSString stringWithFormat:@"%@/user/login",HomePageDomainName];
        _requestLogin.requestParameter = @{
                                       @"mobile":self.loginModel.mobile,
                                       @"password":self.loginModel.password
                                      };
    }
    return _requestLogin;
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
