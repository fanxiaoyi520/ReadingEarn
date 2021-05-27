//
//  RESystemBulletinViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RESystemBulletinViewController.h"
#import "RESystemBulletioModel.h"
#import "RESystembulletinDetailViewController.h"

@interface RESystemBulletinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *personalTableView;
@property (nonatomic ,strong)NSMutableArray *personalArray;
@property (nonatomic ,strong)NSMutableArray *refreshPersonalArray;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation RESystemBulletinViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
    
    self.pageCount = 1;
    self.view.backgroundColor = REBackColor;
    [self re_loadUI];
    [self requestNetworkWithRefresh:NO];
}


#pragma mark - 网络请求--------用户信息
- (void)requestNetworkWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        if (self.refreshPersonalArray.count < 15) {
            
            [self.refreshPersonalArray removeAllObjects];
            [self.personalTableView.mj_footer endRefreshing];
        } else {
            [self.refreshPersonalArray removeAllObjects];
            [self requestNetwork];
        }
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        NSArray *array = response.responseObject[@"data"];
        if ([code isEqualToString:@"1"]) {
            for (NSDictionary *dic in array) {
                RESystemBulletioModel *model = [RESystemBulletioModel mj_objectWithKeyValues:dic];
                [self.personalArray addObject:model];
                [self.refreshPersonalArray addObject:model];
            }
            [self.personalTableView  reloadData];
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
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/article/notice_list",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"page":page,
                                       @"limit":@"15"
                                      };
    }
    return _requestA;
}


#pragma mark - 加载UI
- (void)re_loadUI {
    [self personalTableView];
    self.personalTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    [self.personalTableView.mj_footer resetNoMoreData];
        [self requestNetworkWithRefresh:YES];
    }];
}

- (UITableView *)personalTableView {
    if (!_personalTableView) {
        _personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _personalTableView.delegate = self;
        _personalTableView.dataSource = self;
        [self.view addSubview:_personalTableView];
    }
    return _personalTableView;
}

- (NSMutableArray *)personalArray {
    if (!_personalArray) {
        _personalArray = [NSMutableArray array];
    }
    return _personalArray;
}

- (NSMutableArray *)refreshPersonalArray {
    if (!_refreshPersonalArray) {
        _refreshPersonalArray = [NSMutableArray array];
    }
    return _refreshPersonalArray;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        [cell.contentView addSubview:lineView];
        lineView.tag = 10;
        
        //1.
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 20;
        [cell.contentView addSubview:label];
        
        //2.
        UILabel *timeLabel = [UILabel new];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.tag = 30;
        [cell.contentView addSubview:timeLabel];
    }
    
    RESystemBulletioModel *model = self.personalArray[indexPath.row];
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(22, 69.9, REScreenWidth-44, 0.5);
    
    //1.
    UILabel *label = [cell.contentView viewWithTag:20];
    label.frame = CGRectMake(24, 15, REScreenWidth-24-21-16, 21);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0];
    
    //2
    NSString *timeStr = [ToolObject getDateStringWithTimestamp:model.addTime];
    UILabel *timeLabel = [cell.contentView viewWithTag:30];
    timeLabel.frame = CGRectMake(24, 46, REScreenWidth-24-21-16, 21);
    NSMutableAttributedString *timeLabelstring = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0]}];
    timeLabel.attributedText = timeLabelstring;
    timeLabel.textColor = [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RESystembulletinDetailViewController *vc = [RESystembulletinDetailViewController new];
    vc.naviTitle = @"公告详情";
    RESystemBulletioModel *model = self.personalArray[indexPath.row];
    vc.title = model.title;
    vc.contentsStr = model.contents;
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
