//
//  REBookDetailSectionFiveTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookDetailSectionFiveTableViewCell.h"

@interface REBookDetailSectionFiveTableViewCell ()
@property (nonatomic ,strong)CAGradientLayer *gl;
@end
@implementation REBookDetailSectionFiveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    for (int i=0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 8;
        btn.tag = 100 + i;
        
        UIImageView *imageView = [UIImageView new];
        [btn addSubview:imageView];
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
        imageView.tag = 200+i;
        
        UILabel *label = [UILabel new];
        [btn addSubview:label];
        label.tag = 300+i;
        label.textAlignment = NSTextAlignmentCenter;
        
        
        UILabel *bookWordNumLabel = [UILabel new];
        bookWordNumLabel.tag = 400+i;
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.startPoint = CGPointMake(0, 0.1453857421875);
        gl.endPoint = CGPointMake(0.914423942565918, 0.8652682900428772);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0),@(1.0f)];
        gl.cornerRadius = 11;
        gl.masksToBounds = YES;
        self.gl = gl;
        [imageView.layer addSublayer:gl];
        [imageView addSubview:bookWordNumLabel];

    }
}

- (void)showDataWithModel:(NSMutableArray *)model {
    
    
    for (int i=0; i<model.count; i++) {
        RELikeListModel *likeListModel = model[i];
        UIButton *btn = [self.contentView viewWithTag:100+i];
        if (i<6) {
            objc_setAssociatedObject(btn,"book_id", likeListModel.book_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(btn,"coverpic", likeListModel.coverpic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        if (i<3) {
            btn.frame = CGRectMake(16+i*((REScreenWidth-104*3-32)/2 + 104), 16, 104, 173);
        } else {
            btn.frame = CGRectMake(16+(i-3)*((REScreenWidth-104*3-32)/2 + 104), 16+173+12, 104, 170);
        }
        UIImageView *imageView = [btn viewWithTag:200+i];
        imageView.frame = CGRectMake(0, 0, btn.width, 140);
        [imageView sd_setImageWithURL:[NSURL URLWithString:likeListModel.coverpic] placeholderImage:PlaceholderImage];
        
        UILabel *label = [btn viewWithTag:300+i];
        label.frame = CGRectMake(0, imageView.bottom+12, btn.width, 21);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:likeListModel.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        
        UILabel *bookWordNumLabel = [imageView viewWithTag:400+i];
        NSString *grade = [NSString stringWithFormat:@"%@分",likeListModel.grade];
        CGSize gradesize = [ToolObject sizeWithText:grade withFont:REFont(12)];
        bookWordNumLabel.frame = CGRectMake(104-gradesize.width-10, 0, gradesize.width+10, 20);
        self.gl.frame = CGRectMake(104-gradesize.width-10, 0, gradesize.width+10, 20);
        NSMutableAttributedString *bookWordNumLabelstring = [[NSMutableAttributedString alloc] initWithString:grade attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: REWhiteColor}];
        bookWordNumLabel.attributedText = bookWordNumLabelstring;
        bookWordNumLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)btnAction:(UIButton *)sender {
    NSString *book_id = objc_getAssociatedObject(sender,"book_id");
    NSString *coverpic = objc_getAssociatedObject(sender,"coverpic");
    if (self.btnClickBlock) {
        self.btnClickBlock(sender,book_id,coverpic);
    }
}

@end
