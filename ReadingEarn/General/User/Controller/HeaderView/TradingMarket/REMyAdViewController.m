//
//  REMyAdViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/9.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyAdViewController.h"
#import "REMyAdModel.h"
#import "REMyAdTableViewCell.h"

@interface REMyAdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)NSInteger navbtnTag;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic ,strong)UITableView *myAdTableView;
@property (nonatomic ,strong)NSMutableArray *myAdDataList;
@property (nonatomic ,strong)NSMutableArray *refreshMyAdDataList;
@property (nonatomic ,assign)NSInteger pageCount;
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,strong)REReadingEarnPopupView *popView;
@property (nonatomic ,copy)NSString *paypwd;
@property (nonatomic ,copy)NSString *ad_id;
@end

@implementation REMyAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REBackColor;
    [self navSwitchButton];
    
    self.type = @"1";
    [self re_loadUI];
    [self requestNetworkWithRefresh:NO];
}

#pragma mark - 网络请求-------- 我的广告
-(void) requestNetworkWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        if (self.refreshMyAdDataList.count < 10) {
            [self.refreshMyAdDataList removeAllObjects];
            [self.myAdTableView.mj_footer endRefreshing];
        } else {
            [self.refreshMyAdDataList removeAllObjects];
            [self requestNetwork];
        }
    } else {
        self.pageCount = 1;
        [self.refreshMyAdDataList removeAllObjects];
        [self.myAdDataList removeAllObjects];
        [self requestNetwork];
    }
}

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

        if ([code isEqualToString:@"1"]) {
            NSArray *array = response.responseObject[@"data"];
            for (NSDictionary *dic in array) {
                REMyAdModel *model = [REMyAdModel mj_objectWithKeyValues:dic];
                [self.myAdDataList addObject:model];
                [self.refreshMyAdDataList addObject:model];
            }
            [self.myAdTableView reloadData];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageCount];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/my_ad",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"page":page,
                                       @"limit":@"10",
                                       @"type":self.type,
                                    };
    }
    return _requestA;
}

#pragma mark - 网络请求--------撤销请求
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

        if ([code isEqualToString:@"1"]) {
            [self showAlertMsg:msg Duration:2];
            [self.popView closeThePopupView];
            [self requestNetworkWithRefresh:NO];
        } else {
            [self showAlertMsg:msg Duration:2];
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/otc/cancel_ad",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"ad_id":self.ad_id,
                                       @"paypwd":self.paypwd,
                                    };
    }
    return _requestB;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self myAdTableView];
    self.myAdTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self.myAdTableView.mj_footer resetNoMoreData];
         [self requestNetworkWithRefresh:YES];
    }];
    [self.myAdTableView.mj_footer beginRefreshing];

}

- (UITableView *)myAdTableView {
    if (!_myAdTableView) {
        _myAdTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _myAdTableView.delegate = self;
        _myAdTableView.dataSource = self;
        _myAdTableView.backgroundView = nil;
        _myAdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myAdTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_myAdTableView];
    }
    return _myAdTableView;
}

- (NSMutableArray *)myAdDataList {
    if (!_myAdDataList) {
        _myAdDataList = [NSMutableArray array];
    }
    return _myAdDataList;
}

- (NSMutableArray *)refreshMyAdDataList {
    if (!_refreshMyAdDataList) {
        _refreshMyAdDataList = [NSMutableArray array];
    }
    return _refreshMyAdDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myAdDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID =[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    REMyAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[REMyAdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
        __weak typeof (self)weekself = self;
        cell.cancelBlock = ^(UIButton * _Nonnull sender,UITableViewCell * _Nonnull mycell) {
            __strong typeof (weekself)strongself = weekself;
            
            NSIndexPath *myIndexPath = [tableView indexPathForCell:mycell];
            REMyAdModel *model = self.myAdDataList[myIndexPath.row];
            self.ad_id = model.myad_id;
            REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
            [popView showPopupViewWithData:@""];
            strongself.popView = popView;
            popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                __strong typeof (weekself)strongself = weekself;
                strongself.paypwd = text;
                if (text.length < 6) {
                    [strongself showAlertMsg:@"密码错误" Duration:2];
                } else {
                    [strongself requestNetworkB];
                }
            };
        };
    }
    
    [cell showDataWithModel:self.myAdDataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - 导航栏点击切换按钮
- (void)navSwitchButton {
    NSArray *arrayBtn = @[@"购买",@"出售"];
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
    }
}

- (void)navButtonAction:(UIButton *)sender {
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
    if (sender.tag==10) {
        self.pageCount = 1;
        self.type = @"1";
        [self requestNetworkWithRefresh:NO];
    } else {
        self.pageCount = 1;
        self.type = @"2";
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
