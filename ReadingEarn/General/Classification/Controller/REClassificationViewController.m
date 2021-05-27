//
//  REClassificationViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REClassificationViewController.h"
#import "ClassModel.h"
#import "REClassCollectionViewCell.h"
#import "REBookTypeViewController.h"

@interface REClassificationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong)UIScrollView *classScrollView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UICollectionView *manCollectionView;
@property (nonatomic, assign) NSInteger requestCount;

@end

@implementation REClassificationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
        forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.clipsToBounds = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.requestCount = 0;
    self.dataList = [NSMutableArray array];
    NSArray *array = @[@"男频",@"女频"];
    [self navigationBarButtonToggleArray:array leftMargin:(REScreenWidth -36*2-40)/2 topMargin:9 buttonWidth:36 buttonHeight:25];
    self.channel = @"man";
    //[self re_loadUI];
    [self searchNovel];
}

#pragma mark - 导航栏切换点击
- (void)navButtonAction:(UIButton *)sender {
    [super navButtonAction:sender];
    if (sender.tag == 100) {
        self.channel = @"man";
        [self searchNovel];
    } else {
        self.channel = @"woman";
        [self searchNovel];
    }
}

#pragma mark - 网络请求
- (void)searchNovel {
    self.requestCount++;
    
    [self.dataList removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        NSArray *array = [response.responseObject objectForKey:@"data"];
        for (NSDictionary *dic in array) {
            ClassModel *classModel = [ClassModel mj_objectWithKeyValues:dic];
            [self.dataList addObject:classModel];
        }
        if (self.requestCount==1) {
            [self re_loadUI];
        } else {
            [self.manCollectionView reloadData];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - getter
- (DefaultServerRequest *)requestA {
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/get_novel_type",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"channel":self.channel,
                                       @"token":@""
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    [self classScrollView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 12;
    layout.itemSize = CGSizeMake((REScreenWidth-2*16-15)/2, (((REScreenWidth-2*16-15)/2) * 92)/164);
    layout.sectionInset = UIEdgeInsetsMake(12, 16 ,12, 16);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    self.manCollectionView = collectionView;
    self.manCollectionView.delegate = self;
    self.manCollectionView.dataSource = self;
    self.manCollectionView.frame = CGRectMake(0, 0, REScreenWidth, self.classScrollView.frame.size.height);
    [self.manCollectionView registerClass:[REClassCollectionViewCell class]
               forCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID"];
    [self.classScrollView addSubview:collectionView];
}

- (UIScrollView *)classScrollView {
    if (!_classScrollView) {
        _classScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RENavigationHeight, REScreenWidth, REScreenHeight-RETabBarHeight-RENavigationHeight)];
        _classScrollView.backgroundColor = REBackColor;
        _classScrollView.contentSize = CGSizeMake(2*REScreenWidth, REScreenHeight-RETabBarHeight-RENavigationHeight);
        _classScrollView.showsHorizontalScrollIndicator = NO;
        _classScrollView.showsVerticalScrollIndicator = NO;
        _classScrollView.bounces = YES;
        _classScrollView.pagingEnabled = YES;
        [self.view addSubview:_classScrollView];
    }
    return _classScrollView;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     //创建item / 从缓存池中拿 Item
     REClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID" forIndexPath:indexPath];
     cell.backgroundColor = REWhiteColor;
     cell.layer.shadowColor = [UIColor colorWithRed:204/255.0 green:206/255.0 blue:209/255.0 alpha:0.30].CGColor;
     cell.layer.shadowOffset = CGSizeMake(0,2);
     cell.layer.shadowRadius = 8;
     cell.layer.shadowOpacity = 1;
     cell.layer.cornerRadius = 16;

     if(self.dataList.count > 0){
         ClassModel *calssModel = self.dataList[indexPath.item];
         [cell showClassWithModel:calssModel];
     }
     return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {      [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    //do something ...
    NSLog(@"indexPath:%ld",(long)indexPath.row);
    REBookTypeViewController *vc = [REBookTypeViewController new];
    ClassModel *classModel = self.dataList[indexPath.row];
    vc.naviTitle = classModel.name;
    vc.classModel = classModel;
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
