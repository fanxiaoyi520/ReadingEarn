//
//  RERegisterViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/18.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERegisterViewController.h"
#import "RERegisterModel.h"
#import "RERegisterNextViewController.h"

@interface RERegisterViewController ()

@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic, strong) DefaultServerRequest *requestRegisterCode;
@property (nonatomic, strong) DefaultServerRequest *requestRegister;
@property (nonatomic, strong) RERegisterModel *registerModel;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UILabel *selTextLabel;
@property (nonatomic, strong) UIButton *selButton;
@property (nonatomic, strong) UIButton *getVerificationCodeButton;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, copy) NSString *imageStr;

@end

@implementation RERegisterViewController

- (void)viewDidLoad {
    self.switchNavigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REWhiteColor;
    self.mutableDic = [NSMutableDictionary dictionary];
    //[self re_loadUI];
    [self requestNetworkC];
}

#pragma mark - 网络请求-------注册
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
            self.imageStr = response.responseObject[@"data"][@"register"];
            
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
    
    //2.返回
    //navbar_icon_return_nor
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:REImageName(@"navbar_icon_return_nor") forState:UIControlStateNormal];
    [self.bgImageView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(50);
        make.left.equalTo(@6);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    //3.新用户注册
    UILabel *registerLabel = [UILabel new];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"新用户注册" attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: REWhiteColor}];
    registerLabel.attributedText = string;
    registerLabel.textColor = REWhiteColor;
    [self.bgImageView addSubview:registerLabel];
    [registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(55);
        make.height.equalTo(@25);
        make.centerX.equalTo(self.view);
    }];

    //4.中国（+86）
    UIButton *selMobileHeadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selMobileHeadButton setTitle:@"中国(+86)" forState:UIControlStateNormal];
    [selMobileHeadButton setTitleColor:[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0] forState:UIControlStateNormal];
    selMobileHeadButton.titleLabel.font = REFont(18);
    [self.bgImageView addSubview:selMobileHeadButton];
    [selMobileHeadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(bgH+ratioH(24));
        make.left.equalTo(@20);
    }];
    

    
    //5.输入框
    NSArray *placeholderArray = @[@"请填写手机号码",@"请填写验证码",@"请设置登陆密码",@"请确认登陆密码",@"请填写推荐人"];
    for (int i=0; i<placeholderArray.count; i++) {
        UITextField *inputBoxTextField = [UITextField new];
        inputBoxTextField.placeholder = placeholderArray[i];
        inputBoxTextField.keyboardType = UIKeyboardTypeNumberPad;
        [inputBoxTextField addTarget:self action:@selector(inputBoxTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        inputBoxTextField.tag = 100 + i;
        inputBoxTextField.font = REFont(14);
        inputBoxTextField.frame = CGRectMake(20, bgH+ratioH(54)+i*ratioH(46), REScreenWidth-2*20, ratioH(46));
        inputBoxTextField.borderStyle = UITextBorderStyleNone;
        [self.view addSubview:inputBoxTextField];
        
        UIView *lineView = [UIView new];
        lineView.frame = CGRectMake(20, bgH+ratioH(54)+ratioH(45.5)+i*(ratioH(0.5)+ratioH(45.5)), REScreenWidth-2*20, ratioH(0.5));
        lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [self.view addSubview:lineView];
        if (i==0) {
            UIButton *getVerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [getVerificationCodeButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
            getVerificationCodeButton.titleLabel.font = REFont(14);
            getVerificationCodeButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
            [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            getVerificationCodeButton.layer.cornerRadius = 15;
            getVerificationCodeButton.userInteractionEnabled = YES;
            [self.view addSubview:getVerificationCodeButton];
            self.getVerificationCodeButton = getVerificationCodeButton;
            [getVerificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view).offset(-20);
                make.top.mas_equalTo(self.view).offset(bgH+ratioH(57));
                make.height.mas_equalTo(ratioH(30));
                make.left.mas_equalTo(self.view).offset(255);
            }];
        }
        if (i==2) {
            inputBoxTextField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        }
        if (i>1&&i<4) {
            inputBoxTextField.secureTextEntry = YES;
        }
    }
    //button_iocn_choose_nor
    //button_iocn_choose_pre
    UIButton *selButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selButton.selected = NO;
    [selButton setImage:REImageName(@"button_iocn_choose_nor") forState:UIControlStateNormal];
    [selButton setImage:REImageName(@"button_iocn_choose_pre") forState:UIControlStateSelected];
    [self.view addSubview:selButton];
    [selButton addTarget:self action:@selector(selButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selButton = selButton;
    [selButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.mas_equalTo(self.view).offset(bgH+placeholderArray.count*ratioH(46)+ratioH(60));
    }];
    
    UILabel *selTextLabel = [UILabel new];
    NSMutableAttributedString *selTextstring = [[NSMutableAttributedString alloc] initWithString:@"我已经仔细阅读并同意服务及隐私条款" attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    selTextLabel.attributedText = selTextstring;
    selTextLabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
    [self.view addSubview:selTextLabel];
    self.selTextLabel = selTextLabel;
    [selTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@46);
        make.top.mas_equalTo(selButton).offset(ratioH(2.5));
    }];


    //6.注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     registerButton.backgroundColor = REColor(206, 206, 206);
    registerButton.userInteractionEnabled = NO;
    self.registerButton = registerButton;
     registerButton.layer.cornerRadius = 23;
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(bgH+placeholderArray.count*ratioH(46)+ratioH(140));
        make.left.mas_equalTo(self.view).offset(ratioH(20));
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(ratioH(46));
    }];
    
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:REImageName(@"bg_register")];
        _bgImageView.userInteractionEnabled = YES;
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}

#pragma mark - 事件
- (void)inputBoxTextFieldEditingChanged:(UITextField *)textField {
    if (textField.tag == 100) {
        [self.mutableDic setObject:textField.text forKey:@"mobile"];
    } else if (textField.tag == 101) {
        [self.mutableDic setObject:textField.text forKey:@"code"];
    } else if (textField.tag == 102) {
        [self.mutableDic setObject:textField.text forKey:@"password"];
    } else if (textField.tag == 103) {
        [self.mutableDic setObject:textField.text forKey:@"confirmpwd"];
    } else if (textField.tag == 104) {
        [self.mutableDic setObject:textField.text forKey:@"tuijian"];
    }
    RERegisterModel *registerModel = [RERegisterModel mj_objectWithKeyValues:self.mutableDic];
    self.registerModel = registerModel;
    if (registerModel.mobile != NULL && registerModel.code != NULL && registerModel.password != NULL && registerModel.confirmpwd != NULL && self.selButton.selected == YES) {
        if (![registerModel.mobile isEqualToString:@""] && ![registerModel.code isEqualToString:@""] && ![registerModel.password isEqualToString:@""] && ![registerModel.confirmpwd isEqualToString:@""]) {
            self.registerButton.backgroundColor = REColor(255, 86, 34);
            self.registerButton.userInteractionEnabled = YES;
        } else {
            self.registerButton.backgroundColor = REColor(206, 206, 206);
            self.registerButton.userInteractionEnabled = NO;
        }
    }

}

- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getVerificationCodeButtonAction:(UIButton *)sender {
    RERegisterModel *registerModel = [RERegisterModel mj_objectWithKeyValues:self.mutableDic];
    self.registerModel = registerModel;
    
    if (registerModel.mobile == NULL || [registerModel.mobile isKindOfClass:[NSNull class]] || [NSString valiMobile:registerModel.mobile] == NO) {
        [self showError:@"请输入正确的手机号码"];
    } else {
        [self registerCodeRequest:sender];
    }
}

- (void)registerButtonAction:(UIButton *)sender {
    if ([self.registerModel.tuijian isKindOfClass:[NSNull class]] || self.registerModel.tuijian == NULL) {
        [self.mutableDic setValue:@"" forKey:@"tuijian"];
    }
    RERegisterModel *registerModel = [RERegisterModel mj_objectWithKeyValues:self.mutableDic];
    self.registerModel = registerModel;
    
    if (registerModel.mobile == NULL || [registerModel.mobile isKindOfClass:[NSNull class]]) {
        [self showError:@"请输入正确的手机号码"];
    } else {
        if (registerModel.code == NULL || [registerModel.code isKindOfClass:[NSNull class]]) {
            [self showError:@"验证码不能为空"];
        } else {
            if (registerModel.password == NULL || [registerModel.password isKindOfClass:[NSNull class]]) {
                [self showError:@"密码不能为空"];
            } else {
                if (registerModel.confirmpwd == NULL || [registerModel.confirmpwd isKindOfClass:[NSNull class]]) {
                    [self showError:@"密码不能为空"];
                } else {
                    if (![registerModel.password isEqualToString:registerModel.confirmpwd]) {
                        [self showError:@"两次密码不一致"];
                    } else {
                        if (registerModel.password.length < 6) {
                            [self showError:@"密码至少6位长度"];
                        } else {
                            if (registerModel.password.length >16) {
                                [self showError:@"密码长度不能大于16位"];
                            } else {
                                [self registerRequest];
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)selButtonAction:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        self.selTextLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    } else {
        sender.selected = NO;
        self.selTextLabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
    }
    RERegisterModel *registerModel = [RERegisterModel mj_objectWithKeyValues:self.mutableDic];
    self.registerModel = registerModel;
    if (registerModel.mobile != NULL && registerModel.code != NULL && registerModel.password != NULL && registerModel.confirmpwd != NULL) {
        if (![registerModel.mobile isEqualToString:@""] && ![registerModel.code isEqualToString:@""] && ![registerModel.password isEqualToString:@""] && ![registerModel.confirmpwd isEqualToString:@""] && self.selButton.selected == YES) {
            self.registerButton.backgroundColor = REColor(255, 86, 34);
            self.registerButton.userInteractionEnabled = YES;
        } else {
            self.registerButton.backgroundColor = REColor(206, 206, 206);
            self.registerButton.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - 网络请求
- (void)registerCodeRequest:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestRegisterCode startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestRegisterCode = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self showError:response.responseObject[@"msg"]];
        } else {
            NSLog(@"获取验证码");
            NSString *data = [NSString stringWithFormat:@"%@",response.responseObject[@"data"]];
            [self.mutableDic setValue:data forKey:@"prefix"];
            [self openCountdown:sender];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestRegisterCode = nil;
    }];
}

- (void)registerRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestRegister startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestRegister = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *token = [NSString stringWithFormat:@"%@",response.responseObject[@"token"]];
        if ([code isEqualToString:@"0"]) {
            [self showError:response.responseObject[@"msg"]];
        } else {
            NSLog(@"注册成功");
            RERegisterNextViewController *vc = [RERegisterNextViewController new];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:token forKey:@"token"];
            [userDefaults synchronize];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestRegister = nil;
    }];
}

#pragma mark - getter
- (DefaultServerRequest *)requestRegisterCode {
    if (!_requestRegisterCode) {
        _requestRegisterCode = [[DefaultServerRequest alloc] init];
        _requestRegisterCode.requestMethod = YCRequestMethodPOST;
        _requestRegisterCode.requestURI = [NSString stringWithFormat:@"%@/user/get_reg_code",HomePageDomainName];
        _requestRegisterCode.requestParameter = @{
                                       @"type":@"mobile",
                                       @"mobile":self.registerModel.mobile
                                      };
    }
    return _requestRegisterCode;
}

- (DefaultServerRequest *)requestRegister {
    if (!_requestRegister) {
        _requestRegister = [[DefaultServerRequest alloc] init];
        _requestRegister.requestMethod = YCRequestMethodPOST;
        _requestRegister.requestURI = [NSString stringWithFormat:@"%@/user/register",HomePageDomainName];
        _requestRegister.requestParameter = @{
                                       @"mobile":self.registerModel.mobile,
                                       @"code":self.registerModel.code,
                                       @"password":self.registerModel.password,
                                       @"confirmpwd":self.registerModel.confirmpwd,
                                       @"tuijian":self.registerModel.tuijian,
                                       @"prefix":self.registerModel.prefix,
                                      };
    }
    return _requestRegister;
}

#pragma mark - 倒计时
- (void)openCountdown:(UIButton *)sender {
    

    __block NSInteger time = 120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getVerificationCodeButton.userInteractionEnabled = YES;
            });
            
        }else{

            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //设置label读秒效果
                [self.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)",seconds] forState:UIControlStateNormal];
                // 在这个状态下 用户交互关闭，防止再次点击 button 再次计时
                self.getVerificationCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
                 
    dispatch_resume(timer);
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
