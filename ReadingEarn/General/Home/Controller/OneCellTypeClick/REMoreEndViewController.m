//
//  REMoreEndViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMoreEndViewController.h"
#import "REEndBookTypeView.h"
#import "REEndBookTypeTableViewCell.h"
#import "REEndBookTypeModel.h"

@interface REMoreEndViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)NSInteger navbtnTag;
@property (nonatomic,strong)UIView *backView;

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UITableView *bookTypeTableView;
@property (nonatomic, strong) NSDictionary *dataList;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) NSMutableArray *tableMoreDataList;
@property (nonatomic, strong) REEndBookTypeView *bookTypeView;
@property (nonatomic, copy) NSString *labels;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger footerCount;

@property (nonatomic, assign) NSInteger requestCountTwo;
@property (nonatomic, assign) NSInteger footerCountTwo;
@property (nonatomic, assign) NSInteger pageTwo;

@end

@implementation REMoreEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navSwitchButton];
    
    self.labels = @"";
    self.style = @"";
    self.requestCount = 0;
    self.footerCount = 0;
    self.requestCountTwo = 0;
    self.footerCountTwo = 0;
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
    if ([self.sexStr isEqualToString:@"1"]) {
        if ([mode isEqualToString:RequestModeWithFirst]) {
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
                    [self.bookTypeTableView.mj_footer endRefreshing];
                    self.bookTypeTableView.mj_footer.state = MJRefreshStateNoMoreData;
                } else {
                    [self.tableMoreDataList removeAllObjects];
                    self.page++;
                    [self request:mode];
                }
            }
        }
    } else {
        if ([mode isEqualToString:RequestModeWithFirst]) {
            self.pageTwo = 1;
            self.requestCountTwo++;
            [self.tableDataList removeAllObjects];
            [self.tableMoreDataList removeAllObjects];
            [self request:mode];
        } else {
            if (self.footerCountTwo == 0) {
                self.footerCountTwo++;
                [self request:mode];
            } else {
                if (self.tableMoreDataList.count<10) {
                    [self.tableMoreDataList removeAllObjects];
                    self.pageTwo++;
                    [self.bookTypeTableView.mj_footer endRefreshing];
                    self.bookTypeTableView.mj_footer.state = MJRefreshStateNoMoreData;
                } else {
                    [self.tableMoreDataList removeAllObjects];
                    self.pageTwo++;
                    [self request:mode];
                }
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
            REEndBookTypeModel *bookTypeModel = [REEndBookTypeModel mj_objectWithKeyValues:dic];
            [self.tableDataList addObject:bookTypeModel];
        }
        if ([mode isEqualToString:RequestModeWithFirst]) {
            if (self.requestCount==1) {
                [self re_loadUI];
            } else {
                [self.bookTypeTableView reloadData];
            }
        } else {
            for (NSDictionary *dic in array) {
                REEndBookTypeModel *bookTypeModel = [REEndBookTypeModel mj_objectWithKeyValues:dic];
                [self.tableMoreDataList addObject:bookTypeModel];
            }
            [self.bookTypeTableView reloadData];
            if (self.bookTypeTableView.mj_footer.isRefreshing) {
                [self.bookTypeTableView.mj_footer endRefreshing];
            }
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

#pragma mark - getter
- (DefaultServerRequest *)requestA {
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/get_over_novel_select",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"sex":self.sexStr,
                                      };
    }
    return _requestA;
}

- (DefaultServerRequest *)requestB {
    if (!_requestB) {
        
        NSString *pageStr;
        if ([self.sexStr isEqualToString:@"1"]) {
            pageStr = [NSString stringWithFormat:@"%ld",(long)self.page];
        } else {
            pageStr = [NSString stringWithFormat:@"%ld",(long)self.pageTwo];
        }
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/novel/get_over_novel_list",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"sex":self.sexStr,
                                       @"limit":@"10",
                                       @"page":pageStr,
                                       @"nove_type": self.style,
                                       @"charge_type":self.labels
                                      };
    }
    return _requestB;
}


#pragma mark - 加载UI
- (void)re_loadUI {
    
    [self bookTypeTableView];
    self.bookTypeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.bookTypeTableView.mj_footer resetNoMoreData];
        [self requestBDataWithMode:RequestModeWithSecond];
    }];
    [self.bookTypeTableView.mj_footer beginRefreshing];
}

- (UITableView *)bookTypeTableView {
    if (!_bookTypeTableView) {
        REEndBookTypeView *headerView = [[REEndBookTypeView alloc] initWithFrame:CGRectMake(0, 0, REScreenWidth, 100) withModel:self.dataList];
        headerView.backgroundColor = REWhiteColor;
        self.bookTypeView = headerView;
        
        __weak typeof(self) weakSelf = self;
        
        headerView.bookTypeBlock = ^(UIButton * _Nonnull sender, id  _Nonnull first, id  _Nonnull second) {
            NSLog(@"tag:%ld  first:%@  second:%@" ,(long)sender.tag,first,second);
            __strong  typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.bookTypeTableView.mj_footer beginRefreshing];
            [self.bookTypeTableView.mj_footer resetNoMoreData];
            strongSelf.footerCount = 0;
            if ([second isEqualToString:@"nove_type"]) {
                strongSelf.labels = first;
                strongSelf.style = @""; 
            } else if ([second isEqualToString:@"charge_type"]) {
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
        _bookTypeTableView.backgroundColor = REWhiteColor;
        _bookTypeTableView.tableHeaderView = headerView;
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
    REEndBookTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[REEndBookTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    REEndBookTypeModel *model = self.tableDataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.class_id;
    vc.imageStr = model.coverpic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 导航栏点击切换按钮
- (void)navSwitchButton {
    NSArray *arrayBtn = @[@"完结男生",@"完结女生"];
    UIView *backView = [UIView new];
    self.backView = backView;
    backView.frame = CGRectMake(101, REStatusHeight+5, (REScreenWidth-101*2), 33);
    backView.backgroundColor = REColor(247, 100, 66);
    [ToolObject buttonTangentialFilletWithButton:backView withUIRectCorner:UIRectCornerAllCorners];
    [self.topNavBar addSubview:backView];
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.5+i*((REScreenWidth-102*2)/2), 0.5, (REScreenWidth-102*2)/2, 32);
        [backView addSubview:btn];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arrayBtn[i] forState:UIControlStateNormal];
        btn.titleLabel.font = REFont(16);
        if ([self.sexStr isEqualToString:@"1"]) {
            if (i==0) {
                [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
                [btn setTitleColor:REWhiteColor forState:UIControlStateNormal];
                btn.backgroundColor = REColor(247, 100, 66);
                self.navbtnTag = 10+i;
            } else {
                [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopRight | UIRectCornerBottomRight];
                [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
                btn.backgroundColor = REWhiteColor;
            }
        } else {
            if (i==0) {
                [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
                [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
                btn.backgroundColor = REWhiteColor;
            } else {
                self.navbtnTag = 10+i;
                [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopRight | UIRectCornerBottomRight];
                [btn setTitleColor:REWhiteColor forState:UIControlStateNormal];
                btn.backgroundColor = REColor(247, 100, 66);
            }
        }
    }
}

- (void)navButtonAction:(UIButton *)sender {
    if ([self.sexStr isEqualToString:@"1"]) {

        UIButton *btn = [self.backView viewWithTag:self.navbtnTag];
        if (sender.selected == YES) {
            self.navbtnTag = sender.tag;
        } else {
            sender.selected = NO;
            [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
            btn.backgroundColor = REWhiteColor;
            [sender setTitleColor:REWhiteColor forState:UIControlStateNormal];
            sender.backgroundColor = REColor(247, 100, 66);
            self.navbtnTag = sender.tag;
        }
        if (sender.tag == 10) {
            self.sexStr = @"1";
            self.requestCount = 0;
            self.footerCount = 0;
            self.requestCountTwo = 0;
            self.footerCountTwo = 0;
            [self.tableDataList removeAllObjects];
            [self.tableMoreDataList removeAllObjects];
            [self searchNovel];
        } else {
            [self.tableDataList removeAllObjects];
            [self.tableMoreDataList removeAllObjects];
            self.sexStr = @"2";
            self.requestCount = 0;
            self.footerCount = 0;
            self.requestCountTwo = 0;
            self.footerCountTwo = 0;
            [self searchNovel];
        }

    } else {

        UIButton *btn = [self.backView viewWithTag:self.navbtnTag];
        if (sender.selected == YES) {
            self.navbtnTag = sender.tag;
        } else {
            sender.selected = NO;
            [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
            btn.backgroundColor = REWhiteColor;
            [sender setTitleColor:REWhiteColor forState:UIControlStateNormal];
            sender.backgroundColor = REColor(247, 100, 66);
            self.navbtnTag = sender.tag;
        }
        if (sender.tag == 10) {
            self.sexStr = @"1";
            self.requestCount = 0;
            self.footerCount = 0;
            self.requestCountTwo = 0;
            self.footerCountTwo = 0;
            [self.tableDataList removeAllObjects];
            [self.tableMoreDataList removeAllObjects];
            [self searchNovel];
        } else {
            [self.tableDataList removeAllObjects];
            [self.tableMoreDataList removeAllObjects];
            self.sexStr = @"2";
            self.requestCount = 0;
            self.footerCount = 0;
            self.requestCountTwo = 0;
            self.footerCountTwo = 0;
            [self searchNovel];
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
