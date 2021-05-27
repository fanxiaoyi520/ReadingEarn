//
//  REIncomeHeaderView.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REIncomeHeaderView.h"

@interface REIncomeHeaderView()

@property (nonatomic ,assign)NSInteger btnTag;
@property (nonatomic ,copy)NSString *order;
@end

@implementation REIncomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    for (int i=0; i<4; i++) {
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.tag = 200+i;
        clickButton.titleLabel.font = REFont(13);
        [clickButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickButton];
        
    }

}

- (void)shouDataWithModel:(NSString *)model withTypeClick:(BOOL)isTypeClick{
    self.frame = CGRectMake(0, 0, REScreenWidth, 46);
    
    NSArray *titleArray = @[@"总收益",@"推广收益",@"每日收益",@"社区收益"];
    CGFloat w = 0;
    CGFloat h = 10;
    for (int i = 0; i < titleArray.count; i ++) {
        //获取文字的长度
        NSDictionary *attributes = @{NSFontAttributeName:REFont(13)};
        CGFloat length = [titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;

        UIButton *button = [self viewWithTag:200+i];
        button.layer.cornerRadius = 13;
        button.titleLabel.font = REFont(13);
        button.frame = CGRectMake(ratioW(24) + w, h, ratioW(length) + ratioW(15) , 26);
        //当大于屏幕的宽度自动换
        if (10 + w + length + 15 > REScreenWidth)
        {
            w = 0;
            h = 129;
            button.frame = CGRectMake(ratioW(24) + w, h, ratioW(length) + ratioW(15) , 26);
        }
        w = button.frame.size.width + button.frame.origin.x;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        if (isTypeClick != 1) {
            if (i == 0) {
                self.btnTag = 200;
                button.selected = YES;
                button.backgroundColor = REColor(247, 100, 66);
                [button setTitleColor:REWhiteColor forState:UIControlStateNormal];
            } else {
                button.selected = NO;
                [button setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - 事件
- (void)clickButtonAction:(UIButton *)sender {
    UIButton *btn = [self viewWithTag:self.btnTag];
    if (sender.selected == YES) {
        self.btnTag = sender.tag;
        
        if (sender.tag == 203) {
            self.order = @"2";
        }
    } else {
        self.order = @"1";
        sender.selected = YES;
        btn.selected = NO;
        sender.backgroundColor = REColor(247, 100, 66);
        [sender setTitleColor:REWhiteColor forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
        self.btnTag = sender.tag;
    }
    
    if (self.incomeHeaderBlock) {
        self.incomeHeaderBlock(sender,self.order);
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
