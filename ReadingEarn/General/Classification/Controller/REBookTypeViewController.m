//
//  REBookTypeViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/19.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookTypeViewController.h"
#import "REBookTypeView.h"
#import "REBookTypeTableViewCell.h"
#import "REBookTypeModel.h"

@interface REBookTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, strong) UITableView *bookTypeTableView;
@property (nonatomic, strong) NSDictionary *dataList;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) NSMutableArray *tableMoreDataList;
@property (nonatomic, strong) REBookTypeView *bookTypeView;
@property (nonatomic, copy) NSString *labels;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger footerCount;
@end

@implementation REBookTypeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.labels = @"";
    self.style = @"";
    self.requestCount = 0;
    self.footerCount = 0;
    self.tableDataList = [NSMutableArray array];
    self.tableMoreDataList = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchNovel];
}

#pragma mark - 网络请求
- (void)searchNovel {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.dataList = [response.responseObject objectForKey:@"data"];
        
        [self requestBDataWithMode:RequestModeWithFirst];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)requestBDataWithMode:(NSString *)mode {
    if ([mode isEqualToString:RequestModeWithFirst]) {

        //[self.bookTypeTableView.mj_footer resetNoMoreData];
        self.page = 1;
        self.requestCount++;
        [self.tableDataList removeAllObjects];
        [self.tableMoreDataList removeAllObjects];
        [self request:mode];
    } else {
        if (self.footerCount == 0) {
            self.footerCount++;
            [self request:mode];
        } else {
            if (self.tableMoreDataList.count<10) {
                [self.tableMoreDataList removeAllObjects];
                self.page++;
            } else {
                [self.tableMoreDataList removeAllObjects];
                self.page++;
                [self request:mode];
            }
        }
    }
}

- (void)request:(NSString *)mode {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestB = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = [[response.responseObject objectForKey:@"data"] objectForKey:@"list"];
        for (NSDictionary *dic in array) {
            REBookTypeModel *bookTypeModel = [REBookTypeModel mj_objectWithKeyValues:dic];
            [self.tableDataList addObject:bookTypeModel];
            [self.tableMoreDataList addObject:bookTypeModel];
        }
    
        if ([mode isEqualToString:RequestModeWithFirst]) {
            if (self.requestCount==1) {
                [self re_loadUI];
            } else {
                [self.bookTypeTableView reloadData];
            }
        } else {
            for (NSDictionary *dic in array) {
                REBookTypeModel *bookTypeModel = [REBookTypeModel mj_objectWithKeyValues:dic];
                [self.tableMoreDataList addObject:bookTypeModel];
            }
            [self.bookTypeTableView reloadData];
            if (self.tableMoreDataList.count < 10) {//本次接口获得的数据列表数<10
                [self.bookTypeTableView.mj_footer endRefreshing];
                if (self.tableDataList.count < 10) {//主播动态页的数据列表数<10
                    self.bookTypeTableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        if ([mode isEqualToString:RequestModeWithFirst]) {
        } else {
            [self.bookTypeTableView.mj_footer endRefreshing];
        }
    }];
}

- (void)requestNetWorkCmore {
    self.page++;
    [self requestNetWorkC];
}

- (void)requestNetWorkC {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self)weekself = self;
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestC = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.bookTypeTableView.mj_footer endRefreshing];

        NSArray *array = [[response.responseObject objectForKey:@"data"] objectForKey:@"list"];
        for (NSDictionary *dic in array) {
            REBookTypeModel *bookTypeModel = [REBookTypeModel mj_objectWithKeyValues:dic];
            [self.tableDataList addObject:bookTypeModel];
        }
        [weekself.bookTypeTableView reloadData];

        if (array.count < 10) {
            [self.bookTypeTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
    }];
}

- (DefaultServerRequest *)requestC {
    if (!_requestC) {
        NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)self.page];
        _requestC = [[DefaultServerRequest alloc] init];
        _requestC.requestMethod = YCRequestMethodPOST;
        _requestC.requestURI = [NSString stringWithFormat:@"%@/novel/get_novel_type_list",HomePageDomainName];
        _requestC.requestParameter = @{
                                       @"cate_id":self.classModel.class_id,
                                       @"limit":@"10",
                                       @"page":pageStr,
                                       @"style": self.style,
                                       @"labels":self.labels
                                      };
    }
    return _requestC;
}


#pragma mark - getter
- (DefaultServerRequest *)requestA {
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/get_novel_type_select",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"cate_id":self.classModel.class_id,
                                      };
    }
    return _requestA;
}

- (DefaultServerRequest *)requestB {
    if (!_requestB) {
        NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)self.page];
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/novel/get_novel_type_list",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"cate_id":self.classModel.class_id,
                                       @"limit":@"10",
                                       @"page":pageStr,
                                       @"style": self.style,
                                       @"labels":self.labels
                                      };
    }
    return _requestB;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    [self bookTypeTableView];
}

- (UITableView *)bookTypeTableView {
    if (!_bookTypeTableView) {
        REBookTypeView *headerView = [[REBookTypeView alloc] initWithFrame:CGRectMake(0, 0, REScreenWidth, 100) withModel:self.dataList];
        headerView.backgroundColor = REWhiteColor;
        self.bookTypeView = headerView;
        
        __weak typeof(self) weakSelf = self;
        headerView.bookTypeBlock = ^(UIButton * _Nonnull sender, id  _Nonnull first, id  _Nonnull second) {
            __strong  typeof(weakSelf) strongSelf = weakSelf;
            
            [self.bookTypeTableView.mj_footer resetNoMoreData];

            strongSelf.footerCount = 0;
            if ([second isEqualToString:@"labels"]) {
                strongSelf.labels = first;
                strongSelf.style = @"";
            } else if ([second isEqualToString:@"style"]) {
                strongSelf.labels = @"";
                strongSelf.style = first;
            } else {
                strongSelf.labels = @"";
                strongSelf.style = @"";
            }
            [strongSelf requestBDataWithMode:RequestModeWithFirst];
        };

        _bookTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _bookTypeTableView.delegate = self;
        _bookTypeTableView.dataSource = self;
        _bookTypeTableView.backgroundColor = REBackColor;
//        _bookTypeTableView.tableHeaderView = headerView;
        _bookTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) myweakSelf = self;
        self.bookTypeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [myweakSelf requestNetWorkCmore];
        }];
        [self.view addSubview:_bookTypeTableView];
    }
    return _bookTypeTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    REBookTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[REBookTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
    }
    [cell showDataWithModel:self.tableDataList[indexPath.row]];
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(16, 171.5, REScreenWidth-32, 0.5);
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140+32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.bookTypeView showBookTypeViewWithModel:self.dataList];
    return self.bookTypeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    REBookTypeModel *model = self.tableDataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.class_id;
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
