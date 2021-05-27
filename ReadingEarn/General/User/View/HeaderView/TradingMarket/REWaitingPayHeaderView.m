//
//  REWaitingPayHeaderView.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REWaitingPayHeaderView.h"

@interface REWaitingPayHeaderView()

@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UILabel *isBuyLabel;
@property (nonatomic ,strong)UILabel *YDCLabel;
@property (nonatomic ,strong)UILabel *statusLabel;
@property (nonatomic ,strong)UIImageView *countDownImageView;
@property (nonatomic ,strong)UILabel *countDownLabel;
@property (nonatomic ,strong)UIButton *appealButton;
@property (nonatomic,strong) dispatch_source_t mytimer;
@end
@implementation REWaitingPayHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    UIView *backView = [UIView new];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    self.backView = backView;
    backView.backgroundColor = REWhiteColor;
        
    //1.
    UILabel *isBbuyLabel = [UILabel new];
    isBbuyLabel.layer.cornerRadius = 4;
    isBbuyLabel.layer.masksToBounds = YES;
    [self addSubview:isBbuyLabel];
    self.isBuyLabel = isBbuyLabel;
    
    //2.
    UILabel *YDCLabel = [UILabel new];
    isBbuyLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:YDCLabel];
    self.YDCLabel = YDCLabel;
    YDCLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //3.
    UILabel *statusLabel = [UILabel new];
    [self addSubview:statusLabel];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel = statusLabel;
    statusLabel.textColor = [UIColor colorWithRed:22/255.0 green:206/255.0 blue:79/255.0 alpha:1.0];
    
    //4.
    UIImageView *countDownImageView = [UIImageView new];
    [self addSubview:countDownImageView];
    self.countDownImageView = countDownImageView;
    self.countDownImageView.image = REImageName(@"waiting_pay_time1");

    //5.
    UILabel *countDownLabel = [UILabel new];
    [self addSubview:countDownLabel];
    self.countDownLabel = countDownLabel;
    self.countDownLabel.textAlignment = NSTextAlignmentRight;
    countDownLabel.font = REFont(14);
    countDownLabel.textColor = REColor(153, 153, 153);
    
    //6.
    UIButton *appealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.appealButton = appealButton;
    [self addSubview:appealButton];
    [appealButton addTarget:self action:@selector(appealButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    appealButton.titleLabel.font = REFont(17);
    [appealButton setTitle:@"申诉" forState:UIControlStateNormal];
    appealButton.backgroundColor = REColor(247, 100, 66);
    appealButton.layer.cornerRadius = 12.5;
    
}

- (void)showDataWithModel:(REWaitingPayModel *)model {
    
    if (!model) {
        return;
    }
    self.backView.frame  = CGRectMake(0, 0, REScreenWidth, 42);
    //1.
//    NSString *isBuy;
//    if ([model.order_status isEqualToString:@"1"]) {
//        isBuy = @"买";
//        self.isBuyLabel.backgroundColor = REColor(247, 100, 66);
//        self.isBuyLabel.textColor = REWhiteColor;
//    } else {
//        isBuy = @"卖";
//        self.isBuyLabel.backgroundColor = REColor(22, 206, 79);
//        self.isBuyLabel.textColor = REWhiteColor;
//    }
//    self.isBuyLabel.textAlignment = NSTextAlignmentCenter;
//    self.isBuyLabel.frame = CGRectMake(24, 10, 20, 20);
//    self.isBuyLabel.font = REFont(14);
//    self.isBuyLabel.text = isBuy;
    
    //2.
    CGSize ydcSize = [ToolObject sizeWithText:model.symbol withFont:REFont(14)];
    self.YDCLabel.frame = CGRectMake(24, 10, ydcSize.width+10, 20);
    NSMutableAttributedString *YDCLabelstring = [[NSMutableAttributedString alloc] initWithString:model.symbol attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.YDCLabel.attributedText = YDCLabelstring;

    //3.
    NSString *statusStr;
    if ([model.step isEqualToString:@"1"]) {
        statusStr = @"待付款";
    } else if ([model.step isEqualToString:@"2"]){
        statusStr = @"待收款";
    } else if ([model.step isEqualToString:@"3"]){
        statusStr = @"待放币";
    } else {
        statusStr = @"已完成";
    }
    self.statusLabel.frame = CGRectMake(self.YDCLabel.right+2, 10, 100, 22);
    NSMutableAttributedString *statusLabelstring = [[NSMutableAttributedString alloc] initWithString:statusStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16], NSForegroundColorAttributeName: REColor(247, 100, 66)}];
    self.statusLabel.attributedText = statusLabelstring;
    
    //4.
    NSString *currentTime = [self getNowTimeTimestamp];
    if ([model.step isEqualToString:@"1"]) {
        //时间
        int time = [model.end_time intValue] - [currentTime intValue];
        [self timeout:time];
        self.appealButton.hidden = YES;
        self.countDownImageView.hidden = NO;
        self.countDownLabel.hidden = NO;
    } else if ([model.step isEqualToString:@"4"]) {
        self.countDownImageView.hidden = YES;
        self.countDownLabel.hidden = YES;
        self.appealButton.hidden = NO;
        self.appealButton.userInteractionEnabled = NO;
        self.appealButton.backgroundColor = REColor(153, 153, 153);
        self.appealButton.frame = CGRectMake(REScreenWidth-20-80, 10, 80, 25);
    } else {
        //申诉
        self.countDownImageView.hidden = YES;
        self.countDownLabel.hidden = YES;
        self.appealButton.hidden = NO;
        self.appealButton.frame = CGRectMake(REScreenWidth-20-80, 10, 80, 25);
    }
}

- (NSString *)getNowTimeTimestamp{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

#pragma mark - 事件
- (void)appealButtonAction:(UIButton *)sender {
    if (self.appealBlock) {
        self.appealBlock(sender);
    }
}

#pragma mark - 倒计时
-(void)timeout:(int)time{

    __block int timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    _mytimer = _timer;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行

    dispatch_source_set_event_handler(_timer, ^{

    if(timeout<=0){ //倒计时结束，关闭

    dispatch_source_cancel(_timer);

    dispatch_async(dispatch_get_main_queue(), ^{

//    //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
//    NSString *strTime = @"0时0分0秒";
//    CGSize timesize = [ToolObject sizeWithText:strTime withFont:REFont(14)];
//    self.countDownLabel.frame = CGRectMake(REScreenWidth-20-timesize.width-10, 10, timesize.width+10, 20);
//    self.countDownImageView.frame = CGRectMake(REScreenWidth-14-20-timesize.width-15, 14, 14, 14);
//    self.countDownLabel.text =strTime;
        self.countDownImageView.hidden = YES;
        self.countDownLabel.hidden = YES;
        self.appealButton.hidden = NO;
        self.appealButton.frame = CGRectMake(REScreenWidth-20-80, 10, 80, 25);
    });
    }else{

    dispatch_async(dispatch_get_main_queue(), ^{

    //设置界面的按钮显示 根据自己需求设置
    int second =timeout%60;//秒

    int minutes = timeout/60%60;//分钟的。

    int hour = timeout/60/60%24;//小时

    //int day = timeout/60/60/24;//天

    NSString *strTime = [NSString stringWithFormat:@"%d时%d分钟%d秒",hour,minutes,second];
    CGSize timesize = [ToolObject sizeWithText:strTime withFont:REFont(14)];
    self.countDownLabel.frame = CGRectMake(REScreenWidth-20-timesize.width-10, 10, timesize.width+10, 20);
    self.countDownImageView.frame = CGRectMake(REScreenWidth-14-20-timesize.width-5, 14, 14, 14);
    self.countDownLabel.text =strTime;
    });

    timeout--;

    }

    });

    dispatch_resume(_timer);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
