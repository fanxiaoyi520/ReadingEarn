//
//  REHomeEndViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeEndViewController.h"
#import "REAreaTableViewCell.h"
#import "REEndBookNameModel.h"
#import "REHomeEndModel.h"
#import "REHomeEndTableViewCell.h"
#import "REMoreEndViewController.h"
#import "REHomeFreeViewController.h"

@interface REHomeEndViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) NSMutableArray *manDataList;
@property (nonatomic, strong) NSMutableArray *woManDataList;
@property (nonatomic, strong) REEndBookNameModel *manEndBookNameModel;
@property (nonatomic, strong) REEndBookNameModel *womenEndBookNameModel;
@property (nonatomic, copy) NSString *type;
@end

@implementation REHomeEndViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REWhiteColor;
    if ([self.naviTitle isEqualToString:@"完结"]) {
        self.type = @"/novel/get_over_novel";
    } else if ([self.naviTitle isEqualToString:@"热门书籍"]){
        //热门最新
        self.type = @"/novel/get_area_first";
    } else if ([self.naviTitle isEqualToString:@"最新书籍"]){
        //热门最新
        self.type = @"/novel/get_area_first";
    } else if ([self.naviTitle isEqualToString:@"热血小说"]){
        //热血甜美
        self.type = @"/novel/get_area_first";
    } else if ([self.naviTitle isEqualToString:@"甜美爱恋"]){
        //热血甜美
        self.type = @"/novel/get_area_first";
    }
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@%@",HomePageDomainName,self.type];
        if ([self.naviTitle isEqualToString:@"完结"]) {
        } else if ([self.naviTitle isEqualToString:@"热门书籍"]){
        _requestA.requestParameter = @{
                                       @"nid":@"remenshuji",
                                      };
        } else if ([self.naviTitle isEqualToString:@"最新书籍"]){
        _requestA.requestParameter = @{
                                       @"nid":@"jingxuanzuixin",
                                      };
        } else if ([self.naviTitle isEqualToString:@"热血小说"]){
        _requestA.requestParameter = @{
                                       @"nid":@"rexuexiaoshuo",
                                      };
        } else if ([self.naviTitle isEqualToString:@"甜美爱恋"]){
        _requestA.requestParameter = @{
                                       @"nid":@"tianmeiailian",
                                      };
        }
    }
    return _requestA;
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
    NSString *cellId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    REHomeEndTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[REHomeEndTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId withModel:self.manDataList];
        } else {
            cell = [[REHomeEndTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId withModel:self.woManDataList];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        [cell showDataWithModel:self.manDataList];
    } else {
        [cell showDataWithModel:self.woManDataList];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger arrCount;
    if (indexPath.section == 0) {
        arrCount = self.manDataList.count;
    } else {
        arrCount = self.woManDataList.count;
    }
    
    if (arrCount <1) {
        return 0;
    } else if (arrCount<4) {
        return 172+12;
    } else if (arrCount<7) {
        return 12+2*172 + 16+8;
    } else if (arrCount<8) {
        return 12+2*172 + 16 + 172 +8;
    } else if (arrCount<9) {
        return 12+2*172 + 16 + 172 +8 + 172 + 8;
    }
    return 12+2*172 + 16 + 172 +8 + 172 + 8 + 172;
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
    [moreButton setTitle:@"查看更多 >" forState:UIControlStateNormal];
    [view addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.right.mas_equalTo(-16);
        make.width.equalTo(@70);
        make.height.equalTo(@20);
    }];
    if (section==0) {
        objc_setAssociatedObject(moreButton,"sex", @"1", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(moreButton,"sex", @"2", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
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
    if ([self.naviTitle isEqualToString:@"完结"]) {
        REMoreEndViewController *vc = [REMoreEndViewController new];
        if (sender.tag == 100) {
            vc.sexStr = @"1";
        } else {
            vc.sexStr = @"2";
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.naviTitle isEqualToString:@"热门书籍"]){
        NSString *sex = objc_getAssociatedObject(sender,"sex");
        REHomeFreeViewController *vc = [REHomeFreeViewController new];
        vc.naviTitle = @"热门书籍";
        vc.sex = sex;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.naviTitle isEqualToString:@"最新书籍"]){
        NSString *sex = objc_getAssociatedObject(sender,"sex");
        REHomeFreeViewController *vc = [REHomeFreeViewController new];
        vc.naviTitle = @"最新书籍";
        vc.sex = sex;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.naviTitle isEqualToString:@"热血小说"]){
        NSString *sex = objc_getAssociatedObject(sender,"sex");
        REHomeFreeViewController *vc = [REHomeFreeViewController new];
        vc.naviTitle = @"热血小说";
        vc.sex = sex;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.naviTitle isEqualToString:@"甜美爱恋"]){
        NSString *sex = objc_getAssociatedObject(sender,"sex");
        REHomeFreeViewController *vc = [REHomeFreeViewController new];
        vc.naviTitle = @"甜美爱恋";
        vc.sex = sex;
        [self.navigationController pushViewController:vc animated:YES];
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
