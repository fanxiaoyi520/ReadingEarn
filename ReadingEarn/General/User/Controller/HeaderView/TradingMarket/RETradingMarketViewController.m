//
//  RETradingMarketViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RETradingMarketViewController.h"
#import "RETradingMarketCollectionReusableView.h"
#import "RETradingMarketModel.h"
#import "REBuyCoinsViewController.h"
#import "REMyOrderViewController.h"
#import "REPublishAdViewController.h"
#import "REMyAdViewController.h"

@interface RETradingMarketViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong)UICollectionView *tradingMarketCollectionView;
@property (nonatomic ,strong)NSArray *tradingMarketDataList;
@property (nonatomic ,strong)NSArray *tradingMarketImageDataList;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) RETradingMarketModel *tradingMarketModel;
@end

@implementation RETradingMarketViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tradingMarketDataList = [[RESingleton sharedRESingleton] tradingMarketTitleArray];
    self.tradingMarketImageDataList = [[RESingleton sharedRESingleton] tradingMarketImageArray];
    
    [self re_loadUI];
    [self requestNetwork];
}

#pragma mark - 网络请求--------交易市场
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
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            RETradingMarketModel *model = [RETradingMarketModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.tradingMarketModel = model;
            
            [self.tradingMarketCollectionView reloadData];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/otc_total",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    //交易市场
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 11;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake((REScreenWidth-2*16-11)/2, ratioH(76));
    layout.sectionInset = UIEdgeInsetsMake(0, 16 ,20, 11);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize =CGSizeMake(REScreenWidth,188);//头视图大小
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    self.tradingMarketCollectionView = collectionView;
    self.tradingMarketCollectionView.delegate = self;
    self.tradingMarketCollectionView.dataSource = self;
    self.tradingMarketCollectionView.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
    [self.tradingMarketCollectionView registerClass:[UICollectionViewCell class]
               forCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID"];
    [self.tradingMarketCollectionView registerClass:[RETradingMarketCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:collectionView];

}

- (NSArray *)tradingMarketDataList {
    if (!_tradingMarketDataList) {
        _tradingMarketDataList = [[NSArray alloc] init];
    }
    return _tradingMarketDataList;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tradingMarketDataList.count;
}

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     //创建item / 从缓存池中拿 Item
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID" forIndexPath:indexPath];
     cell.backgroundColor = REWhiteColor;
     
     UIImageView *imageView = [UIImageView new];
     [cell.contentView addSubview:imageView];
     imageView.frame = CGRectMake(0, 0, cell.width, cell.height);
     imageView.image = REImageName(self.tradingMarketImageDataList[indexPath.item]);
     imageView.layer.shadowColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.20].CGColor;
     imageView.layer.shadowOffset = CGSizeMake(0,2);
     imageView.layer.shadowRadius = 10;
     imageView.layer.shadowOpacity = 1;
     imageView.layer.cornerRadius = 16;
     
     UILabel *label = [UILabel new];
     [cell.contentView addSubview:label];
     NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.tradingMarketDataList[indexPath.item] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16], NSForegroundColorAttributeName: [UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1.0]}];
     label.attributedText = string;
     label.textAlignment = NSTextAlignmentLeft;
     label.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1.0];
     label.frame = CGRectMake(74, ratioH(27), cell.width-74, ratioH(22));
     return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    RETradingMarketCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    [header showDataWithModel:self.tradingMarketModel];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        REBuyCoinsViewController *vc = [REBuyCoinsViewController new];
        vc.naviTitle = self.tradingMarketDataList[indexPath.item];
        vc.type = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.item == 1) {
        REBuyCoinsViewController *vc = [REBuyCoinsViewController new];
        vc.naviTitle = self.tradingMarketDataList[indexPath.item];
        vc.type = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.item == 2) {
        REMyOrderViewController *vc = [REMyOrderViewController new];
        vc.naviTitle = self.tradingMarketDataList[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.item == 3) {
       REPublishAdViewController *vc = [REPublishAdViewController new];
        __weak typeof (self)weekself = self;
        vc.releaseAdBlock = ^(NSString * _Nonnull msg) {
            __strong typeof (weekself)strongself = weekself;
            [strongself showAlertMsg:msg Duration:2];
        };
       [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.item == 4) {
       REMyAdViewController *vc = [REMyAdViewController new];
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
