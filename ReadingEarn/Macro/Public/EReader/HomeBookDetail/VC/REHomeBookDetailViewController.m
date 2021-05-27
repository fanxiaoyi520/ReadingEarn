//
//  REHomeBookDetailViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeBookDetailViewController.h"
#import "REBookDetailSectionOneTableViewCell.h"
#import "REBookDetailSectionTwoTableViewCell.h"
#import "REBookDetailSectionThreeTableViewCell.h"
#import "REBookDetailSectionFourTableViewCell.h"
#import "REBookDetailSectionFiveTableViewCell.h"
#import "REAllDirectoriesViewController.h"
#import "REMorePlayRewardViewController.h"
#import "RECollectionModel.h"
#import "REDynamicModel.h"
#import "RENovelInfoModel.h"
#import "RECommentViewController.h"
#import "RECommentListViewController.h"

@interface REHomeBookDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *bookDetailTableView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, strong) DefaultServerRequest *requestJionBookShelf;
@property (nonatomic, strong) DefaultServerRequest *requestJionPlayReward;
@property (nonatomic, strong) DefaultServerRequest *requestDianZan;
@property (nonatomic, strong) DefaultServerRequest *requestAnotherChange;
@property (nonatomic, strong) RECollectionModel *collectionModel;
@property (nonatomic, strong) REDynamicModel *dynamicModel;
@property (nonatomic, strong) RENovelInfoModel *novelInfoModel;
@property (nonatomic, strong) NSString *exc_id;

@property (nonatomic, copy) NSString *joinBookShelfStr;
@property (nonatomic, copy) NSString *playrewardStr;
@property (nonatomic, copy) NSString *replyStr;
@property (nonatomic, copy) NSString *dianzanStr;
@property (nonatomic, copy) NSString *anotherChangeStr;
@property (nonatomic, copy) NSString *content_id;
@property (nonatomic, strong) NSIndexPath *myIndexPath;
@property (nonatomic, copy) NSString *is_Collection;
@end

@implementation REHomeBookDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REWhiteColor;
    self.naviTitle = @"小说主页";
    
    self.joinBookShelfStr = @"0";
    self.playrewardStr = @"0";
    self.replyStr = @"0";
    self.dianzanStr = @"0";
    self.anotherChangeStr = @"0";
    [self re_loadUI];
    [self requestNetWrokA];
}

#pragma mark - 请求数据 ----------A
- (void)requestNetWrokA {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        RENovelInfoModel *model = [RENovelInfoModel mj_objectWithKeyValues:response.responseObject[@"data"]];
        self.novelInfoModel = model;
        
        if ([self.joinBookShelfStr isEqualToString:@"0"]) {
            [self requestNetWrokB];
        } else {
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.bookDetailTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        if (![self.anotherChangeStr isEqualToString:@"0"]) {
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
            [self.bookDetailTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/novel_info",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"book_id":self.book_id,
                                       @"token":token,
                                      };
    }
    return _requestA;
}

#pragma mark - 请求数据 ----------B
- (void)requestNetWrokB {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        REDynamicModel *model = [REDynamicModel mj_objectWithKeyValues:response.responseObject[@"data"]];
        self.dynamicModel = model;
        if ([self.playrewardStr isEqualToString:@"0"]) {
            [self requestNetWrokC];
        } else {
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [self.bookDetailTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        if (![self.replyStr isEqualToString:@"0"]) {
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [self.bookDetailTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (![self.dianzanStr isEqualToString:@"0"]) {
            [self.bookDetailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.myIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/novel/novel_info_dynamic",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"book_id":self.book_id,
                                       @"token":token,
                                      };
    }
    return _requestB;
}

#pragma mark - 请求数据 ----------C
- (void)requestNetWrokC {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        self.requestC = nil;
        RECollectionModel *model = [RECollectionModel mj_objectWithKeyValues:response.responseObject];
        self.collectionModel = model;
        self.is_Collection = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        [self.bookDetailTableView reloadData];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
    }];

}

- (DefaultServerRequest *)requestC {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestC) {
        _requestC = [[DefaultServerRequest alloc] init];
        _requestC.requestMethod = YCRequestMethodGET;
        _requestC.requestURI = [NSString stringWithFormat:@"%@/novel/get_collection",HomePageDomainName];
        _requestC.requestParameter = @{
                                       @"bookid":self.book_id,
                                       @"token":token,
                                      };
    }
    return _requestC;
}

#pragma mark - 请求数据 ----------加入书架
- (void)requestNetWrokJionBookShelf {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestJionBookShelf startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        self.joinBookShelfStr = @"1";
        [self requestNetWrokC];
        [self showAlertMsg:msg Duration:2];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestJionBookShelf = nil;
    }];

}

- (DefaultServerRequest *)requestJionBookShelf {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestJionBookShelf) {
        _requestJionBookShelf = [[DefaultServerRequest alloc] init];
        _requestJionBookShelf.requestMethod = YCRequestMethodGET;
        _requestJionBookShelf.requestURI = [NSString stringWithFormat:@"%@/collect/add_collect",HomePageDomainName];
        _requestJionBookShelf.requestParameter = @{
                                       @"book_id":self.book_id,
                                       @"token":token,
                                      };
    }
    return _requestJionBookShelf;
}

#pragma mark - 请求数据 ----------打赏
- (void)requestNetWrokJionPlayReward {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestJionPlayReward startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        self.playrewardStr = @"1";
        [self requestNetWrokB];
        [self showAlertMsg:msg Duration:2];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestJionPlayReward = nil;
    }];

}

- (DefaultServerRequest *)requestJionPlayReward {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestJionPlayReward) {
        _requestJionPlayReward = [[DefaultServerRequest alloc] init];
        _requestJionPlayReward.requestMethod = YCRequestMethodPOST;
        _requestJionPlayReward.requestURI = [NSString stringWithFormat:@"%@/novel/reward_in",HomePageDomainName];
        _requestJionPlayReward.requestParameter = @{
                                       @"book_id":self.book_id,
                                       @"token":token,
                                       @"exc_id":self.exc_id
                                      };
    }
    return _requestJionPlayReward;
}

#pragma mark - 请求数据 ----------点赞
- (void)requestNetWrokDianZan {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestDianZan startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestDianZan = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestNetWrokB];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestDianZan = nil;
    }];

}

- (DefaultServerRequest *)requestDianZan {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestDianZan) {
        _requestDianZan = [[DefaultServerRequest alloc] init];
        _requestDianZan.requestMethod = YCRequestMethodPOST;
        _requestDianZan.requestURI = [NSString stringWithFormat:@"%@/novel/add_like",HomePageDomainName];
        _requestDianZan.requestParameter = @{
                                       @"comments_id":self.content_id,
                                       @"token":token,
                                      };
    }
    return _requestDianZan;
}

#pragma mark - 请求数据 ----------换一换
- (void)requestNetWrokAnotherChange {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestAnotherChange startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestAnotherChange = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestNetWrokA];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestAnotherChange = nil;
    }];

}

- (DefaultServerRequest *)requestAnotherChange {
//    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestAnotherChange) {
        _requestAnotherChange = [[DefaultServerRequest alloc] init];
        _requestAnotherChange.requestMethod = YCRequestMethodPOST;
        _requestAnotherChange.requestURI = [NSString stringWithFormat:@"%@/novel/guess",HomePageDomainName];
    }
    return _requestAnotherChange;
}


#pragma mark - 加载UI
- (void)re_loadUI {
    [self bookDetailTableView];
}

- (UITableView *)bookDetailTableView {
    if (!_bookDetailTableView) {
        _bookDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight+REStatusHeight, REScreenWidth, REScreenHeight-NavBarHeight-REStatusHeight) style:UITableViewStyleGrouped];
        _bookDetailTableView.delegate = self;
        _bookDetailTableView.backgroundColor = REBackColor;
        _bookDetailTableView.dataSource = self;
        [self.view addSubview:_bookDetailTableView];
    }
    return _bookDetailTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    } else if (section == 3) {
        if (self.dynamicModel.comments.list.count <1) {
            return 1;
        } else {
            return self.dynamicModel.comments.list.count;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *cellID = [NSString stringWithFormat:@"one%ld",(long)indexPath.row];
        REBookDetailSectionOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REBookDetailSectionOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //1.开始阅读
            __weak typeof (self)weekself = self;
            cell.startReadBlock = ^(UIButton * _Nonnull sender) {
                __strong typeof (weekself)strongself = weekself;
                [strongself.navigationController popViewControllerAnimated:YES];
//                EReaderContainerController *vc = [EReaderContainerController new];
//                vc.bookId = strongself.book_id;
//                [strongself.navigationController pushViewController:vc animated:YES];
            };
            //2.加入书架
            cell.jionBookShelfBlock = ^(UIButton * _Nonnull sender) {
                __strong typeof (weekself)strongself = weekself;
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"喜欢就加入书架吧?"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          //响应事件
                                                                          NSLog(@"action = %@", action);
                    [self requestNetWrokJionBookShelf];
                                                                      }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          //响应事件
                                                                          NSLog(@"action = %@", action);
                                                                      }];

                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [strongself presentViewController:alert animated:YES completion:nil];
            };
            
        }
        [cell showDataWithModel:self.novelInfoModel.bookInfo withStr:self.is_Collection];
        return cell;
    } else if (indexPath.section == 1) {
        NSString *cellID = [NSString stringWithFormat:@"two%ld",(long)indexPath.row];
        REBookDetailSectionTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REBookDetailSectionTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell showDataWithModel:self.novelInfoModel.bookList[indexPath.row] withnewInfoModel:self.novelInfoModel.mynewInfoModel withIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
       NSString *cellID = [NSString stringWithFormat:@"three%ld",(long)indexPath.row];
       REBookDetailSectionThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
       tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       if (!cell) {
           cell = [[REBookDetailSectionThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
           __weak typeof (self)weekself = self;
           cell.morePalyRewardBlock = ^(UIButton * _Nonnull sender) {
               __strong typeof (weekself)strongself = self;
               REMorePlayRewardViewController *vc = [REMorePlayRewardViewController new];
               vc.naviTitle = @"打赏记录";
               vc.book_id = self.book_id;
               [strongself.navigationController pushViewController:vc animated:YES];
           };
       }
       [cell showDataWithModel:self.dynamicModel.graInfo];
       return cell;
    } else if (indexPath.section == 3) {
       NSString *cellID = [NSString stringWithFormat:@"four%ld",(long)indexPath.row];
       REBookDetailSectionFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
       tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       if (!cell) {
           cell = [[REBookDetailSectionFourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
           __weak typeof (self)weekself = self;
           cell.dianzanBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull content_id,UITableViewCell *_Nonnull mycell) {
               __strong typeof (weekself)strongself = self;
               self.myIndexPath = [tableView indexPathForCell:mycell];
               self.dianzanStr = @"1";
               strongself.content_id = content_id;
               [strongself requestNetWrokDianZan];
           };
           
           cell.replyBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull content_id,UITableViewCell *_Nonnull mycell) {
               __strong typeof (weekself)strongself = self;
               RECommentViewController *vc = [RECommentViewController new];
               vc.naviTitle = @"回复";
               vc.book_id = self.book_id;
               vc.contents_id = content_id;
               //返回回调
               vc.backBlock = ^(NSString * _Nonnull book_id) {
                  strongself.replyStr = @"1";
                   strongself.book_id = book_id;
                  [strongself requestNetWrokB];
               };

               [strongself.navigationController pushViewController:vc animated:YES];
           };
       }
        
        if (self.dynamicModel.comments.list.count >0) {
            [cell showDataWithModel:self.dynamicModel.comments.list[indexPath.row]];
        } else {
            [cell showDataWithModel];
        }
       return cell;
    } else if (indexPath.section == 4) {
          NSString *cellID = [NSString stringWithFormat:@"five%ld",(long)indexPath.row];
          REBookDetailSectionFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
          tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
          if (!cell) {
              cell = [[REBookDetailSectionFiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              
              __weak typeof (self)weekself = self;
              cell.btnClickBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull book_id,NSString * _Nonnull imageStr) {
                  __strong typeof (weekself)strongself = weekself;
                  EReaderContainerController *vc = [EReaderContainerController new];
                  vc.bookId = book_id;
                  vc.imageStr = imageStr;
                  [strongself.navigationController pushViewController:vc animated:YES];
              };
          }
        [cell showDataWithModel:self.novelInfoModel.likeList];
        return cell;
       }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (!self.novelInfoModel.bookInfo.contents || [self.novelInfoModel.bookInfo.contents isEqualToString:@""]) {
            return  222;
        }
        NSString *detailStr = self.novelInfoModel.bookInfo.contents;
        detailStr = [detailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        detailStr = [detailStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        CGSize detailStrSize = [ToolObject textHeightFromTextString:detailStr width:REScreenWidth-36 fontSize:14];
        CGFloat rate = 21;//每行需要的高度
        if (detailStrSize.height>rate*3) {
            detailStrSize.height = rate*3;
        }
        return 222 + 44 + detailStrSize.height;
    } else if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 2) {
        //242 没有数据
        if (self.dynamicModel.graInfo.count <0) {
            return 242-45;
        }
        return 213-45;
    } else if (indexPath.section == 3) {
        if (self.dynamicModel.comments.list.count<1) {
            return 242-45;
        } else {
            
            RECommentsListModel *model = self.dynamicModel.comments.list[indexPath.row];
            CGSize contentsize = [ToolObject textHeightFromTextString:model.content width:200 fontSize:14];
            CGFloat rowH = 96+contentsize.height+model.sons.count*36+12;
            return rowH;
        }
    }
    if (self.novelInfoModel.likeList.count <3) {
        return 12+(173+12);
    }
    return 12+(173+12)*2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = REWhiteColor;
    if (section > 0) {
        //1.
        NSArray *titleArray = @[@"目录",@"打赏记录",@"评论",@"猜你喜欢"];
        CGSize size = [ToolObject sizeWithText:titleArray[section-1] withFont:REFont(18)];
        UILabel *titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:titleLabel];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleArray[section-1] attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        titleLabel.attributedText = string;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@18);
            make.height.equalTo(@25);
        }];

        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
        lineView.layer.cornerRadius = 2;
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@45);
            make.left.equalTo(@18);
            make.height.equalTo(@4);
            make.width.mas_equalTo(size.width);
        }];
        
        //2.
        UILabel *rewardRecordLabel = [UILabel new];
        rewardRecordLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        if (section == 2) {
            if (!self.dynamicModel) {
                return nil;
            }
            NSString *reward = [NSString stringWithFormat:@"(收到打赏%@币)",self.dynamicModel.graTotal];
            NSMutableAttributedString *rewardRecordLabelstring = [[NSMutableAttributedString alloc] initWithString:reward attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
            rewardRecordLabel.attributedText = rewardRecordLabelstring;
            [view addSubview:rewardRecordLabel];
            [rewardRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@21);
                make.left.mas_equalTo(@98);
                make.width.lessThanOrEqualTo(@150);
                make.height.equalTo(@17);
            }];
        }
        if (section == 3) {
            if (!self.dynamicModel.comments) {
                return nil;
            }
            NSString *reward = [NSString stringWithFormat:@"(%@条评论)",self.dynamicModel.comments.total];
            NSMutableAttributedString *rewardRecordLabelstring = [[NSMutableAttributedString alloc] initWithString:reward attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
            rewardRecordLabel.attributedText = rewardRecordLabelstring;

            [view addSubview:rewardRecordLabel];
            [rewardRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@21);
                make.left.mas_equalTo(@62);
                make.width.lessThanOrEqualTo(@150);
                make.height.equalTo(@17);
            }];
        }
        
        //3.
        NSArray *btnArray = @[@"我要打赏",@"我要评论"];
        UIButton *secButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [secButton addTarget:self action:@selector(secButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        secButton.tag = 100+section;
        secButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor;
        secButton.layer.borderWidth = 1;
        secButton.layer.cornerRadius = 16;
        [secButton setTitleColor:[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0] forState:UIControlStateNormal];
        secButton.titleLabel.font = REFont(14);
        if (section >= 2 && section < 4) {
            [secButton setTitle:btnArray[section-2] forState:UIControlStateNormal];
            [view addSubview:secButton];
            [secButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@16);
                make.right.mas_equalTo(-16);
                make.height.equalTo(@28);
                make.width.equalTo(@72);
            }];
        }
        
        //4.
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeButton setTitle:@"换一批" forState:UIControlStateNormal];
        CGRect rect = [@"换一批" boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
        [changeButton setImage:[UIImage imageNamed:@"toolbar_icon_change"] forState:UIControlStateNormal];
        changeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -changeButton.imageView.image.size.width-2.5, 0, changeButton.imageView.image.size.width+2.5);
        changeButton.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width+2.5, 0, -rect.size.width-2.5);
        changeButton.titleLabel.font = REFont(14);
        [changeButton setTitleColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(secButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        changeButton.tag = 100+section;
        if (section == 4) {
            [view addSubview:changeButton];
            [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@16);
                make.right.mas_equalTo(-16);
                make.height.equalTo(@28);
                make.width.equalTo(@72);
            }];
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 57;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == 1) {
        UIView *btnBackView = [UIView new];
        btnBackView.frame = CGRectMake(0, 0, REScreenWidth, 72);
        btnBackView.backgroundColor = REWhiteColor;
        [view addSubview:btnBackView];
        
        UIButton *allDirectoriesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [allDirectoriesButton addTarget:self action:@selector(allDirectoriesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        allDirectoriesButton.layer.borderColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor;
        allDirectoriesButton.layer.borderWidth = 1;
        allDirectoriesButton.layer.cornerRadius = 20;
        allDirectoriesButton.titleLabel.font = REFont(16);
        [allDirectoriesButton setTitle:@"全部目录" forState:UIControlStateNormal];
        [allDirectoriesButton setTitleColor:[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0] forState:UIControlStateNormal];
        [view addSubview:allDirectoriesButton];
        [allDirectoriesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.left.equalTo(@18);
            make.right.mas_equalTo(-18);
            make.height.equalTo(@40);
        }];
    } else if (section == 3) {
        if (self.dynamicModel.comments.list.count >0) {
            UIView *btnBackView = [UIView new];
            btnBackView.frame = CGRectMake(0, 0, REScreenWidth, 34);
            btnBackView.backgroundColor = REWhiteColor;
            [view addSubview:btnBackView];

            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            moreButton.frame = CGRectMake(0, 0, REScreenWidth, 34);
            moreButton.titleLabel.font = REFont(14);
            [moreButton setTitleColor:REColor(153, 153, 153) forState:UIControlStateNormal];
            [moreButton setTitle:@"更多评论 >" forState:UIControlStateNormal];
            [btnBackView addSubview:moreButton];

        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 80;
    } else if (section == 3) {
        if (self.dynamicModel.comments.list.count >0) {
            return 42;
        }
    }
    
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        REBookListModel *model = self.novelInfoModel.bookList[indexPath.row];
        if (indexPath.row == 0) {
            EReaderContainerController *vc = [EReaderContainerController new];
            vc.bookId = model.book_id;
            vc.imageStr = self.imageStr;
            vc.chapter_number = self.novelInfoModel.mynewInfoModel.chapter_number;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            EReaderContainerController *vc = [EReaderContainerController new];
            vc.bookId = model.book_id;
            vc.imageStr = self.imageStr;
            vc.chapter_number = model.chapter_number;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 事件
- (void)secButtonAction:(UIButton *)sender {
    if (sender.tag == 102) {
        REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:3];
        [popView showPopupViewWithData:self.dynamicModel.graType];
        
        __weak typeof (self)weekself = self;
        popView.graTypeBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull gratype_idStr) {
            __strong typeof (weekself)strongself = weekself;
            strongself.exc_id = gratype_idStr;
            [strongself requestNetWrokJionPlayReward];
        };
    } else if (sender.tag == 103) {
        RECommentViewController *vc = [RECommentViewController new];
        vc.naviTitle = @"评论";
        vc.contents_id = @"";
        vc.book_id = self.book_id;
        __weak typeof (self)weekself = self;
        vc.backBlock = ^(NSString * _Nonnull book_id) {
            __strong typeof (weekself)strongself = weekself;
            strongself.book_id = book_id;
            strongself.replyStr = @"1";
            [strongself requestNetWrokB];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        self.anotherChangeStr = @"1";
        [self requestNetWrokAnotherChange];
    }
}

//查看全部目录
- (void)allDirectoriesButtonAction:(UIButton *)sender {
    REAllDirectoriesViewController *vc = [REAllDirectoriesViewController new];
    vc.book_id = self.book_id;
    vc.imageStr = self.imageStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButtonAction:(UIButton *)sender {
    RECommentListViewController *vc = [RECommentListViewController new];
    vc.book_id = self.book_id;
    vc.naviTitle = @"全部评论";
    //返回回调
    __weak typeof (self)weekself = self;
    vc.backBlock = ^(NSString * _Nonnull book_id) {
        __strong typeof (weekself)strongself = weekself;
        strongself.book_id = book_id;
        strongself.replyStr = @"1";
        [strongself requestNetWrokB];
    };
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
