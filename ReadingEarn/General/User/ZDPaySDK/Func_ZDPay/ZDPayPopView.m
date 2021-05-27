
//
//  ZDPayPopView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayPopView.h"
#import "ZDPayFuncTool.h"

@interface ZDPayPopView()<UIGestureRecognizerDelegate>

@property (nonatomic ,weak)UIWindow *myWindow;
@property (nonatomic ,strong)UIView *coverView;
@property (nonatomic ,assign)ZDPayPopViewEnum type;
@property (nonatomic ,copy)NSString *data;
@property (nonatomic ,strong)NSDictionary *model;
@property (nonatomic ,strong)NSString *boxInputViewstr;
@property (nonatomic ,strong)UIButton *certainButton;
@property (nonatomic ,strong)NSArray *gratypeArray;
@property (nonatomic ,copy)NSString *gratype_idStr;
@property (nonatomic ,assign)NSInteger btnTag;

//@property (nonatomic ,strong)REGraTypeModel *graTypeModel;
//@property (nonatomic ,strong)REUseWalletModel *useWalletModel;
@end
@implementation ZDPayPopView

#pragma mark - private
- (instancetype)initWithFrame:(CGRect)frame withType:(ZDPayPopViewEnum)type
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
    self.coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.coverView.alpha = 0.5;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    [self.coverView addGestureRecognizer:tap];
    
    if (self.type == SetPaymentPassword) {
        [self re_loadSetPaymentPasswordUI];
    }
}

- (void)re_loadSetPaymentPasswordUI {
    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 10;
    titleLabel.textColor = COLORWITHHEXSTRING(@"#666666;", 1.0);
    [self addSubview:titleLabel];
    
    //2.
    UILabel *moneyNumberLab = [UILabel new];
    moneyNumberLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    moneyNumberLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:moneyNumberLab];
    moneyNumberLab.tag = 20;
    
    //线条
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.tag = 60;
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#DDDDDD", 1.0);
    
    //支付银行
    UIImageView *bankImageView = [UIImageView new];
    [self addSubview:bankImageView];
    bankImageView.tag = 70;
    
    UILabel *bankLabel = [UILabel new];
    [self addSubview:bankLabel];
    bankLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    bankLabel.textAlignment = NSTextAlignmentLeft;
    bankLabel.tag = 80;
    
    //3.
    CRBoxInputView *boxInputView = [CRBoxInputView new];
    boxInputView.tag = 30;
    boxInputView.codeLength = 6;// 不设置时，默认4
    [boxInputView loadAndPrepareViewWithBeginEdit:YES]; // BeginEdit:是否自动启用编辑模式
    [self addSubview:boxInputView];

    //4.
    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certainButton = forgetPassBtn;
    forgetPassBtn.titleLabel.font = ZD_Fout_Regular(14);
    forgetPassBtn.tag = 40;
    forgetPassBtn.layer.cornerRadius = ratioH(17.5);
    [forgetPassBtn setTitle:NSLocalizedString(@"忘记密码",nil) forState:UIControlStateNormal];
    [forgetPassBtn addTarget:self action:@selector(forgetPassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPassBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1.0) forState:UIControlStateNormal];
    [self addSubview:forgetPassBtn];
    
    //3.
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"icon_close") forState:UIControlStateNormal];
    [self addSubview:closeButton];
}

- (void)layoutAndLoadDataPaymentPassword {
    //1.
    CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:NSLocalizedString(@"请输入支付密码",nil) withFont:ZD_Fout_Regular(ratioH(16))];
    UILabel *titleLabel = [self viewWithTag:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"请输入支付密码",nil) attributes:@{NSFontAttributeName: ZD_Fout_Regular(ratioH(16)), NSForegroundColorAttributeName: COLORWITHHEXSTRING(@"#666666", 1.0)}];
    titleLabel.attributedText = titleLabelstring;
    titleLabel.frame = CGRectMake((self.width-titleRect.size.width)/2, ratioH(24), titleRect.size.width, ratioH(25));
    
    //2.
    UILabel *moneyNumberLab = [self viewWithTag:20];
    NSString *amountMoneyStr = [ZDPayFuncTool getRoundFloat:[@"1976.00" doubleValue] withPrecisionNum:2];
    moneyNumberLab.frame = CGRectMake(0, titleLabel.bottom+ratioH(20), self.width, ratioH(24));
    moneyNumberLab.text = [NSString stringWithFormat:@"HK$ %@",amountMoneyStr];
    [ZDPayFuncTool LabelAttributedString:moneyNumberLab FontNumber:ZD_Fout_Medium(ratioH(30)) AndRange:NSMakeRange(4, amountMoneyStr.length-2) AndColor:nil];
        
    //线条
    UIView *lineview = [self viewWithTag:60];
    lineview.frame = CGRectMake(0, ratioH(121), self.width, .5);
    
    //支付银行
    UIImageView *banImageview = [self viewWithTag:70];
    banImageview.backgroundColor = [UIColor yellowColor];
    banImageview.frame = CGRectMake(ratioW(21), lineview.bottom + ratioH(23), ratioW(17), ratioH(17));
    
    UILabel *bankLabel = [self viewWithTag:80];
    bankLabel.text = NSLocalizedString(@"建设银行(3456)",nil);
    bankLabel.frame = CGRectMake(banImageview.right + ratioW(10), lineview.bottom + ratioH(24), self.width-58, 16);
    
    //3.
    CRBoxInputView *boxInputView = [self viewWithTag:30];
    boxInputView.ifNeedSecurity = YES;
    boxInputView.securityDelay = CRBoxSecurityCustomViewType;
    boxInputView.frame = CGRectMake(21, lineview.bottom + ratioH(64), self.width-42, 44);
    __weak typeof (self)weekself = self;
    boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        __strong typeof (weekself)strongself = weekself;
        strongself.boxInputViewstr = text;
        if (strongself.setPaymentPassword) {
            strongself.setPaymentPassword(text, isFinished);
        }
    };
    [boxInputView clearAllWithBeginEdit:YES]; // BeginEdit:清空后是否自动启用编辑模式

    //4.
    UIButton *certainButton = [self viewWithTag:40];
    CGRect forgetPassBtnRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:NSLocalizedString(@"忘记密码",nil) withFont:ZD_Fout_Regular(ratioH(14))];
    certainButton.frame = CGRectMake(self.width-19-forgetPassBtnRect.size.width, lineview.bottom + ratioH(128), forgetPassBtnRect.size.width, ratioH(14));
    
    //5.
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 30, ratioH(10), ratioW(20), ratioW(20));
}

- (void)forgetPassBtnAction:(UIButton *)sender {
    if (self.forgetPassword) {
        self.forgetPassword();
    }
}

#pragma mark - public
+ (ZDPayPopView *)readingEarnPopupViewWithType:(ZDPayPopViewEnum)type {
    return [[ZDPayPopView alloc] initWithFrame:CGRectZero withType:type];
}

- (void)showPopupViewWithData:(__nullable id)model
                      payPass:(void (^)(NSString *text, BOOL isFinished))payPass
                   forgetPass:(void (^)(void))forgetPass {
    self.setPaymentPassword = payPass;
    self.forgetPassword = forgetPass;
    
    [self.myWindow addSubview:self];
    if (self.type == SetPaymentPassword) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(16,(ScreenHeight-ratioH(286))/2, ScreenWidth-32, ratioH(286));
         [self layoutAndLoadDataPaymentPassword];
    }
}

- (void)closeThePopupView {
    self.coverView.hidden = YES;
    self.hidden = YES;
    [self removeFromSuperview];
    [self.coverView removeFromSuperview];
}

@end
