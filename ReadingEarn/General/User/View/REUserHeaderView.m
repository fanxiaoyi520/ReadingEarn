//
//  REUserHeaderView.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/18.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REUserHeaderView.h"

@interface REUserHeaderView ()

@property (nonatomic ,strong)CAGradientLayer *gradientLayer;
@property (nonatomic ,strong)UILabel *loginStatusLabel;     //改为用户名
@property (nonatomic ,strong)UIButton *setButton;
@property (nonatomic ,strong)UIButton *toSignInBUutton;
@property (nonatomic ,strong)UIView *btnView;
@property (nonatomic ,strong)UIView *functionBackView;
@property (nonatomic ,strong)UIView *walletView;
@property (nonatomic ,strong)CAGradientLayer *gradientLayer2;
@property (nonatomic ,strong)UIImageView *walletImageView;
@property (nonatomic ,strong)UILabel *tishiLabel;
@property (nonatomic ,strong)UIView *btnBackView;
@property (nonatomic ,strong)UIButton *generateWalletBtn;
@property (nonatomic ,strong)UIButton *headButton;
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *activityLevelLabel;
@property (nonatomic ,strong)UIImageView *vipImageView;
@property (nonatomic ,strong)UILabel *authenticationStatusLabel;

//已经生成钱包地址
@property (nonatomic ,strong)UILabel *codeaddressLabel;
@property (nonatomic ,strong)UIButton *addressCopyButton;
@property (nonatomic ,strong)UILabel *totalYDCLabel;
@property (nonatomic ,strong)UIButton *withdrawMoneyButton;
@property (nonatomic ,strong)UIButton *exchangeButton;
@property (nonatomic ,strong)UIButton *ReceivablesButton;
@end

@implementation REUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    //1.个人信息背景图
    UIView *backView = [UIView new];
    backView.userInteractionEnabled = YES;
    CAGradientLayer *gl = [CAGradientLayer layer];
    self.gradientLayer = gl;
    gl.startPoint = CGPointMake(-0.10951936990022659, 0.11703116446733475);
    gl.endPoint = CGPointMake(1.2151217460632324, 0.610962986946106);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [backView.layer addSublayer:gl];
    [self addSubview:backView];
    
    //a.头像
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headButton = headButton;
    [headButton setImage:REImageName(@"default_head") forState:UIControlStateNormal];
    [headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headButton];
    
    UIImageView *headImageView = [UIImageView new];
    self.headImageView = headImageView;
    [headButton addSubview:headImageView];
    
    UIImageView *vipImageView = [UIImageView new];
    self.vipImageView = vipImageView;
    [headButton addSubview:vipImageView];
    //b.用户名 活跃度
    UILabel *loginStatusLabel = [UILabel new];
    self.loginStatusLabel = loginStatusLabel;
    loginStatusLabel.textAlignment = NSTextAlignmentLeft;
    loginStatusLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [self addSubview:loginStatusLabel];
    
    UILabel *activityLevelLabel = [UILabel new];
    [self addSubview:activityLevelLabel];
    self.activityLevelLabel = activityLevelLabel;
    activityLevelLabel.textAlignment = NSTextAlignmentLeft;
    activityLevelLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    UILabel *authenticationStatusLabel = [UILabel new];
    [self addSubview:authenticationStatusLabel];
    self.authenticationStatusLabel = authenticationStatusLabel;
    authenticationStatusLabel.textAlignment = NSTextAlignmentLeft;
    authenticationStatusLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    //c.设置----------去掉了
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setButton = setButton;
    [setButton setImage:REImageName(@"tubiao_two") forState:UIControlStateNormal];
    //[setButton addTarget:self action:@selector(setButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:setButton];
    //d.去签到
    UIView *btnView = [UIView new];
    btnView.backgroundColor = REWhiteColor;
    [self addSubview:btnView];
    self.btnView = btnView;
    
    UIButton *toSignInBUutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toSignInBUutton = toSignInBUutton;
    toSignInBUutton.titleLabel.font = REFont(12);
    [toSignInBUutton addTarget:self action:@selector(toSignInBUuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:toSignInBUutton];
    //f.阅币 我的团度 总收益
    for (int i=0; i<3; i++) {
        UILabel *contentLabel = [UILabel new];
        contentLabel.tag = 100 + i;
        contentLabel.textColor = REWhiteColor;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:contentLabel];
        
        UILabel *numLabel = [UILabel new];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = 200 + i;
        numLabel.textColor = REWhiteColor;
        [self addSubview:numLabel];
    }
    
    //2.功能模块
    UIView *functionBackView = [UIView new];
    functionBackView.userInteractionEnabled = YES;
    functionBackView.backgroundColor = REWhiteColor;
    functionBackView.layer.shadowColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.20].CGColor;
    functionBackView.layer.shadowOffset = CGSizeMake(0,2);
    functionBackView.layer.shadowRadius = 10;
    functionBackView.layer.shadowOpacity = 1;
    functionBackView.layer.cornerRadius = 16;
    self.functionBackView = functionBackView;
    [self addSubview:functionBackView];
    
    for (int i=0; i<4; i++) {
        UIButton *funButton = [UIButton buttonWithType:UIButtonTypeCustom];
        funButton.tag = 300+i;
        [funButton addTarget:self action:@selector(funButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [functionBackView addSubview:funButton];

        UIImageView *funImageView = [UIImageView new];
        funImageView.tag = 310+i;
        [funButton addSubview:funImageView];

        UILabel *funLabel = [UILabel new];
        funLabel.tag = 320+i;
        funLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [funButton addSubview:funLabel];
    }
    
//    for (int i=0; i<3; i++) {
//        UIButton *funButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        funButton.tag = 300+i;
//        [funButton addTarget:self action:@selector(funButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [functionBackView addSubview:funButton];
//
//        UIImageView *funImageView = [UIImageView new];
//        funImageView.tag = 310+i;
//        [funButton addSubview:funImageView];
//
//        UILabel *funLabel = [UILabel new];
//        funLabel.tag = 320+i;
//        funLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
//        [funButton addSubview:funLabel];
//    }

    
    //3.生成钱包地址
    UIView *walletView = [[UIView alloc] init];
    walletView.userInteractionEnabled = YES;
    CAGradientLayer *g2 = [CAGradientLayer layer];
    self.gradientLayer2 = g2;
    g2.startPoint = CGPointMake(-0.10951936990022659, 0.11703116446733475);
    g2.endPoint = CGPointMake(1.2151217460632324, 0.610962986946106);
    g2.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor];
    g2.locations = @[@(0),@(1.0f)];
    [backView.layer addSublayer:g2];
    g2.cornerRadius = 16;
    [self addSubview:walletView];
    self.walletView = walletView;
    
    //a.
    UIImageView *walletImageView = [UIImageView new];
    [walletView addSubview:walletImageView];
    self.walletImageView = walletImageView;
    
    //************************未生成钱包地址**************************//
    //b
    UILabel *tishiLabel = [UILabel new];
    NSMutableAttributedString *tishistring = [[NSMutableAttributedString alloc] initWithString:@"您还未生成钱包地址" attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: REBackColor}];
    tishiLabel.attributedText = tishistring;
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    tishiLabel.textColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [walletView addSubview:tishiLabel];
    self.tishiLabel = tishiLabel;
    
    //c
    UIView *btnBackView = [UIView new];
    btnBackView.backgroundColor = REWhiteColor;
    [walletView addSubview:btnBackView];
    self.btnBackView = btnBackView;
    
    UIButton *generateWalletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [generateWalletBtn addTarget:self action:@selector(generateWalletBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [generateWalletBtn setTitle:@"生成钱包地址" forState:UIControlStateNormal];
    [generateWalletBtn setTitleColor:REWhiteColor forState:UIControlStateNormal];
    generateWalletBtn.titleLabel.font = REFont(14);
    generateWalletBtn.backgroundColor = REColor(255, 128, 49);
    [walletView addSubview:generateWalletBtn];
    self.generateWalletBtn = generateWalletBtn;
    
    
     //************************已经生成钱包地址**************************//
    //a.
    UILabel *codeaddressLabel = [UILabel new];
    self.codeaddressLabel = codeaddressLabel;
    [walletView addSubview:codeaddressLabel];
    codeaddressLabel.hidden = YES;

    //b.
    UIButton *addressCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressCopyButton = addressCopyButton;
    [walletView addSubview:addressCopyButton];
    [addressCopyButton addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    addressCopyButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    addressCopyButton.tag = 1000;
    addressCopyButton.layer.borderWidth = 1;
    addressCopyButton.layer.cornerRadius = 10;
    [addressCopyButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [addressCopyButton setTitle:@"复制" forState:UIControlStateNormal];
    addressCopyButton.titleLabel .font = REFont(12);
    addressCopyButton.hidden = YES;
    
    //c totalYDCLabel
    UILabel *totalYDCLabel = [UILabel new];
    self.totalYDCLabel= totalYDCLabel;
    totalYDCLabel.textAlignment = NSTextAlignmentCenter;
    [walletView addSubview:totalYDCLabel];
    totalYDCLabel.hidden = YES;
    totalYDCLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    //d
    NSArray *walletArray = @[@"提币",@"兑换",@"充值",@"转账"];
    for (int i=0; i<walletArray.count; i++) {
        UIButton *walletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [walletView addSubview:walletButton];
        [walletButton addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        walletButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        walletButton.tag = 1001+i;
        walletButton.layer.borderWidth = 1;
        walletButton.layer.cornerRadius = 13;
        walletButton.titleLabel .font = REFont(14);
        walletButton.hidden = YES;
    }
}

- (void)showUserHeaderModel:(REUserModel *)model withWalletModel:(nonnull REUseWalletModel *)walletModel auditStatusStr:(nonnull NSString *)auditStatusStr is_TransferAccountsShowStr:(NSString *)is_TransferAccountsShowStr {

    //1.
    self.gradientLayer.frame = CGRectMake(0, 0, REScreenWidth, 228);
    //a.
    self.headButton.frame = CGRectMake(20, 62, 48, 48);
    self.headImageView.frame = CGRectMake(0, 0, 48, 48);
    self.headImageView.layer.cornerRadius = 24;
    self.headImageView.layer.masksToBounds = YES;

    
    self.vipImageView.frame = CGRectMake(30, 30, 18, 18);
    //b.
    self.loginStatusLabel.frame = CGRectMake(84, 68, 150, 18);
    self.activityLevelLabel.frame = CGRectMake(84, 94, 150, 12);
    self.authenticationStatusLabel.frame = CGRectMake(84, self.activityLevelLabel.bottom+8, 150, 12);
    //设置 ----去掉了
//    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-92);
//        make.top.mas_equalTo(self).offset(78);
//    }];
    
    //d.
    self.btnView.frame = CGRectMake(REScreenWidth-77, 71, 76.5, 30);
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.btnView.bounds   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft    cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.btnView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.btnView.layer.mask = maskLayer1;
    //去签到
    if ([model.sign_status isEqualToString:@"0"]) {
        [self.toSignInBUutton setTitle:@"去签到" forState:UIControlStateNormal];
        [self.toSignInBUutton setImage:REImageName(@"tubiao_one") forState:UIControlStateNormal];
        self.toSignInBUutton.backgroundColor = REColor(255, 120, 49);
        [self.toSignInBUutton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    } else {
        [self.toSignInBUutton setTitle:@"已签到" forState:UIControlStateNormal];
        [self.toSignInBUutton setImage:REImageName(@"tu_biao_qiandao") forState:UIControlStateNormal];
        self.toSignInBUutton.backgroundColor = REWhiteColor;
        [self.toSignInBUutton setTitleColor:REColor(255, 120, 49) forState:UIControlStateNormal];
    }
    self.toSignInBUutton.frame = CGRectMake(REScreenWidth-76, 72, 80, 28);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.toSignInBUutton.bounds   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft    cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.toSignInBUutton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.toSignInBUutton.layer.mask = maskLayer;
    
    //f.
    for (int i=0; i<3; i++) {
        UILabel *contentLabel = [self viewWithTag:100+i];
        contentLabel.frame = CGRectMake(i*REScreenWidth/3, 136, REScreenWidth/3, 11);
        
        UILabel *numLabel = [self viewWithTag:200+i];
        numLabel.frame = CGRectMake(i*REScreenWidth/3, 153, REScreenWidth/3, 22);
    }
        
    //2.
    self.functionBackView.frame = CGRectMake(20, 194, REScreenWidth-40, 98);
    NSArray *imageArray = @[@"user_toolbar_icon_kind",@"toolbar_icon_bangdan",@"user_toolbar_icon_free",@"toolbar_icon_finish@3x"];
    NSArray *labelArray = @[@"我的书友",@"阅读包",@"交易市场",@"推荐码"];
    for (int i=0; i<4; i++) {
        UIButton *funButton = [self.functionBackView viewWithTag:300+i];
        funButton.frame = CGRectMake(i*((REScreenWidth-32-3*7)/4 +7), 0, (REScreenWidth-32-3*7)/4, 98);

        UIImageView *funImageView =[self.functionBackView viewWithTag:310+i];
        funImageView.image = REImageName(imageArray[i]);
        funImageView.frame = CGRectMake(((REScreenWidth-32-3*7)/4-36)/2, 20, 36, 36);

        UILabel *funLabel = [self.functionBackView viewWithTag:320+i];
        funLabel.textAlignment = NSTextAlignmentCenter;
        funLabel.frame = CGRectMake(0, 60, (REScreenWidth-40)/4, 17);
        NSMutableAttributedString *funstring = [[NSMutableAttributedString alloc] initWithString:labelArray[i] attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        funLabel.attributedText = funstring;
    }
//    self.functionBackView.frame = CGRectMake(20, 194, REScreenWidth-40, 98);
//    NSArray *imageArray = @[@"user_toolbar_icon_kind",@"toolbar_icon_bangdan",@"toolbar_icon_finish@3x"];
//    NSArray *labelArray = @[@"我的书友",@"阅读包",@"推荐码"];
//    for (int i=0; i<3; i++) {
//        UIButton *funButton = [self.functionBackView viewWithTag:300+i];
//        funButton.frame = CGRectMake(i*((REScreenWidth-32-3*7)/3 +7), 0, (REScreenWidth-32-2*7)/4, 98);
//
//        UIImageView *funImageView =[self.functionBackView viewWithTag:310+i];
//        funImageView.image = REImageName(imageArray[i]);
//        funImageView.frame = CGRectMake(((REScreenWidth-32-2*7)/3-36)/2, 20, 36, 36);
//
//        UILabel *funLabel = [self.functionBackView viewWithTag:320+i];
//        funLabel.textAlignment = NSTextAlignmentCenter;
//        funLabel.frame = CGRectMake(0, 60, (REScreenWidth-40)/3, 17);
//        NSMutableAttributedString *funstring = [[NSMutableAttributedString alloc] initWithString:labelArray[i] attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
//        funLabel.attributedText = funstring;
//    }

    //************************没有生成钱包地址**************************//
    //3.
    self.walletView.frame = CGRectMake(16, 308, REScreenWidth-16*2, 160);
    self.gradientLayer2.frame = CGRectMake(16, 308, REScreenWidth-16*2, 160);
    
    //a.
    self.walletImageView.frame = CGRectMake(12, 12, 32, 32);
    [self.walletImageView sd_setImageWithURL:[NSURL URLWithString:walletModel.logo] placeholderImage:nil];
    //b
    self.tishiLabel.frame = CGRectMake(0, 60, REScreenWidth-16*2, 18);
    //c.
    self.btnBackView.frame = CGRectMake(114, 107, REScreenWidth-40-2*114, 28);
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:self.btnBackView.bounds   byRoundingCorners: UIRectCornerAllCorners     cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer3 = [[CAShapeLayer alloc] init];
    maskLayer3.frame = self.btnBackView.bounds;
    maskLayer3.path = maskPath3.CGPath;
    self.btnBackView.layer.mask = maskLayer3;
    
    self.generateWalletBtn.frame = CGRectMake(115, 108,REScreenWidth-40-2*115, 26);
    UIBezierPath *maskPath4 = [UIBezierPath bezierPathWithRoundedRect:self.generateWalletBtn.bounds   byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer4 = [[CAShapeLayer alloc] init];
    maskLayer4.frame = self.generateWalletBtn.bounds;
    maskLayer4.path = maskPath4.CGPath;
    self.generateWalletBtn.layer.mask = maskLayer4;
    
    //************************已经生成钱包地址**************************//
    //a
    self.codeaddressLabel.frame = CGRectMake(71, 42, 150, 15);
    self.codeaddressLabel.textColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];

    //b.
    self.addressCopyButton.frame = CGRectMake(233, 40, 40, 20);
    //c
    self.totalYDCLabel.frame = CGRectMake(0, 72, self.walletView.width, 32);
    
    //d.
    NSArray *walletArray;
    if ([is_TransferAccountsShowStr isEqualToString:@"1"]) {
        //显示
        walletArray = @[@"提币",@"兑换",@"充值",@"转账"];
        for (int i = 0; i<walletArray.count; i++) {
            UIButton *walletButton = [self.walletView viewWithTag:1001+i];
            [walletButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
            [walletButton setTitle:walletArray[i] forState:UIControlStateNormal];
            walletButton.frame = CGRectMake(30+i*(57+(self.walletView.width-57*walletArray.count-30*2)/(walletArray.count-1)), 116, 57, 26);
        }
    } else {
        
        UIButton *walletButtons = [self.walletView viewWithTag:1004];
        walletButtons.hidden = YES;
        walletArray = @[@"提币",@"兑换",@"充值"];
        for (int i = 0; i<walletArray.count; i++) {
            UIButton *walletButton = [self.walletView viewWithTag:1001+i];
            [walletButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
            [walletButton setTitle:walletArray[i] forState:UIControlStateNormal];
            walletButton.frame = CGRectMake(30+i*(57+(self.walletView.width-57*walletArray.count-30*2)/(walletArray.count-1)), 116, 57, 26);
        }

    }


    if (walletModel != nil) {
        self.codeaddressLabel.hidden = NO;
        NSMutableAttributedString *codeaddressLabelstring = [[NSMutableAttributedString alloc] initWithString:walletModel.data.address attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]}];
        self.codeaddressLabel.attributedText = codeaddressLabelstring;

        
        self.codeaddressLabel.hidden = NO;
        NSNumber * nsNumber = @(walletModel.data.total.floatValue);
        NSString * outNumber = [NSString stringWithFormat:@"%@",nsNumber];
        NSString *totalStr = [NSString stringWithFormat:@"%@YDC",outNumber];
        NSMutableAttributedString *totalYDCLabelstring = [[NSMutableAttributedString alloc] initWithString:totalStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 30], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.totalYDCLabel.attributedText = totalYDCLabelstring;

        
        self.addressCopyButton.hidden = NO;
        objc_setAssociatedObject(self.addressCopyButton, @"address", walletModel.data.address,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        self.totalYDCLabel.hidden = NO;
        for (int i = 0; i<walletArray.count; i++) {
            UIButton *walletButton = [self.walletView viewWithTag:1001+i];
            walletButton.hidden = NO;
        }
        
        self.tishiLabel.hidden = YES;
        self.generateWalletBtn.hidden = YES;
        self.btnBackView.hidden = YES;
        
    } else {
        self.codeaddressLabel.hidden = YES;
        self.codeaddressLabel.hidden = YES;
        self.addressCopyButton.hidden = YES;
        self.totalYDCLabel.hidden = YES;
        for (int i = 0; i<walletArray.count; i++) {
            UIButton *walletButton = [self.walletView viewWithTag:1001+i];
            walletButton.hidden = YES;
        }

        self.tishiLabel.hidden = NO;
        self.generateWalletBtn.hidden = NO;
        self.btnBackView.hidden = NO;
    }
    
    if (!model) {
        //默认
        self.headImageView.image = PlaceholderHead_Image;
        
        NSMutableAttributedString *activityLevelLabelstring = [[NSMutableAttributedString alloc] initWithString:@"用户等级: 0" attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.activityLevelLabel.attributedText = activityLevelLabelstring;
        
        NSMutableAttributedString *authenticationStatusLabelstring = [[NSMutableAttributedString alloc] initWithString:@"未认证" attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.authenticationStatusLabel.attributedText = authenticationStatusLabelstring;
        
        NSArray *array = @[@" 阅币(YC)",@"我的团队",@"总收益(YDC)"];
        NSArray *numArray = @[@"0.00",@"0",@"0.00"];
        for (int i=0; i<3; i++) {
            UILabel *contentLabel = [self viewWithTag:100+i];
            NSMutableAttributedString *contentstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: REFont(11), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
            contentLabel.attributedText = contentstring;
            
            NSMutableAttributedString *numstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: REFont(22), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
            UILabel *numLabel = [self viewWithTag:200+i];
            numLabel.attributedText = numstring;
        }
        return;
    } else {
        //头像
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];
        [self.vipImageView sd_setImageWithURL:[NSURL URLWithString:model.vip_icon] placeholderImage:PlaceholderHead_Image];
        //用户名 活跃度
        NSMutableAttributedString *loginStatusstring = [[NSMutableAttributedString alloc] initWithString:model.nickname attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.loginStatusLabel.attributedText = loginStatusstring;
        
        NSString *actityLabel = [NSString stringWithFormat:@"用户等级: %@",model.vip_rank];
        NSMutableAttributedString *activityLevelLabelstring = [[NSMutableAttributedString alloc] initWithString:actityLabel attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.activityLevelLabel.attributedText = activityLevelLabelstring;
        
        NSString *authenticationStatus;
        if ([auditStatusStr isEqualToString:@"认证信息成功"]) {
            authenticationStatus = @"已认证";
        } else {
            authenticationStatus = @"未认证";
        }
        NSMutableAttributedString *authenticationStatusLabelstring = [[NSMutableAttributedString alloc] initWithString:authenticationStatus attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.authenticationStatusLabel.attributedText = authenticationStatusLabelstring;

        //f
        NSString *yc = [NSString stringWithFormat:@"阅币(%@)",model.YC];
        NSString *ydc = [NSString stringWithFormat:@"总收益(%@)",model.YDC];
        NSArray *array = @[yc,@"活跃度",ydc];
        
        NSString *currency_reading = [ToolObject getRoundFloat:[model.currency_reading floatValue] withPrecisionNum:2];
        NSString *total_profit = [ToolObject getRoundFloat:[model.total_profit floatValue] withPrecisionNum:2];
        NSArray *numArray = @[currency_reading,model.active,total_profit];
        for (int i=0; i<3; i++) {
            UILabel *contentLabel = [self viewWithTag:100+i];
            NSMutableAttributedString *contentstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: REFont(11), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
            contentLabel.attributedText = contentstring;

            
            NSMutableAttributedString *numstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: REFont(22), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
            UILabel *numLabel = [self viewWithTag:200+i];
            numLabel.attributedText = numstring;
        }
    }
}

#pragma mark - 事件
- (void)headButtonAction:(UIButton *)sender {
    NSLog(@"点击了头像");
}

- (void)toSignInBUuttonAction:(UIButton *)sender {
    if (self.toSignInBlock) {
        self.toSignInBlock(sender);
    }
}

- (void)funButtonAction:(UIButton *)sender {
    if (self.functionBlock) {
        self.functionBlock(sender);
    }
}

//生成钱包地址事件
- (void)generateWalletBtnAction:(UIButton *)sender {
    if (self.generateWalletBlock) {
        self.generateWalletBlock(sender);
    }
}

#pragma mark - 已生成钱包-------事件
- (void)walletButtonAction:(UIButton *)sender {
    if (sender.tag == 1000) {
        NSString * address = objc_getAssociatedObject(sender, @"address");
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = address;
    }
    
    if (self.walletFunctionBlock) {
        self.walletFunctionBlock(sender);
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
