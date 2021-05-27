//
//  ZDPay_OrderSureViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureViewController.h"
#import "ZDPay_OrderSureHeaderView.h"
#import "ZDPay_OrderSureFooterView.h"
#import "ZDPay_OrderSureTableViewCell.h"
#import "ZDPayFuncTool.h"
#import "ZDPayNetRequestManager.h"
#import "ZDPay_MyWalletViewController.h"

#import "ZDPay_OrderSureModel.h"
#import "ZDPay_OrderSureRespModel.h"
#import "ZDPay_OrderSureBankListRespModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"

typedef void(^PaySucessBlock) (id _Nonnull responseObject);
typedef void(^PayCancelBlock) (id _Nonnull reason);
typedef void(^PayFailureBlock) (id _Nonnull desc,NSError * _Nonnull error);

@interface ZDPay_OrderSureViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,copy)PaySucessBlock paySucessBlock;
@property (nonatomic ,copy)PayCancelBlock payCancelBlock;
@property (nonatomic ,copy)PayFailureBlock payFailureBlock;

@property (nonatomic ,strong)UITableView *payTableView;
@property (nonatomic ,strong)ZDPay_OrderSureHeaderView *headerView;
@property (nonatomic ,strong)ZDPay_OrderSureFooterView *footerView;
@property (nonatomic ,strong)ZDPay_OrderSureModel *pay_OrderSureModel;
@property (nonatomic ,strong)ZDPay_OrderSureRespModel *pay_OrderSureRespModel;
@property (nonatomic ,strong)NSMutableArray *bankDataList;
@property (nonatomic ,strong)NSMutableArray *payDataList;
@end

@implementation ZDPay_OrderSureViewController
+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (void)ZDPay_PaymentResultCallbackWithPaySucess:(void (^)(id _Nonnull responseObject))paySucess
                                       payCancel:(void (^)(id _Nonnull reason))payCancel
                                      payFailure:(void (^)(id _Nonnull desc,NSError * _Nonnull error))payFailure {
    self.paySucessBlock = paySucess;
    self.payCancelBlock = payCancel;
    self.payFailureBlock = payFailure;
}

- (void)viewDidLoad {
    self.naviTitle = NSLocalizedString(@"订单确认", nil);
    [super viewDidLoad];
    self.view.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5",1.0);

    NSDictionary *dic = @{
        @"registerCountryCode": @"86",
        @"registerMobile": @"13927495764",
        @"merId": @"1000000",
        @"countryCode": @"142",
        @"phoneSystem": @"Ios",
        @"mcc": @"5045",
        @"subject": @"交易内容",
        @"subAppid": @"微信官方审核通过的appId",
        @"timeExpire": @"30",
        @"orderNo": @"123456789",
        @"amount": @"12",
        @"notifyUrl": @"www.baidu.com",
        @"language": @"zh-CN"
    };
    
    NSDictionary *paramsDic = [dic mj_setKeyValues:self.pay_OrderSureModel];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:paramsDic postUrlStr:[NSString stringWithFormat:@"http://192.168.37.227:9001%@",QUERYPAYMETHOD] suscess:^(id  _Nullable responseObject) {
        ZDPay_OrderSureRespModel *model = [ZDPay_OrderSureRespModel mj_objectWithKeyValues:responseObject];
        self.pay_OrderSureRespModel = model;
        [self.pay_OrderSureRespModel.bankList enumerateObjectsUsingBlock:^(ZDPay_OrderSureBankListRespModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZDPay_OrderSureBankListRespModel *model = [ZDPay_OrderSureBankListRespModel mj_objectWithKeyValues:obj];
            [self.bankDataList addObject:model];
        }];
        [self.pay_OrderSureRespModel.payList enumerateObjectsUsingBlock:^(ZDPay_OrderSurePayListRespModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
            [self.payDataList addObject:model];
        }];
    }];
    [self payTableView];
}

#pragma mark - lazy loading
- (UITableView *)payTableView {
    if (!_payTableView) {
        _payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTableView.showsVerticalScrollIndicator = NO;
        _payTableView.showsHorizontalScrollIndicator = NO;
        _payTableView.backgroundView = nil;
        _payTableView.backgroundColor = [UIColor clearColor];
        _payTableView.bounces = NO;
        _payTableView.frame = CGRectMake(ratioW(10), mcNavBarAndStatusBarHeight, ZDScreen_Width-ratioW(20),ZDScreen_Height - mcNavBarAndStatusBarHeight);
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        
        ZDPay_OrderSureHeaderView *headerView = [ZDPay_OrderSureHeaderView new];
        headerView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
        headerView.frame = CGRectMake(0, 0, ZDScreen_Width, ratioH(133));
        _payTableView.tableHeaderView = headerView;
        self.headerView = headerView;
        
        ZDPay_OrderSureFooterView *footerView = [ZDPay_OrderSureFooterView new];
        footerView.frame = CGRectMake(0, 0, ZDScreen_Width, ratioH(233));
        footerView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
        _payTableView.tableFooterView = footerView;
        [self.view addSubview:_payTableView];
        self.footerView = footerView;
    }
    return _payTableView;
}

- (NSMutableArray *)payDataList {
    if (!_payDataList) {
        _payDataList = [NSMutableArray array];
    }
    return _payDataList;
}

- (NSMutableArray *)bankDataList {
    if (!_bankDataList) {
        _bankDataList = [NSMutableArray array];
    }
    return _bankDataList;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.payDataList) {
        return self.payDataList.count + 2;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    ZDPay_OrderSureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[ZDPay_OrderSureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);

        UIView *lineView = [UIView new];
        [cell.contentView addSubview:lineView];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#DCDCDC", 1.0);
        lineView.tag = 30;
        
        if (indexPath.row == 0) {
            UILabel *label = [UILabel new];
            label.tag = 100;
            [cell.contentView addSubview:label];
            label.font = [UIFont boldSystemFontOfSize:ratioH(16)];
            //ZD_Fout_Medium(ratioH(16))
            label.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
        }
        if (indexPath.row == self.payDataList.count + 1) {
            UILabel *label = [UILabel new];
            [cell.contentView addSubview:label];
            label.tag = 200;
            label.font = ZD_Fout_Medium(ratioH(14));
            label.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
        }
    }
    UIView *lineView = (UIView *)[cell.contentView viewWithTag:30];
    
    if (indexPath.row == 0) {
        CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:NSLocalizedString(@"请选择支付方式",nil) withFont:[UIFont boldSystemFontOfSize:ratioH(16)]];
        UILabel *label = [cell.contentView viewWithTag:100];
        label.frame = CGRectMake(ratioW(20), ratioH(16), rect.size.width, ratioH(16));
        label.text = NSLocalizedString(@"请选择支付方式",nil);
        lineView.frame = CGRectMake(0, ratioH(49)-.5, self.payTableView.width, .5);
    }
    if (indexPath.row == self.payDataList.count+1) {
        CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:NSLocalizedString(@"添加支付方式 >",nil) withFont:ZD_Fout_Medium(ratioH(14))];
        UILabel *label = [cell.contentView viewWithTag:200];
        label.frame = CGRectMake(ratioW(48), ratioH(19), rect.size.width, ratioH(14));
        label.text = NSLocalizedString(@"添加支付方式 >",nil);
    }
    
    if (indexPath.row > 0 && indexPath.row <= self.payDataList.count) {
        lineView.frame = CGRectMake(ratioW(20), ratioH(49)-.5, self.payTableView.width-ratioW(20), .5);
        [cell layoutAndLoadData:self.payDataList[indexPath.row-1]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ratioH(49);
}

//cell每组第一和最后一个单元格切圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    CGFloat radius = 6.f;
    cell.backgroundColor = UIColor.clearColor;
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    UIBezierPath *bezierPath = nil;
    if (rowNum == 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    }else{
        if (indexPath.row == 0) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
        }else if (indexPath.row == rowNum - 1){
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
        }else{
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
     normalLayer.path = bezierPath.CGPath;
     selectLayer.path = bezierPath.CGPath;
        
     UIView *nomarBgView = [[UIView alloc] initWithFrame:bounds];
     normalLayer.fillColor = [[UIColor whiteColor] CGColor];
     [nomarBgView.layer insertSublayer:normalLayer atIndex:0];
     nomarBgView.backgroundColor = UIColor.clearColor;
     cell.backgroundView = nomarBgView;

    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
     selectLayer.fillColor = [[UIColor whiteColor] CGColor];
     [selectBgView.layer insertSublayer:selectLayer atIndex:0];
     selectBgView.backgroundColor = UIColor.clearColor;
     cell.selectedBackgroundView = selectBgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.headerView layoutAndLoadData:self.pay_OrderSureRespModel];
    UIView *view = [UIView new];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    [self.footerView layoutAndLoadData:self.pay_OrderSureRespModel surePay:^(UIButton * _Nonnull sender) {
        ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:0];
        [popView showPopupViewWithData:nil payPass:^(NSString * _Nonnull text, BOOL isFinished) {
            NSLog(@"text:%@",text);
        } forgetPass:^{
            NSLog(@"1111");
        }];
    }];
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0 && indexPath.row <= self.payDataList.count) {
        [tableView reloadData];
    }

    ZDPay_OrderSureTableViewCell *cell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectImageView.image = [UIImage imageNamed:@"btn_choose"];
    if (indexPath.row == self.payDataList.count + 1) {
        ZDPay_MyWalletViewController *vc = [ZDPay_MyWalletViewController new];
        vc.bankDataList = self.bankDataList;
        vc.walletType = WalletType_binding;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
