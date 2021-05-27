//
//  REChangePaymentPasswordViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REChangePaymentPasswordViewController.h"
#import "REChangePaymentPasswordModel.h"

@interface REChangePaymentPasswordViewController ()

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableDictionary *mutableDic;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) REChangePaymentPasswordModel *changeLoginPasswoldModel;
@end

@implementation REChangePaymentPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mutableDic = [NSMutableDictionary dictionary];
    UIView *backView = [UIView new];
    self.backView = backView;
    backView.frame = CGRectMake(0, 0, REScreenWidth, REScreenHeight);
    [self.view addSubview:backView];

    [self re_loadUI];
}

#pragma mark - 网络请求--------修改支付密码
- (void)requestNetwork {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"0"]) {
            [self showAlertMsg:msg Duration:1];
        } else {
            
            [self showAlertMsg:msg Duration:1];
            if (self.changePayPwdTipsBlock) {
                self.changePayPwdTipsBlock(msg);
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/set_pay_pwd",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"payword":self.changeLoginPasswoldModel.oldPasswold,
                                       @"confirmpwd":self.changeLoginPasswoldModel.mynewPasswold,
                                       @"prefix":self.changeLoginPasswoldModel.prefix,
                                       @"code":self.changeLoginPasswoldModel.sureNewPasswold,
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求--------获取验证码
- (void)requestNetworkBwithButton:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
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
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/ucenter/msg",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestB;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    NSArray *array = @[@"请设置密码",@"请确认支付密码",@"请填写验证码"];
    for (int i=0; i<3; i++) {
        UITextField *changeTextField = [UITextField new];
        changeTextField.placeholder = array[i];
        changeTextField.tag = 100+i;
        changeTextField.secureTextEntry = YES;
        changeTextField.font = REFont(14);
        changeTextField.borderStyle = UITextBorderStyleNone;
        changeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [changeTextField addTarget:self action:@selector(changeTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
        changeTextField.frame = CGRectMake(20, NavHeight + 12+i*(56), REScreenWidth-40, 56);
        [self.backView addSubview:changeTextField];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        lineView.frame = CGRectMake(20, NavHeight+12+55.5 + i*(55.5+0.5), REScreenWidth-40, 0.5);
        [self.backView addSubview:lineView];
    }
    
    //获取验证码
    UIButton *codeButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton = codeButton;
    [codeButton addTarget:self action:@selector(codeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.titleLabel.font = REFont(14);
    codeButton.layer.cornerRadius = 18;
    codeButton.userInteractionEnabled = YES;
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:REColor(44, 72, 121) forState:UIControlStateNormal];
    [self.backView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.backView).offset(NavHeight+78+56);
        make.height.mas_equalTo(ratioH(30));
        make.left.mas_equalTo(self.view).offset(255);
    }];

    //下一步
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton = nextButton;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    nextButton.layer.cornerRadius = 22.5;
    nextButton.titleLabel.font = REFont(17);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    nextButton.frame =CGRectMake(32, NavHeight+298, REScreenWidth-64, 45);
    [self.view addSubview:nextButton];
}

#pragma mark - 事件
- (void)changeTextFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        [self.mutableDic setObject:textField.text forKey:@"oldPasswold"];
    } else if (textField.tag == 101){
        [self.mutableDic setObject:textField.text forKey:@"mynewPasswold"];
    } else if (textField.tag == 102) {
        [self.mutableDic setObject:textField.text forKey:@"sureNewPasswold"];
    }
    REChangePaymentPasswordModel *model = [REChangePaymentPasswordModel mj_objectWithKeyValues:self.mutableDic];
    self.changeLoginPasswoldModel = model;
    if (model.oldPasswold != NULL && model.mynewPasswold != NULL && model.sureNewPasswold != NULL) {
        if (![model.oldPasswold isEqualToString:@""] && ![model.mynewPasswold isEqualToString:@""] && ![model.sureNewPasswold isEqualToString:@""]) {
            self.nextButton.backgroundColor = REColor(255, 86, 34);
        } else {
            self.nextButton.backgroundColor = REColor(206, 206, 206);
        }
    }
}

- (void)nextButtonAction:(UIButton *)sender {
    REChangePaymentPasswordModel *model = [REChangePaymentPasswordModel mj_objectWithKeyValues:self.mutableDic];
    self.changeLoginPasswoldModel = model;
    if ([model.oldPasswold isEqualToString:@""]) {
        [self showAlertMsg:@"密码不能为空" Duration:1];
    } else {
        if (model.oldPasswold.length <6 || model.oldPasswold.length >16) {
            [self showAlertMsg:@"密码必须是6-16位" Duration:1];
        } else {
            if (![model.oldPasswold isEqualToString:model.mynewPasswold]) {
                [self showAlertMsg:@"两次密码不一致" Duration:1];
            } else {
                [self requestNetwork];
            }
        }
    }
}

- (void)codeButtonAction:(UIButton *)sender {
    [self requestNetworkBwithButton:sender];
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
                [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.codeButton.backgroundColor = [UIColor clearColor];
                self.codeButton.userInteractionEnabled = YES;
                [self.codeButton setTitleColor:REColor(44, 72, 121) forState:UIControlStateNormal];
            });
            
        }else{

            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //设置label读秒效果
                [self.codeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)",seconds] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
                self.codeButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
                // 在这个状态下 用户交互关闭，防止再次点击 button 再次计时
                self.codeButton.userInteractionEnabled = NO;
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
