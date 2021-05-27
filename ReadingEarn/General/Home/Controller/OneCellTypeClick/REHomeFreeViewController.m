//
//  REHomeFreeViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeFreeViewController.h"
#import "RESearchTableViewCell.h"
#import "REHomeTypeFreeModel.h"

@interface REHomeFreeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *refreshDataList;
@property (nonatomic, copy) NSString *type;
@end

@implementation REHomeFreeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([ToolObject onlineAuditJudgment] == YES) {
        if ([self.naviTitle isEqualToString:@"免费"]) {
            self.type = @"/novel/get_free_novel";
        }
    } else {
        if ([self.naviTitle isEqualToString:@"排行"]) {
            self.type = @"/novel/get_free_novel";
        }
    }
    
    if ([self.naviTitle isEqualToString:@"热门书籍"]){
        //热门最新
        self.type = @"/novel/get_area_list";
    } else if ([self.naviTitle isEqualToString:@"最新书籍"]){
        //热门最新
        self.type = @"/novel/get_area_list";
    } else if ([self.naviTitle isEqualToString:@"热血小说"]){
        //热血甜美
        self.type = @"/novel/get_area_list";
    } else if ([self.naviTitle isEqualToString:@"甜美爱恋"]){
        //热血甜美
        self.type = @"/novel/get_area_list";
    }
    
    [self re_loadUI];
    [self requestNetworkWithRefresh:NO];
}

#pragma mark - 请求数据
- (void)requestNetworkWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
//        if (self.refreshDataList.count < 10) {
//            [self.typeTableView.mj_footer endRefreshing];
//            [self.refreshDataList removeAllObjects];
//        } else {
//            [self.refreshDataList removeAllObjects];
            [self requestNetwork];
        //}
    } else {
        self.pageCount = 1;
        [self requestNetwork];
    }
}

- (void)requestNetwork {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = [response.responseObject objectForKey:@"data"];
        for (NSDictionary *dic in array) {
            REHomeTypeFreeModel *model = [REHomeTypeFreeModel mj_objectWithKeyValues:dic];
            [self.dataList addObject:model];
            //[self.refreshDataList addObject:model];
        }
        [self.typeTableView.mj_footer endRefreshing];
        if (array.count < 10) {
            [self.typeTableView.mj_footer resetNoMoreData];
        }
        [self.typeTableView reloadData];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    if (!_requestA) {
        NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@%@",HomePageDomainName,self.type];
        if ([self.naviTitle isEqualToString:@"完结"]) {
            _requestA.requestParameter = @{
                                           @"limit":@"10",
                                           @"page":page
                                          };
        } else if ([self.naviTitle isEqualToString:@"热门书籍"]){
        _requestA.requestParameter = @{
                                       @"nid":@"remenshuji",
                                       @"limit":@"10",
                                       @"page":page,
                                       @"sex":self.sex
                                      };
        } else if ([self.naviTitle isEqualToString:@"最新书籍"]){
        _requestA.requestParameter = @{
                                       @"nid":@"jingxuanzuixin",
                                       @"limit":@"10",
                                       @"page":page,
                                       @"sex":self.sex
                                      };
        } else if ([self.naviTitle isEqualToString:@"热血小说"]){
        _requestA.requestParameter = @{
                                       @"nid":@"rexuexiaoshuo",
                                       @"limit":@"10",
                                       @"page":page,
                                       @"sex":self.sex
                                      };
        } else if ([self.naviTitle isEqualToString:@"甜美爱恋"]){
        _requestA.requestParameter = @{
                                       @"nid":@"tianmeiailian",
                                       @"limit":@"10",
                                       @"page":page,
                                       @"sex":self.sex
                                      };
        } else if ([self.naviTitle isEqualToString:@"免费"]){
        _requestA.requestParameter = @{
                                       @"limit":@"10",
                                       @"page":page,
                                      };
        }
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self typeTableView];
    self.typeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestNetworkWithRefresh:YES];
    }];
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

- (NSMutableArray *)refreshDataList {
    if (!_refreshDataList) {
        _refreshDataList = [NSMutableArray array];
    }
    return _refreshDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    RESearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[RESearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
    }
    [cell showDataWithHomeFreeModel:self.dataList[indexPath.row]];
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(16, 171.5, REScreenWidth-32, 0.5);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 172;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
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
    REHomeTypeFreeModel *model = self.dataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.free_id;
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
