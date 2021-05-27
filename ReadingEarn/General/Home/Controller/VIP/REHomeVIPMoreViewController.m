//
//  REHomeVIPMoreViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeVIPMoreViewController.h"
#import "REHomeVipMoreTableViewCell.h"
#import "REEndBookNameModel.h"

@interface REHomeVIPMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) NSMutableArray *manDataList;
@property (nonatomic, strong) NSMutableArray *woManDataList;
@property (nonatomic, strong) REEndBookNameModel *manEndBookNameModel;
@property (nonatomic, strong) REEndBookNameModel *womenEndBookNameModel;
@property (nonatomic, copy) NSString *sexStr;
@end

@implementation REHomeVIPMoreViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REWhiteColor;
    [self re_loadUI];
    [self requestNetwork];
}

#pragma mark - 请求数据
- (void)requestNetwork {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //1.
        NSDictionary *manDic = [[response.responseObject objectForKey:@"data"] objectForKey:@"man"];
        REEndBookNameModel *manModel = [REEndBookNameModel mj_objectWithKeyValues:manDic];
        self.manEndBookNameModel = manModel;
        for (NSDictionary *dic in manModel.book) {
            REHomeEndModel *model = [REHomeEndModel mj_objectWithKeyValues:dic];
            [self.manDataList addObject:model];
        }

        //2.
        NSDictionary *womanDic = [[response.responseObject objectForKey:@"data"] objectForKey:@"woman"];
        REEndBookNameModel *womanModel = [REEndBookNameModel mj_objectWithKeyValues:womanDic];
        self.womenEndBookNameModel =womanModel;
        for (NSDictionary *dic in womanModel.book) {
            REHomeEndModel *model = [REHomeEndModel mj_objectWithKeyValues:dic];
            [self.woManDataList addObject:model];
        }
//        [self re_loadUI];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/get_vip_novel_first",HomePageDomainName];
    }
    return _requestA;
}

#pragma mark - 请求数据 ----------换一批
- (void)requestNetworkB {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestB = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([self.sexStr isEqualToString:@"1"]) {
            NSArray *manDic = [response.responseObject objectForKey:@"data"];
            for (NSDictionary *dic in manDic) {
                REHomeEndModel *model = [REHomeEndModel mj_objectWithKeyValues:dic];
                [self.manDataList addObject:model];
            }
            [self.typeTableView reloadData];
//            [self.typeTableView beginUpdates];
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//            [self.typeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.typeTableView endUpdates];
        } else {
            NSArray *womanDic = [response.responseObject objectForKey:@"data"];
            for (NSDictionary *dic in womanDic) {
                REHomeEndModel *model = [REHomeEndModel mj_objectWithKeyValues:dic];
                [self.woManDataList addObject:model];
            }
            [self.typeTableView reloadData];
//            [self.typeTableView beginUpdates];
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//            [self.typeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.typeTableView endUpdates];
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/novel/get_vip_novel_more",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"sex":self.sexStr
                                      };
    }
    return _requestB;
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

- (NSMutableArray *)manDataList {
    if (!_manDataList) {
        _manDataList = [NSMutableArray array];
    }
    return _manDataList;
}

- (NSMutableArray *)woManDataList {
    if (!_woManDataList) {
        _woManDataList = [NSMutableArray array];
    }
    return _woManDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *cellId = [NSString stringWithFormat:@"man%ld",(long)indexPath.row];
        REHomeVipMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REHomeVipMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId withModel:self.manDataList];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell showDataWithModel:self.manDataList];
        //点击书本阅读
        __weak typeof (self)weekself = self;
        cell.readingBookBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull book_id,NSString * _Nonnull imageStr) {
            __strong typeof (weekself)strongself = weekself;
            EReaderContainerController *vc = [EReaderContainerController new];
            vc.bookId = book_id;
            vc.imageStr = imageStr;
            [strongself.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else {
        NSString *cellId = [NSString stringWithFormat:@"woman%ld",(long)indexPath.row];
        REHomeVipMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REHomeVipMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId withModel:self.woManDataList];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          }
        [cell showDataWithModel:self.woManDataList];
        //点击书本阅读
        __weak typeof (self)weekself = self;
        cell.readingBookBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull book_id,NSString * _Nonnull imageStr) {
            __strong typeof (weekself)strongself = weekself;
            EReaderContainerController *vc = [EReaderContainerController new];
            vc.bookId = book_id;
            vc.imageStr = imageStr;
            [strongself.navigationController pushViewController:vc animated:YES];
        };

        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.manDataList.count <1) {
            return 0;
        } else if (self.manDataList.count<4) {
            return 172+12;
        } else if (self.manDataList.count<7) {
            return 12+2*172 + 16+8;
        } else {
            return 12+2*172 + 16+8+ (172+8)*(self.manDataList.count-6);
        }
    } else {
        if (self.woManDataList.count <1) {
            return 0;
        } else if (self.woManDataList.count<4) {
            return 172+12;
        } else if (self.woManDataList.count<7) {
            return 12+2*172 + 16+8;
        } else {
            return 12+2*172 + 16+8 +(172+8)*(self.woManDataList.count-6);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = REWhiteColor;
    NSString *str;
    if (section == 0) {
        str = self.manEndBookNameModel.name;
    } else {
        str = self.womenEndBookNameModel.name;
    }
    CGSize size = [ToolObject sizeWithText:str withFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    UILabel *label  = [UILabel new];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = str;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@16);
        make.width.lessThanOrEqualTo(@250);
        make.height.equalTo(@25);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    lineView.layer.cornerRadius = 2;
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@41);
        make.left.equalTo(@16);
        make.width.mas_equalTo(size.width);
        make.height.equalTo(@4);
    }];
    
    //查看更多
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.titleLabel.font = REFont(14);
    [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 100 + section;
    [moreButton setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
    [moreButton setTitle:@"换一批" forState:UIControlStateNormal];
    CGRect rect = [@"换一批" boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    [moreButton setImage:[UIImage imageNamed:@"toolbar_icon_change"] forState:UIControlStateNormal];
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -moreButton.imageView.image.size.width-2.5, 0, moreButton.imageView.image.size.width+2.5);
    moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width+2.5, 0, -rect.size.width-2.5);
    [view addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.right.mas_equalTo(-16);
        make.width.equalTo(@70);
        make.height.equalTo(@20);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        if (self.manDataList.count <1) {
            return 0;
        } else {
            return 45;
        }
    } else {
        if (self.woManDataList.count <1) {
            return 0;
        } else {
            return 45;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = REBackColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

#pragma mark - 事件
- (void)moreButtonAction:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 100) {
        self.sexStr = @"1";
        [self.manDataList removeAllObjects];
    } else {
        self.sexStr = @"2";
        [self.woManDataList removeAllObjects];
    }
    [self requestNetworkB];
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
