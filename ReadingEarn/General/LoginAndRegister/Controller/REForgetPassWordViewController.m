//
//  REForgetPassWordViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/21.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REForgetPassWordViewController.h"
#import "REForgetPassModel.h"

@interface REForgetPassWordViewController ()
@property (nonatomic, strong) DefaultServerRequest *requestForgetPass;
@property (nonatomic, strong) DefaultServerRequest *requestChange;
@property (nonatomic, strong) NSMutableDictionary *mutableDic;
@property (nonatomic, strong) REForgetPassModel *forgetPassModel;
@property (nonatomic, copy) NSString *codeData;
@property (nonatomic, strong) UIButton *codeButoton;
@property (nonatomic, strong) UIButton *changeButoton;
@end

@implementation REForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mutableDic = [NSMutableDictionary dictionary];
    self.view.backgroundColor = REBackColor;
    [self re_loadUI];
}

- (void)re_loadUI {
    
    UIView *backView = [UIView new];
    backView.backgroundColor = REWhiteColor;
    backView.frame = CGRectMake(0, self.topNavBar.height, REScreenWidth, 55*4);
    [self.view addSubview:backView];
    
    NSArray *array = @[@"请输入手机号",@"请输入验证码",@"请输入新登陆密码",@"确认新登陆密码"];
    for (int i=0; i<4; i++) {
        UITextField *textField = [UITextField new];
        textField.tag = 100 + i;
        textField.keyboardType = UIKeyboardTypePhonePad;
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.frame = CGRectMake(16, i*55, REScreenWidth-32, 55);
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = array[i];
        [backView addSubview:textField];

        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        lineView.frame = CGRectMake(16, 54.5+i*(0.5+54.5), REScreenWidth-32, 0.5);
        [backView addSubview:lineView];
        
        if (i==2 || i==3) {
            textField.secureTextEntry = YES;
        }
    }
    
    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(codeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.layer.cornerRadius = 13;
    [codeButton setTitleColor:RELineColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = REFont(15);
    [backView addSubview:codeButton];
    codeButton.frame = CGRectMake(REScreenWidth-16-100, 55+7.5, 100, 30);
    self.codeButoton = codeButton;
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setTitle:@"修改" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.layer.cornerRadius = 22.5;
    changeButton.backgroundColor = REColor(206, 206, 206);
    [changeButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    changeButton.titleLabel.font = REFont(18);
    changeButton.userInteractionEnabled = NO;
    [self.view addSubview:changeButton];
    changeButton.frame = CGRectMake(30, 55*4+100, REScreenWidth-60, 45);
    self.changeButoton = changeButton;

}

#pragma mark - 事件
- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag==100) {
        [self.mutableDic setObject:textField.text forKey:@"username"];
    } else if (textField.tag==101) {
        [self.mutableDic setObject:textField.text forKey:@"code"];
    } else if (textField.tag == 102){
        [self.mutableDic setObject:textField.text forKey:@"mynewPassword"];
    } else {
        [self.mutableDic setObject:textField.text forKey:@"mynewPassword2"];
    }
    REForgetPassModel *forgetPassModel = [REForgetPassModel mj_objectWithKeyValues:self.mutableDic];
    self.forgetPassModel = forgetPassModel;
    if (forgetPassModel.username != NULL && forgetPassModel.code != NULL && forgetPassModel.mynewPassword != NULL && forgetPassModel.mynewPassword2 != NULL) {
        if (![forgetPassModel.username isEqualToString:@""] && ![forgetPassModel.code isEqualToString:@""] && ![forgetPassModel.mynewPassword isEqualToString:@""] && ![forgetPassModel.mynewPassword2 isEqualToString:@""]) {
            self.changeButoton.backgroundColor = REColor(255, 86, 34);
            self.changeButoton.userInteractionEnabled = YES;
        } else {
            self.changeButoton.backgroundColor = REColor(206, 206, 206);
            self.changeButoton.userInteractionEnabled = NO;
        }
    }
}

- (void)codeButtonAction:(UIButton *)sender {
    REForgetPassModel *forgetPassModel = [REForgetPassModel mj_objectWithKeyValues:self.mutableDic];
    self.forgetPassModel = forgetPassModel;
    if ([forgetPassModel.username isKindOfClass:[NSNull class]] || forgetPassModel.username == NULL) {
        [self showError:@"账号不能为空"];
    } else {
        if ([NSString valiMobile:forgetPassModel.username] == NO) {
            [self showError:@"账号不存在"];
        } else {
            [self requestNetwork:sender];
        }
    }
}

- (void)changeButtonAction:(UIButton *)sender {
    REForgetPassModel *forgetPassModel = [REForgetPassModel mj_objectWithKeyValues:self.mutableDic];
    self.forgetPassModel = forgetPassModel;
    
    if (forgetPassModel.mynewPassword.length < 6) {
        [self showError:@"密码至少包含6位英文数字组合"];
    } else {
        if (![forgetPassModel.mynewPassword isEqualToString:forgetPassModel.mynewPassword2]) {
            [self showError:@"两次密码不一致"];
        } else {
            if (forgetPassModel.mynewPassword.length >16) {
                [self showError:@"密码长度不能大于16位"];
            } else {
                [self requestNetworkChange:sender];
            }
        }
    }
}

#pragma mark - 网络请求
- (void)requestNetwork:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestForgetPass startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestForgetPass = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self showError:response.responseObject[@"msg"]];
        } else {
            //验证码判断
            self.codeData = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"data"]];
            [self openCountdown:sender];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestForgetPass = nil;
    }];
}

- (void)requestNetworkChange:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestChange startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestChange = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self showError:response.responseObject[@"msg"]];
        } else {
            if (self.forgetPasswordBlock) {
                self.forgetPasswordBlock(response.responseObject[@"msg"]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestChange = nil;
    }];
}


#pragma mark - getter
- (DefaultServerRequest *)requestForgetPass {
    if (!_requestForgetPass) {
        _requestForgetPass = [[DefaultServerRequest alloc] init];
        _requestForgetPass.requestMethod = YCRequestMethodPOST;
        _requestForgetPass.requestURI = [NSString stringWithFormat:@"%@/user/forget_get_code",HomePageDomainName];
        _requestForgetPass.requestParameter = @{
                                       @"username":self.forgetPassModel.username,
                                      };
    }
    return _requestForgetPass;
}

- (DefaultServerRequest *)requestChange {
    if (!_requestChange) {
        _requestChange = [[DefaultServerRequest alloc] init];
        _requestChange.requestMethod = YCRequestMethodPOST;
        _requestChange.requestURI = [NSString stringWithFormat:@"%@/user/forget",HomePageDomainName];
        _requestChange.requestParameter = @{
                                       @"username":self.forgetPassModel.username,
                                       @"password":self.forgetPassModel.mynewPassword,
                                       @"confirmpwd":self.forgetPassModel.mynewPassword2,
                                       @"code":self.forgetPassModel.code,
                                       @"prefix":self.codeData
                                      };
    }
    return _requestChange;
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
                [self.codeButoton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.codeButoton.backgroundColor = [UIColor clearColor];
                self.codeButoton.userInteractionEnabled = YES;
            });
            
        }else{

            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //设置label读秒效果
                [self.codeButoton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)",seconds] forState:UIControlStateNormal];
                self.codeButoton.backgroundColor = REColor(255, 86, 34);
                // 在这个状态下 用户交互关闭，防止再次点击 button 再次计时
                self.codeButoton.userInteractionEnabled = NO;
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
