//
//  REHomeViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeViewController.h"
#import "RERootViewController.h"
#import "HomeModel.h"
#import "HomeAreaModel.h"
#import "REHomeOneTableViewCell.h"
#import "REVIPTableViewCell.h"
#import "REAreaTableViewCell.h"
#import "REHistoryBackModel.h"
#import "REReadHistoryModel.h"
//二级界面
//1.第一模块
#import "REHomeSearchViewController.h"
#import "REHomeBookDetailViewController.h"
#import "REHomeTypeClickViewController.h"
#import "REHomeFreeViewController.h"
#import "REHomeEndViewController.h"
//2.VIP模块
#import "REHomeVIPMoreViewController.h"

#import "HomeVipModel.h"
#import "HomeQuick2Model.h"
#import "HomeManModel.h"
#import "HomeWomanTypeModel.h"
#import "REAdvertisementViewController.h"

@interface REHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, strong) DefaultServerRequest *requestHistory;
@property (nonatomic, strong) DefaultServerRequest *requestHistoryTwo;
@property (nonatomic, copy) NSString *channel;

@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic, strong) HomeAreaModel *homeAreaModel;
@property (nonatomic, strong) NSMutableArray *homeAreaArray;
@property (nonatomic ,strong)UITableView *homeTableView;
@property (nonatomic, strong) NSMutableDictionary *responseDic;
@property (nonatomic, assign) NSUInteger requestCount;
@property (nonatomic, copy) NSString *keyStr;
@property (nonatomic, strong) NSMutableArray *bookArray;
@property (nonatomic, strong) DefaultServerRequest *requestReading;
@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, strong) REHistoryBackModel *historyBackModel;
@property (nonatomic, strong) REReadHistoryModel *readHistoryModel;
@property (nonatomic, copy) NSString *distinguishStr;
@end

@implementation REHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.homeTableView reloadData];
        [self requestNetworkHistory];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.channel = @"jingxuan";
    self.homeAreaArray = [NSMutableArray array];
    self.bookArray = [NSMutableArray array];
    self.requestCount = 0;
    NSArray *array = @[@"精选",@"男生",@"女生"];
    [self navigationBarButtonToggleArray:array leftMargin:(REScreenWidth-36*3-60)/2 topMargin:17 buttonWidth:36 buttonHeight:25];
    [self requestNetworkC];
}

#pragma mark - 导航栏切换点击
- (void)navButtonAction:(UIButton *)sender {
    self.distinguishStr = @"0";
    [super navButtonAction:sender];
    if (sender.tag == 100) {
        self.channel = @"jingxuan";
        //[self.homeTableView removeFromSuperview];
        [self searchNovel];
    } else if (sender.tag == 101) {
        self.channel = @"man";
        //[self.homeTableView removeFromSuperview];
        [self searchNovel];
    } else {
        self.channel = @"woman";
        //[self.homeTableView removeFromSuperview];
        [self searchNovel];
    }
}

#pragma mark - 网络请求
- (void)searchNovel {
    self.requestCount++;
    [self.homeAreaArray removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic = [response.responseObject objectForKey:@"data"];
        HomeModel *p1 = [HomeModel mj_objectWithKeyValues:dic];
        self.homeModel = p1;
        
        //area
        NSDictionary *responseDic = [dic objectForKey:@"area"];//@"请求结果"
        self.responseDic = [[NSMutableDictionary alloc]initWithDictionary:responseDic];
        NSArray *responseKeys = responseDic.allKeys;
        [self.homeAreaArray addObjectsFromArray:responseKeys];

        [self.homeTableView reloadData];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodGET;
        _requestA.requestSerializer = [AFJSONRequestSerializer serializer];
        _requestA.requestURI = [NSString stringWithFormat:@"%@/index/get_channel_data",HomePageDomainName];
        _requestA.requestParameter = @{
                                          @"channel":self.channel,
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求---------换一批
- (void)searchNovelBwithCell:(UITableViewCell *)mycell {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestB = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = [response.responseObject objectForKey:@"data"];
        for (NSDictionary *dic in array) {
            HomeBookModel *model = [HomeBookModel mj_objectWithKeyValues:dic];
            [self.bookArray addObject:model];
        }

        NSIndexPath *myIndexPath = [self.homeTableView indexPathForCell:mycell];
        NSMutableDictionary *dics = [[NSMutableDictionary alloc] initWithDictionary:[self.responseDic objectForKey:self.homeAreaArray[myIndexPath.section-2]]];
        
        [dics setValue:array forKey:@"book"];
        [self.responseDic setValue:dics forKey:self.homeAreaArray[myIndexPath.section-2]];
        [self.homeTableView beginUpdates];
        [self.homeTableView reloadRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.homeTableView endUpdates];
        
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/index/get_area_data",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"area":self.keyStr,
                                      };
    }
    return _requestB;
}

#pragma mark - 网络请求---------阅读历史
- (void)requestNetworkHistory {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestHistory startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestHistory = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *dic = [response.responseObject objectForKey:@"data"];
            REReadHistoryModel *model = [REReadHistoryModel mj_objectWithKeyValues:dic[@"readHistory"]];
            self.readHistoryModel = model;
            REHistoryBackModel *backModel = [REHistoryBackModel mj_objectWithKeyValues:dic[@"historyBack"]];
            self.historyBackModel = backModel;
            
            if ([self.homeTableView numberOfRowsInSection:0] == 1) {
                [self.homeTableView beginUpdates];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [self.homeTableView endUpdates];
            }
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestHistory = nil;
    }];
}

- (DefaultServerRequest *)requestHistory {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestHistory) {
        _requestHistory = [[DefaultServerRequest alloc] init];
        _requestHistory.requestMethod = YCRequestMethodPOST;
        _requestHistory.requestURI = [NSString stringWithFormat:@"%@/index/get_read_history",HomePageDomainName];
        _requestHistory.requestParameter = @{
                                       @"token":token,
                                       @"channel":self.channel,
                                      };
    }
    return _requestHistory;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    //[self homeTableView];
    _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RENavigationHeight, REScreenWidth, REScreenHeight-RETabBarHeight-RENavigationHeight) style:UITableViewStyleGrouped];
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    _homeTableView.backgroundColor = REWhiteColor;
    _homeTableView.estimatedRowHeight = 65+2*173 + 16 + 172 +8 + 172 + 8 + 172;
    [self.view addSubview:_homeTableView];

}

- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RENavigationHeight, REScreenWidth, REScreenHeight-RETabBarHeight-RENavigationHeight) style:UITableViewStyleGrouped];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.backgroundColor = REWhiteColor;
        _homeTableView.estimatedRowHeight = 65+2*173 + 16 + 172 +8 + 172 + 8 + 172;
        [self.view addSubview:_homeTableView];
    }
    return _homeTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homeAreaArray.count+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         NSString *cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        REHomeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REHomeOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withModel:self.homeModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self)weekself = self;
            cell.searchBlock = ^(UIButton * _Nonnull sender) {
                __strong typeof (weekself)strongself = weekself;
                REHomeSearchViewController *vc = [REHomeSearchViewController new];
                [strongself.navigationController pushViewController:vc animated:YES];
            };
            
            //种类点击事件
            cell.typeClickBlock = ^(UIButton * _Nonnull sender) {
                __strong typeof (weekself)strongself = weekself;
                if (sender.tag == 200) {
                      strongself.tabBarController.selectedIndex=1;
                } else if (sender.tag == 201) {
                    REHomeTypeClickViewController *vc = [REHomeTypeClickViewController new];
                    [strongself.navigationController pushViewController:vc animated:YES];
                } else if (sender.tag == 202) {
                    REHomeFreeViewController *vc = [REHomeFreeViewController new];
                    if ([ToolObject onlineAuditJudgment] == YES) {
                        vc.naviTitle = @"免费";
                    } else {
                        vc.naviTitle = @"排行";
                    }
                    [strongself.navigationController pushViewController:vc animated:YES];
                } else if (sender.tag == 203) {
                    REHomeEndViewController *vc = [REHomeEndViewController new];
                    vc.naviTitle = @"完结";
                    [strongself.navigationController pushViewController:vc animated:YES];
                                   
                }
            };
            
            //热门最新
            cell.rotAndNewBlock = ^(id  _Nonnull sender) {
                __strong typeof (weekself)strongself = weekself;
                UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
                UIImageView *imageView = (UIImageView *)tap.view;
                
                if (imageView.tag == 300) {
                    REHomeEndViewController *vc = [REHomeEndViewController new];
                    vc.naviTitle = @"热门书籍";
                    [strongself.navigationController pushViewController:vc animated:YES];

                } else {
                    REHomeEndViewController *vc = [REHomeEndViewController new];
                    vc.naviTitle = @"最新书籍";
                    [strongself.navigationController pushViewController:vc animated:YES];
                }
            };
            
            //阅读历史
            cell.readHistoryBlock = ^(UIButton * _Nonnull sender) {
                __strong typeof (weekself)strongself = weekself;
                strongself.book_id = strongself.readHistoryModel.book_id;
                EReaderContainerController *vc = [EReaderContainerController new];
                vc.bookId = strongself.book_id;
                vc.imageStr = strongself.readHistoryModel.coverpic;
                vc.chapter_number = strongself.readHistoryModel.chapter_number;
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            //直播
            cell.liveBroadcastBlock = ^(id  _Nonnull sender) {
                __strong typeof (weekself)strongself = weekself;
                REAdvertisementViewController *vc = [REAdvertisementViewController new];
                vc.naviTitle = @"关注";
                [strongself.navigationController pushViewController:vc animated:YES];
            };
        }
        [cell showDataWithModel:self.homeModel withHistoryModel:self.historyBackModel withReadHistoryModel:self.readHistoryModel];
        
         return cell;
        
    } else if (indexPath.section == 1) {
        NSString *cellID = [NSString stringWithFormat:@"vip%ld",(long)indexPath.row];
        REVIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REVIPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withModel:self.homeModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell showDataWithModel:self.homeModel];
        __weak typeof (self)weekself = self;
        cell.vipMoreClickBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            REHomeVIPMoreViewController *vc = [REHomeVIPMoreViewController new];
            vc.naviTitle = @"VIP专属";
            [strongself.navigationController pushViewController:vc animated:YES];
        };
        //点击书本阅读
        cell.readingBookBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull book_id,NSString * _Nonnull imageStr) {
            __strong typeof (weekself)strongself = weekself;
            strongself.book_id = book_id;
            EReaderContainerController *vc = [EReaderContainerController new];
            vc.bookId = book_id;
            vc.imageStr = imageStr;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        //
        cell.boyAndGirlBlock = ^(id  _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
            UIImageView *imageView = (UIImageView *)tap.view;
            
            if (imageView.tag == 380) {
                REHomeEndViewController *vc = [REHomeEndViewController new];
                vc.naviTitle = @"热血小说";
                [strongself.navigationController pushViewController:vc animated:YES];

            } else {
                REHomeEndViewController *vc = [REHomeEndViewController new];
                vc.naviTitle = @"最新书籍";
                [strongself.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    } else {
        //[NSString stringWithFormat:@"area%ld%ld",(long)indexPath.section,indexPath.row]
        static NSString *cellID = @"cell";
        REAreaTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            NSDictionary *areaDic = [self.responseDic objectForKey:self.homeAreaArray[indexPath.section-2]];
            HomeAreaModel *areaModel = [HomeAreaModel mj_objectWithKeyValues:areaDic];
            cell = [[REAreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withModel:areaModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *areaDic = [self.responseDic objectForKey:self.homeAreaArray[indexPath.section-2]];

        HomeAreaModel *areaModel = [HomeAreaModel mj_objectWithKeyValues:areaDic];
        [cell showDataWithModel:areaModel withKey:self.homeAreaArray[indexPath.section-2]];
        __weak typeof (self)weekself = self;
        cell.areaMoreClickBlock = ^(UIButton * _Nonnull sender, NSString * _Nonnull key,UITableViewCell *_Nonnull mycell) {
            __strong typeof (weekself)strongself = weekself;
            strongself.keyStr = key;
            [strongself searchNovelBwithCell:mycell];
        };
        //点击书本阅读
        cell.readingBookBlocks = ^(UIButton * _Nonnull sender,NSString * _Nonnull book_id,NSString * _Nonnull imageStr) {
            __strong typeof (weekself)strongself = weekself;
            strongself.book_id = book_id;
            EReaderContainerController *vc = [EReaderContainerController new];
            vc.bookId = book_id;
            vc.imageStr = imageStr;
            [self.navigationController pushViewController:vc animated:YES];

        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat boyGirlImageW = AdaptationW(16, 2, 11);
    CGFloat boyGirlImageH =  boyGirlImageW * 76 / 166;
    if (indexPath.section == 0) {
        CGFloat oneCellHeight = (94+205+140)*REScreenWidth/375;
        return oneCellHeight;
    } else if (indexPath.section == 1) {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *arraytwo = [NSMutableArray array];
        for (HomeVipModel *vipModel in self.homeModel.vip) {
            [array addObject:vipModel];
        }
        for (HomeVipModel *quick2Model in self.homeModel.quick2) {
            [arraytwo addObject:quick2Model];
        }
        if (array.count == 0) {
            if (arraytwo.count == 0) {
                return 145;
            }
            return 135+boyGirlImageH;
        } else {
            if (arraytwo.count==0) {
                return 188 + 140;
            }
            return 188 + 140 + boyGirlImageH;
        }
    }
    
    NSMutableArray *bookArray = [NSMutableArray array];
    NSDictionary *areaDic = [self.responseDic objectForKey:self.homeAreaArray[indexPath.section-2]];
    HomeAreaModel *areaModel = [HomeAreaModel mj_objectWithKeyValues:areaDic];
    
    for (HomeBookModel *bookModel in areaModel.book) {
        [bookArray addObject:bookModel];
    }
    if (bookArray.count <1) {
        return 0;
    } else if (bookArray.count<4) {
        return 65+173;
    } else if (bookArray.count<7) {
        return 65+2*173 + 16+8;
    } else {
        return 65+3*173 + (16+8)*2;
    }
//    else if (bookArray.count<8) {
//        return 65+2*173 + 16 + 172 +8;
//    } else if (bookArray.count<9) {
//        return 65+2*173 + 16 + 172 +8 + 172 + 8;
//    } else {
//        return 65+2*173 + 16 + 172 +8 + 172 + 8 + 172;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section <3) {
        view.backgroundColor = REWhiteColor;
    } else {
        view.backgroundColor = REBackColor;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (section < 3) {
        return 0.001;
    }
    NSMutableArray *bookArray = [NSMutableArray array];
    NSDictionary *areaDic = [self.responseDic objectForKey:self.homeAreaArray[section-2]];
    HomeAreaModel *areaModel = [HomeAreaModel mj_objectWithKeyValues:areaDic];
    
    for (HomeBookModel *bookModel in areaModel.book) {
        [bookArray addObject:bookModel];
    }

    if (bookArray.count==0) {
        return 0.01;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *backView = [UIView new];
    if (section == self.homeAreaArray.count+2-1) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 8, REScreenWidth, 52);
        view.backgroundColor = [UIColor whiteColor];
        [backView addSubview:view];
        
        NSMutableArray *lineArray = [NSMutableArray array];
        for (int i=0; i<2; i++) {
            UIView *lineView = [UIView new];
            lineView.backgroundColor = RELineColor;
            [lineArray addObject:lineView];
            [backView addSubview:lineView];
        }
        [lineArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:116 leadSpacing:76 tailSpacing:76];
        [lineArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view).offset(22);
            make.height.equalTo(@1);
        }];
        
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 12, REScreenWidth, 20);
        label.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我是有底线的" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [view addSubview:label];
    }
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.homeAreaArray.count+2-1) {
        return 60;
    }
    return 0.01;
}

#pragma mark - 网络请求--------获取版本号
- (void)requestNetworkC {
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSString *data = [NSString stringWithFormat:@"%@",response.responseObject[@"data"]];

            [RESingleton sharedRESingleton].userModel = data;
            //[self.homeTableView reloadData];
            
            [self re_loadUI];
            self.channel = @"jingxuan";
            [self searchNovel];
        } else {
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        self.requestC = nil;
        [self.homeTableView reloadData];
    }];
}

- (DefaultServerRequest *)requestC {
    if (!_requestC) {
        _requestC = [[DefaultServerRequest alloc] init];
        _requestC.requestMethod = YCRequestMethodPOST;
        _requestC.requestURI = [NSString stringWithFormat:@"%@/ucenter/editions",HomePageDomainName];
    }
    return _requestC;
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
