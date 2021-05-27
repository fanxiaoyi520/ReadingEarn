//
//  ZDPay_AddBankCardSecondViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_AddBankCardSecondViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_BankCardSecondTableViewCell.h"
#import "ZDPay_SafetyCertificationViewController.h"

@interface ZDPay_AddBankCardSecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *bankCardTableView;
@end

@implementation ZDPay_AddBankCardSecondViewController

- (void)viewDidLoad {
    self.naviTitle = @"添加银行卡";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];

    [self bankCardTableView];
}

#pragma mark - lazy loading
- (UITableView *)bankCardTableView {
    if (!_bankCardTableView) {
        _bankCardTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bankCardTableView.showsVerticalScrollIndicator = NO;
        _bankCardTableView.showsHorizontalScrollIndicator = NO;
        _bankCardTableView.backgroundView = nil;
        _bankCardTableView.backgroundColor = [UIColor clearColor];
        _bankCardTableView.bounces = YES;
        _bankCardTableView.frame = CGRectMake(0, mcNavBarAndStatusBarHeight, ZDScreen_Width,ZDScreen_Height - mcNavBarAndStatusBarHeight);
        _bankCardTableView.delegate = self;
        _bankCardTableView.dataSource = self;
        [self.view addSubview:_bankCardTableView];

//        ZDPay_OrderSureFooterView *footerView = [ZDPay_OrderSureFooterView new];
//        footerView.frame = CGRectMake(0, 0, ZDScreen_Width, 223);
//        footerView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
//        _bankCardTableView.tableFooterView = footerView;
//        self.footerView = footerView;
    }
    return _bankCardTableView;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    ZDPay_BankCardSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[ZDPay_BankCardSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [cell.contentView addSubview:lineView];
        lineView.tag = 10;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(20, ratioH(54.5), self.view.width-40, ratioH(.5));
    
    [cell layoutAndLoadData:@"dd"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ratioH(55);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.userInteractionEnabled = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
    
    btn.backgroundColor = COLORWITHHEXSTRING(@"#333333", .5);
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    btn.titleLabel.font = ZD_Fout_Medium(18);
    btn.frame = CGRectMake(20, ratioH(40), ScreenWidth-40, ratioH(42));
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = ratioH(21);
    btn.layer.masksToBounds = YES;
    return view;
}

- (void)btnAction:(UIButton *)sender {
    ZDPay_SafetyCertificationViewController *vc = [ZDPay_SafetyCertificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ratioH(200);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
