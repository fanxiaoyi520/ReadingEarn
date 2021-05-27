//
//  REBookshelfViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookshelfViewController.h"
#import "REBookShelfCollectionViewCell.h"
#import "REReadingHistoryTableViewCell.h"
#import "REBookShelfModel.h"
#import "REReadingHistoryModel.h"
#import "REBookShelfCollectionReusableView.h"

@interface REBookshelfViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) DefaultServerRequest *requestC; //tableView单元格删除
@property (nonatomic, strong) DefaultServerRequest *requestD; //collectionView单元格删除
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UICollectionView *bookShelfCollectionView;
@property (nonatomic, strong) UITableView *readingHistoryTableView;
@property (nonatomic, strong) NSMutableArray *bookShelfDataList;
@property (nonatomic, strong) NSMutableArray *readingHistoryDataList;
@property (nonatomic, assign) NSInteger countRequestA;
@property (nonatomic, assign) NSInteger countRequestB;
@property (nonatomic, strong) NSMutableArray *refreshADataList;
@property (nonatomic, strong) NSMutableArray *refreshBDataList;

@property (nonatomic, strong) REBookShelfModel *bookShelfModel;
@property (nonatomic, strong) REReadingHistoryModel *readingHistoryModel;
@property (nonatomic, strong) NSMutableArray *deleteBookShelfDataList;
@property (nonatomic, copy) NSString *deleteBookShelfStr;
@property (nonatomic, assign) BOOL isSelectAll;
@end

@implementation REBookshelfViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self networkRequestBookSelfWithRefresh:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self re_loadUI];
    self.isSelectAll = NO;
    self.refreshADataList = [NSMutableArray array];
    self.refreshBDataList = [NSMutableArray array];
    self.deleteBookShelfDataList = [NSMutableArray array];
    NSArray *array = @[@"我的书架",@"阅读历史"];
    [self navigationBarButtonToggleArray:array leftMargin:(REScreenWidth - 73*2 - 30)/2 topMargin:9 buttonWidth:73 buttonHeight:25];
    
}

#pragma mark - 导航栏切换点击 和 事件
- (void)navButtonAction:(UIButton *)sender {
    [super navButtonAction:sender];
    if (sender.tag==100) {
        self.backScrollView.contentOffset = CGPointMake(0, 0);
    } else {
        self.backScrollView.contentOffset = CGPointMake(REScreenWidth, 0);
    }
}

#pragma mark - 请求数据---------我的书架
- (void)networkRequestBookSelfWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        if (self.refreshADataList.count<13) {
            [self.refreshADataList removeAllObjects];
            self.countRequestA++;
            [self.bookShelfCollectionView.mj_footer endRefreshing];
            self.bookShelfCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        } else {
            [self.refreshADataList removeAllObjects];
            self.countRequestA++;
            [self requestAWithRefresh:isRefresh];
        }
    } else {
        self.countRequestA = 1;
        [self.refreshADataList removeAllObjects];
        [self.bookShelfDataList removeAllObjects];
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestAWithRefresh:isRefresh];
    }
}

- (void)requestAWithRefresh:(BOOL)isRefresh {
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [[response.responseObject objectForKey:@"code"] stringValue];
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showError:[response.responseObject objectForKey:@"msg"]];
        } else if ([code isEqualToString:@"2"]) {
            //token过期
            RELoginViewController *vc = [RELoginViewController new];
            RERootNavigationViewController *nav = [[RERootNavigationViewController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = NO;
            [self presentViewController:nav animated:NO completion:nil];
        } else {
            
            NSArray *array = [[response.responseObject objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary *dic in array) {
                REBookShelfModel *bookShelfModel = [REBookShelfModel mj_objectWithKeyValues:dic];
                [self.bookShelfDataList addObject:bookShelfModel];
            }
            if (isRefresh == NO) {
                [self networkRequestReadingHistoryWithRefresh:NO];
            } else {
                for (NSDictionary *dic in array) {
                    REBookShelfModel *bookShelfModel = [REBookShelfModel mj_objectWithKeyValues:dic];
                    [self.refreshADataList addObject:bookShelfModel];
                }
                [self.bookShelfCollectionView reloadData];
                if (self.bookShelfCollectionView.mj_footer.isRefreshing) {
                    [self.bookShelfCollectionView.mj_footer endRefreshing];
                }
            }
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *countRequestStr = [NSString stringWithFormat:@"%ld",(long)self.countRequestA];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/collect/ajax_list",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"page":countRequestStr,
                                       @"limit":@"12"
                                      };
    }
    return _requestA;
}

#pragma mark - 请求数据---------阅读历史
- (void)networkRequestReadingHistoryWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        if (self.refreshBDataList.count<13) {
            [self.refreshBDataList removeAllObjects];
            self.countRequestB++;
            [self.readingHistoryTableView.mj_footer endRefreshing];
            self.readingHistoryTableView.mj_footer.state = MJRefreshStateNoMoreData;
        } else {
            [self.refreshBDataList removeAllObjects];
            self.countRequestB++;
            [self requestBWithRefresh:isRefresh];
        }
    } else {
        self.countRequestB = 1;
        [self.refreshBDataList removeAllObjects];
        [self.readingHistoryDataList removeAllObjects];
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestBWithRefresh:isRefresh];
    }
}

- (void)requestBWithRefresh:(BOOL)isRefresh {
    
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestB = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = [[response.responseObject objectForKey:@"data"] objectForKey:@"list"];
        for (NSDictionary *dic in array) {
            REReadingHistoryModel *readingHistoryModel = [REReadingHistoryModel mj_objectWithKeyValues:dic];
            [self.readingHistoryDataList addObject:readingHistoryModel];
        }
        if (isRefresh == NO) {
//            [self re_loadUI];
            [self.bookShelfCollectionView reloadData];
            [self.readingHistoryTableView reloadData];
        } else {
            for (NSDictionary *dic in array) {
                REReadingHistoryModel *readingHistoryModel = [REReadingHistoryModel mj_objectWithKeyValues:dic];
                [self.refreshBDataList addObject:readingHistoryModel];
            }
            [self.readingHistoryTableView reloadData];
            if (self.readingHistoryTableView.mj_footer.isRefreshing) {
                [self.readingHistoryTableView.mj_footer endRefreshing];
            }
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *countRequestStr = [NSString stringWithFormat:@"%ld",(long)self.countRequestB];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/collect/reading_log",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"page":countRequestStr,
                                       @"limit":@"12"
                                      };
    }
    return _requestB;
}

#pragma mark - 请求数据----------阅读历史tableView删除单元格
- (void)requestNetworkDelete:(UITableViewCell *)currentCell withVC:(REBookshelfViewController *)strongself {
    NSIndexPath *currentIndexPath = [self.readingHistoryTableView indexPathForCell:currentCell];
    REReadingHistoryModel *readingHistoryModel = self.readingHistoryDataList[currentIndexPath.row];
    self.readingHistoryModel = readingHistoryModel;
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestC = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
            NSIndexPath *currentIndexPath = [self.readingHistoryTableView indexPathForCell:currentCell];
            [strongself.readingHistoryDataList removeObjectAtIndex:currentIndexPath.row];
            [strongself.readingHistoryTableView beginUpdates];
            [strongself.readingHistoryTableView deleteRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [strongself.readingHistoryTableView endUpdates];
            
            [self showAlertMsg:msg Duration:2];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
    }];

}

- (DefaultServerRequest *)requestC {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestC) {
        _requestC = [[DefaultServerRequest alloc] init];
        _requestC.requestMethod = YCRequestMethodPOST;
        _requestC.requestURI = [NSString stringWithFormat:@"%@/collect/del_read",HomePageDomainName];
        _requestC.requestParameter = @{
                                       @"token":token,
                                       @"book_id":self.readingHistoryModel.book_id,
                                      };
    }
    return _requestC;
}

#pragma mark - 请求数据-----------collectionView删除单元格
- (void)requestNetworkBookShrlfDelete:(UICollectionView *)currentCell withVC:(REBookshelfViewController *)strongself {

    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.deleteBookShelfDataList.count; i++) {
        //NSIndexPath *indexPath = self.deleteBookShelfDataList[i];
        REBookShelfModel *bookShelfModel = self.deleteBookShelfDataList[i];
        [array addObject:bookShelfModel.book_id];
    }
    self.deleteBookShelfStr = [NSString stringWithFormat:@"%@",[array componentsJoinedByString:@","]];
    [self.requestD startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestD = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
            for (NSIndexPath *indexPath in [strongself.bookShelfCollectionView indexPathsForVisibleItems]) {
                REBookShelfCollectionViewCell *cell = (REBookShelfCollectionViewCell *)[self.bookShelfCollectionView cellForItemAtIndexPath:indexPath];
                cell.cellSelectButton.selected = NO;
            }
            [strongself.bookShelfDataList removeObjectsInArray:self.deleteBookShelfDataList];
            [strongself.bookShelfCollectionView reloadData];
            [self.deleteBookShelfDataList removeAllObjects];
            [self showAlertMsg:msg Duration:2];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestD = nil;
    }];

}


- (DefaultServerRequest *)requestD {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestD) {
        _requestD = [[DefaultServerRequest alloc] init];
        _requestD.requestMethod = YCRequestMethodPOST;
        _requestD.requestURI = [NSString stringWithFormat:@"%@/collect/del_collect",HomePageDomainName];
        _requestD.requestParameter = @{
                                       @"token":token,
                                       @"ids":self.deleteBookShelfStr,
                                      };
    }
    return _requestD;
}



#pragma mark - 加载UI
- (void)re_loadUI {
    
    [self backScrollView];
    
    //1.我的书架
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 16;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake((REScreenWidth-3*16-16*2)/3, (((REScreenWidth-3*16-2*16)/3) * 172)/104);
    layout.sectionInset = UIEdgeInsetsMake(16, 16 ,16, 16);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize =CGSizeMake(REScreenWidth,39);//头视图大小
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    self.bookShelfCollectionView = collectionView;
    self.bookShelfCollectionView.delegate = self;
    self.bookShelfCollectionView.dataSource = self;
    self.bookShelfCollectionView.frame = CGRectMake(0, 0, REScreenWidth, self.backScrollView.frame.size.height);
    [self.bookShelfCollectionView registerClass:[REBookShelfCollectionViewCell class]
               forCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID"];
    [self.bookShelfCollectionView registerClass:[REBookShelfCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.backScrollView addSubview:collectionView];
    
    self.bookShelfCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    [self.bookShelfCollectionView.mj_footer resetNoMoreData];
        [self networkRequestBookSelfWithRefresh:YES];
    }];
    [self.bookShelfCollectionView.mj_footer beginRefreshing];


    //2.阅读历史
    UITableView *readingHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(REScreenWidth, 0, REScreenWidth, self.backScrollView.frame.size.height) style:UITableViewStylePlain];
    [self.backScrollView addSubview:readingHistoryTableView];
    readingHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    readingHistoryTableView.delegate = self;
    readingHistoryTableView.dataSource = self;
    self.readingHistoryTableView = readingHistoryTableView;
    readingHistoryTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    [self.readingHistoryTableView.mj_footer resetNoMoreData];
        [self networkRequestReadingHistoryWithRefresh:YES];
    }];
    [self.readingHistoryTableView.mj_footer beginRefreshing];

}

- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight+REStatusHeight, REScreenWidth, REScreenHeight-NavBarHeight-REStatusHeight-RETabBarHeight)];
        _backScrollView.contentSize = CGSizeMake(REScreenWidth*2,
                                                 REScreenHeight-NavBarHeight-REStatusHeight-RETabBarHeight);
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.delegate = self;
        _backScrollView.scrollEnabled = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_backScrollView];
    }
    return _backScrollView;
}

- (NSMutableArray *)readingHistoryDataList{
    if (!_readingHistoryDataList) {
        _readingHistoryDataList = [NSMutableArray array];
    }
    return _readingHistoryDataList;
}

- (NSMutableArray *)bookShelfDataList{
    if (!_bookShelfDataList) {
        _bookShelfDataList = [NSMutableArray array];
    }
    return _bookShelfDataList;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookShelfDataList.count;
}

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     //创建item / 从缓存池中拿 Item
     REBookShelfCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID" forIndexPath:indexPath];
     cell.backgroundColor = REWhiteColor;
     cell.layer.cornerRadius = 8;
     [cell showDataWithModel:self.bookShelfDataList[indexPath.item]];
     
     __weak typeof (self)weekself = self;
     cell.cellSelectBlock = ^(UICollectionViewCell * _Nonnull currentCell,UIButton * _Nonnull sender) {
         __strong typeof (weekself)strongself = weekself;
          NSIndexPath *currentIndexPath = [strongself.bookShelfCollectionView indexPathForCell:currentCell];
          REBookShelfModel *bookShelfModel = strongself.bookShelfDataList[currentIndexPath.item];
          if (sender.selected == NO) {
              sender.selected = YES;
              [sender setImage:REImageName(@"toolbar_btn_choose_pre") forState:UIControlStateSelected];
              [strongself.deleteBookShelfDataList addObject:bookShelfModel];
          } else {
              sender.selected = NO;
              [sender setImage:REImageName(@"toolbar_btn_choose_nor") forState:UIControlStateNormal];
              [strongself.deleteBookShelfDataList removeObject:bookShelfModel];
          }
     };
     return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    REBookShelfCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    [header showDataWithModel:self.bookShelfDataList];
        __weak typeof (self)weekself = self;
    //管理书架
    header.managerBookShelfBlock = ^(UIButton * _Nonnull sender) {
        __strong typeof (weekself)strongself = weekself;
        for (NSIndexPath *indexPath in [strongself.bookShelfCollectionView indexPathsForVisibleItems]) {
            REBookShelfCollectionViewCell *cell = (REBookShelfCollectionViewCell *)[self.bookShelfCollectionView cellForItemAtIndexPath:indexPath];
            cell.cellSelectButton.hidden = NO;
            cell.cellSelectButton.selected = NO;
        }
        [strongself.deleteBookShelfDataList removeAllObjects];
        [strongself.bookShelfCollectionView reloadData];
    };
    //选择
    header.selectBlock = ^(UIButton * _Nonnull sender) {
        __strong typeof (weekself)strongself = weekself;
        if (strongself.isSelectAll == YES) {
            strongself.isSelectAll = NO;
            for (NSIndexPath *indexPath in [strongself.bookShelfCollectionView indexPathsForVisibleItems]) {
                REBookShelfCollectionViewCell *cell = (REBookShelfCollectionViewCell *)[self.bookShelfCollectionView cellForItemAtIndexPath:indexPath];
                cell.cellSelectButton.selected = NO;
                REBookShelfModel *bookShelfModel = strongself.bookShelfDataList[indexPath.item];
                [self.deleteBookShelfDataList removeObject:bookShelfModel];
            }
        } else {
            strongself.isSelectAll = YES;
            for (NSIndexPath *indexPath in [strongself.bookShelfCollectionView indexPathsForVisibleItems]) {
                REBookShelfCollectionViewCell *cell = (REBookShelfCollectionViewCell *)[self.bookShelfCollectionView cellForItemAtIndexPath:indexPath];
                cell.cellSelectButton.selected = YES;
                REBookShelfModel *bookShelfModel = strongself.bookShelfDataList[indexPath.item];
                [self.deleteBookShelfDataList addObject:bookShelfModel];
            }
        }
        [strongself.bookShelfCollectionView reloadData];
    };
    //删除
    header.headerDeleteBlock = ^(UIButton * _Nonnull sender) {
        __strong typeof (weekself)strongself = weekself;
        [self requestNetworkBookShrlfDelete:collectionView withVC:strongself];
    };
    //取消
    header.cancelBlock = ^(UIButton * _Nonnull sender) {
        __strong typeof (weekself)strongself = weekself;
        for (NSIndexPath *indexPath in [strongself.bookShelfCollectionView indexPathsForVisibleItems]) {
            REBookShelfCollectionViewCell *cell = (REBookShelfCollectionViewCell *)[self.bookShelfCollectionView cellForItemAtIndexPath:indexPath];
            cell.cellSelectButton.hidden = YES;
            cell.cellSelectButton.selected = YES;
            //REBookShelfModel *bookShelfModel = strongself.bookShelfDataList[indexPath.item];
        }
        [strongself.deleteBookShelfDataList removeAllObjects];
        [strongself.bookShelfCollectionView reloadData];
    };
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    REBookShelfModel *model = self.bookShelfDataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.book_id;
    vc.imageStr = model.coverpic;
    [self.navigationController pushViewController:vc animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.readingHistoryDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    REReadingHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[REReadingHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
        
        __weak typeof (self) weekself = self;
        cell.bookShelfBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (self) strongself = weekself;
            NSLog(@"加入书架");
        };
        cell.deleteBlock = ^(UITableViewCell * _Nonnull currentCell) {
            __strong typeof (self) strongself = weekself;
            [self requestNetworkDelete:currentCell withVC:strongself];
        };
    }
    [cell showDataWithModel:self.readingHistoryDataList[indexPath.row]];
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(16, 171.5, REScreenWidth-32, 0.5);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140+32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    REReadingHistoryModel *model = self.readingHistoryDataList[indexPath.row];
    EReaderContainerController *vc = [EReaderContainerController new];
    vc.bookId = model.book_id;
    vc.chapter_number = model.chapter_number;
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
