//
//  REHomeOneTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/17.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeOneTableViewCell.h"
@interface REHomeOneTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *homeBannelArray;
@property (nonatomic, strong) NSMutableArray *homeIconArray;
@property (nonatomic, strong) NSMutableArray *homeQuick1Array;
@property (nonatomic, strong) UIScrollView *bannelScrollow;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *LeftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) CGFloat second;
@end

@implementation REHomeOneTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HomeModel *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.homeBannelArray = [NSMutableArray array];
        self.homeIconArray = [NSMutableArray array];
        self.homeQuick1Array = [NSMutableArray array];
        
        self.currentIndex = 0;
        self.second = 3;
        [self re_loadUI:model];
    }
    return self;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_centerImageView.layer setMasksToBounds:YES];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.backgroundColor = [UIColor whiteColor];
    }
    return _centerImageView;
}

- (UIImageView *)LeftImageView {
    if (!_LeftImageView) {
        _LeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_LeftImageView.layer setMasksToBounds:YES];
        _LeftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _LeftImageView.backgroundColor = [UIColor whiteColor];
    }
    return _LeftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_rightImageView.layer setMasksToBounds:YES];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.backgroundColor = [UIColor whiteColor];
    }
    return _rightImageView;
}

- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scroll.backgroundColor=[UIColor whiteColor];
        _scroll.showsHorizontalScrollIndicator=NO;
        _scroll.showsVerticalScrollIndicator=NO;
        _scroll.pagingEnabled=YES;
        _scroll.bounces=NO;
        _scroll.delegate=self;
        _scroll.contentOffset=CGPointMake(REScreenWidth, 0);
        _scroll.contentSize=CGSizeMake(REScreenWidth*3, 0);
        [_scroll addSubview:self.LeftImageView];
        
        [_scroll addSubview:self.centerImageView];
        
        [_scroll addSubview:self.rightImageView];
    }
    
    return _scroll;
}

- (void)re_loadUI:(HomeModel *)model {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (HomeBannelModel *bannelModel in model.banner) {
        [imageArray addObject:bannelModel];
     }
    //1.轮播图

//    if ([ToolObject onlineAuditJudgment] == YES) {
//        [self.contentView addSubview:self.scroll];
//        //    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
//        //    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    } else {
        UIScrollView *bannelScrollow = [UIScrollView new];
        bannelScrollow.showsHorizontalScrollIndicator = NO;
        bannelScrollow.bounces = YES;
        bannelScrollow.pagingEnabled = YES;
        [self.contentView addSubview:bannelScrollow];
        self.bannelScrollow = bannelScrollow;
        for (int i=0; i<10; i++) {
            UIImageView *bannerImageView = [UIImageView new];
            bannerImageView.tag = 100 + i;
            bannerImageView.userInteractionEnabled = YES;
            [bannelScrollow addSubview:bannerImageView];
        }
//    }

    //2.icon
    NSMutableArray *iconArray = [NSMutableArray array];
    for (HomeIconModel *iconModel in model.icon) {
        [iconArray addObject:iconModel];
    }
    for (int i=0; i<4; i++) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.tag = 200 + i;
        [self.contentView addSubview:backButton];
        
        UIImageView *buttonImage = [UIImageView new];;
        buttonImage.tag = 220+i;
        [backButton addSubview:buttonImage];
        
        UILabel *buttonLabel = [UILabel new];
        buttonLabel.textAlignment = NSTextAlignmentCenter;
        buttonLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        buttonLabel.tag = 240+i;
        [backButton addSubview:buttonLabel];
    }
    
    //3.热门最新
    NSMutableArray *quick1Array = [NSMutableArray array];
    for (HomeQuick1Model *quick1Model in model.quick1) {
        [quick1Array addObject:quick1Model];
    }
    for (int i=0; i<2; i++) {
        UIImageView *hotAndNewImageView = [UIImageView new];
        hotAndNewImageView.userInteractionEnabled = YES;
        hotAndNewImageView.backgroundColor = REWhiteColor;
        hotAndNewImageView.tag = 300 + i;
        hotAndNewImageView.layer.shadowColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.20].CGColor;
        hotAndNewImageView.layer.shadowOffset = CGSizeMake(0,2);
        hotAndNewImageView.layer.shadowRadius = 10;
        hotAndNewImageView.layer.shadowOpacity = 1;
        hotAndNewImageView.layer.cornerRadius = 16;
        [self.contentView addSubview:hotAndNewImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotAndNewAction:)];
        [hotAndNewImageView addGestureRecognizer:tap];
    }
    
    //4.阅读记录
    UIButton *readHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:readHistoryButton];
    readHistoryButton.tag = 2000;
    
    UIImageView *readImageView = [UIImageView new];
    readImageView.tag = 400;
    [readHistoryButton addSubview:readImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readHistoryButtonAction:)];
    [readImageView addGestureRecognizer:tap];
    
    
    UILabel *defaultTitleLabel = [UILabel new];
    [readHistoryButton addSubview:defaultTitleLabel];
    defaultTitleLabel.tag = 440;
    defaultTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *defaultcontentLabel = [UILabel new];
    [readHistoryButton addSubview:defaultcontentLabel];
    defaultcontentLabel.tag = 450;
    defaultcontentLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *readTitleLabel = [UILabel new];
    readTitleLabel.tag = 410;
    readTitleLabel.userInteractionEnabled = YES;
    readTitleLabel.font = REFont(14);
    [readHistoryButton addSubview:readTitleLabel];
    readTitleLabel.textColor = REWhiteColor;
    
    UILabel *contenReadLabel = [UILabel new];
    contenReadLabel.userInteractionEnabled = YES;
    [readHistoryButton addSubview:contenReadLabel];
    contenReadLabel.tag = 420;
    contenReadLabel.numberOfLines = 0;
    [contenReadLabel sizeToFit];
    contenReadLabel.textAlignment = NSTextAlignmentCenter;
    contenReadLabel.font = REFont(14);
    contenReadLabel.textColor = REWhiteColor;
    
    //5.搜索
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.tag = 500;
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    searchButton.layer.cornerRadius = 17;
    searchButton.layer.shadowColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.20].CGColor;
    searchButton.layer.shadowOffset = CGSizeMake(0,2);
    searchButton.layer.shadowRadius = 10;
    searchButton.layer.shadowOpacity = 1;
    [self.contentView addSubview:searchButton];

    UIImageView *searchImageView = [UIImageView new];
    searchImageView.tag = 510;
    [searchButton addSubview:searchImageView];
    
    UILabel *searchLabel = [UILabel new];
    searchLabel.tag = 520;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请输入书名搜索" attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    searchLabel.attributedText = string;
    searchLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [searchButton addSubview:searchLabel];
}

- (void)showDataWithModel:(HomeModel *)model withHistoryModel:(REHistoryBackModel *)historyModel withReadHistoryModel:(REReadHistoryModel *)readHistoryModel{
    [self.homeBannelArray removeAllObjects];
    [self.homeIconArray removeAllObjects];
    [self.homeQuick1Array removeAllObjects];
    
    if (!model) {
        return;
    }
    if ([ToolObject onlineAuditJudgment] == YES) {
        //获取banner图片数据
        for (HomeBannelModel *bannelModel in model.banner) {
            [self.homeBannelArray addObject:bannelModel];
        }
        
        //获取icon数据
        for (HomeIconModel *iconModel in model.icon) {
            [self.homeIconArray addObject:iconModel];
        }
    } else {
        NSArray *array = @[@"my_bannel_1",@"my_bannel_2",@"my_bannel_3"];
        for (int i=0; i<3; i++) {
            [self.homeBannelArray addObject:array[i]];
        }
        
        NSArray *array1 = @[@"my_1",@"my_2",@"my_3",@"my_4"];
        for (int i=0; i<4; i++) {
            [self.homeIconArray addObject:array1[i]];
        }
    }
    //获取quick1数据
    //获取icon数据
    for (HomeQuick1Model *quick1Model in model.quick1) {
        [self.homeQuick1Array addObject:quick1Model];
    }
    
    //1.
    CGFloat  bannelH = REScreenWidth*140/375;
    self.bannelScrollow.frame = CGRectMake(0, 0, REScreenWidth, bannelH);

    if ([ToolObject onlineAuditJudgment] == YES) {
        self.bannelScrollow.contentSize = CGSizeMake(self.homeBannelArray.count*REScreenWidth, bannelH);
        for (int i=0; i<self.homeBannelArray.count; i++) {
            HomeBannelModel *bannelModel = self.homeBannelArray[i];
            UIImageView *bannelImageView = [self.bannelScrollow viewWithTag:100+i];
            bannelImageView.frame = CGRectMake(i*REScreenWidth, 0, REScreenWidth, bannelH);
            [bannelImageView sd_setImageWithURL:[NSURL URLWithString:bannelModel.ad_code] placeholderImage:PlaceholderImage];

            if ([bannelModel.ad_link isEqualToString:@"zhibo"]) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBannelAction:)];
                [bannelImageView addGestureRecognizer:tap];
            }
        }
//        self.scroll.frame = CGRectMake(0, 0, REScreenWidth, bannelH);
//        self.centerImageView.frame = CGRectMake(REScreenWidth, 0, REScreenWidth, bannelH);
//        self.LeftImageView.frame = CGRectMake(0, 0, REScreenWidth, bannelH);
//        self.rightImageView.frame = CGRectMake(2 * REScreenWidth, 0, REScreenWidth, bannelH);
//        self.imageCount = self.homeBannelArray.count;
//        self.imageArray = self.homeBannelArray;
//
//        if (!self.timer) {
//            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
//                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//        }
//       [self setImageByIndex:self.currentIndex array:self.imageArray];
    } else {
        self.bannelScrollow.contentSize = CGSizeMake(self.homeBannelArray.count*REScreenWidth, bannelH);
        for (int i=0; i<self.homeBannelArray.count; i++) {
            UIImageView *bannelImageView = [self.bannelScrollow viewWithTag:100+i];
            bannelImageView.frame = CGRectMake(i*REScreenWidth, 0, REScreenWidth, bannelH);
            bannelImageView.image = REImageName(self.homeBannelArray[i]);
        }
        //self.scroll = self.bannelScrollow;
    }
    
    //2.
    if ([ToolObject onlineAuditJudgment] == YES) {
        for (int i=0; i<self.homeIconArray.count; i++) {

            CGFloat buttonWidth = (REScreenWidth - 27*2 - 50*(self.homeIconArray.count-1))/self.homeIconArray.count;
            CGFloat backButtonH = 62*buttonWidth/44;

            HomeIconModel *iconModel = self.homeIconArray[i];
            UIButton *backButton = [self.contentView viewWithTag:200+i];
            backButton.frame = CGRectMake(27+i*(buttonWidth+(REScreenWidth-27*2-buttonWidth*self.homeIconArray.count)/(self.homeIconArray.count-1)), self.bannelScrollow.bottom+33, buttonWidth, backButtonH);
            
            UIImageView *buttonImage = [backButton viewWithTag:220+i];
            [buttonImage sd_setImageWithURL:[NSURL URLWithString:iconModel.ad_code] placeholderImage:PlaceholderImage];
            buttonImage.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
            //[buttonImageArray addObject:buttonImage];
            
            UILabel *buttonLabel = [backButton viewWithTag:240+i];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:iconModel.ad_name attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            buttonLabel.attributedText = string;
            buttonLabel.frame = CGRectMake(0, backButtonH-10, buttonWidth, 20);
            //[buttonLabelArray addObject:buttonLabel];
        }
    } else {
        NSArray *array = @[@"分类",@"榜单",@"排行",@"完结"];
        for (int i=0; i<self.homeIconArray.count; i++) {

            CGFloat buttonWidth = (REScreenWidth - 27*2 - 50*(self.homeIconArray.count-1))/self.homeIconArray.count;
            CGFloat backButtonH = 62*buttonWidth/44;

            UIButton *backButton = [self.contentView viewWithTag:200+i];
            backButton.frame = CGRectMake(27+i*(buttonWidth+(REScreenWidth-27*2-buttonWidth*self.homeIconArray.count)/(self.homeIconArray.count-1)), self.bannelScrollow.bottom+33, buttonWidth, backButtonH);
            
            UIImageView *buttonImage = [backButton viewWithTag:220+i];
            buttonImage.image = REImageName(self.homeIconArray[i]);
            buttonImage.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
            //[buttonImageArray addObject:buttonImage];
            
            UILabel *buttonLabel = [backButton viewWithTag:240+i];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            buttonLabel.attributedText = string;
            buttonLabel.frame = CGRectMake(0, backButtonH-10, buttonWidth, 20);
            //[buttonLabelArray addObject:buttonLabel];
        }
    }
    
    //3.
    for (int i=0; i<self.homeQuick1Array.count; i++) {
        CGFloat quick1Width = (REScreenWidth - 16*2 - 11*(self.homeQuick1Array.count-1))/self.homeQuick1Array.count;
        CGFloat h = quick1Width*76/166;

        HomeQuick1Model *quick1Model = self.homeQuick1Array[i];
        UIImageView *hotAndNewImageView = [self.contentView viewWithTag:300+i];
        [hotAndNewImageView sd_setImageWithURL:[NSURL URLWithString:quick1Model.ad_code] placeholderImage:PlaceholderImage];
        hotAndNewImageView.frame = CGRectMake(16+i*(quick1Width+(REScreenWidth-16*2-quick1Width*self.homeQuick1Array.count)/(self.homeQuick1Array.count-1)), self.bannelScrollow.bottom+119, quick1Width, h);
    }
    
    //4.
    CGFloat readImageViewH = REScreenWidth *94/359;
    UIButton *readHistoryButton = [self.contentView viewWithTag:2000];
    [readHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(readImageViewH);
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
    }];
    
    UIImageView *readImageView = [readHistoryButton viewWithTag:400];
    [readImageView sd_setImageWithURL:[NSURL URLWithString:historyModel.ad_code] placeholderImage:PlaceholderImage];
    [readImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(readImageViewH);
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
    }];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    
    if (readHistoryModel && ![token isEqualToString:@"(null)"]) {
        readImageView.userInteractionEnabled = YES;
        UILabel *readTitleLabel = [readHistoryButton viewWithTag:410];
        readTitleLabel.textAlignment = NSTextAlignmentLeft;
        readTitleLabel.frame = CGRectMake(120, 25, 100, 20);
        NSString *contentStr = @"上次读到:";
        readTitleLabel.text = contentStr;

        UILabel *contenReadLabel = [readHistoryButton viewWithTag:420];
        contenReadLabel.textAlignment = NSTextAlignmentLeft;
        contenReadLabel.frame = CGRectMake(120, readTitleLabel.bottom+15, 150, 20);
        
        NSString *contentStrs = [NSString stringWithFormat:@"%@",readHistoryModel.chapter_name];
        NSString *resultStr = [contentStrs stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        contenReadLabel.text = resultStr;
    }
    
    //5.
    UIButton *searchButton = [self.contentView viewWithTag:500];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bannelH-17);
        make.left.mas_equalTo(self.contentView).offset(16);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.height.equalTo(@34);
    }];
    
    //toolbar_icon_search_nor
    UIImageView *searchImageView = [searchButton viewWithTag:510];
    searchImageView.image = REImageName(@"toolbar_icon_search_nor");
    searchImageView.userInteractionEnabled = YES;
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@16);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];

    UILabel *seachLabel = [searchButton viewWithTag:520];
    seachLabel.userInteractionEnabled = YES;
    seachLabel.textAlignment = NSTextAlignmentLeft;
    [seachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@50);
        make.height.equalTo(@14);
    }];

    
}

#pragma mark - 事件
- (void)searchButtonAction:(UIButton *)sender {
    if (self.searchBlock) {
        self.searchBlock(sender);
    }
}

- (void)backButtonAction:(UIButton *)sender {
    if (self.typeClickBlock) {
        self.typeClickBlock(sender);
    }
}

- (void)readHistoryButtonAction:(id)sender {
    if (self.readHistoryBlock) {
        self.readHistoryBlock(sender);
    }
}

- (void)hotAndNewAction:(id)sender {
    if (self.rotAndNewBlock) {
        self.rotAndNewBlock(sender);
    }
}

- (void)tapBannelAction:(UIGestureRecognizer *)tap {
    if (self.liveBroadcastBlock) {
        self.liveBroadcastBlock(tap);
    }
}

#pragma mark - 轮播图
- (void)autoScroll {
    [self.scroll setContentOffset:CGPointMake(2 * REScreenWidth, 0) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self refreshImage];
    self.scroll.contentOffset = CGPointMake(REScreenWidth,0);

}

-(void)refreshImage
{
    if (self.scroll.contentOffset.x > REScreenWidth) {
        self.currentIndex=((self.currentIndex + 1) % self.imageCount);
    }
    else if(self.scroll.contentOffset.x < REScreenWidth){
        //防止currentIndex为0时，数组越界
        self.currentIndex=((self.currentIndex - 1 + self.imageCount) % self.imageCount);
    }
    [self setImageByIndex:(NSInteger)self.currentIndex array:self.imageArray];
}

#pragma mark ----该方法根据传回的下标设置三个ImageView的图片，如果是网络图片可以在这里进行修改
-(void)setImageByIndex:(NSInteger)currentIndex array:(NSArray *)array
{
    if (!array.count) {
        [self.timer invalidate];
        self.timer = nil;

        return;
    }
//    if (array.count<3) {
//        currentIndex = 1;
//    }
    HomeBannelModel *bannelModel = array[currentIndex];
    NSString *currentImageName=[NSString stringWithString:bannelModel.ad_code];
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:currentImageName]];
    self.centerImageView.tag = currentIndex;
    self.centerImageView.userInteractionEnabled = YES;
    
//    if ([bannelModel.ad_link isEqualToString:@"zhibo"]) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBannelAction:)];
//        [self.centerImageView addGestureRecognizer:tap];
//    }

    [self.centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewClick:)]];
        
    HomeBannelModel *LeftStringmodel = array[((self.currentIndex - 1 + self.imageCount) % self.imageCount)];
    NSString *LeftString = LeftStringmodel.ad_code;
    [self.LeftImageView sd_setImageWithURL:[NSURL URLWithString:LeftString]];
        
    
    HomeBannelModel *rightStringmodel = array[((self.currentIndex + 1) % self.imageCount)];
        NSString *rightString = rightStringmodel.ad_code;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rightString]];
}

#pragma mark - banner点击事件
-(void)imgViewClick:(UITapGestureRecognizer *)recognizer {
    UIImageView *imgView = (UIImageView *)recognizer.view;
    HomeBannelModel *bannelModel = self.imageArray[imgView.tag];
    if ([bannelModel.ad_link isEqualToString:@"zhibo"]) {
        if (self.liveBroadcastBlock) {
            self.liveBroadcastBlock(recognizer);
        }
    }
}

#pragma mark -- 拖拽停止NSTimer
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshImage];
    self.scroll.contentOffset = CGPointMake(REScreenWidth,0);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.second != 0) {
        NSTimeInterval interval = fabs(self.second);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        //[self.timer invalidate];
    }
}

@end
