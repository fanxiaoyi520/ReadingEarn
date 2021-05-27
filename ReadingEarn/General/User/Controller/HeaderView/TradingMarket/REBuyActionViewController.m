
//
//  REBuyActionViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBuyActionViewController.h"
#import "REBuyActionModel.h"

@interface REBuyActionViewController ()

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UIScrollView *buyScrollView;
@property (nonatomic, strong) REBuyActionModel *buyActionModel;
@property (nonatomic, assign) NSInteger btnTag;
@property (nonatomic, copy) NSString *paypwd;
@property (nonatomic, strong)REReadingEarnPopupView *popView;
@end

@implementation REBuyActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.paypwd = @"";
    [self requestNetwork];
}

#pragma mark - 网络请求--------买卖
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
            REBuyActionModel *model = [REBuyActionModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.buyActionModel = model;
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/otc_ad_info",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"id":self.buyCoinsModel.buy_id,
                                      };
    }
    return _requestA;
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
//            UITextField *textField = [self.buyScrollView viewWithTag:500];
//            textField.text = @"";
            self.paypwd = @"";
//            UILabel *label = [self.buyScrollView viewWithTag:600];
//            label.text = @"￥0.00";
            [self showAlertMsg:msg Duration:2];
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
    UITextField *textField = [self.buyScrollView viewWithTag:500];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/otc/otc_submit",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"id":self.buyActionModel.buy_id,
                                       @"paypwd":self.paypwd,
                                       @"type":self.type,
                                       @"order_num":textField.text,
                                      };
        NSLog(@"requestB.requestParameter:%@",_requestB.requestParameter);
    }
    return _requestB;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    [self buyScrollView];
    
    //1.
    NSString *isBuy;
    if ([self.type isEqualToString:@"2"]) {
        isBuy = @"卖家";
    } else {
        isBuy = @"买家";
    }
    UILabel *buyLabel = [UILabel new];
    buyLabel.textAlignment = NSTextAlignmentLeft;
    [self.buyScrollView addSubview:buyLabel];
    NSMutableAttributedString *buyLabelstring = [[NSMutableAttributedString alloc] initWithString:isBuy attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:22/255.0 green:206/255.0 blue:79/255.0 alpha:1.0]}];
    buyLabel.attributedText = buyLabelstring;
    buyLabel.textColor = [UIColor colorWithRed:22/255.0 green:206/255.0 blue:79/255.0 alpha:1.0];
    CGSize buysize = [ToolObject sizeWithText:isBuy withFont:REFont(14)];
    buyLabel.frame = CGRectMake(20, 20, buysize.width+10, 20);
    
    //2.
    UIImageView *headImageView = [UIImageView new];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.buyActionModel.headimg] placeholderImage:PlaceholderHead_Image];
    [self.buyScrollView addSubview:headImageView];
    headImageView.frame = CGRectMake(buyLabel.right, 20, 20, 20);
    headImageView.layer.cornerRadius = 10;
    headImageView.layer.masksToBounds = YES;
    
    //3.
    UILabel *nameLabel = [UILabel new];
    [self.buyScrollView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:self.buyActionModel.mobile attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    nameLabel.attributedText = nameLabelstring;
    nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    CGSize nameSize = [ToolObject sizeWithText:self.buyActionModel.mobile withFont:REFont(12)];
    nameLabel.frame = CGRectMake(headImageView.right+8, 22, nameSize.width+10, 17);

    //4
    UIImageView *channelImageView = [UIImageView new];
    [self.buyScrollView addSubview:channelImageView];
    channelImageView.frame = CGRectMake(REScreenWidth-14-22, 30, 14, 14);
    channelImageView.image = REImageName(@"zhifubao");
    
    //5.
    NSString *rateStr = [NSString stringWithFormat:@"成交量:%@          成交率",self.buyActionModel.deal_total];
    NSArray *array;
    
    NSString *deal_amout_not = [ToolObject getRoundFloat:[self.buyActionModel.deal_amout_not floatValue] withPrecisionNum:2];
    NSString *deal_scal = [NSString stringWithFormat:@"%@%%",self.buyActionModel.deal_scal];
    
    CGFloat feef = [self.buyActionModel.fee floatValue] * 100;
    NSString *fee = [ToolObject getRoundFloat:feef withPrecisionNum:0];
    NSString *feestr = [NSString stringWithFormat:@"%@%%",fee];
    NSArray *numArray;
    if (![self.type isEqualToString:@"2"]) {
        //isBuy = @"卖家";
        array = @[rateStr,@"广告价格(CNY)",@"广告数量YDC",@"手续费:"];
        numArray = @[deal_scal,self.buyActionModel.price,deal_amout_not,feestr];
    } else {
        //isBuy = @"买家";
        array = @[rateStr,@"广告价格(CNY)",@"广告数量YDC"];
        numArray = @[deal_scal,self.buyActionModel.price,deal_amout_not];
    }
    
    for (int i=0; i<numArray.count; i++) {
        CGSize labelsize = [ToolObject sizeWithText:array[i] withFont:REFont(14)];
        UILabel *label = [UILabel new];
        [self.buyScrollView addSubview:label];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        label.frame = CGRectMake(20, 52+i*(20+12), labelsize.width+10, 20);
        if (i==0) {
            label.textColor = REColor(153, 153, 153);
        }

        UILabel *numLabel = [UILabel new];
        [self.buyScrollView addSubview:numLabel];
        NSMutableAttributedString *numLabelstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
        numLabel.attributedText = numLabelstring;
        numLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
        numLabel.frame = CGRectMake(label.right + 30, 52+i*(20+12), 100, 20);
    }
    
    //6.
    NSArray *arrayTwo;
    if (![self.type isEqualToString:@"2"]) {
        arrayTwo = @[@"购买数量YDC",@"应付金额(CNY)"];
    } else {
        arrayTwo = @[@"出售数量YDC",@"应付金额(CNY)"];
    }
    for (int i=0; i<2; i++) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentLeft;
        [self.buyScrollView addSubview:label];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:arrayTwo[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        
        if (![self.type isEqualToString:@"2"]) {
            label.frame = CGRectMake(20, 180+i*(20+66), 150, 20);

        } else {
            label.frame = CGRectMake(20, 148+i*(20+66), 150, 20);
        }
        
        UITextField *textField = [UITextField new];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.buyScrollView addSubview:textField];
        textField.tag = 500+i;
        if (i==0) {
            if (![self.type isEqualToString:@"2"]) {
                textField.frame = CGRectMake(20, 206+i*(46+40), REScreenWidth-40, 46);
                NSString *locked_amout_not = [ToolObject getRoundFloat:([self.buyActionModel.deal_amout_not doubleValue]*[self.buyActionModel.fee doubleValue]+[self.buyActionModel.deal_amout_not doubleValue]) withPrecisionNum:8];
                textField.text = locked_amout_not;

            } else {
                NSString *deal_amout_not = [ToolObject getRoundFloat:[self.buyActionModel.deal_amout_not doubleValue] withPrecisionNum:8];
                textField.text = deal_amout_not;
                textField.frame = CGRectMake(20, 176+i*(46+40), REScreenWidth-40, 46);
            }
            textField.userInteractionEnabled = NO;
        } else {
            if (![self.type isEqualToString:@"2"]) {
                textField.frame = CGRectMake(20, 206+i*(46+40), REScreenWidth-40, 46);
            } else {
                textField.frame = CGRectMake(20, 176+i*(46+40), REScreenWidth-40, 46);
            }
            //textField.frame = CGRectMake(20, 176+i*(46+40), REScreenWidth-40, 46);
            textField.userInteractionEnabled = NO;
        }
    }
    //最大数量
    UIButton *maximumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.buyScrollView addSubview:maximumButton];
    maximumButton.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [maximumButton addTarget:self action:@selector(maximumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    maximumButton.layer.cornerRadius = 4;
    maximumButton.titleLabel.font = REFont(14);
    [maximumButton setTitle:@"最大数量" forState:UIControlStateNormal];
    [maximumButton setTitleColor:REColor(44, 72, 121) forState:UIControlStateNormal];
    
    //￥
    UILabel *cnyLabel = [UILabel new];
    [self.buyScrollView addSubview:cnyLabel];
    NSMutableAttributedString *cnyLabelstring = [[NSMutableAttributedString alloc] initWithString:@"CNY" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    cnyLabel.textAlignment = NSTextAlignmentRight;
    cnyLabel.attributedText = cnyLabelstring;
    cnyLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    UILabel *maxNumLabel = [UILabel new];
    maxNumLabel.tag = 600;
    [self.buyScrollView addSubview:maxNumLabel];
    maxNumLabel.textAlignment = NSTextAlignmentRight;
    maxNumLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    maxNumLabel.font = REFont(17);
    
    if (![self.type isEqualToString:@"2"]) {
        maximumButton.frame = CGRectMake(REScreenWidth-20-81, 206, 81, 46);
        cnyLabel.frame = CGRectMake(REScreenWidth-32-40, 307, 40, 20);
        maxNumLabel.frame =CGRectMake(REScreenWidth-70-150, 303, 150, 24);

        CGFloat amountPayable = [self.buyActionModel.deal_amout_not doubleValue] * [self.buyActionModel.price doubleValue];
        NSString *amountPayableStr = [ToolObject getRoundFloat:amountPayable withPrecisionNum:8];
        maxNumLabel.text = [NSString stringWithFormat:@"￥%@",amountPayableStr];

    } else {
        maximumButton.frame = CGRectMake(REScreenWidth-20-81, 176, 81, 46);
        cnyLabel.frame = CGRectMake(REScreenWidth-32-40, 277, 40, 20);
        maxNumLabel.frame =CGRectMake(REScreenWidth-70-150, 273, 150, 24);
     
        
        
        CGFloat amountPayable = [self.buyActionModel.deal_amout_not doubleValue] * [self.buyActionModel.price doubleValue];
        NSString *amountPayableStr = [ToolObject getRoundFloat:amountPayable withPrecisionNum:8];
        maxNumLabel.text = [NSString stringWithFormat:@"￥%@",amountPayableStr];
    }

    //7.
    NSArray *isBuyArray;
    if ([self.type isEqualToString:@"2"]) {
        isBuyArray = @[@"取消",@"购买"];
    } else {
        isBuyArray = @[@"取消",@"出售"];
    }
    for (int i=0; i<2; i++) {
        UIButton *isBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buyScrollView addSubview:isBuyButton];
        isBuyButton.titleLabel.font = REFont(17);
        isBuyButton.tag = 10+i;
        [isBuyButton setTitle:isBuyArray[i] forState:UIControlStateNormal];
        [isBuyButton addTarget:self action:@selector(isBuyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        isBuyButton.layer.cornerRadius = 22.5;
        isBuyButton.frame = CGRectMake(16+i*((REScreenWidth-32-20)/2 + 20), 368, (REScreenWidth-32-20)/2, 45);

        if (i==1) {
            self.btnTag = 10+i;
            isBuyButton.backgroundColor = REColor(247, 100, 66);
            [isBuyButton setTitleColor:REColor(255, 255, 255) forState:UIControlStateNormal];
        } else {
            isBuyButton.backgroundColor = REColor(229, 229, 229);
            [isBuyButton setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
        }
    }
}

- (UIScrollView *)buyScrollView {
    if (!_buyScrollView) {
        _buyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight)];
        _buyScrollView.contentSize = CGSizeMake(REScreenWidth, REScreenHeight-NavHeight);
        _buyScrollView.showsVerticalScrollIndicator = NO;
        _buyScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_buyScrollView];
    }
    return _buyScrollView;
}

#pragma mark - 事件
- (void)maximumButtonAction:(UIButton *)sender {
    UITextField *textField = [self.buyScrollView viewWithTag:500];
    NSString *locked_amout_not = [ToolObject getRoundFloat:[self.buyActionModel.locked_amout_not floatValue] withPrecisionNum:0];
    textField.text = locked_amout_not;
    
    NSString *locked_amout_notlabel = [ToolObject getRoundFloat:[self.buyActionModel.locked_amout_not floatValue] withPrecisionNum:2];
    UILabel *label = [self.buyScrollView viewWithTag:600];
    label.text = [NSString stringWithFormat:@"￥%@",locked_amout_notlabel];
}

- (void)isBuyButtonAction:(UIButton *)sender {
    UIButton *btn = [self.buyScrollView viewWithTag:self.btnTag];
    if (sender.selected == YES) {
        self.btnTag = sender.tag;
    } else {
        sender.selected = NO;
        btn.backgroundColor = REColor(229, 229, 229);
        [btn setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];

        sender.backgroundColor = REColor(247, 100, 66);
        [sender setTitleColor:REColor(255, 255, 255) forState:UIControlStateNormal];

        self.btnTag = sender.tag;
    }
    
    if (sender.tag == 11) {
        UITextField *textField = [self.buyScrollView viewWithTag:500];
        if (textField.text.length < 1 || textField.text == nil || [textField.text isEqualToString:@""]) {
            if ([self.type isEqualToString:@"2"]) {
                [self showAlertMsg:@"请输入购买数量" Duration:2];
            } else {
                [self showAlertMsg:@"请输入出售数量" Duration:2];
            }
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
                     self.paypwd = text;
                    [strongself requestNetworkPay];
                }
            };
        }
    } else {
    }
}

- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 500) {
        if ([textField.text floatValue] < [self.buyActionModel.locked_amout_not floatValue]) {
            NSString *locked_amout_notlabel = [ToolObject getRoundFloat:[textField.text floatValue] withPrecisionNum:2];
            UILabel *label = [self.buyScrollView viewWithTag:600];
            label.text = [NSString stringWithFormat:@"￥%@",locked_amout_notlabel];
        } else {
            UITextField *textFields = [self.buyScrollView viewWithTag:500];
            NSString *locked_amout_not = [ToolObject getRoundFloat:[self.buyActionModel.locked_amout_not floatValue] withPrecisionNum:0];
            textFields.text = locked_amout_not;

            
            NSString *locked_amout_notlabel = [ToolObject getRoundFloat:[textField.text floatValue] withPrecisionNum:2];
            UILabel *label = [self.buyScrollView viewWithTag:600];
            label.text = [NSString stringWithFormat:@"￥%@",locked_amout_notlabel];
            [self showAlertMsg:@"超过限额" Duration:3];
        }
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
