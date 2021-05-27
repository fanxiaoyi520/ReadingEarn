//
//  REAdvertisementViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REAdvertisementViewController.h"
#import "REAdvertisementCollectionViewCell.h"
#import "REAdvertisementModel.h"
#import "REVideoPlaybackViewController.h"

@interface REAdvertisementViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *adCollectionView;
@property (nonatomic, strong) NSMutableArray *adDataList;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@end

@implementation REAdvertisementViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageCount = 1;
    [self re_loadUI];
    [self requestNetworking];
}

#pragma mark - 网络请求
- (void)requestNetworking {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        })
        self.requestA = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = [response.responseObject objectForKey:@"data"];
        for (NSDictionary *dic in array) {
            REAdvertisementModel *model = [REAdvertisementModel mj_objectWithKeyValues:dic];
            [self.adDataList addObject:model];
        }
        
        [self.adCollectionView reloadData];
        [self.adCollectionView.mj_footer endRefreshing];
        if (array.count < 10) {
            [self.adCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageCount];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodGET;
        _requestA.requestSerializer = [AFJSONRequestSerializer serializer];
        _requestA.requestURI = [NSString stringWithFormat:@"%@/play/play_list",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"page":page,
                                       @"limit":@"10"
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    
    layout.itemSize = CGSizeMake((REScreenWidth-4*3)/2, ((REScreenWidth-4*3)/2)*272/181.5);
    layout.sectionInset = UIEdgeInsetsMake(4, 4 ,4, 4);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    self.adCollectionView = collectionView;
    self.adCollectionView.delegate = self;
    self.adCollectionView.dataSource = self;
    self.adCollectionView.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
    [self.adCollectionView registerClass:[REAdvertisementCollectionViewCell class]
               forCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID"];
    [self.view addSubview:collectionView];
    
    __weak typeof(self) myweakSelf = self;
    self.adCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageCount++;
        [myweakSelf requestNetworking];
    }];
}

- (NSMutableArray *)adDataList {
    if (!_adDataList) {
        _adDataList = [NSMutableArray new];
    }
    return _adDataList;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.adDataList.count;
}

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     //创建item / 从缓存池中拿 Item
     REAdvertisementCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID" forIndexPath:indexPath];
     cell.backgroundColor = REWhiteColor;
     cell.layer.shadowColor = [UIColor colorWithRed:204/255.0 green:206/255.0 blue:209/255.0 alpha:0.30].CGColor;
     cell.layer.shadowOffset = CGSizeMake(0,2);
     cell.layer.shadowRadius = 8;
     cell.layer.shadowOpacity = 1;
     cell.layer.cornerRadius = 16;

     if(self.adDataList.count > 0){
         REAdvertisementModel *advertisementModel = self.adDataList[indexPath.item];
         [cell showDataWithModel:advertisementModel];
     }
     return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    //do something ...
    REAdvertisementModel *advertisementModel = self.adDataList[indexPath.item];
    REVideoPlaybackViewController *vc = [REVideoPlaybackViewController new];
    vc.advertisementModel = advertisementModel;
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
