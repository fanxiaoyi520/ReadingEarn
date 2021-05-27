//
//  REReadingEarnPopupView.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REReadingEarnPopupView.h"
#import "REUseWalletModel.h"
#import "REGraTypeModel.h"

@interface REReadingEarnPopupView()<UIGestureRecognizerDelegate>

@property (nonatomic ,weak)UIWindow *myWindow;
@property (nonatomic ,strong)UIView *coverView;
@property (nonatomic ,assign)REReadingEarnPopupViewsEnum type;
@property (nonatomic ,strong)REUseWalletModel *useWalletModel;
@property (nonatomic ,copy)NSString *data;
@property (nonatomic ,strong)NSDictionary *model;
@property (nonatomic ,strong)NSString *boxInputViewstr;
@property (nonatomic ,strong)UIButton *certainButton;
@property (nonatomic ,strong)REGraTypeModel *graTypeModel;
@property (nonatomic ,strong)NSArray *gratypeArray;
@property (nonatomic ,copy)NSString *gratype_idStr;
@property (nonatomic ,assign)NSInteger btnTag;
@end
@implementation REReadingEarnPopupView

- (instancetype)initWithFrame:(CGRect)frame withType:(REReadingEarnPopupViewsEnum)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.myWindow = [UIApplication sharedApplication].keyWindow;
    self.coverView = [UIView new];
    [self.myWindow addSubview:self.coverView];
    self.coverView.frame = CGRectMake(0, 0, REScreenWidth, REScreenHeight);
    self.coverView.backgroundColor = REColor(0, 0, 0);
    self.coverView.alpha = 0.5;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    [self.coverView addGestureRecognizer:tap];
    
    if (self.type == REReadingEarnPopupView_ContactCustomerService) {
        [self re_loadUIContactCustomerService];
    } else if (self.type == REReadingEarnPopupView_ExchangeYDC) {
        [self re_loadUIExchangeYDC];
    } else if (self.type == REReadingEarnPopupView_Recharge) {
        [self re_loadRecharge];
    } else if (self.type == REReadingEarnPopupView_Recharge2) {
        [self re_loadRecharge];
    } else if (self.type == REReadingEarnPopupView_PlayReward) {
        [self re_loadPlayReward];
    } else if (self.type == REReadingEarnPopupView_SignIn) {
        [self re_loadSignIn];
    } else if (self.type == REReadingEarnPopupView_ImmediateRecharge) {
        [self re_loadImmediateRecharge];
    } else if (self.type == REReadingEarnPopupView_UserAgreement) {
        [self re_loadUserAgreement];
    }
}

#pragma mark - 加载视图
- (void)re_loadUIContactCustomerService {
    
    //1.
    UILabel *nameLabel = [UILabel new];
    nameLabel.tag = 10;
    nameLabel.font = REFont(17);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = REColor(63, 63, 63);
    [self addSubview:nameLabel];
    
    //2.
    UIImageView *QRcodeImageView = [UIImageView new];
    QRcodeImageView.tag = 20;
    [self addSubview:QRcodeImageView];
    
    //3.
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tag = 30;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"xxxxxxxxxxxxx_1") forState:UIControlStateNormal];
    [self addSubview:closeButton];
}

- (void)re_loadUIExchangeYDC {
    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 10;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self addSubview:titleLabel];
    
    //2.
    UILabel *describeLabel = [UILabel new];
    describeLabel.textColor = [UIColor colorWithRed:158/255.0 green:160/255.0 blue:164/255.0 alpha:1.0];
    [self addSubview:describeLabel];
    describeLabel.tag = 20;
    
    //3.
    CRBoxInputView *boxInputView = [CRBoxInputView new];
    boxInputView.tag = 30;
    boxInputView.codeLength = 6;// 不设置时，默认4
    [boxInputView loadAndPrepareViewWithBeginEdit:YES]; // BeginEdit:是否自动启用编辑模式
    [self addSubview:boxInputView];

    //4.
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certainButton = certainButton;
    certainButton.titleLabel.font = REFont(14);
    certainButton.tag = 40;
    certainButton.layer.cornerRadius = ratioH(17.5);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    [certainButton addTarget:self action:@selector(certainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    certainButton.backgroundColor = REColor(255, 112, 68);
    [self addSubview:certainButton];
    
    //3.
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"xxxxxxxxxxxxx_1") forState:UIControlStateNormal];
    [self addSubview:closeButton];
}

- (void)re_loadRecharge {
    
    //1.
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.tag = 10;
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    
    
    //2.
    UIImageView *moneySymbolImageView = [UIImageView new];
    [self addSubview:moneySymbolImageView];
    moneySymbolImageView.tag = 20;
    
    //3.
    UIImageView *QRImageView = [UIImageView new];
    [self addSubview:QRImageView];
    QRImageView.tag = 30;
    
    //4.
    UILabel *codeLabel = [UILabel new];
    [self addSubview:codeLabel];
    codeLabel.textColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    codeLabel.tag = 40;
    
    //5.
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:copyButton];
    copyButton.tag = 50;
    copyButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    copyButton.layer.borderWidth = 1;
    copyButton.layer.cornerRadius = 10;
    copyButton.titleLabel.font = REFont(12);
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //6.
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeButton];
    closeButton.tag = 60;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"login_icon_delect_nor") forState:UIControlStateNormal];
}

//我要打赏
- (void)re_loadPlayReward {
    
    //关闭
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeButton];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"xxxxxxxxxxxxx_1") forState:UIControlStateNormal];

    //1.title
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.tag = 60;
    
    //2.
    for (int i=0; i<4; i++) {
        UIButton *playRewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playRewardButton.tag = 70+i;
        [playRewardButton addTarget:self action:@selector(playRewardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playRewardButton];
        
        UIImageView *playRewardImageView = [UIImageView new];
        playRewardImageView.tag = 80+i;
        [playRewardButton addSubview:playRewardImageView];
        
        UILabel *moneyLabel = [UILabel new];
        moneyLabel.tag = 90+i;
        [playRewardButton addSubview:moneyLabel];
    }
    
    //3.
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sureButton];
    sureButton.tag = 100;
    sureButton.titleLabel.font = REFont(16);
    [sureButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.backgroundColor = REColor(247, 100, 66);
}

//签到奖励
- (void)re_loadSignIn {
    //关闭
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeButton];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"xxxxxxxxxxxxx_1") forState:UIControlStateNormal];
    
    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 10;
    [self addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = REFont(18);
    
    //2.
    UIImageView *signInImageView = [UIImageView new];
    [self addSubview:signInImageView];
    signInImageView.tag = 20;
    
    //3.
    UILabel *numLabel = [UILabel new];
    numLabel.tag = 30;
    [self addSubview:numLabel];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = REFont(14);
    
    //4.
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:certainButton];
    certainButton.tag = 40;
    certainButton.backgroundColor = REColor(247, 100, 66);
    certainButton.titleLabel.font = REFont(18);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    [certainButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [certainButton addTarget:self action:@selector(certainSignInButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)re_loadImmediateRecharge {
    //关闭
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeButton];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"xxxxxxxxxxxxx_1") forState:UIControlStateNormal];
    
    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 10;
    titleLabel.textColor = REColor(247, 100, 66);
    [self addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = REFont(18);
    
    //2.
    UIImageView *bookImageView = [UIImageView new];
    [self addSubview:bookImageView];
    bookImageView.tag = 20;

    //3.
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.tag = 30;
    [self addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = REFont(17);
    
    //4.
    UIImageView *mybookImageView = [UIImageView new];
    [self addSubview:mybookImageView];
    mybookImageView.tag = 40;
    
    //5.
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:certainButton];
    certainButton.tag = 60;
    certainButton.backgroundColor = REColor(247, 100, 66);
    certainButton.titleLabel.font = REFont(16);
    [certainButton setTitle:@"立即充值" forState:UIControlStateNormal];
    [certainButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [certainButton addTarget:self action:@selector(immediateRechargeAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)re_loadUserAgreement {
    //关闭
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeButton];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"xxxxxxxxxxxxx_1") forState:UIControlStateNormal];
    
    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 10;
    titleLabel.textColor = REColor(247, 100, 66);
    [self addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = REFont(18);
    
    //2.
    UITextView *textView = [UITextView new];
    textView.tag = 20;
    textView.userInteractionEnabled = NO;
    textView.textColor = REColor(51, 51, 51);
    textView.font = REFont(14);
    [self addSubview:textView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = REFont(14);
    btn.tag = 30;
    btn.backgroundColor = REColor(247, 100, 66);
    [btn setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(isAgreeAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - public
+ (REReadingEarnPopupView *)readingEarnPopupViewWithType:(REReadingEarnPopupViewsEnum)type {
    return [[REReadingEarnPopupView alloc] initWithFrame:CGRectZero withType:type];
}

- (void)showPopupViewWithData:(id)model {
    [self.myWindow addSubview:self];
    
    if (self.type == REReadingEarnPopupView_ContactCustomerService) {
        self.backgroundColor = REWhiteColor;
        self.layer.cornerRadius = 10;
        self.frame = CGRectMake(16, (REScreenHeight - REScreenWidth-32)/2, REScreenWidth-32, REScreenWidth-32);
        self.model = model;
        [self contactCustomerService];
    } else if (self.type == REReadingEarnPopupView_ExchangeYDC) {
        self.backgroundColor = REWhiteColor;
        self.layer.cornerRadius = 10;
        self.frame = CGRectMake(16,ratioH(232), REScreenWidth-32, ratioH(209));

        [self ExchangeYDC];
    }  else if (self.type == REReadingEarnPopupView_Recharge) {
       self.layer.cornerRadius = 10;
       self.frame = CGRectMake(16,(REScreenHeight-ratioH(344)-ratioH(48))/2, REScreenWidth-32, ratioH(344)+ratioH(48));
        self.useWalletModel = model;
        [self Recharge];
    } else if (self.type == REReadingEarnPopupView_Recharge2) {
         self.layer.cornerRadius = 10;
         self.frame = CGRectMake(16,(REScreenHeight-ratioH(344)-ratioH(48))/2, REScreenWidth-32, ratioH(344)+ratioH(48));
          self.data = [NSString stringWithFormat:@"%@",model];
          [self Recharge2];
    } else if (self.type == REReadingEarnPopupView_PlayReward) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = REWhiteColor;
        self.frame = CGRectMake(16,(REScreenHeight-ratioH(344)-ratioH(48))/2, REScreenWidth-32, 272);
        self.gratypeArray = model;
        [self PlayReward];
    } else if (self.type == REReadingEarnPopupView_SignIn) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = REWhiteColor;
        self.frame = CGRectMake(16,NavHeight+ratioH(134), REScreenWidth-32, 253);
        self.model = model;
        [self SignIn];
    } else if (self.type == REReadingEarnPopupView_ImmediateRecharge) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = REWhiteColor;
        self.frame = CGRectMake(16,NavHeight+ratioH(134), REScreenWidth-32, 272);
        [self ImmediateRecharge];
    }  else if (self.type == REReadingEarnPopupView_UserAgreement) {
           self.layer.cornerRadius = 10;
           self.backgroundColor = REWhiteColor;
           self.frame = CGRectMake(16,100, REScreenWidth-32, REScreenHeight-200);
           [self UserAgreement];
    }
}

//联系客服
- (void)contactCustomerService {
    //1.
    UILabel *nameLabel = [self viewWithTag:10];
    nameLabel.text = @"联系客服";
    nameLabel.frame = CGRectMake(0, ratioH(20), self.width, ratioH(20));
    
    //2.
    UIImageView *QRcodeImageView = [self viewWithTag:20];
    QRcodeImageView.frame = CGRectMake(80, ratioH(70), self.width - 160, self.width - 160);
    [QRcodeImageView sd_setImageWithURL:[NSURL URLWithString:[self.model objectForKey:@"public_logo"]] placeholderImage:PlaceholderImage];
    //3.
    UIButton *closeButton = [self viewWithTag:30];
    closeButton.frame = CGRectMake(self.width - 40, ratioH(20), 20, 20);
}

//兑换ydc和 购买
- (void)ExchangeYDC {
    //1.
    UILabel *titleLabel = [self viewWithTag:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:@"安全校验" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 18], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    titleLabel.attributedText = titleLabelstring;
    titleLabel.frame = CGRectMake(0, ratioH(24), self.width, ratioH(25));
    
    //2.
    UILabel *describeLabel = [self viewWithTag:20];
    NSMutableAttributedString *describeLabelstring = [[NSMutableAttributedString alloc] initWithString:@"请输入安全校验密码" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:158/255.0 green:160/255.0 blue:164/255.0 alpha:1.0]}];
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.attributedText = describeLabelstring;
    describeLabel.frame = CGRectMake(0, ratioH(65), self.width, ratioH(20));
    
    //3.
    CRBoxInputView *boxInputView = [self viewWithTag:30];
    boxInputView.ifNeedSecurity = YES;
    boxInputView.securityDelay = CRBoxSecurityCustomViewType;
    boxInputView.frame = CGRectMake(21, ratioH(97), self.width-42, 44);
    __weak typeof (self)weekself = self;
    boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        __strong typeof (weekself)strongself = weekself;
        strongself.boxInputViewstr = text;
        objc_setAssociatedObject(strongself.certainButton, "firstObject", self.boxInputViewstr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    };
    [boxInputView clearAllWithBeginEdit:YES]; // BeginEdit:清空后是否自动启用编辑模式

    //4.
    UIButton *certainButton = [self viewWithTag:40];
    certainButton.frame = CGRectMake(32, ratioH(155), self.width-64, ratioH(35));
    
    //5.
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 40, ratioH(20), 20, 20);
}

//充值
- (void)Recharge {
    
    //1.
    UIImageView *bgImageView = [self viewWithTag:10];
    bgImageView.frame = CGRectMake(0, 0, self.width, ratioH(344));
    bgImageView.image = REImageName(@"re_popup_bg");
    
    //2.
    UIImageView *moneySymbolImageView = [self viewWithTag:20];
    [moneySymbolImageView sd_setImageWithURL:[NSURL URLWithString:self.useWalletModel.logo] placeholderImage:PlaceholderImage];
    moneySymbolImageView.frame = CGRectMake((self.width-ratioH(32))/2, ratioH(30), ratioH(32), ratioH(32));
    
    //3.
    UIImageView *QRcodeImageView = [self viewWithTag:30];
    QRcodeImageView.frame = CGRectMake((self.width - ratioH(200))/2, moneySymbolImageView.bottom+ratioH(12), ratioH(200), ratioH(200));
    QRcodeImageView.image=[ToolObject createNonInterpolatedUIImageFormCIImage:[ToolObject creatQRcodeWithUrlstring:self.useWalletModel.data.address] withSize:150];
    //4.
    UIButton *closeButton = [self viewWithTag:60];
    closeButton.frame = CGRectMake((self.width-ratioH(32))/2, bgImageView.bottom+ratioH(12), ratioH(32), ratioH(32));
    
    //5.
    UILabel *codeLabel = [self viewWithTag:40];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.useWalletModel.data.address attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]}];
    codeLabel.attributedText = string;
    codeLabel.frame = CGRectMake(32, QRcodeImageView.bottom+ratioH(14), self.width-64, 15);
    
    //6.
    UIButton *copyButton = [self viewWithTag:50];
    copyButton.frame = CGRectMake((self.width-80)/2, codeLabel.bottom+ratioH(10), 80, ratioH(25));
    objc_setAssociatedObject(copyButton, @"index", self.useWalletModel.data.address,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//充值
- (void)Recharge2 {
    
    //1.
    UIImageView *bgImageView = [self viewWithTag:10];
    bgImageView.frame = CGRectMake(0, 0, self.width, ratioH(344));
    bgImageView.image = REImageName(@"re_popup_bg");
    
    //2.
    UIImageView *moneySymbolImageView = [self viewWithTag:20];
//    [moneySymbolImageView sd_setImageWithURL:[NSURL URLWithString:self.useWalletModel.logo] placeholderImage:PlaceholderImage];
    moneySymbolImageView.frame = CGRectMake((self.width-ratioH(32))/2, ratioH(30), ratioH(32), ratioH(32));
    
    //3.
    UIImageView *QRcodeImageView = [self viewWithTag:30];
    QRcodeImageView.frame = CGRectMake((self.width - ratioH(200))/2, moneySymbolImageView.bottom+ratioH(12), ratioH(200), ratioH(200));
    QRcodeImageView.image=[ToolObject createNonInterpolatedUIImageFormCIImage:[ToolObject creatQRcodeWithUrlstring:self.data] withSize:150];
    //4.
    UIButton *closeButton = [self viewWithTag:60];
    closeButton.frame = CGRectMake((self.width-ratioH(32))/2, bgImageView.bottom+ratioH(12), ratioH(32), ratioH(32));
    
    //5.
    UILabel *codeLabel = [self viewWithTag:40];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.data attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]}];
    codeLabel.attributedText = string;
    codeLabel.frame = CGRectMake(32, QRcodeImageView.bottom+ratioH(14), self.width-64, 15);
    
    //6.
    UIButton *copyButton = [self viewWithTag:50];
    copyButton.frame = CGRectMake((self.width-80)/2, codeLabel.bottom+ratioH(10), 80, ratioH(25));
    objc_setAssociatedObject(copyButton, @"index", self.data,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)PlayReward {
    self.gratype_idStr = @"";
    if (self.gratypeArray.count <1) {
        return;
    }
    
    
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 40, ratioH(20), 20, 20);
    
    //1.
    UILabel *titleLabel = [self viewWithTag:60];
    NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:@"打赏作品" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 18], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    titleLabel.attributedText = titleLabelstring;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    titleLabel.frame = CGRectMake(0, 42, self.width, 25);
    //2.
    for (int i=0; i< self.gratypeArray.count; i++) {
        REGraTypeModel *model = self.gratypeArray[i];
        UIButton *playRewardButton = [self viewWithTag:70+i];
        playRewardButton.frame = CGRectMake(32+i*(48+((self.width-64-48*4))/3), 103, 48, 78);
        objc_setAssociatedObject(playRewardButton,"firstObject", model.grainfo_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIImageView *playRewardImageView = [playRewardButton viewWithTag:80+i];
        playRewardImageView.frame = CGRectMake(0, 0, 48, 48);
        [playRewardImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
        
        NSString *moneyStr = [NSString stringWithFormat:@"%@币",model.money];
        UILabel *moneyLabel = [playRewardButton viewWithTag:90+i];
        moneyLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        moneyLabel.font = REFont(14);
        moneyLabel.text = moneyStr;
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.frame = CGRectMake(0, playRewardImageView.bottom+10, 48, 20);
        
    }

    //3.
    UIButton *sureButton = [self viewWithTag:100];
    sureButton.layer.cornerRadius = 20;
    sureButton.frame = CGRectMake(16, 216, self.width-32, 40);
}

- (void)SignIn {
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 40, ratioH(20), 20, 20);
    
    //1.
    UILabel *titileLabel = [self viewWithTag:10];
    titileLabel.textColor = REColor(51, 51, 51);
    titileLabel.frame = CGRectMake(0, 42, self.width, 25);
    NSString *modelStr = [NSString stringWithFormat:@"%@",[self.model objectForKey:@"sign_day"]];
    NSString *text = [NSString stringWithFormat:@"连续签到%@天奖励",modelStr];
    titileLabel.text = text;
    [ToolObject LabelAttributedString:titileLabel FontNumber:REFont(18) AndRange:NSMakeRange(4, modelStr.length) AndColor:REColor(247, 100, 66)];
    
    //2.
    UIImageView *signInImageView = [self viewWithTag:20];
    signInImageView.image = REImageName(@"sign_image");
    signInImageView.frame = CGRectMake((self.width-48)/2, 87, 48, 48);
    
    //3.
    UILabel *numLabel = [self viewWithTag:30];
    numLabel.textColor = REColor(51, 51, 51);
    numLabel.frame = CGRectMake(0, signInImageView.bottom+12, self.width, 20);
    NSString *modelnumStr = [NSString stringWithFormat:@"%@",[self.model objectForKey:@"sign_reward"]];
    NSString *numtext = [NSString stringWithFormat:@"+%@%@",modelnumStr,[self.model objectForKey:@"symbol"]];
    numLabel.text = numtext;
    [ToolObject LabelAttributedString:numLabel FontNumber:REFont(14) AndRange:NSMakeRange(0, modelnumStr.length+1) AndColor:REColor(247, 100, 66)];

    //4.
    UIButton *certainButton = [self viewWithTag:40];
    certainButton.layer.cornerRadius = 20;
    certainButton.frame = CGRectMake(16, numLabel.bottom+20, self.width-32, 40);
}

- (void)ImmediateRecharge {
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 40, ratioH(20), 20, 20);
    
    //1.
    UILabel *titileLabel = [self viewWithTag:10];
    titileLabel.frame = CGRectMake(0, 42, self.width, 25);
    titileLabel.text = @"温馨提示";
    
    //2.
    UIImageView *bookImageView = [self viewWithTag:20];
    bookImageView.image = REImageName(@"book_d");
    bookImageView.frame = CGRectMake(32, 82, 89, 110);
    
    //3.
    UILabel *tipsLabel = [self viewWithTag:30];
    tipsLabel.textColor = REColor(51, 51, 51);
    tipsLabel.frame = CGRectMake(141, titileLabel.bottom+42, 158, 50);
    tipsLabel.text = @"您的书币余额不足,请及时充值";
    
    //4.
    UIImageView *mybookImageView = [self viewWithTag:40];
    mybookImageView.image = REImageName(@"mybook_d");
    mybookImageView.frame = CGRectMake(self.width-27-46, 164, 46, 37);

    //5.
    UIButton *certainButton = [self viewWithTag:60];
    certainButton.layer.cornerRadius = 20;
    certainButton.frame = CGRectMake(16, titileLabel.bottom+158, self.width-32, 40);
}

- (void)UserAgreement {
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 40, ratioH(20), 20, 20);
    
    //1.
    UILabel *titileLabel = [self viewWithTag:10];
    titileLabel.frame = CGRectMake(0, 42, self.width, 25);
    titileLabel.text = @"交易必知";
    
    //2.
    UITextView *textView = [self viewWithTag:20];
    textView.frame = CGRectMake(12, 87, self.width-24, self.height - 187);
    textView.font = REFont(15);
    textView.text = @"买卖双方需严格遵守平台指导价进行交易！严禁溢价超出平台规定的价格进行交易！此类交易不受监管保护！希望各位书友积极维护自身权益，拒绝高价收售！\n1．交易市场每日开放时间：10:00-20:00\n2．确认打款、收款的时间为1小时。\n3．超过1小时买家不付款、系统自动取消订单。\n4．超过1小时卖家不确认、不投诉，系统将自动确认订单。\n5．买家买后不付款，属于恶意行为，平台进行一次封号7天处理，二次永久封号。";
    
    //3.
    UIButton *btn = [self viewWithTag:30];
    btn.layer.cornerRadius = 22.5;
    btn.frame = CGRectMake(12, self.height-75, self.width-24, 45);
    [btn setTitle:@"同意" forState:UIControlStateNormal];
}

- (void)closeThePopupView {
    self.coverView.hidden = YES;
    self.hidden = YES;
    [self removeFromSuperview];
    [self.coverView removeFromSuperview];
}

#pragma mark - private

#pragma mark - 事件回调
- (void)certainButtonAction:(UIButton *)sender {
    NSString *first = objc_getAssociatedObject(sender, "firstObject");
    if (self.exchangeYDCBlock) {
        self.exchangeYDCBlock(sender,first);
    }
}

- (void)copyButtonAction:(UIButton *)sender {
    NSString *addressStr = objc_getAssociatedObject(sender, @"index");
    if (self.copyQRcodeAddressBlock) {
        self.copyQRcodeAddressBlock(sender,addressStr);
    }
}

- (void)sureButtonAction:(UIButton *)sender {
    if ([self.gratype_idStr isEqualToString:@""]) {
        [self closeThePopupView];
    } else {
        [self closeThePopupView];
        if (self.graTypeBlock) {
            self.graTypeBlock(sender,self.gratype_idStr);
        }
    }
}

- (void)playRewardButtonAction:(UIButton *)sender {
    UIButton *btn = [self viewWithTag:self.btnTag];
    UIImageView *btnImageView = [btn viewWithTag:self.btnTag+10];
    UIImageView *imageView = [sender viewWithTag:sender.tag+10];
    
    if (sender.selected == YES) {
        self.btnTag = sender.tag;
    } else {
        sender.selected = NO;
        self.btnTag = sender.tag;
        
        CALayer *layer=[imageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:24.0];
        [layer setBorderWidth:1];
        [layer setBorderColor:[[UIColor redColor] CGColor]];
        
        CALayer *layers=[btnImageView layer];
        [layers setMasksToBounds:NO];
        [layers setCornerRadius:0];
        [layers setBorderWidth:0];
        [layers setBorderColor:[[UIColor clearColor] CGColor]];
    }
    
    NSString *first = objc_getAssociatedObject(sender,"firstObject");
    self.gratype_idStr = first;
}

- (void)certainSignInButtonAction:(UIButton *)sender {
    [self closeThePopupView];
}

- (void)immediateRechargeAction:(UIButton *)sender {
    if (self.immediateRechargeBlock) {
        self.immediateRechargeBlock(sender);
    }
}

- (void)isAgreeAction:(UIButton *)sender {
    [self closeThePopupView];
    if (self.isAgreeBlock) {
        self.isAgreeBlock(sender);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
