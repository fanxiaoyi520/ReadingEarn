//
//  REExchangeViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REExchangeViewController.h"
#import "REExchangeModel.h"

@interface REExchangeViewController ()

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) REExchangeModel *exchangeModel;
@property (nonatomic, strong)UIButton *exchangeButton;
@property (nonatomic, strong)NSString *texStr;
@property (nonatomic, strong)NSString *paypwd;
@property (nonatomic, strong)REReadingEarnPopupView *popView;
@property (nonatomic, strong)UIView *backView;

@end

@implementation REExchangeViewController
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
    self.texStr = @"";
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
            
            REExchangeModel *model = [REExchangeModel mj_objectWithKeyValues:response.responseObject];
            self.exchangeModel = model;
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/wallet/exchange",HomePageDomainName];
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/wallet/exchange",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"paypwd":self.paypwd,
                                       @"amout":self.texStr
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
    NSArray *array = @[@"我要兑换",@"兑换数量",@"可兑换数量:"];
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
        if (i==0) {
            textField.text = self.exchangeModel.app_symbol;
            textField.userInteractionEnabled = NO;
        }
    }
    
    //3.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btn];
    btn.frame = CGRectMake(backView.width-62, 65, 20, 20);
    [btn setImage:REImageName(@"xiala") forState:UIControlStateNormal];
    
    UILabel *label = [UILabel new];
    [backView addSubview:label];
    label.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.exchangeModel.wallet_symbol attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
    label.frame =CGRectMake(backView.width-82, 138+18, 40, 20);

    //4.
    UILabel *numdanweiLabel = [UILabel new];
    numdanweiLabel.text = self.exchangeModel.app_symbol;
    numdanweiLabel.textAlignment = NSTextAlignmentRight;
    numdanweiLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [backView addSubview:numdanweiLabel];
    numdanweiLabel.frame = CGRectMake(backView.width-20-24, 224, 30, 20);
    
    UILabel *numLabel = [UILabel new];
    self.numLabel = numLabel;
    numLabel.text = @"0";
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    [backView addSubview:numLabel];
    numLabel.frame = CGRectMake(backView.width-150-30-24, 224, 150, 20);
    
    
    //5.
    UILabel *totalLabel = [UILabel new];
    NSMutableAttributedString *totalLabelstring = [[NSMutableAttributedString alloc] initWithString:@"可兑换总额" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.attributedText = totalLabelstring;
    totalLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [backView addSubview:totalLabel];
    totalLabel.frame =CGRectMake(backView.width-100-24, 252, 100, 17);
    
    //7.
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:exchangeButton];
    [exchangeButton addTarget:self action:@selector(exchangeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    exchangeButton.frame = CGRectMake(32, NavHeight+369, REScreenWidth-64, 45);
    exchangeButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    exchangeButton.layer.cornerRadius = 22.5;
    exchangeButton.titleLabel.font = REFont(17);
    [exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    self.exchangeButton = exchangeButton;
}

- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 101) {
        self.texStr = textField.text;
        CGFloat a = [textField.text floatValue]*[self.exchangeModel.scale floatValue];
        NSString *str = [NSString stringWithFormat:@"%ld",(long)a];
        self.numLabel.text = str;
        
        if (textField.text.length >0) {
            self.exchangeButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
        } else {
            self.exchangeButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
        }
    }
}

- (void)exchangeButtonAction:(UIButton *)sender {
    if (self.texStr.length > 0) {
        REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
        self.popView = popView;
        [popView showPopupViewWithData:@""];
        __weak typeof (self)weekself = self;
        popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
            __strong typeof (weekself)strongself = weekself;
            if (text.length < 6) {
                [strongself showAlertMsg:@"密码错误" Duration:2];
            } else {
                self.paypwd = text;
                [strongself requestNetworkB];
            }
        };
    } else {
        [self showAlertMsg:@"兑换数量不能为空" Duration:2];
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
