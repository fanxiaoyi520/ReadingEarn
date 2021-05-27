//
//  REUserAppHeaderView.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/24.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REUserAppHeaderView.h"

@interface REUserAppHeaderView()

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
@implementation REUserAppHeaderView
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
}

- (void)showUserHeaderModel:(REUserModel *)model withWalletModel:(nonnull REUseWalletModel *)walletModel auditStatusStr:(nonnull NSString *)auditStatusStr is_TransferAccountsShowStr:(NSString *)is_TransferAccountsShowStr {

    //1.
    self.gradientLayer.frame = CGRectMake(0, 0, REScreenWidth, 150);
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

    //f.
    for (int i=0; i<3; i++) {
        UILabel *contentLabel = [self viewWithTag:100+i];
        contentLabel.frame = CGRectMake(i*REScreenWidth/3, 136, REScreenWidth/3, 11);
        
        UILabel *numLabel = [self viewWithTag:200+i];
        numLabel.frame = CGRectMake(i*REScreenWidth/3, 153, REScreenWidth/3, 22);
    }
        
    if (!model) {
        //默认
        self.headImageView.image = PlaceholderHead_Image;
//        NSMutableAttributedString *activityLevelLabelstring = [[NSMutableAttributedString alloc] initWithString:@"用户等级: 0" attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//        self.activityLevelLabel.attributedText = activityLevelLabelstring;
        
        NSMutableAttributedString *authenticationStatusLabelstring = [[NSMutableAttributedString alloc] initWithString:@"未认证" attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.authenticationStatusLabel.attributedText = authenticationStatusLabelstring;
        return;
    } else {
        //头像
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];
        [self.vipImageView sd_setImageWithURL:[NSURL URLWithString:model.vip_icon] placeholderImage:PlaceholderHead_Image];
        //用户名 活跃度
        NSMutableAttributedString *loginStatusstring = [[NSMutableAttributedString alloc] initWithString:model.nickname attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.loginStatusLabel.attributedText = loginStatusstring;
        
//        NSString *actityLabel = [NSString stringWithFormat:@"用户等级: %@",model.vip_rank];
//        NSMutableAttributedString *activityLevelLabelstring = [[NSMutableAttributedString alloc] initWithString:actityLabel attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//        self.activityLevelLabel.attributedText = activityLevelLabelstring;
        
        NSString *authenticationStatus;
        if ([auditStatusStr isEqualToString:@"认证信息成功"]) {
            authenticationStatus = @"已认证";
        } else {
            authenticationStatus = @"未认证";
        }
        NSMutableAttributedString *authenticationStatusLabelstring = [[NSMutableAttributedString alloc] initWithString:authenticationStatus attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        self.authenticationStatusLabel.attributedText = authenticationStatusLabelstring;
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
