//
//  REEndBookTypeView.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REEndBookTypeView.h"
@interface REEndBookTypeView()

@property (nonatomic ,assign)NSInteger btnTag;
@property (nonatomic ,assign)NSInteger btnTagone;
@end
@implementation REEndBookTypeView
- (instancetype)initWithFrame:(CGRect)frame withModel:(NSDictionary *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        [self re_loadUIWithModel:model];
    }
    return self;
}

- (void)re_loadUIWithModel:(NSDictionary *)model {
    
    //1.全部
    for (int i=0; i<2; i++) {
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        allButton.selected = YES;
        [allButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        allButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
        [allButton setTitle:@"全部" forState:UIControlStateNormal];
        [allButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
        allButton.titleLabel.font = REFont(14);
        allButton.layer.cornerRadius = 16;
        [self addSubview:allButton];
        if (i==0) {
            allButton.tag = 200;
            self.btnTagone = 200;
        } else {
            allButton.tag = 300;
            self.btnTag = 300;
        }
    }

    //2.labels
    NSArray *styleArray = (NSArray *)[model objectForKey:@"nove_type"];
    for (int i=0; i<styleArray.count; i++) {
        UIButton *labelsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        labelsButton.tag = 201 + i;
        labelsButton.selected = NO;
        labelsButton.titleLabel.font = REFont(14);
        labelsButton.layer.cornerRadius = 16;
        [labelsButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:labelsButton];
    }

    //3.style
    NSDictionary *dic = [model objectForKey:@"charge_type"];
    NSArray *array = dic.allKeys;
    for (int i=0; i<array.count; i++) {
        UIButton *styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        styleButton.tag = 301 + i;
        styleButton.selected = NO;
        styleButton.titleLabel.font = REFont(14);
        styleButton.layer.cornerRadius = 16;
        [styleButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:styleButton];
    }

}

- (void)showBookTypeViewWithModel:(NSDictionary *)model {
    
    //1.
    for (int i=0; i<2; i++) {
        UIButton *allButton = [self viewWithTag:200+i*100];
        allButton.frame = CGRectMake(16, 16+i*(28+12), 72, 28);
        objc_setAssociatedObject(allButton, "firstObject", @"", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
         objc_setAssociatedObject(allButton, "secondObject", @"全部", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    //2.
    NSArray *array = (NSArray *)[model objectForKey:@"nove_type"];
    for (int i=0; i<array.count; i++) {
        NSString *str = [array[i] objectForKey:@"name"];
        UIButton *labelsButton = [self viewWithTag:201+i];
        [labelsButton setTitle:str forState:UIControlStateNormal];
        [labelsButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        labelsButton.titleLabel.font = REFont(14);
        labelsButton.frame = CGRectMake(82+i*(72-6), 16, 72, 28);
        //nove_type charge_type
        objc_setAssociatedObject(labelsButton, "firstObject", [array[i] objectForKey:@"sort"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(labelsButton, "secondObject", @"nove_type", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    //3.
    NSDictionary *dic = [model objectForKey:@"charge_type"];
    NSArray *styleArray = dic.allKeys;
    for (int i=0; i<styleArray.count; i++) {
        NSString *str = [dic objectForKey:styleArray[i]];
        UIButton *styleButton = [self viewWithTag:301+i];
        [styleButton setTitle:str forState:UIControlStateNormal];
        [styleButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        styleButton.titleLabel.font = REFont(14);
        styleButton.frame = CGRectMake(82+i*(72-6), 56, 72, 28);
        objc_setAssociatedObject(styleButton, "firstObject", styleArray[i], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(styleButton, "secondObject", @"charge_type", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - 事件
- (void)allButtonAction:(UIButton *)sender {
    UIButton *btn = [self viewWithTag:self.btnTag];
    UIButton *btnone = [self viewWithTag:self.btnTagone];
    if (sender.selected == YES) {
        if (sender.tag <300) {
            self.btnTagone = sender.tag;
        } else {
            self.btnTag = sender.tag;
        }
    } else {
        sender.selected = YES;
        if (sender.tag <300) {
            btnone.selected = NO;
            btnone.backgroundColor = [UIColor clearColor];
            [btnone setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.btnTagone = sender.tag;
        } else {
            btn.selected = NO;
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.btnTag = sender.tag;
        }
        
        sender.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
        [sender setTitleColor:REWhiteColor forState:UIControlStateSelected];
    }
    
    id first = objc_getAssociatedObject(sender, "firstObject");
    id second = objc_getAssociatedObject(sender, "secondObject");
    if (self.bookTypeBlock) {
        self.bookTypeBlock(sender,first,second);
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
