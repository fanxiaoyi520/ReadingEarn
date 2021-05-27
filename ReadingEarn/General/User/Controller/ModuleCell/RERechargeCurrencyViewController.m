//
//  RERechargeCurrencyViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERechargeCurrencyViewController.h"
#import "RERechargeCurrencyModel.h"
#import "RERechangeCurrencyCollectionViewCell.h"
#import "RERechangeCurrencyCollectionReusableView.h"
@interface RERechargeCurrencyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong)UICollectionView *chargeCurrencyCollectionView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) RERechargeCurrencyModel *rechargeCurrencyModel;
@property (nonatomic, strong)REReadingEarnPopupView *popView;
@property (nonatomic, copy)NSString *paypwd;
@property (nonatomic, copy)NSString *type_id;

@end

@implementation RERechargeCurrencyViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self re_loadUI];
    [self requestNetwork];
}

#pragma mark - 网络请求--------充值阅币
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
        if ([code isEqualToString:@"1"]) {
            RERechargeCurrencyModel *model = [RERechargeCurrencyModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.rechargeCurrencyModel = model;
           
            [self.chargeCurrencyCollectionView reloadData];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

#pragma mark - 网络请求--------支付
- (void)requestNetworkPay {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"1"]) {
            
            [self.popView closeThePopupView];
            [self showAlertMsg:msg Duration:2];
            [self requestNetwork];
        } else {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/wallet/read_buy_do",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"id":self.type_id,
                                       @"paypwd":self.paypwd,
                                      };
    }
    return _requestB;
}

- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/wallet/read_buy_first",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    //1.我的书架
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 12;
    layout.itemSize = CGSizeMake((REScreenWidth-2*16-15)/2, (((REScreenWidth-2*16-15)/2) * 124)/166);
    layout.sectionInset = UIEdgeInsetsMake(12, 16 ,12, 16);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize =CGSizeMake(REScreenWidth,362);//头视图大小
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    self.chargeCurrencyCollectionView = collectionView;
    self.chargeCurrencyCollectionView.delegate = self;
    self.chargeCurrencyCollectionView.dataSource = self;
    self.chargeCurrencyCollectionView.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
    [self.chargeCurrencyCollectionView registerClass:[RERechangeCurrencyCollectionViewCell class]
               forCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID"];
    [self.chargeCurrencyCollectionView registerClass:[RERechangeCurrencyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rechargeCurrencyModel.chargeType.count;
}

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     //创建item / 从缓存池中拿 Item
     RERechangeCurrencyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID" forIndexPath:indexPath];
     cell.layer.cornerRadius = 8;
     
     __weak typeof (self)weekself = self;
     cell.moneyYDCBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull type_id) {
         __strong typeof (weekself)strongself = weekself;
         self.type_id = type_id;
         REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
         [popView showPopupViewWithData:@""];
         self.popView = popView;
         popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
             if (text.length < 6) {
                 [strongself showAlertMsg:@"密码错误" Duration:2];
             } else {
                  self.paypwd = text;
                 [strongself requestNetworkPay];
             }
         };

     };
     [cell showDataWithModel:self.rechargeCurrencyModel.chargeType[indexPath.item]];
     
     return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    RERechangeCurrencyCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    
    [header showDataWithModel:self.rechargeCurrencyModel];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
