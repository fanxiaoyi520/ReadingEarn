//
//  REGoSignInViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REGoSignInViewController.h"
#import "REGoSignInModel.h"
@interface REGoSignInViewController ()

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UIScrollView *signInScrollView;
@property (nonatomic, strong) REGoSignInModel *goSignInModel;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSString *status;
@end

@implementation REGoSignInViewController
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
    [self requestNetwork];
}

#pragma mark - 网络请求--------用户信息
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
        self.status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            NSDictionary *dic = response.responseObject[@"day"];
            self.dic = [dic objectForKey:@"0"];
            REGoSignInModel *model = [REGoSignInModel mj_objectWithKeyValues:dic];
            self.goSignInModel = model;
            [self re_loadUI];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/user_sign/sign",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求--------签到
- (void)requestNetworkBwithButton:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        self.status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            [sender setImage:REImageName(@"button_gosignin_pre") forState:UIControlStateNormal];
            sender.userInteractionEnabled = NO;
            
            REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:REReadingEarnPopupView_SignIn];
            [popView showPopupViewWithData:response.responseObject[@"data"]];
            
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/user_sign/user_sign",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestB;
}


//ser_sign/sign

#pragma mark - 加载UI
- (void)re_loadUI {
    [self signInScrollView];
    //1.button_gosignin button_gosignin_pre
    UIButton *buttonGoSignin = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signInScrollView addSubview:buttonGoSignin];
    [buttonGoSignin addTarget:self action:@selector(buttonGoSigninAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonGoSignin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ratioH(20));
        make.width.mas_equalTo(ratioH(86));
        make.height.mas_equalTo(ratioH(86));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    //2.
    NSString *signDayStr;
    UILabel *signDayLabel = [UILabel new];
    signDayLabel.textAlignment = NSTextAlignmentCenter;
    signDayLabel.frame = CGRectMake(0, ratioH(126), REScreenWidth, ratioH(18));
    [self.signInScrollView addSubview:signDayLabel];
    if ([self.status isEqualToString:@"0"]) {
        [buttonGoSignin setImage:REImageName(@"button_gosignin") forState:UIControlStateNormal];
        buttonGoSignin.userInteractionEnabled = YES;
        signDayLabel.textColor = REColor(255, 86, 34);
        signDayStr = [NSString stringWithFormat:@"立即签到"];
    } else {
        [buttonGoSignin setImage:REImageName(@"button_gosignin_pre") forState:UIControlStateNormal];
        buttonGoSignin.userInteractionEnabled = NO;
        signDayStr = [NSString stringWithFormat:@"已连续签到 1 天"];
        NSMutableAttributedString *signDayLabelstring = [[NSMutableAttributedString alloc] initWithString:signDayStr attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        signDayLabel.attributedText = signDayLabelstring;
        [ToolObject LabelAttributedString:signDayLabel FontNumber:REFont(18) AndRange:NSMakeRange(5, 2+1) AndColor:REColor(248, 115, 102)];
    }

    //3.
    NSString *signRankingStr = [NSString stringWithFormat:@"签到奖励排第 %@ 名",self.goSignInModel.rank];
    UILabel *signRankingLabel = [UILabel new];
    signRankingLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *signRankingLabelstring = [[NSMutableAttributedString alloc] initWithString:signRankingStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: REColor(153, 153, 153)}];
    signRankingLabel.font = REFont(14);
    signRankingLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    signRankingLabel.attributedText = signRankingLabelstring;
    [ToolObject LabelAttributedString:signRankingLabel FontNumber:REFont(14) AndRange:NSMakeRange(6, 2+self.goSignInModel.rank.length) AndColor:REColor(255, 197, 137)];
    signRankingLabel.frame = CGRectMake(0, ratioH(160), REScreenWidth, ratioH(14));
    [self.signInScrollView addSubview:signRankingLabel];

    //4.
    UIView *backView = [UIView new];
    backView.backgroundColor = REBackColor;
    backView.frame =CGRectMake(0, ratioH(194), REScreenWidth, ratioH(94));
    [self.signInScrollView addSubview:backView];
    
    NSArray *array = self.dic.allKeys;
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序

    }];
    NSArray *labelArray = @[@"1天",@"2天",@"3天",@"4天",@"5天",@"6天",@"7天"];
    for (int i=0; i<result.count; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(20+i*(ratioH(50)+((REScreenWidth - 40)-ratioH(50)*7)/6), ratioH(5), ratioH(50), ratioH(50));
        [backView addSubview:imageView];
        NSString *str = [NSString stringWithFormat:@"%@",[self.dic objectForKey:result[i]]];
        
        UILabel *label = [UILabel new];
        label.font = REFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [backView addSubview:label];
        label.frame = CGRectMake(20+i*(ratioH(50)+((REScreenWidth - 40)-ratioH(50)*7)/6), ratioH(62), ratioH(50), ratioH(14));
        if ([str isEqualToString:@"0"]) {
            imageView.image = REImageName(@"sign_in_w");
            label.text = labelArray[i];
        } else if ([str isEqualToString:@"1"]) {
            imageView.image = REImageName(@"sign_in_d");
            label.text = @"待签";
        } else {
            imageView.image = REImageName(@"sign_in_y");
            label.text = @"已签";
        }

    }
    
    //5.
    UILabel *shuomingLabel = [UILabel new];
    shuomingLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *shuomingLabelstring = [[NSMutableAttributedString alloc] initWithString:@"特别说明" attributes:@{NSFontAttributeName: REFont(19), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    shuomingLabel.attributedText = shuomingLabelstring;
    shuomingLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.signInScrollView addSubview:shuomingLabel];
    shuomingLabel.frame = CGRectMake(0, ratioH(307), REScreenWidth, ratioH(19));
    
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"·本签到为累计形式，若中断签到则重新开始\n·保持连续签到，第7天可获得高额奖励\n·签到可获得20YC奖励，连续第7天可获得100YC\n·按要求参与分享活动者，签到奖励翻倍\n·每自然月排名靠前100者可随机获得神秘大礼包" attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    UITextView *textView = [UITextView new];
    textView.attributedText = string;
    textView.userInteractionEnabled = NO;
    [self.signInScrollView  addSubview:textView];
    textView.frame = CGRectMake(26, ratioH(352), REScreenWidth-52, 120);
    
    UIImageView *ggimageView = [UIImageView new];
    [self.signInScrollView addSubview:ggimageView];
    [ggimageView sd_setImageWithURL:[NSURL URLWithString:self.goSignInModel.log] placeholderImage:PlaceholderImage];
    ggimageView.frame = CGRectMake(0, self.signInScrollView.contentSize.height-ratioH(136), REScreenWidth, ratioH(136));
}

- (UIScrollView *)signInScrollView {
    if (!_signInScrollView) {
        _signInScrollView = [[UIScrollView alloc] init];
        _signInScrollView.bounces = NO;
        _signInScrollView.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
        _signInScrollView.showsVerticalScrollIndicator = NO;
        _signInScrollView.showsHorizontalScrollIndicator = NO;
        _signInScrollView.contentSize = CGSizeMake(REScreenWidth, ratioH(588)+ratioH(136));
        [self.view addSubview:_signInScrollView];
    }
    return _signInScrollView;
}

#pragma mark - 事件
- (void)buttonGoSigninAction:(UIButton *)sender {
    [self requestNetworkBwithButton:sender];
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
