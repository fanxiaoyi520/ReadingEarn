//
//  REHomeTypeClickViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeTypeClickViewController.h"
#import "REHomeTypeClickModel.h"
#import "RETypeClickTableViewCell.h"

@interface REHomeTypeClickViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation REHomeTypeClickViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typeStr = @"1";
    self.view.backgroundColor = REWhiteColor;
    NSArray *array = @[@"点击榜",@"畅销榜",@"打赏榜"];
    [self customNavigationBarButtonToggleArray:array leftMargin:76 topMargin:REStatusHeight+8 buttonWidth:55 buttonHeight:25];
    [self re_loadUI];
    [self requestNetwork];
}

#pragma mark - 导航栏切换点击事件
- (void)customNavButtonAction:(UIButton *)sender {
    [super customNavButtonAction:sender];
    switch (sender.tag) {
        case 100:
            self.typeStr = @"1";
            [self requestNetwork];
            break;
        case 101:
            self.typeStr = @"2";
            [self requestNetwork];
            break;
        case 102:
            self.typeStr = @"3";
            [self requestNetwork];
            break;
        default:
            self.typeStr = @"1";
            break;
    }
}

#pragma mark - 请求数据
- (void)requestNetwork {
    [self.dataList removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = [[response.responseObject objectForKey:@"data"] objectForKey:@"list"];
        for (NSDictionary *dic in array) {
            REHomeTypeClickModel *model = [REHomeTypeClickModel mj_objectWithKeyValues:dic];
            [self.dataList addObject:model];
        }
        [self.typeTableView reloadData];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/collect/rank",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"limit":@"10",
                                       @"type":self.typeStr
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self typeTableView];
}

- (UITableView *)typeTableView {
    if (!_typeTableView) {
        _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStyleGrouped];
        _typeTableView.delegate = self;
        _typeTableView.dataSource = self;
        _typeTableView.backgroundColor = REWhiteColor;
        [self.view addSubview:_typeTableView];
    }
    return _typeTableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    RETypeClickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[RETypeClickTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
    }
    [cell showDataWithModel:self.dataList[indexPath.row]];
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(16, 171.5, REScreenWidth-32, 0.5);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 172;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    REHomeTypeClickModel *model = self.dataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.type_id;
    vc.imageStr = model.coverpic;
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
