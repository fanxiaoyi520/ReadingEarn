//
//  REWaitingPayFooterView.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REWaitingPayFooterView.h"

@interface REWaitingPayFooterView()

@property (nonatomic ,strong)UITextView *textView;
@end
@implementation REWaitingPayFooterView
- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self re_loadUI:type];
    }
    return self;
}

- (void)re_loadUI:(NSString *)type {
    
    //1.
    if ([type isEqualToString:@"1"]) {
        for (int i=0; i<2; i++) {
            UIButton *isBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:isBuyButton];
            isBuyButton.titleLabel.font = REFont(17);
            isBuyButton.tag = 10+i;
            [isBuyButton addTarget:self action:@selector(isBuyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            isBuyButton.layer.cornerRadius = 22.5;
            isBuyButton.hidden = NO;
        }

        UIButton *appealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:appealButton];
        appealButton.tag = 100;
        appealButton.titleLabel.font = REFont(17);
        [appealButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
        appealButton.layer.cornerRadius = 22.5;
        appealButton.hidden = YES;
        
        //2.
        UITextView *textView = [UITextView new];
        [self addSubview:textView];
        textView.hidden = NO;
        self.textView = textView;
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = NO;
        textView.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    } else {
        UIButton *appealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:appealButton];
        appealButton.tag = 100;
        appealButton.titleLabel.font = REFont(17);
        [appealButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
        appealButton.layer.cornerRadius = 22.5;
//        [appealButton addTarget:self action:@selector(appealButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showDataWithModel:(REWaitingPayModel *)model withType:(NSString *)type withModel:(nonnull REAppealStatusModel *)statusModel{
    
    if (!model) {
        return;
    }
    
    if ([type isEqualToString:@"1"]) {
        //1.
        NSArray *isBuyArray = @[@"取消",model.data.button];
        for (int i=0; i<2; i++) {
            UIButton *isBuyButton = [self viewWithTag:10+i];
            [isBuyButton setTitle:isBuyArray[i] forState:UIControlStateNormal];
            isBuyButton.frame = CGRectMake(16+i*((REScreenWidth-32-20)/2 + 20), 32, (REScreenWidth-32-20)/2, 45);
            if (i==1) {
                if ([model.data.name isEqualToString:@"1"]) {
                    isBuyButton.backgroundColor = REColor(247, 100, 66);
                    [isBuyButton setTitleColor:REColor(255, 255, 255) forState:UIControlStateNormal];
                    isBuyButton.userInteractionEnabled = YES;
                } else {
                    isBuyButton.userInteractionEnabled = NO;
                    isBuyButton.backgroundColor = REColor(229, 229, 229);
                    [isBuyButton setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
                }
            } else {
                if ([model.data.cancel isEqualToString:@"1"]) {
                    isBuyButton.userInteractionEnabled = YES;
                    isBuyButton.backgroundColor = REColor(247, 100, 66);
                    [isBuyButton setTitleColor:REColor(255, 255, 255) forState:UIControlStateNormal];
                } else {
                    isBuyButton.userInteractionEnabled = NO;
                    isBuyButton.backgroundColor = REColor(229, 229, 229);
                    [isBuyButton setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
                }
            }
        }
        
        //2.
        self.textView.frame = CGRectMake(20, 184, REScreenWidth-40, 78);
        NSMutableAttributedString *textViewstring = [[NSMutableAttributedString alloc] initWithString:@"交易说明：\n1.选择以上1种支付方式向对方转账，转账完成后务必点击【我已付款】，避免15分钟后系统自动取消订单造成您的财产损失。" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        self.textView.attributedText = textViewstring;


    } else {
        for (int i=0; i<2; i++) {
            UIButton *isBuyButton = [self viewWithTag:10+i];
            isBuyButton.hidden = YES;
        }
        self.textView.hidden = YES;
        UIButton *appealButton = [self viewWithTag:100];
        
        appealButton.hidden = NO;
        appealButton.frame = CGRectMake(32, 32, REScreenWidth-64, 45);
        [appealButton setTitle:@"申诉" forState:UIControlStateNormal];
        if ([type isEqualToString:@"3"]) {
            appealButton.backgroundColor = REColor(247, 100, 66);
            appealButton.userInteractionEnabled = NO;
            [appealButton setTitle:@"已取消" forState:UIControlStateNormal];
        } else if ([type isEqualToString:@"4"]) {
            if ([statusModel.status isEqualToString:@"1"]) {
                appealButton.backgroundColor = REColor(247, 100, 66);
                appealButton.userInteractionEnabled = NO;
                [appealButton setTitle:@"申诉中" forState:UIControlStateNormal];
            } else {
                appealButton.backgroundColor = REColor(247, 100, 66);
                appealButton.userInteractionEnabled = NO;
                [appealButton setTitle:@"申诉完成" forState:UIControlStateNormal];
            }
        } else {
            appealButton.backgroundColor = REColor(247, 100, 66);
            appealButton.userInteractionEnabled = NO;
            [appealButton setTitle:@"已完成" forState:UIControlStateNormal];

//            if ([model.step isEqualToString:@"4"]) {
//                appealButton.backgroundColor = REColor(153, 153, 153);
//                appealButton.userInteractionEnabled = NO;
//            } else {
//                appealButton.backgroundColor = REColor(247, 100, 66);
//            }
        }
    }
}

- (void)isBuyButtonAction:(UIButton *)sender {
    if (self.payOrCancelBlock) {
        self.payOrCancelBlock(sender);
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
