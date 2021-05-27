//
//  REAllDirectoriesViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REAllDirectoriesViewController.h"
#import "REChapterModel.h"

@interface REAllDirectoriesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;

@property (nonatomic, strong) UITableView *chapterTableView;
@property (nonatomic, strong) UITableView *chapterSegmentationTableView;
@property (nonatomic, strong) NSMutableArray *chapterDataList;
@property (nonatomic, strong) NSMutableArray *chapterSegmentationDataList;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) UIButton *navButton;
@end

@implementation REAllDirectoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestNetWrokBWithRefresh:NO];
}

- (void)navButtonUI:(NSString *)total {
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navButton.titleLabel.font = REFont(18);
    [navButton setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
    navButton.frame = CGRectMake(100, REStatusHeight+8, REScreenWidth-200, 25);
    [navButton setTitle:total forState:UIControlStateNormal];
    [self.topNavBar addSubview:navButton];
}

#pragma mark - 请求数据 ----------获取分章列表
- (void)requestNetWrokA {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        
    } failure:^(YCNetworkResponse * _Nonnull response) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    //NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/get_chapter_first",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"bookid":self.book_id,
                                      };
    }
    return _requestA;
}

#pragma mark - 请求数据 ----------获取章节列表
- (void)requestNetWrokBWithRefresh:(BOOL)isRefresh {
    self.isRefresh = isRefresh;
    if (isRefresh == YES) {
        self.pageCount++;
        [self requestNetWrokB];
    } else {
        self.pageCount = 1;
        [self requestNetWrokB];
    }
}

- (void)requestNetWrokB {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"1"]) {
            NSArray *array = response.responseObject[@"data"];
            for (NSDictionary *dic in array) {
                REChapterModel *model = [REChapterModel mj_objectWithKeyValues:dic];
                [self.chapterDataList addObject:model];
            }
            if (self.isRefresh == NO) {
                NSString *total = [NSString stringWithFormat:@"共%@章",response.responseObject[@"total"]];
                [self navButtonUI:total];
                [self re_loadUI];
            } else {
                [self.chapterTableView reloadData];
            }
        } else {
            [self showAlertMsg:msg Duration:2];
        }
        
    } failure:^(YCNetworkResponse * _Nonnull response) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageCount];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/novel/get_chapter_data",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"bookid":self.book_id,
                                       @"page":page,
                                       @"order":@"ase",
                                       @"limit":@"500"
                                      };
    }
    return _requestB;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self chapterTableView];
    self.chapterTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.chapterTableView.mj_footer resetNoMoreData];
        [self requestNetWrokBWithRefresh:YES];
    }];
    [self.chapterTableView.mj_footer beginRefreshing];

}

- (UITableView *)chapterTableView {
    if (!_chapterTableView) {
        _chapterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _chapterTableView.delegate = self;
        _chapterTableView.dataSource = self;
        [self.view addSubview:_chapterTableView];
    }
    return _chapterTableView;
}

- (UITableView *)chapterSegmentationTableView {
    if (!_chapterSegmentationTableView) {
        _chapterSegmentationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _chapterSegmentationTableView.delegate = self;
        _chapterSegmentationTableView.dataSource = self;
        [self.view addSubview:_chapterSegmentationTableView];
    }
    return _chapterTableView;
}

- (NSMutableArray *)chapterDataList {
    if (!_chapterDataList) {
        _chapterDataList = [NSMutableArray new];
    }
    return _chapterDataList;
}

- (NSMutableArray *)chapterSegmentationDataList {
    if (!_chapterSegmentationDataList) {
        _chapterSegmentationDataList = [NSMutableArray new];
    }
    return _chapterSegmentationDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.chapterTableView) {
        return self.chapterDataList.count;
    } else {
        return self.chapterSegmentationDataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.chapterTableView) {
        NSString *cellid = [NSString stringWithFormat:@"chap%ld",indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            
            cell.textLabel.font = REFont(14);
            cell.textLabel.textColor = REColor(51, 51, 51);
        }
        REChapterModel *model = self.chapterDataList[indexPath.row];
        NSString *chapter_name = [model.chapter_name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        cell.textLabel.text = chapter_name;
        return cell;
    } else {
        NSString *cellid = [NSString stringWithFormat:@"chapseg%ld",indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chapterTableView) {
        return 40;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    REChapterModel *model = self.chapterDataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.book_id;
    vc.imageStr = self.imageStr;
    vc.chapter_number = model.chapter_number;
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
