//
//  REChangeLoginPasswordViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REChangeLoginPasswordViewController.h"
#import "REChangeLoginPasswoldModel.h"

@interface REChangeLoginPasswordViewController ()
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableDictionary *mutableDic;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) REChangeLoginPasswoldModel *changeLoginPasswoldModel;

@end

@implementation REChangeLoginPasswordViewController

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

#pragma mark - 网络请求--------修改登陆密码
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
            for (UIView *view in self.backView.subviews) {
                [view removeFromSuperview];
            }
            [self re_loadUI];
            
            [self.mutableDic removeAllObjects];
            REChangeLoginPasswoldModel *model = [REChangeLoginPasswoldModel mj_objectWithKeyValues:self.mutableDic];
            self.changeLoginPasswoldModel = model;
            [self showAlertMsg:msg Duration:1];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/set_pwd",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"oldpwd":self.changeLoginPasswoldModel.oldPasswold,
                                       @"newpwd":self.changeLoginPasswoldModel.mynewPasswold,
                                       @"confirmpwd":self.changeLoginPasswoldModel.sureNewPasswold,
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    NSArray *array = @[@"请输入旧登陆密码",@"请设置新登陆密码",@"确认新登陆密码"];
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
    REChangeLoginPasswoldModel *model = [REChangeLoginPasswoldModel mj_objectWithKeyValues:self.mutableDic];
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
    REChangeLoginPasswoldModel *model = [REChangeLoginPasswoldModel mj_objectWithKeyValues:self.mutableDic];
     self.changeLoginPasswoldModel = model;
    if ([model.mynewPasswold isEqualToString:@""]) {
        [self showAlertMsg:@"密码不能为空" Duration:1];
    } else {
        if (model.mynewPasswold.length <6 || model.mynewPasswold.length >16) {
            [self showAlertMsg:@"密码必须是6-16位" Duration:1];
        } else {
            if (![model.mynewPasswold isEqualToString:model.sureNewPasswold]) {
                [self showAlertMsg:@"两次密码不一致" Duration:1];
            } else {
                [self requestNetwork];
            }
        }
    }
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
