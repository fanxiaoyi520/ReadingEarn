//
//  REAlipayRealNameAuthenticationViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/1/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "REAlipayRealNameAuthenticationViewController.h"
#import "REAuthModel.h"

@interface REAlipayRealNameAuthenticationViewController ()
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic ,strong)UIScrollView *backScrollView;
@property (nonatomic ,strong)UIView *backHeaderView;
@property (nonatomic ,strong)UILabel *headerLabel;
@property (nonatomic ,strong)UILabel *tipsLabel;
@property (nonatomic ,strong)UIButton *selButton;
@property (nonatomic ,strong)UILabel *selTextLabel;
@property (nonatomic ,strong)UIButton *certainButton;
@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)REAuthModel *authModel;
@property (nonatomic ,copy)NSString *auditStatusStr;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,strong)NSDictionary *dic;
@end

@implementation REAlipayRealNameAuthenticationViewController
- (void)dealloc {
        //单条移除观察者
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_TABLEVIEW" object:nil];
}

- (void)refreshTableView: (NSNotification *) notification {
         //处理消息
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"REFRESH_TABLEVIEW" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setObject:@"" forKey:@"cert_name"];
    [self.mutableDic setObject:@"" forKey:@"cert_no"];
    REAuthModel *model = [REAuthModel mj_objectWithKeyValues:self.mutableDic];
    self.authModel = model;
    
    [self re_loadUI];
    [self requestNetworkB];
}

#pragma mark - 网络请求--------审核状态
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
        NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([code isEqualToString:@"1"]) {
            self.auditStatusStr = msg;
            self.status = status;
            self.dic = (NSDictionary *)response.responseObject[@"data"];
            
            [self loadFrameAndData];
        } else {
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/ucenter/user_certification",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestB;
}

#pragma mark - 网络请求-------------认证
- (void)requestNetworkA {
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
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"success");
                [self.navigationController popViewControllerAnimated:YES];
            }];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/aliaop/aop",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"cert_no":self.authModel.cert_no,
                                       @"cert_name":self.authModel.cert_name,
                                       @"type":@"2"
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
        
    [self backScrollView];
    
    UILabel *tipsLabel = [UILabel new];
    self.tipsLabel = tipsLabel;
    tipsLabel.backgroundColor = REColor(253, 253, 232);
    tipsLabel.font = REFont(17);
    tipsLabel.textColor = REColor(193, 193, 193);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    [self.backScrollView addSubview:tipsLabel];
    
    //1.
    UIView *backHeaderView = [UIView new];
    [self.backScrollView addSubview:backHeaderView];
    self.backHeaderView = backHeaderView;
    
    UILabel *headerLabel = [UILabel new];
    self.headerLabel = headerLabel;
    headerLabel.font = REFont(15);
    headerLabel.textColor = REColor(51, 51, 51);
    headerLabel.numberOfLines = 0;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [backHeaderView addSubview:headerLabel];
    
    //2.
    for (int i=0; i<2; i++) {
        UITextField *textField = [UITextField new];
        textField.tag = 10+i;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [textField addTarget:self action:@selector(accAndPassTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [self.backScrollView addSubview:textField];
    }
    
    //3.
    UIButton *selButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selButton.selected = NO;
    [selButton setImage:REImageName(@"button_iocn_choose_nor") forState:UIControlStateNormal];
    [selButton setImage:REImageName(@"button_iocn_choose_pre") forState:UIControlStateSelected];
    [self.backScrollView addSubview:selButton];
    [selButton addTarget:self action:@selector(selButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selButton = selButton;
    
    UILabel *selTextLabel = [UILabel new];
    NSMutableAttributedString *selTextstring = [[NSMutableAttributedString alloc] initWithString:@"同意阅赚用户协议与用户隐私协议" attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    [selTextstring addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 4)];
    [selTextstring addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9, 6)];
    selTextLabel.attributedText = selTextstring;
    [self.backScrollView addSubview:selTextLabel];
    self.selTextLabel = selTextLabel;

    //4.
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    certainButton.layer.cornerRadius = 22.5;
    [certainButton addTarget:self action:@selector(certainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [certainButton setTitle:@"认证" forState:UIControlStateNormal];
    certainButton.backgroundColor = REColor(247, 100, 66);
    [self.backScrollView addSubview:certainButton];
    self.certainButton = certainButton;
    
    //5.
    UITextView *textView = [UITextView new];
    textView.userInteractionEnabled = NO;
    textView.font = REFont(14);
    textView.textColor = REColor(153, 153, 153);
    [self.backScrollView addSubview:textView];
    self.textView = textView;
}

- (void)loadFrameAndData {
    
    self.tipsLabel.frame = CGRectMake(0, 0, REScreenWidth, 40);
    NSString *str = [NSString stringWithFormat:@"  认证状态:%@",self.auditStatusStr];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    self.tipsLabel.attributedText = string;
    [ToolObject LabelAttributedString:self.tipsLabel FontNumber:REFont(14) AndRange:NSMakeRange(7, self.auditStatusStr.length) AndColor:REColor(255, 100, 62)];

    //1.
    NSString *text = @"若因您填写资料有误等原因导致认证失败,再次认证需要再付认证服务费.请慎重填写以确保资料准确";
    CGSize size = [ToolObject textHeightFromTextString:text width:(REScreenWidth-40) fontSize:15];
    self.backHeaderView.frame = CGRectMake(0, 40, REScreenWidth, size.height+30);
    
    self.headerLabel.frame = CGRectMake(20, 15, REScreenWidth-40, size.height);
    self.headerLabel.text = text;
    
    //2.
    //未认证0 审核中1 审核失败2  审核成功3
    NSArray *placeholderArray;
    if (![self.status isEqualToString:@"3"]) {
        placeholderArray = @[@"请输入姓名",@"请输入身份证号码"];
    } else {
        placeholderArray = @[[self.dic objectForKey:@"real_name"],[self.dic objectForKey:@"id_card"]];
    }

    //NSArray *placeholderArray = @[@"请输入姓名",@"请输入身份证号码"];
    for (int i=0; i<2; i++) {
        UITextField *textField = [self.backScrollView viewWithTag:10+i];
        textField.placeholder = placeholderArray[i];
        textField.frame = CGRectMake(20, self.backHeaderView.height+40+i*(46+20), REScreenWidth-2*20, 46);
        
        //未认证0 审核中1 审核失败2  审核成功3
        if (![self.status isEqualToString:@"3"]) {
            textField.userInteractionEnabled = YES;
        } else {
            textField.userInteractionEnabled = NO;
        }
    }

    //3.
    [self.selButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.mas_equalTo(self.view).offset(self.backHeaderView.height+40+placeholderArray.count*(46+20)+60+20);
    }];

    [self.selTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@46);
        make.top.mas_equalTo(self.selButton).offset(ratioH(2.5));
    }];
    
    //4.
    [self.certainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.mas_equalTo(self.selButton).offset(35);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo((REScreenWidth-40));
    }];
    if (![self.status isEqualToString:@"3"]) {
        self.selButton.userInteractionEnabled = YES;
        self.certainButton.userInteractionEnabled = YES;
    } else {
        self.certainButton.userInteractionEnabled = NO;
        self.selButton.userInteractionEnabled = NO;
    }
    
    //5
    NSString *textStr = @"亲爱的用户，为保证用户的真实性，我们将调用第三方公司认证系统进行实名认证，整个认证过程只做用户真实性匹配对比，不做其他任何用途。";
    CGSize sizeStr = [ToolObject textHeightFromTextString:textStr width:(REScreenWidth-40) fontSize:14];
    self.textView.text = textStr;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.mas_equalTo(self.certainButton).offset(65);
        make.height.mas_equalTo(sizeStr.height+30);
        make.width.mas_equalTo((REScreenWidth-40));
    }];
}

- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [UIScrollView new];
        _backScrollView.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
        _backScrollView.contentSize = CGSizeMake(REScreenWidth, REScreenHeight-NavHeight);
        [self.view addSubview:_backScrollView];
    }
    return _backScrollView;
}

#pragma mark - 事件
- (void)accAndPassTextFieldAction:(UITextField *)textField {
    if (textField.tag == 10) {
        [self.mutableDic setObject:textField.text forKey:@"cert_name"];
    } else {
        [self.mutableDic setObject:textField.text forKey:@"cert_no"];
    }
    
    REAuthModel *model = [REAuthModel mj_objectWithKeyValues:self.mutableDic];
    self.authModel = model;
}

- (void)selButtonAction:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
    } else {
        sender.selected = NO;
    }
}

- (void)certainButtonAction:(UIButton *)sender {
    if ([self.authModel.cert_name isEqualToString:@""]) {
        [self showAlertMsg:@"姓名不能为空" Duration:2];
    } else if ([self.authModel.cert_no isEqualToString:@""]) {
        [self showAlertMsg:@"身份证号码不能为空" Duration:2];
    } else if (self.selButton.selected == NO) {
        [self showAlertMsg:@"是否同意协议勾选项" Duration:2];
    } else {
        [self requestNetworkA];
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
