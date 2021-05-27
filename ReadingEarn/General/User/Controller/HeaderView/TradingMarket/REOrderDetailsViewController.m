//
//  REOrderDetailsViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REOrderDetailsViewController.h"
#import "REWaitingPayModel.h"
#import "REAppealViewController.h"
#import "REAppealStatusModel.h"
@interface REOrderDetailsViewController ()

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) REWaitingPayModel *waitingPayModel;
@property (nonatomic, strong) REAppealStatusModel *appealStatusModel;
@end

@implementation REOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REBackColor;
    [self requestNetworkWithRefresh:NO];
}

#pragma mark - 网络请求--------买卖
- (void)requestNetworkWithRefresh:(BOOL)isRefresh {

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
            REWaitingPayModel *model = [REWaitingPayModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.waitingPayModel = model;
            
            if ([self.type isEqualToString:@"4"]) {
                [self requestNetworkWithAppeal];
            } else {
                [self re_loadUI];
            }
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/order_info",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"id":self.myOrderModel.order_id,
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求--------申诉状态
- (void)requestNetworkWithAppeal {
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
            REAppealStatusModel *model = [REAppealStatusModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.appealStatusModel = model;
            
            [self re_loadUI];
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/otc/appeal_status",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"ordid":self.waitingPayModel.ordid,
                                      };
        NSLog(@"_requestB.requestParameter:%@",_requestB.requestParameter);
    }
    return _requestB;
}


- (void)re_loadUI {
    
    //一.
    UIView *headerBgView = [UIView new];
    [self.view addSubview:headerBgView];
    headerBgView.backgroundColor = REWhiteColor;
    headerBgView.frame = CGRectMake(0, NavHeight+8, REScreenWidth, 42);
    
    //1.
    UILabel *isBuyLabel = [UILabel new];
    [headerBgView addSubview:isBuyLabel];
    isBuyLabel.textAlignment = NSTextAlignmentCenter;
    isBuyLabel.layer.cornerRadius = 4;
    isBuyLabel.layer.masksToBounds = YES;
    isBuyLabel.frame = CGRectMake(24, 11, 20, 20);
    isBuyLabel.textColor = REWhiteColor;
    NSString *isbuy;
    if ([self.waitingPayModel.order_status isEqualToString:@"1"]) {
        isbuy = @"买";
        isBuyLabel.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:0.30];
    } else {
        isbuy = @"卖";
        isBuyLabel.backgroundColor = [UIColor colorWithRed:3/255.0 green:217/255.0 blue:68/255.0 alpha:0.30];
    }
    NSMutableAttributedString *isBuyLabelstring = [[NSMutableAttributedString alloc] initWithString:isbuy attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: REWhiteColor}];
    isBuyLabel.attributedText = isBuyLabelstring;


    //2.
    UILabel *nameLabel = [UILabel new];
    [headerBgView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:self.waitingPayModel.symbol attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    nameLabel.attributedText = nameLabelstring;
    nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    nameLabel.frame = CGRectMake(isBuyLabel.right+8, 10, 100, 22);
    
    //3.
    NSString *statusStr;
    if ([self.waitingPayModel.step isEqualToString:@"1"]) {
        statusStr = @"待付款";
    } else if ([self.waitingPayModel.step isEqualToString:@"2"]){
        statusStr = @"待收款";
    } else if ([self.waitingPayModel.step isEqualToString:@"3"]){
        statusStr = @"待放币";
    } else {
        statusStr = @"已完成";
    }

    UILabel *statusLabel = [UILabel new];
    [headerBgView addSubview:statusLabel];
    statusLabel.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *statusLabelstring = [[NSMutableAttributedString alloc] initWithString:statusStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    statusLabel.attributedText = statusLabelstring;
    statusLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    statusLabel.frame = CGRectMake(REScreenWidth - 20 - 100, 10, 100, 22);
    
    //二.
    UIView *bgView = [UIView new];
    bgView.backgroundColor = REWhiteColor;
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, NavHeight+58, REScreenWidth, 285);
    
    UIView *lineView = [UIView new];
    [bgView addSubview:lineView];
    lineView.backgroundColor = RELineColor;
    lineView.frame  = CGRectMake(30, 49, REScreenWidth-30-20, 0.5);
    
    //1.
    UIImageView *headImageView = [UIImageView new];
    [bgView addSubview:headImageView];
    headImageView.frame = CGRectMake(30, 16, 20, 20);
    headImageView.layer.cornerRadius = 10;
    headImageView.layer.masksToBounds = YES;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.waitingPayModel.headimg] placeholderImage:PlaceholderHead_Image];
    
    //2.
    CGSize mobilesize = [ToolObject sizeWithText:self.waitingPayModel.mobile withFont:REFont(14)];
    UILabel *mobileLabel = [UILabel new];
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:mobileLabel];
    mobileLabel.frame = CGRectMake(headImageView.right+8, 16, mobilesize.width+10, 20);
    NSMutableAttributedString *mobileLabelstring = [[NSMutableAttributedString alloc] initWithString:self.waitingPayModel.mobile attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    mobileLabel.attributedText = mobileLabelstring;
    mobileLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //3.
    UIImageView *mobileImageView = [UIImageView new];
    [bgView addSubview:mobileImageView];
    mobileImageView.frame = CGRectMake(mobileLabel.right+2, 19, 14, 14);
    mobileImageView.image = REImageName(@"waiting_mobile");
    
    //4.
    NSString *moneyStr = [NSString stringWithFormat:@"¥%@",self.waitingPayModel.total_money];
    UILabel *moneyLabel = [UILabel new];
    [bgView addSubview:moneyLabel];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.frame = CGRectMake(REScreenWidth-100-58, 12, 100, 28);
    NSMutableAttributedString *moneyLabelstring = [[NSMutableAttributedString alloc] initWithString:moneyStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 20], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    moneyLabel.attributedText = moneyLabelstring;
    moneyLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    
    UILabel *moneyUnitLabel = [UILabel new];
    [bgView addSubview:moneyUnitLabel];
    moneyUnitLabel.textAlignment = NSTextAlignmentRight;
    moneyUnitLabel.frame = CGRectMake(REScreenWidth-20-40, 20, 40, 20);
    NSMutableAttributedString *moneyUnitLabelstring = [[NSMutableAttributedString alloc] initWithString:@"CNY" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    moneyUnitLabel.attributedText = moneyUnitLabelstring;
    moneyUnitLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //4.
    NSArray *array = @[@"订单号:",@"价格(CNY):",@"数量(YDC):",@"订单创建时间:",@"标记付款时间:",@"放币时间:",@"支付方式:"];
    
    NSString *create_time = [ToolObject getDateStringWithTimestamp_time:self.waitingPayModel.create_time];
    NSString *payment_time = [ToolObject getDateStringWithTimestamp_time:self.waitingPayModel.payment_time];
    NSString *release_time = [ToolObject getDateStringWithTimestamp_time:self.waitingPayModel.release_time];
    NSNumber *order_numnum = @(self.waitingPayModel.order_num.floatValue);
    NSString *order_num = [NSString stringWithFormat:@"%@",order_numnum];
    NSArray *numArray = @[self.waitingPayModel.ordid,self.waitingPayModel.price,order_num,create_time,payment_time,release_time,@"支付宝"];
    
    for (int i=0; i<7; i++) {
        UILabel *label = [UILabel new];
        [bgView addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        label.frame = CGRectMake(30, 61+i*(20+12), 150, 20);
        
        UILabel *numLabel = [UILabel new];
        [bgView addSubview:numLabel];
        numLabel.textAlignment = NSTextAlignmentRight;
        NSMutableAttributedString *numLabelstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        numLabel.attributedText = numLabelstring;
        numLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        numLabel.frame = CGRectMake(REScreenWidth-20-200, 61+i*(20+12), 200, 20);
        
        if (i>0 && i<3) {
            numLabel.textColor = REColor(247, 100, 66);
        }
        if (i==6) {
            UIImageView *alipayImageView =  [UIImageView new];
            [bgView addSubview:alipayImageView];
//            [alipayImageView sd_setImageWithURL:[NSURL URLWithString:self.waitingPayModel.pay_code] placeholderImage:REImageName(@"waiting_pay_zhifubao")];
            alipayImageView.image = REImageName(@"waiting_pay_zhifubao");
            alipayImageView.frame = CGRectMake(REScreenWidth-74-24, 219+32, 24, 24);
        }
    }
    
    //5.申诉
    UIButton *appealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:appealButton];
    appealButton.frame = CGRectMake(32, bgView.bottom+32, REScreenWidth-64, 45);
    appealButton.titleLabel.font = REFont(17);
    [appealButton setTitle:@"申诉" forState:UIControlStateNormal];
    [appealButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    appealButton.layer.cornerRadius = 22.5;
    [appealButton addTarget:self action:@selector(appealButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.type isEqualToString:@"3"]) {
        appealButton.backgroundColor = REColor(153, 153, 153);
        appealButton.userInteractionEnabled = NO;
    } else if ([self.type isEqualToString:@"4"]) {
        if ([self.appealStatusModel.status isEqualToString:@"1"]) {
            appealButton.backgroundColor = REColor(153, 153, 153);
            appealButton.userInteractionEnabled = NO;
            [appealButton setTitle:@"申诉中" forState:UIControlStateNormal];
        } else {
            appealButton.backgroundColor = REColor(153, 153, 153);
            appealButton.userInteractionEnabled = NO;
            [appealButton setTitle:@"申诉中" forState:UIControlStateNormal];
        }
    } else {
        if ([self.waitingPayModel.step isEqualToString:@"4"]) {
            appealButton.backgroundColor = REColor(153, 153, 153);
            appealButton.userInteractionEnabled = NO;
        } else {
            appealButton.backgroundColor = REColor(247, 100, 66);
        }
    }
}

- (void)appealButtonAction:(UIButton *)sender {
    REAppealViewController *vc = [REAppealViewController new];
    vc.naviTitle = @"申诉";
    vc.waitingPayModel = self.waitingPayModel;
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
