//
//  REMyOrderViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyOrderViewController.h"
#import "REMyOrderModel.h"
#import "REMyOrderTableViewCell.h"
#import "REOrderDetailsViewController.h"
#import "REWaitingPaymentViewController.h"

@interface REMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *orderDataList;
@property (nonatomic, assign) NSInteger orderBtnTag;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger status;
@end

@implementation REMyOrderViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestNetworkWithRefresh:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.type = @"1";
    self.status=0;
    [self re_loadUI];
    //[self requestNetworkWithRefresh:NO];
}

#pragma mark - 网络请求--------买卖
- (void)requestNetworkWithRefresh:(BOOL)isRefresh {
    [self.orderDataList removeAllObjects];
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
            
            NSArray *array = response.responseObject[@"data"];
            for (NSDictionary *dic in array) {
                REMyOrderModel *model = [REMyOrderModel mj_objectWithKeyValues:dic];
                [self.orderDataList addObject:model];
            }
            [self.orderTableView reloadData];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/order_list",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"type":self.type,
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self orderTableView];
    //头视图
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, REScreenWidth, 44);
    view.backgroundColor = REWhiteColor;
    NSArray *array = @[@"进行中",@"已完成",@"已取消",@"申诉中"];
    for (int i=0; i<4; i++) {
        UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:statusButton];
        [statusButton setTitle:array[i] forState:UIControlStateNormal];
        statusButton.frame = CGRectMake(40+i*((REScreenWidth-40*2-33*3)/4+33), 11, (REScreenWidth-40*2-33*3)/4, 22);
        statusButton.titleLabel.font = REFont(16);
        statusButton.tag = 300+i;
        [statusButton setTitleColor:REColor(153, 153, 153) forState:UIControlStateNormal];
        [statusButton addTarget:self action:@selector(statusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView  = [UIView new];
        lineView.backgroundColor = REColor(247, 100, 66);
        lineView.tag = 400;
        [view addSubview:lineView];
        
        if (i==0) {
            self.orderBtnTag = 300+i;
            [statusButton setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
            lineView.frame = CGRectMake(40, statusButton.bottom+8, (REScreenWidth-40*2-33*3)/4, 3);
        }
    }
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RELineColor;
    [view addSubview:lineView];
    lineView.frame = CGRectMake(0, 43.5, REScreenWidth, 0.5);
    self.orderTableView.tableHeaderView = view;
}

- (UITableView *)orderTableView {
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.backgroundColor = [UIColor clearColor];
        _orderTableView.backgroundView = nil;
        [self.view addSubview:_orderTableView];
    }
    return _orderTableView;
}

- (NSMutableArray *)orderDataList {
    if (!_orderDataList) {
        _orderDataList = [NSMutableArray array];
    }
    return _orderDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    REMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[REMyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        [cell.contentView addSubview:lineView];
        lineView.tag = 10;
    }
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(0, 135.5, REScreenWidth, .5);
    [cell showDataWithModel:self.orderDataList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 136;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有更多数据了";
    label.textColor = REColor(153, 153, 153);
    label.font = REFont(17);
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.type isEqualToString:@"1"]) {
        REWaitingPaymentViewController *vc = [REWaitingPaymentViewController new];
        vc.naviTitle = @"待支付";
        vc.type = self.type;
        vc.myOrderModel = self.orderDataList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        REWaitingPaymentViewController *vc = [REWaitingPaymentViewController new];
        vc.naviTitle = @"订单详情";
        vc.type = self.type;
        vc.myOrderModel = self.orderDataList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];

        
//        REOrderDetailsViewController *vc = [REOrderDetailsViewController new];
//        vc.naviTitle = @"订单详情";
//        vc.type = self.type;
//        vc.myOrderModel = self.orderDataList[indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 事件
- (void)statusButtonAction:(UIButton *)sender {
    self.status = 1;
    UIButton *btn = [sender.superview viewWithTag:self.orderBtnTag];
    UIView *lineView = [sender.superview viewWithTag:400];
    
    if (sender.selected==YES) {
        self.orderBtnTag = sender.tag;
    } else {
        sender.selected = YES;
        btn.selected = NO;
        [sender setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
        lineView.frame = CGRectMake(40+(sender.tag-300)*((REScreenWidth-40*2-33*3)/4+33), sender.bottom+8, (REScreenWidth-40*2-33*3)/4, 3);
        [btn setTitleColor:REColor(153, 153, 153) forState:UIControlStateNormal];
        self.orderBtnTag = sender.tag;
    }
    
    if (sender.tag == 300) {
        self.type = @"1";
        [self requestNetworkWithRefresh:NO];
    } else if (sender.tag ==301) {
        self.type = @"2";
        [self requestNetworkWithRefresh:NO];
    } else if (sender.tag ==302) {
        self.type = @"3";
        [self requestNetworkWithRefresh:NO];
    } else if (sender.tag ==303) {
        self.type = @"4";
        [self requestNetworkWithRefresh:NO];
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
