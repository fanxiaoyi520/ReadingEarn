//
//  REClassCollectionViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/18.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REClassCollectionViewCell.h"

@interface REClassCollectionViewCell ()

@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *typeLabel;
@property (nonatomic ,strong)UIImageView *imageView;
@end

@implementation REClassCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    //1.title
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //2.type
    UILabel *typeLabel = [UILabel new];
    typeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    //3.image
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)showClassWithModel:(ClassModel *)model {
    
    //1.
    NSMutableAttributedString *titlestring = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:18], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.titleLabel.attributedText = titlestring;
    self.titleLabel.frame = CGRectMake(16, 12, 80, 25);

    //2.
    NSMutableAttributedString *typestring = [[NSMutableAttributedString alloc] initWithString:model.attribute_name attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.typeLabel.attributedText = typestring;
    self.typeLabel.frame = CGRectMake(16, 59, 100, 20);
    
    //3.
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:PlaceholderImage];
    self.imageView.frame = CGRectMake(self.frame.size.width-50-16, 8, 50, 50);
}

@end
