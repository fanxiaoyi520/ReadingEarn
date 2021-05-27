//
//  RETransferAccountsViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/20.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RETransferAccountsViewController.h"
#import "REExchangeModel.h"
#import "RETransferAccountsModel.h"

@interface RETransferAccountsViewController ()

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) REExchangeModel *exchangeModel;
@property (nonatomic, strong)UIButton *exchangeButton;
@property (nonatomic, strong)NSString *paypwd;
@property (nonatomic, strong)REReadingEarnPopupView *popView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, copy)NSString *availableSurplusStr;
@property (nonatomic, strong)NSMutableDictionary *mutableDic;
@property (nonatomic, strong)RETransferAccountsModel *transferAccountsModel;
@end

@implementation RETransferAccountsViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setObject:@"" forKey:@"mobile"];
    [self.mutableDic setObject:@"" forKey:@"number"];
    [self.mutableDic setObject:@"" forKey:@"paypwd"];

    self.view.backgroundColor = REBackColor;
    [self requestNetwork];
}

#pragma mark - 网络请求-------兑换
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
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            
            self.availableSurplusStr = [NSString stringWithFormat:@"可用余额:%@YDC",response.responseObject[@"data"]];
            [self re_loadUI];
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
        _requestA.requestMethod = YCRequestMethodGET;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/transfer_info",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestA;
}


#pragma mark - 网络请求-------提交
- (void)requestNetworkB {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            [self showAlertMsg:msg Duration:2];
            [self.popView closeThePopupView];
            for (UIView *view in self.backView.subviews) {
                [view removeFromSuperview];
            }
            [self.backView removeFromSuperview];
            [self.exchangeButton removeFromSuperview];
            [self requestNetwork];
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/ucenter/transfer_account",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"mobile":self.transferAccountsModel.mobile,
                                       @"number":self.transferAccountsModel.number,
                                       @"paypwd":self.transferAccountsModel.paypwd,
                                      };
    }
    return _requestB;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    //1.
    UIView *backView = [UIView new];
    self.backView = backView;
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    backView.layer.cornerRadius = 16;
    backView.frame = CGRectMake(16, NavHeight+20, REScreenWidth-32, 285);

    
    //2.
    NSArray *array = @[@"对方账户",@"转账数量",self.availableSurplusStr];
    for (int i=0; i<3; i++) {
        UILabel *titleLabel = [UILabel new];
        [backView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        titleLabel.attributedText = titleLabelstring;
        titleLabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        titleLabel.frame = CGRectMake(24, 24+i*(20+66), backView.width-48, 20);
        
        UITextField *textField = [[UITextField alloc] init];
        textField.tag = 100+i;
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        textField.frame = CGRectMake(24, 52+i*(46+40), backView.width-48, 46);
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if (i!=2) {
            [backView addSubview:textField];
        }
    }
    
    //3.
    UILabel *label = [UILabel new];
    [backView addSubview:label];
    label.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"YDC" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
    label.frame =CGRectMake(backView.width-82, 138+18, 40, 20);

    //4.
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:exchangeButton];
    [exchangeButton addTarget:self action:@selector(exchangeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    exchangeButton.frame = CGRectMake(32, NavHeight+369, REScreenWidth-64, 45);
    exchangeButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    exchangeButton.layer.cornerRadius = 22.5;
    exchangeButton.titleLabel.font = REFont(17);
    [exchangeButton setTitle:@"确认" forState:UIControlStateNormal];
    [exchangeButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    self.exchangeButton = exchangeButton;
}

- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"mobile"];
    } else if (textField.tag == 101) {
        [self.mutableDic setValue:textField.text forKey:@"number"];
    }
    
    RETransferAccountsModel *model = [RETransferAccountsModel mj_objectWithKeyValues:self.mutableDic];
    if (![model.mobile isEqualToString:@""] && [model.number isEqualToString:@""]) {
        self.exchangeButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    } else {
        self.exchangeButton.backgroundColor = REColor(247, 100, 66);
    }
}

- (void)exchangeButtonAction:(UIButton *)sender {
    RETransferAccountsModel *model = [RETransferAccountsModel mj_objectWithKeyValues:self.mutableDic];
    
    if ([model.mobile isEqualToString:@""]) {
        [self showAlertMsg:@"对方账号不能为空" Duration:2];
    } else {
        if ([model.number isEqualToString:@""]) {
            [self showAlertMsg:@"转账数量不能为空" Duration:2];
        } else {
            REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
            self.popView = popView;
            [popView showPopupViewWithData:@""];
            __weak typeof (self)weekself = self;
            popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                __strong typeof (weekself)strongself = weekself;
                if (text.length < 6) {
                    [strongself showAlertMsg:@"密码错误" Duration:2];
                } else {
                    [self.mutableDic setValue:text forKey:@"paypwd"];
                    RETransferAccountsModel *model = [RETransferAccountsModel mj_objectWithKeyValues:self.mutableDic];
                    self.transferAccountsModel = model;
                    [strongself requestNetworkB];
                }
            };
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
