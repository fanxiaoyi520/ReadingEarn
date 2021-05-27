//
//  REMyBookFriendHeaderView.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyBookFriendHeaderView.h"

@interface REMyBookFriendHeaderView()
@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,assign)NSInteger btnTag;
@property (nonatomic ,copy)NSString *order;
@property (nonatomic ,assign)NSInteger mydtag;
@end

@implementation REMyBookFriendHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    //1.
    UIImageView *bgImageView = [UIImageView new];
    self.bgImageView = bgImageView;
    [self addSubview:bgImageView];
    
    //2.
    for (int i=0; i<3; i++) {
        UIView *bgView = [UIView new];
        bgView.tag = 100+i;
        [bgImageView addSubview:bgView];
        
        UILabel *label = [UILabel new];
        label.tag = 110+i;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [bgView addSubview:label];
        
        UILabel *numLabel = [UILabel new];
        numLabel.tag = 120+i;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [bgView addSubview:numLabel];
    }
    
    //3.
    for (int i=0; i<4; i++) {
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.tag = 200+i;
        clickButton.titleLabel.font = REFont(13);
        [clickButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickButton];
        
    }
}

- (void)showDataWithModel:(REHeaderBookFriendModel *)model withTypeClick:(BOOL)isTypeClick{
    self.frame = CGRectMake(0, 0, REScreenWidth, 164);
//    self.order = @"1";
    //1.
    self.bgImageView.image = REImageName(@"user_bg");
    self.bgImageView.frame = CGRectMake(16, 12, REScreenWidth-32, 96);
    
    //2.
    NSArray *array = @[@"团队人数",@"活跃度",@"有效成员"];
    NSArray *numArray;
    if (!model) {
        numArray = @[@"0",@"0",@"0"];
    } else {
        numArray = @[model.team_total,model.active_total,model.valid_total];
    }
    for (int i=0; i<3; i++) {
        UIView *bgView = [self.bgImageView viewWithTag:100+i];
        bgView.frame = CGRectMake(i*(self.bgImageView.width/3), 20, self.bgImageView.width/3, 56);
        
        UILabel *label = [bgView viewWithTag:110+i];
        label.frame = CGRectMake(0, 6, bgView.width, 11);
        NSMutableAttributedString *labelstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: REFont(11), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        label.attributedText = labelstring;

        UILabel *numLabel = [bgView viewWithTag:120+i];
        numLabel.frame = CGRectMake(0, 44, bgView.width, 22);
        NSMutableAttributedString *numLabelstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: REFont(22), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        numLabel.attributedText = numLabelstring;
        
    }
    
    //3.
    NSArray *titleArray = @[@"直推队友",@"完成实名",@"未实名",@"排序"];
    CGFloat w = 0;
    CGFloat h = 129;
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
        }
    } else {
        sender.selected = YES;
        btn.selected = NO;
        sender.backgroundColor = REColor(247, 100, 66);
        [sender setTitleColor:REWhiteColor forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
        self.btnTag = sender.tag;
    }
    
    if (sender.tag < 203) {
        if (self.headerClickBlock) {
            self.headerClickBlock(sender,self.order);
            self.mydtag = sender.tag;
        }
    } else if (sender.tag == 203){
        if ([self.order isEqualToString:@"1"]) {
            self.order = @"2";

        } else {
            self.order = @"1";

        }
        if (self.sortClickBlock) {
            NSString *tag = [NSString stringWithFormat:@"%ld",self.mydtag];
            self.sortClickBlock(sender,self.order,tag);
        }
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
