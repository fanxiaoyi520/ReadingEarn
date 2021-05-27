//
//  REHomeVipMoreTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeVipMoreTableViewCell.h"

#define Start_X (REScreenWidth - 104*3)/4 // 第一个按钮的X坐标
#define Start_Y 12 // 第一个按钮的Y坐标
#define Width_Space (REScreenWidth - 104*3)/4 // 2个按钮之间的横间距
#define Height_Space (REScreenWidth - 104*3)/4 // 竖间距

@implementation REHomeVipMoreTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(NSMutableArray *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self re_loadUIwithModel:model];
    }
    return self;

}

- (void)re_loadUIwithModel:(NSMutableArray *)model {
    for (int i = 0 ; i < 9; i++) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = 200+i;
        [self.contentView addSubview:backButton];

        UIImageView *buttonImageView = [UIImageView new];
        [backButton addSubview:buttonImageView];
        buttonImageView.tag = 210+i;
        buttonImageView.layer.cornerRadius = 10;
        buttonImageView.layer.masksToBounds = YES;

        UILabel *buttonLabel = [UILabel new];
        buttonLabel.tag = 220+i;
        buttonLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [backButton addSubview:buttonLabel];
                
        UILabel *scoreLabel = [UILabel new];
        scoreLabel.tag = 230+i;
        scoreLabel.layer.cornerRadius = 11;
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
        if (i != model.count-1) {
            [backButton addSubview:lineView];
        }
    }
}

- (void)showDataWithModel:(NSMutableArray *)model {
    if (model.count<1) {
        
    } else if (model.count<4) {
        for (int i = 0 ; i < model.count; i++) {

            NSInteger index = i % 3;
            NSInteger page = i / 3;
            CGFloat backButtonW = 104;
            CGFloat backButtonH = 140;
            REHomeEndModel *bookModel = model[i];
            UIButton *backButton = [self.contentView viewWithTag:200+i];
            backButton.frame = CGRectMake(index * (backButtonW + Width_Space) + Start_X, page  * (backButtonH+12+21 + Height_Space)+Start_Y, backButtonW, backButtonH+12+21);
            [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(backButton, @"book_id", bookModel.end_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

//            NSString *scoreStr = [NSString stringWithFormat:@"%@分",bookModel.grade];
//            CGSize scoresize = [ToolObject sizeWithText:scoreStr withFont:REFont(13)];
//            UILabel *scoreLabel = [backButton viewWithTag:230+i];
//            NSMutableAttributedString *scoreLabelstring = [[NSMutableAttributedString alloc] initWithString:scoreStr attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//            scoreLabel.backgroundColor = REColor(255, 104, 42);
//            scoreLabel.attributedText = scoreLabelstring;
//            scoreLabel.frame = CGRectMake(backButton.width-12-scoresize.width, 0, scoresize.width+12, 20);

        }
    } else if (model.count<7) {
           for (int i = 0 ; i < model.count; i++) {
               NSInteger index = i % 3;
               NSInteger page = i / 3;
               CGFloat backButtonW = 104;
               CGFloat backButtonH = 140;
               REHomeEndModel *bookModel = model[i];
               UIButton *backButton = [self.contentView viewWithTag:200+i];
               backButton.frame = CGRectMake(index * (backButtonW + Width_Space) + Start_X, page  * (backButtonH+12+21 + Height_Space)+Start_Y, backButtonW, backButtonH+12+21);
               [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
               objc_setAssociatedObject(backButton, @"book_id", bookModel.end_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
               
//               NSString *scoreStr = [NSString stringWithFormat:@"%@分",bookModel.grade];
//               CGSize scoresize = [ToolObject sizeWithText:scoreStr withFont:REFont(13)];
//               UILabel *scoreLabel = [backButton viewWithTag:230+i];
//               NSMutableAttributedString *scoreLabelstring = [[NSMutableAttributedString alloc] initWithString:scoreStr attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//               scoreLabel.backgroundColor = REColor(255, 104, 42);
//               scoreLabel.attributedText = scoreLabelstring;
//               scoreLabel.frame = CGRectMake(backButton.width-12-scoresize.width, 0, scoresize.width+12, 20);

           }

       } else if (model.count<10) {
           for (int i = 0 ; i < model.count; i++) {
               REHomeEndModel *bookModel = model[i];
               CGFloat backButtonW = 104;
               CGFloat backButtonH =  140 ;
               if (i<6) {
                   NSInteger index = i % 3;
                   NSInteger page = i / 3;
                   UIButton *backButton = [self.contentView viewWithTag:200+i];
                   backButton.frame = CGRectMake(index * (backButtonW + Width_Space) + Start_X, page  * (backButtonH+12+21 + Height_Space)+Start_Y, backButtonW, backButtonH+12+21);
                   [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                   objc_setAssociatedObject(backButton, @"book_id", bookModel.end_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                   objc_setAssociatedObject(backButton, @"imageStr", bookModel.coverpic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

                   UIImageView *buttonImageView = [backButton viewWithTag:210+i];
                   buttonImageView.frame = CGRectMake(0, 0, backButtonW, backButtonH);
                   [buttonImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.coverpic] placeholderImage:PlaceholderImage];

                   UILabel *buttonLabel = [backButton viewWithTag:220+i];
                   buttonLabel.textAlignment = NSTextAlignmentCenter;
                   NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:bookModel.title attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
                   buttonLabel.attributedText = string;
                   buttonLabel.frame = CGRectMake(0, backButtonH+12, backButtonW, 21);
                   
//                   NSString *scoreStr = [NSString stringWithFormat:@"%@分",bookModel.grade];
//                   CGSize scoresize = [ToolObject sizeWithText:scoreStr withFont:REFont(13)];
//                   UILabel *scoreLabel = [backButton viewWithTag:230+i];
//                   NSMutableAttributedString *scoreLabelstring = [[NSMutableAttributedString alloc] initWithString:scoreStr attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//                   scoreLabel.backgroundColor = REColor(255, 104, 42);
//                   scoreLabel.attributedText = scoreLabelstring;
//                   scoreLabel.frame = CGRectMake(backButton.width-12-scoresize.width, 0, scoresize.width+12, 20);

               } else {
                   
                   UIButton *backButton = [self.contentView viewWithTag:200+i];
                   backButton.frame = CGRectMake(0, 12+2*49+2*backButtonH+(i-6)*(172), REScreenWidth, 172);
                   [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                   objc_setAssociatedObject(backButton, @"book_id", bookModel.end_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                   objc_setAssociatedObject(backButton, @"imageStr", bookModel.coverpic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

                   UIImageView *buttonImageView = [backButton viewWithTag:210+i];
                   buttonImageView.frame = CGRectMake(16, 16, 104, 140);
                   [buttonImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.coverpic] placeholderImage:PlaceholderImage];
                   
                   
                   CGSize size = [ToolObject sizeWithText:bookModel.title withFont:REFont(17)];
                   UILabel *buttonLabel = [self.contentView viewWithTag:220+i];
                    NSMutableAttributedString *buttonLabelstring = [[NSMutableAttributedString alloc] initWithString:bookModel.title attributes:@{NSFontAttributeName: REFont(17), NSForegroundColorAttributeName: REFontColor}];
                    buttonLabel.attributedText = buttonLabelstring;
                    buttonLabel.textColor = REFontColor;
                   buttonLabel.frame = CGRectMake(132, 18, size.width, 24);
                   
                   NSString *scoreStr = [NSString stringWithFormat:@"%@分",bookModel.grade];
                   CGSize scoresize = [ToolObject sizeWithText:scoreStr withFont:REFont(13)];
                   UILabel *scoreLabel = [backButton viewWithTag:230+i];
                   NSMutableAttributedString *scoreLabelstring = [[NSMutableAttributedString alloc] initWithString:scoreStr attributes:@{NSFontAttributeName: REFont(13), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
                   scoreLabel.attributedText = scoreLabelstring;
                   scoreLabel.backgroundColor = REColor(255, 191, 175);
                   scoreLabel.frame = CGRectMake(buttonLabel.right+10, 20, scoresize.width+12, 20);
                
                   UILabel *detailLabel = [backButton viewWithTag:240+i];
                   NSString *detailStr = bookModel.contents;
                   detailStr = [detailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                   detailStr = [detailStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                   CGSize detailStrSize = [self textHeightFromTextString:detailStr width:227 fontSize:14];
                   CGFloat rate = detailLabel.font.lineHeight;//每行需要的高度
                   if (detailStrSize.height>rate*3) {
                       detailStrSize.height = rate*3;
                   }
                   NSMutableAttributedString *detailLabelstring = [[NSMutableAttributedString alloc] initWithString:detailStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
                   detailLabel.attributedText = detailLabelstring;
                   detailLabel.frame = CGRectMake(buttonImageView.right+10, 52, 227, detailStrSize.height+20);
                   [detailLabel setText:bookModel.contents lineSpacing:6.0f];
                   detailLabel.font = REFont(14);

                   UIView *lineView = [backButton viewWithTag:250+i];
                   lineView.backgroundColor = REBackColor;
                   lineView.frame = CGRectMake(0, 172, REScreenWidth, 8);
               }
           }
       }
}

- (void)backButtonAction:(UIButton *)sender {
    NSString * book_id = objc_getAssociatedObject(sender, @"book_id");
    NSString * imageStr = objc_getAssociatedObject(sender, @"imageStr");
    if (self.readingBookBlock) {
        self.readingBookBlock(sender,book_id,imageStr);
    }
}

@end
