//
//  REHomeSearchViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeSearchViewController.h"
#import "REHomeRotSearchModel.h"
#import "RESearchModel.h"
#import "RESearchTableViewCell.h"
@interface REHomeSearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)DefaultServerRequest *requestA;
@property (nonatomic ,strong)DefaultServerRequest *requestB;
@property (nonatomic ,strong)NSMutableArray *rotSearchDataList;
@property (nonatomic ,strong)NSMutableArray *searchDataList;
@property (nonatomic ,strong)UITableView *searchTableView;
@property (nonatomic ,strong)UIView *searchView;
@property (nonatomic ,copy)NSString *searchString;

@end

@implementation REHomeSearchViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REWhiteColor;
    [self.topNavBar addSearchBox];
    
    self.searchString = @"";
    __weak typeof (self)weekself = self;
    self.topNavBar.searchBarShouldBeginEditingBlock = ^(UISearchBar * _Nonnull searchBar) {
        __strong typeof (weekself)strongself = weekself;
    };
    self.topNavBar.searchBartextDidChangeBlock = ^(UISearchBar * _Nonnull searchBar, NSString * _Nonnull searchText) {
        __strong typeof (weekself)strongself = weekself;
    };
    self.topNavBar.searchBarCancelButtonClickedBlock = ^(UISearchBar * _Nonnull searchBar) {
        __strong typeof (weekself)strongself = weekself;
        strongself.searchTableView.hidden = YES;
        strongself.searchView.hidden = NO;
        [strongself.topNavBar.customSearchBar resignFirstResponder];
    };
    self.topNavBar.searchBarSearchButtonClickedBlock = ^(UISearchBar * _Nonnull searchBar) {
        __strong typeof (weekself)strongself = weekself;
        [strongself requestNetworkBWithSearchString:searchBar.text];
    };
    
    [self requestNetworkA];
}

#pragma mark - 请求数据-----------热门搜索
- (void)requestNetworkA {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = [response.responseObject objectForKey:@"data"];
        for (NSDictionary *dic in array) {
            REHomeRotSearchModel *model = [REHomeRotSearchModel mj_objectWithKeyValues:dic];
            [self.rotSearchDataList addObject:model];
        }
        [self re_loadUI];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/collect/keyword_list",HomePageDomainName];
    }
    return _requestA;
}

#pragma mark - 请求数据 -----------搜索
- (void)requestNetworkBWithSearchString:(NSString *)searchString {
    [self.searchDataList removeAllObjects];
    self.searchString = [NSString stringWithFormat:@"%@",searchString];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestB = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray *array = [[response.responseObject objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary *dic in array) {
                RESearchModel *model = [RESearchModel mj_objectWithKeyValues:dic];
                [self.searchDataList addObject:model];
            }
            self.searchTableView.hidden = NO;
            self.searchView.hidden = YES;
            [self.searchTableView reloadData];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/collect/keyword_book",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"book_name":self.searchString,
                                      };
    }
    return _requestB;
}



#pragma mark - 加载UI
- (void)re_loadUI {
    
    [self searchTableView];
    
    UIView *searchView = [UIView new];
    searchView.hidden = NO;
    searchView.userInteractionEnabled = YES;
    [self.view addSubview:searchView];
    self.searchView = searchView;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavBarHeight+REStatusHeight);
        make.width.mas_equalTo(REScreenWidth);
        make.height.mas_equalTo(REScreenHeight-NavBarHeight-REStatusHeight-RETabBarHeight);
    }];
    
    
    //1.热门搜索
    UILabel *rotLabel = [UILabel new];
    rotLabel.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"热门搜索" attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0]}];
    rotLabel.attributedText = string;
    rotLabel.textColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0];
    [searchView addSubview:rotLabel];
    [rotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@16);
        make.height.equalTo(@13);
    }];
    
    //2.热门标签
    CGFloat w = 0;
    CGFloat h = 55;
    for (int i = 0; i < self.rotSearchDataList.count; i ++) {
        //获取文字的长度
        REHomeRotSearchModel *homeRotSearchModel = self.rotSearchDataList[i];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [homeRotSearchModel.title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
        NSLog(@"%f",length);
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.20];
        button.layer.cornerRadius = 14;
        button.titleLabel.font = REFont(11);
        button.frame = CGRectMake(10 + w, h, length + 15 , 28);
        //当大于屏幕的宽度自动换
        if (10 + w + length + 15 > REScreenWidth)
        {
            w = 0;
            h = h + button.frame.size.height + 12;
            button.frame = CGRectMake(10 + w, h, length + 15 , 28);
        }
        w = button.frame.size.width + button.frame.origin.x;
        [button setTitle:homeRotSearchModel.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0] forState:UIControlStateNormal];
        [searchView addSubview:button];
        [button addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight+REStatusHeight, REScreenWidth, REScreenHeight-NavBarHeight-REStatusHeight) style:UITableViewStyleGrouped];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.hidden = YES;
        _searchTableView.backgroundColor = REWhiteColor;
        [self.view addSubview:_searchTableView];
    }
    return _searchTableView;
}

- (NSMutableArray *)rotSearchDataList {
    if (!_rotSearchDataList) {
        _rotSearchDataList = [NSMutableArray array];
    }
    return _rotSearchDataList;
}

- (NSMutableArray *)searchDataList {
    if (!_searchDataList) {
        _searchDataList = [NSMutableArray array];
    }
    return _searchDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchDataList.count;
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
    [cell showDataWithModel:self.searchDataList[indexPath.row]];
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(16, 171.5, REScreenWidth-32, 0.5);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 172;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = REWhiteColor;
    NSString *str = [NSString stringWithFormat:@"搜索%@结果,共%lu条",self.searchString,(unsigned long)self.searchDataList.count];
    NSString *searchCountStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.searchDataList.count];
    UILabel *label = [ToolObject createLabelWithTitle:str textColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] textFont:15 addSubView:view];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: REColor(153, 153, 153)}];
    [string addAttributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: REColor(153, 153, 153)} range:NSMakeRange(0, str.length)];
    [string addAttributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: REColor(247, 100, 67)} range:NSMakeRange(2, self.searchString.length)];
    [string addAttributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: REColor(247, 100, 67)} range:NSMakeRange(6+self.searchString.length, searchCountStr.length)];
//    label.text = str;
    label.attributedText = string;
    label.frame =CGRectMake(24, 21, REScreenWidth-48, 15);
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RELineColor;
    lineView.frame =CGRectMake(16, 48.5, REScreenWidth-32, 0.5);
    [view addSubview:lineView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    
    UILabel *label = [UILabel new];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"没有更多书籍了" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    [view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 15, REScreenWidth, 20);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RESearchModel *model = self.searchDataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.search_id;
    vc.imageStr = model.coverpic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 事件
- (void)searchButtonAction:(UIButton *)sender {
//    self.searchView.hidden = YES;
//    self.searchTableView.hidden = NO;
    [self requestNetworkBWithSearchString:sender.titleLabel.text];
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
