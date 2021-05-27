//
//  REAreaTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/17.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REAreaTableViewCell.h"

#define Start_X (REScreenWidth - 104*3)/4 // 第一个按钮的X坐标
#define Start_Y 65.0f // 第一个按钮的Y坐标
#define Width_Space (REScreenWidth - 104*3)/4 // 2个按钮之间的横间距
#define Height_Space (REScreenWidth - 104*3)/4 // 竖间距

@interface REAreaTableViewCell ()

@property (nonatomic ,strong)NSMutableArray *bookArray;
@property (nonatomic ,strong)CAGradientLayer *gl;
@end

@implementation REAreaTableViewCell
- (NSMutableArray *)bookArray {
    if (!_bookArray) {
        _bookArray = [NSMutableArray array];
    }
    return _bookArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HomeAreaModel *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI:model];
        
    }
    return self;

}

- (void)re_loadUI:(HomeAreaModel *)model {
    NSMutableArray *bookArray = [NSMutableArray array];
    for (HomeBookModel *bookModel in model.book) {
        [bookArray addObject:bookModel];
    }

    //1.标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 100;
    [self.contentView addSubview:titleLabel];
    UIView *lineView = [UIView new];
    lineView.tag = 110;
    lineView.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    lineView.layer.cornerRadius = 2;
    [self.contentView addSubview:lineView];
    
    //2.换一批
    UIButton *anotherBatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    anotherBatchButton.tag = 120;
    [anotherBatchButton setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
    anotherBatchButton.titleLabel.font = REFont(14);
    [self.contentView addSubview:anotherBatchButton];

    //3.
    for (int i = 0 ; i < 9; i++) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = 200+i;
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:backButton];

        UIImageView *buttonImageView = [UIImageView new];
        buttonImageView.layer.cornerRadius = 10;
        buttonImageView.layer.masksToBounds = YES;
        [backButton addSubview:buttonImageView];
        buttonImageView.tag = 210+i;

        UILabel *buttonLabel = [UILabel new];
        buttonLabel.tag = 220+i;
        buttonLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [backButton addSubview:buttonLabel];
        
        UILabel *scoreLabel1 = [UILabel new];
        scoreLabel1.tag = 700+i;
        scoreLabel1.layer.cornerRadius = 10;
        scoreLabel1.layer.masksToBounds = YES;
        scoreLabel1.textAlignment = NSTextAlignmentCenter;
        scoreLabel1.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [backButton addSubview:scoreLabel1];
        
        UILabel *scoreLabel = [UILabel new];
        scoreLabel.tag = 230+i;
        scoreLabel.layer.cornerRadius = 10;
        scoreLabel.layer.masksToBounds = YES;
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [backButton addSubview:scoreLabel];
        
        UILabel *detailLabel = [UILabel new];
        detailLabel.tag = 240+i;
        detailLabel.numberOfLines = 3;
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [backButton addSubview:detailLabel];
        detailLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        
        UIView *lineView = [UIView new];
        lineView.tag = 250+i;
        lineView.backgroundColor = REBackColor;
        if (i != bookArray.count-1) {
            [backButton addSubview:lineView];
        }        
    }
}

- (void)showDataWithModel:(HomeAreaModel *)model withKey:(NSString *)key {
    [self.bookArray removeAllObjects];
    
    for (HomeBookModel *bookModel in model.book) {
        [self.bookArray addObject:bookModel];
    }
    if (self.bookArray.count == 0) {
        return;
    }
    //1.
    UILabel *titleLabel = [self.contentView viewWithTag:100];
    titleLabel.text = model.name;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    CGSize d = [self sizeWithText:titleLabel.text withFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.height.equalTo(@25);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(self.contentView).offset(7);
    }];
    
    UIView *lineView = [self.contentView viewWithTag:110];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.height.equalTo(@4);
        make.width.mas_equalTo(d.width);
        make.top.mas_equalTo(self.contentView).offset(36);
    }];

    //2.
    //toolbar_icon_change
    UIButton *anotherBatchButton = [self.contentView viewWithTag:120];
    objc_setAssociatedObject(anotherBatchButton, @"key",key,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(anotherBatchButton, @"mycell", self,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [anotherBatchButton addTarget:self action:@selector(anotherBatchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    anotherBatchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [anotherBatchButton setTitle:@"换一批" forState:UIControlStateNormal];
    [anotherBatchButton setImage:[UIImage imageNamed:@"toolbar_icon_change"] forState:UIControlStateNormal];
    CGFloat leftlab = [@"换一批" sizeWithAttributes:@{NSFontAttributeName : anotherBatchButton.titleLabel.font}].width;
    [anotherBatchButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftlab + 40, 0, 0)];
    [anotherBatchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [anotherBatchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
        make.height.equalTo(@20);
        make.left.equalTo(@289);
        make.top.mas_equalTo(self.contentView).offset(13);
    }];
    
    //3.
    if (self.bookArray.count<1) {
        
    } else if (self.bookArray.count<4) {
        for (int i = 0 ; i < self.bookArray.count; i++) {

            NSInteger index = i % 3;
            NSInteger page = i / 3;
            CGFloat backButtonW = 104;
            CGFloat backButtonH = 140;
            HomeBookModel *bookModel = self.bookArray[i];
            UIButton *backButton = [self.contentView viewWithTag:200+i];
            backButton.frame = CGRectMake(index * (backButtonW + Width_Space) + Start_X, page  * (backButtonH+12+21 + Height_Space)+Start_Y, backButtonW, backButtonH+12+21);
            objc_setAssociatedObject(backButton, @"book_id", bookModel.home_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(backButton, @"imageStr", bookModel.coverpic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            UIImageView *buttonImageView = [backButton viewWithTag:210+i];
            buttonImageView.frame = CGRectMake(0, 0, backButtonW, backButtonH);
            buttonImageView.backgroundColor = [UIColor redColor];
            [buttonImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.coverpic] placeholderImage:PlaceholderImage];

            UILabel *buttonLabel = [backButton viewWithTag:220+i];
            buttonLabel.textAlignment = NSTextAlignmentCenter;
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:bookModel.title attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            buttonLabel.attributedText = string;
            buttonLabel.frame = CGRectMake(0, backButtonH+12, backButtonW, 21);
        }
    } else if (self.bookArray.count<10) {
           for (int i = 0 ; i < self.bookArray.count; i++) {
               NSInteger index = i % 3;
               NSInteger page = i / 3;
               CGFloat backButtonW = 104;
               CGFloat backButtonH = 140;
               HomeBookModel *bookModel = self.bookArray[i];
               UIButton *backButton = [self.contentView viewWithTag:200+i];
               backButton.frame = CGRectMake(index * (backButtonW + Width_Space) + Start_X, page  * (backButtonH+12+21 + Height_Space)+Start_Y, backButtonW, backButtonH+12+21);
               
               objc_setAssociatedObject(backButton, @"book_id", bookModel.home_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
               objc_setAssociatedObject(backButton, @"imageStr", bookModel.coverpic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

               UIImageView *buttonImageView = [backButton viewWithTag:210+i];
               buttonImageView.backgroundColor = [UIColor redColor];
               buttonImageView.frame = CGRectMake(0, 0, backButtonW, backButtonH);
               [buttonImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.coverpic] placeholderImage:PlaceholderImage];

               UILabel *buttonLabel = [backButton viewWithTag:220+i];
               buttonLabel.textAlignment = NSTextAlignmentCenter;
               NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:bookModel.title attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
               buttonLabel.attributedText = string;
               buttonLabel.frame = CGRectMake(0, backButtonH+12, backButtonW, 21);
           }
       }
    
//    else if (self.bookArray.count<10) {
//           for (int i = 0 ; i < self.bookArray.count; i++) {
//               HomeBookModel *bookModel = self.bookArray[i];
//               CGFloat backButtonW = 104;
//               CGFloat backButtonH =  140 ;
//               if (i<6) {
//                   NSInteger index = i % 3;
//                   NSInteger page = i / 3;
//                   UIButton *backButton = [self.contentView viewWithTag:200+i];
//                   backButton.frame = CGRectMake(index * (backButtonW + Width_Space) + Start_X, page  * (backButtonH+12+21 + Height_Space)+Start_Y, backButtonW, backButtonH+12+21);
//
//                   objc_setAssociatedObject(backButton, @"book_id", bookModel.home_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//                   objc_setAssociatedObject(backButton, @"imageStr", bookModel.coverpic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//                   UIImageView *buttonImageView = [backButton viewWithTag:210+i];
//                   buttonImageView.frame = CGRectMake(0, 0, backButtonW, backButtonH);
//                   [buttonImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.coverpic] placeholderImage:PlaceholderImage];
//
//                   UILabel *buttonLabel = [backButton viewWithTag:220+i];
//                   buttonLabel.textAlignment = NSTextAlignmentCenter;
//                   NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:bookModel.title attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
//                   buttonLabel.attributedText = string;
//                   buttonLabel.frame = CGRectMake(0, backButtonH+12, backButtonW, 21);
//
////                   NSString *scoreStr = [NSString stringWithFormat:@"%@分",bookModel.grade];
////                   CGSize scoresize = [ToolObject sizeWithText:scoreStr withFont:REFont(13)];
////                   UILabel *scoreLabel = [backButton viewWithTag:230+i];
////                   NSMutableAttributedString *scoreLabelstring = [[NSMutableAttributedString alloc] initWithString:scoreStr attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
////                   scoreLabel.backgroundColor = REColor(255, 104, 42);
////                   scoreLabel.attributedText = scoreLabelstring;
////                   scoreLabel.frame = CGRectMake(backButton.width-12-scoresize.width, 0, scoresize.width+12, 20);
//
//               } else {
//
//                   UIButton *backButton = [self.contentView viewWithTag:200+i];
//                   backButton.frame = CGRectMake(0, 65+2*49+2*backButtonH+(i-6)*(172), REScreenWidth, 172);
//                   objc_setAssociatedObject(backButton, @"book_id", bookModel.home_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//                   objc_setAssociatedObject(backButton, @"imageStr", bookModel.coverpic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//                   UIImageView *buttonImageView = [backButton viewWithTag:210+i];
//                   buttonImageView.frame = CGRectMake(16, 16, 104, 140);
//                   [buttonImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.coverpic] placeholderImage:PlaceholderImage];
//
//
//                   CGSize size = [ToolObject sizeWithText:bookModel.title withFont:REFont(17)];
//                   UILabel *buttonLabel = [self.contentView viewWithTag:220+i];
//                    NSMutableAttributedString *buttonLabelstring = [[NSMutableAttributedString alloc] initWithString:bookModel.title attributes:@{NSFontAttributeName: REFont(17), NSForegroundColorAttributeName: REFontColor}];
//                    buttonLabel.attributedText = buttonLabelstring;
//                    buttonLabel.textColor = REFontColor;
//                   buttonLabel.frame = CGRectMake(132, 18, size.width, 24);
//
//                   NSString *scoreStr1 = [NSString stringWithFormat:@"%@分",bookModel.grade];
//                   CGSize scoresize1 = [ToolObject sizeWithText:scoreStr1 withFont:REFont(13)];
//                   UILabel *scoreLabel1 = [backButton viewWithTag:700+i];
//                   NSMutableAttributedString *scoreLabel1string = [[NSMutableAttributedString alloc] initWithString:scoreStr1 attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//                   //scoreLabel1.attributedText = scoreLabel1string;
//                   scoreLabel1.backgroundColor = [UIColor clearColor];
//                   //scoreLabel1.backgroundColor = REColor(255, 191, 175);
//                   scoreLabel1.frame = CGRectMake(buttonLabel.right+10, 20, scoresize1.width+12, 20);
//
//                   CAGradientLayer *gl = [CAGradientLayer layer];
//                   gl.frame = CGRectMake(0, 0, scoresize1.width+12, 20);
//                   gl.startPoint = CGPointMake(0, 0.8802323937416077);
//                   gl.endPoint = CGPointMake(1.0533899068832397, 0);
//                   gl.colors = @[(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor];
//                   gl.locations = @[@(0),@(1.0f)];
//                   [scoreLabel1.layer addSublayer:gl];
//
//                   NSString *scoreStr = [NSString stringWithFormat:@"%@分",bookModel.grade];
//                   CGSize scoresize = [ToolObject sizeWithText:scoreStr withFont:REFont(13)];
//                   UILabel *scoreLabel = [backButton viewWithTag:230+i];
//                   NSMutableAttributedString *scoreLabelstring = [[NSMutableAttributedString alloc] initWithString:scoreStr attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//                   scoreLabel.attributedText = scoreLabelstring;
//                   //scoreLabel.backgroundColor = REColor(255, 191, 175);
//                   scoreLabel.frame = CGRectMake(buttonLabel.right+10, 20, scoresize.width+12, 20);
//
//                   UILabel *detailLabel = [backButton viewWithTag:240+i];
//                   NSString *detailStr = bookModel.contents;
//                   detailStr = [detailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                   detailStr = [detailStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                   CGSize detailStrSize = [self textHeightFromTextString:detailStr width:227 fontSize:14];
//                   CGFloat rate = detailLabel.font.lineHeight;//每行需要的高度
//                   if (detailStrSize.height>rate*3) {
//                       detailStrSize.height = rate*3;
//                   }
//                   NSMutableAttributedString *detailLabelstring = [[NSMutableAttributedString alloc] initWithString:detailStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
//                   detailLabel.attributedText = detailLabelstring;
//                   detailLabel.frame = CGRectMake(buttonImageView.right+10, 52, 227, detailStrSize.height+20);
//                   [detailLabel setText:bookModel.contents lineSpacing:6.0f];
//                   detailLabel.font = REFont(14);
//
//                   UIView *lineView = [backButton viewWithTag:250+i];
//                   lineView.backgroundColor = REBackColor;
//                   lineView.frame = CGRectMake(0, 172, REScreenWidth, 8);
//               }
//           }
//       }
}

#pragma mark - 事件
- (void)anotherBatchButtonAction:(UIButton *)sender {
    NSString * key = objc_getAssociatedObject(sender, @"key");
    REAreaTableViewCell * cell = objc_getAssociatedObject(sender, @"mycell");
    if (self.areaMoreClickBlock) {
        self.areaMoreClickBlock(sender,key,cell);
    }
}

- (void)backButtonAction:(UIButton *)sender {
    NSString * book_id = objc_getAssociatedObject(sender, @"book_id");
    NSString * imageStr = objc_getAssociatedObject(sender, @"imageStr");

    if (self.readingBookBlocks) {
        self.readingBookBlocks(sender,book_id,imageStr);
    }
}

@end
