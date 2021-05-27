//
//  REPublishAdViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/9.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REPublishAdViewController.h"
#import "REReleaseAdModel.h"
#import "REPriceModel.h"

@interface REPublishAdViewController ()

@property (nonatomic,assign)NSInteger navbtnTag;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)NSArray *buyArray;
@property (nonatomic,strong)NSArray *sellArray;
@property (nonatomic,strong)UIScrollView *buyOrSellScrollView;
@property (nonatomic,strong)UILabel *allMoneyLabel;
@property (nonatomic,strong)UILabel *allMoneyUnitLabel;
@property (nonatomic,strong)NSMutableDictionary *mutableDic;
@property (nonatomic,strong)REReleaseAdModel *releaseAdModel;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)REReadingEarnPopupView *popView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) REPriceModel *priceModel;
@end

@implementation REPublishAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.type = @"1";
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setValue:self.type forKey:@"type"];
    [self navSwitchButton];
    self.buyArray = [RESingleton sharedRESingleton].tradingMarketBuyArray;
    self.sellArray = [RESingleton sharedRESingleton].tradingMarketSellArray;
    [self requestNetworkB];
}

#pragma mark - 网络请求--------价格
- (void)requestNetworkB {
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
            REPriceModel *model = [REPriceModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.priceModel = model;
            
            [self re_loadUI];
        } else {
            [self showAlertMsg:msg Duration:2];
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/otc/otc_price",HomePageDomainName];
    }
    return _requestB;
}

#pragma mark - 发布广告
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
            if (self.releaseAdBlock) {
                self.releaseAdBlock(msg);
            }
            [self.popView closeThePopupView];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlertMsg:msg Duration:2];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/ad_submit",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"amout":self.releaseAdModel.amout,
                                       @"price":self.releaseAdModel.price,
                                       @"type":self.releaseAdModel.type,
                                       @"create_user_id_phone":self.releaseAdModel.create_user_id_phone,
                                       @"create_user_id_email":self.releaseAdModel.create_user_id_email,
                                       @"payType":self.releaseAdModel.payType,
                                       @"paypwd":self.releaseAdModel.paypwd,
                                       @"UpperLimit":@"1",
                                       @"LowerLimit":@"1",
                                      };
    }
    return _requestA;
}
#pragma mark - 加载UI
- (void)re_loadUI {
    [self buyOrSellScrollView];
    
    //1.标题
    for (int i=0; i<self.buyArray.count; i++) {
        UILabel *titleLabel = [UILabel new];
        [self.buyOrSellScrollView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        titleLabel.tag = 100+i;
        
        UITextField *textField = [UITextField new];
        textField.tag = 200+i;
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [self.buyOrSellScrollView addSubview:textField];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        if (i==3) {
            textField.hidden = YES;
        }
        if (i==4 || i == 2) {
            textField.backgroundColor = REColor(235, 236, 228);
            textField.userInteractionEnabled = NO;
        }
        if (i==1 || i==5 || i==6) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    //2.总额
    UILabel *allMoneyLabel = [UILabel new];
    self.allMoneyLabel = allMoneyLabel;
    [self.buyOrSellScrollView addSubview:allMoneyLabel];
    allMoneyLabel.textAlignment = NSTextAlignmentRight;
    allMoneyLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    
    UILabel *allMoneyUnitLabel = [UILabel new];
    self.allMoneyUnitLabel = allMoneyUnitLabel;
    [self.buyOrSellScrollView addSubview:allMoneyUnitLabel];
    allMoneyUnitLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //3.支付方式
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.tag = 330;
    [self.buyOrSellScrollView addSubview:payButton];
    
    UIImageView *alipayImageView = [UIImageView new];
    alipayImageView.tag = 315;
    [payButton addSubview:alipayImageView];
    alipayImageView.image = REImageName(@"zhifubao");
    
    UILabel *alipayLabel = [UILabel new];
    alipayLabel.tag = 320;
    [payButton addSubview:alipayLabel];
    NSMutableAttributedString *alipayLabelstring = [[NSMutableAttributedString alloc] initWithString:@"支付宝钱包" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    alipayLabel.attributedText = alipayLabelstring;
    alipayLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    UIImageView *lowImageView = [UIImageView new];
    lowImageView.tag = 325;
    [payButton addSubview:lowImageView];
    lowImageView.image = REImageName(@"xiala");
    
    //5.注意事项
    UITextView *beCarefulTextView = [UITextView new];
    beCarefulTextView.tag = 400;
    [self.buyOrSellScrollView addSubview:beCarefulTextView];
    beCarefulTextView.userInteractionEnabled = NO;
    beCarefulTextView.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //6.
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.tag = 500;
    [self.buyOrSellScrollView addSubview:releaseButton];
    releaseButton.titleLabel.font = REFont(17);
    [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    [releaseButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(releaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    releaseButton.backgroundColor = REColor(247, 100, 66);




    [self showFrameAndData:self.buyArray];
}

- (void)showFrameAndData:(NSArray *)array {
    
    //1.
    for (int i=0; i<self.buyArray.count; i++) {
        UILabel *titleLabel = [self.buyOrSellScrollView viewWithTag:100+i];
        NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        titleLabel.attributedText = titleLabelstring;
        titleLabel.frame = CGRectMake(20, 20+i*(20+66), 150, 20);
        
        UITextField *textField = [self.buyOrSellScrollView viewWithTag:200+i];
        textField.frame = CGRectMake(20, 48+i*(46+40), REScreenWidth-40, 46);
        textField.text = @"";
        if (i==0) {
            textField.backgroundColor = REColor(206, 206, 206);
            textField.userInteractionEnabled = NO;
            textField.text = @"YDC";
        }
        
        
        if (i==2) {
            textField.userInteractionEnabled = NO;
            if ([self.type isEqualToString:@"1"]) {
                textField.text = self.priceModel.buy;
            } else {
                textField.text = self.priceModel.sell;
            }
            [self.mutableDic setValue:textField.text forKey:@"price"];
            UITextField *num = [self.buyOrSellScrollView viewWithTag:202];
            CGFloat a = [textField.text floatValue]*[num.text floatValue];
            self.allMoneyLabel.text = [NSString stringWithFormat:@"%f",a];
        }
    }
    
    //2.
    self.allMoneyLabel.frame = CGRectMake(REScreenWidth-68-150, 308, 150, 24);
    self.allMoneyLabel.font = REFont(17);
    self.allMoneyLabel.textColor = REColor(247, 100, 66);
    self.allMoneyLabel.text = @"¥ 0";

    self.allMoneyUnitLabel.frame = CGRectMake(REScreenWidth-20-40, 312, 40, 20);
    NSMutableAttributedString *allMoneyUnitLabelstring = [[NSMutableAttributedString alloc] initWithString:@"CNY" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.allMoneyUnitLabel.attributedText = allMoneyUnitLabelstring;
    
    //4.
    UIButton *payButton = [self.buyOrSellScrollView viewWithTag:330];
    payButton.frame = CGRectMake(20, 392, REScreenWidth-40, 46);
    
    UIImageView *alipayImageView = [payButton viewWithTag:315];
    alipayImageView.frame = CGRectMake(12, 11, 24, 24);
    
    UILabel *alipayLabel = [payButton viewWithTag:320];
    alipayLabel.frame =CGRectMake(alipayImageView.right+12, 13, 150, 20);
    
    UIImageView *lowImageView = [self.buyOrSellScrollView viewWithTag:325];
    lowImageView.frame = CGRectMake(payButton.width-20-16, 20, 16, 10);

    //5.
    UITextView *beCarefulTextView = [self.buyOrSellScrollView viewWithTag:400];
    beCarefulTextView.frame = CGRectMake(20, 622, REScreenWidth-40, 80);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"注：此过程中如果出现买家迟迟不打款、买家上传假凭证或是买家以打款卖家否认收款等问题时，这就是可以申请平台介入了。一旦发现哪方违约将没收保证金以及降低账号信誉等级，严重者甚至可封号处理。" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    beCarefulTextView.attributedText = string;

    //6.
    UIButton *releaseButton = [self.buyOrSellScrollView viewWithTag:500];
    releaseButton.layer.cornerRadius = 23;
    releaseButton.frame = CGRectMake(32, beCarefulTextView.bottom+32, REScreenWidth-64, 45);
    
}

- (UIScrollView *)buyOrSellScrollView {
    if (!_buyOrSellScrollView) {
        _buyOrSellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight)];
        _buyOrSellScrollView.contentSize = CGSizeMake(REScreenWidth, 897-NavHeight);
        [self.view addSubview:_buyOrSellScrollView];
        _buyOrSellScrollView.showsVerticalScrollIndicator = NO;
        _buyOrSellScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _buyOrSellScrollView;
}

#pragma mark - 事件
- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 201) {
        [self.mutableDic setValue:textField.text forKey:@"amout"];
        UITextField *price = [self.buyOrSellScrollView viewWithTag:202];
        CGFloat a = [textField.text floatValue]*[price.text floatValue];
        NSString *d = [ToolObject getRoundFloat:a withPrecisionNum:2];
        self.allMoneyLabel.text = [NSString stringWithFormat:@"%@",d];

    } else if (textField.tag == 202) {
        NSLog(@"textField.text:%@",textField.text);
    } else if (textField.tag == 205) {
        [self.mutableDic setValue:textField.text forKey:@"create_user_id_phone"];
    } else if (textField.tag == 206) {
        [self.mutableDic setValue:textField.text forKey:@"create_user_id_email"];
    }
    REReleaseAdModel *model = [REReleaseAdModel mj_objectWithKeyValues:self.mutableDic];
    self.releaseAdModel = model;
}

- (void)releaseButtonAction:(UIButton *)sender {
    [self.mutableDic setValue:@"alipay" forKey:@"payType"];
    REReleaseAdModel *model = [REReleaseAdModel mj_objectWithKeyValues:self.mutableDic];
    self.releaseAdModel = model;
    
    if ([model.amout isEqualToString:@""]) {
        [self showAlertMsg:@"数量不能为空" Duration:2];
    } else if ([model.price isEqualToString:@""]) {
        [self showAlertMsg:@"单价不能为空" Duration:2];
    } else if ([model.create_user_id_phone isEqualToString:@""]) {
        [self showAlertMsg:@"联系方式不能为空" Duration:2];
    } else {
        __weak typeof (self)weekself = self;
        REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
        [popView showPopupViewWithData:@""];
        self.popView = popView;
        popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
            __strong typeof (weekself)strongself = weekself;
            if (text.length < 6) {
                [strongself showAlertMsg:@"密码错误" Duration:2];
            } else {
                [self.mutableDic setValue:text forKey:@"paypwd"];
                 REReleaseAdModel *model = [REReleaseAdModel mj_objectWithKeyValues:self.mutableDic];
                self.releaseAdModel = model;
                [strongself requestNetwork];
            }
        };
    }


}

#pragma mark - 导航栏点击切换按钮
- (void)navSwitchButton {
    NSArray *arrayBtn = @[@"购买",@"出售"];
    UIView *backView = [UIView new];
    self.backView = backView;
    backView.frame = CGRectMake(101, REStatusHeight+5, (REScreenWidth-101*2), 33);
    backView.backgroundColor = REColor(247, 100, 66);
    [ToolObject buttonTangentialFilletWithButton:backView withUIRectCorner:UIRectCornerAllCorners];
    [self.topNavBar addSubview:backView];
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.5+i*((REScreenWidth-102*2)/2), 0.5, (REScreenWidth-102*2)/2, 32);
        [backView addSubview:btn];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arrayBtn[i] forState:UIControlStateNormal];
        btn.titleLabel.font = REFont(16);
        if (i==0) {
            [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
            [btn setTitleColor:REWhiteColor forState:UIControlStateNormal];
            btn.backgroundColor = REColor(247, 100, 66);
            self.navbtnTag = 10+i;
        } else {
            [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopRight | UIRectCornerBottomRight];
            [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
            btn.backgroundColor = REWhiteColor;
        }
    }
}

- (void)navButtonAction:(UIButton *)sender {
//    UIButton *btn = [self.backView viewWithTag:self.navbtnTag];
//    if (sender.selected == YES) {
//        self.navbtnTag = sender.tag;
//    } else {
//        sender.selected = NO;
//        [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
//        btn.backgroundColor = REWhiteColor;
//        [sender setTitleColor:REWhiteColor forState:UIControlStateNormal];
//        sender.backgroundColor = REColor(247, 100, 66);
//        self.navbtnTag = sender.tag;
//    }
    if (sender.tag==10) {
        [self.mutableDic removeAllObjects];
        self.type = @"1";
        [self.mutableDic setValue:self.type forKey:@"type"];
        [self showFrameAndData:self.buyArray];
    } else {
        [self showAlertMsg:@"暂未开放" Duration:3];
//        self.type = @"2";
//        [self.mutableDic removeAllObjects];
//        [self.mutableDic setValue:self.type forKey:@"type"];
//        [self showFrameAndData:self.sellArray];
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
