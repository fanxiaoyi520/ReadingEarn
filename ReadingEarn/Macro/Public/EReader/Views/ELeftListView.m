//
//  ELeftListView.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "ELeftListView.h"
#import "EDataSourceManager.h"
#import "EMarkCell.h"
#import "EDataCenter.h"

#pragma mark - CELL REUSE ID
static NSString * const kChapterCellID = @"EChapterCellID";
static NSString * const kMarkCellID = @"EMarkCellID";

@implementation ELeftListView{

    NSInteger _dataCount;
    NSMutableArray *_dataSource;
    UISegmentedControl *_segmentControl;
    CGFloat  _panStartX;
    BOOL    _isMenu;
    BOOL    _isMark;
    
    UIImageView *_detailImageButton;
}

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        _dataCount = [EDataSourceManager shareInstance].totalChapter;
        [self configListView];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEListView:)];
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}

- (void)detailButtonAction:(UITapGestureRecognizer *)sender {
     UIViewController *nav = [ToolObject jsd_getCurrentViewController];
    REHomeBookDetailViewController *vc = [REHomeBookDetailViewController new];
    vc.book_id = [EDataSourceManager shareInstance].book_id;
    vc.imageStr = [EDataSourceManager shareInstance].imageStr;
    [nav.navigationController pushViewController:vc animated:YES];
}

#pragma mark - View -
- (void)configListView{
    
    _isMenu = YES;
    _isMark = NO;
    
    
    _detailImageButton = [UIImageView new];
    [self addSubview:_detailImageButton];
    _detailImageButton.userInteractionEnabled = YES;
    _detailImageButton.frame = CGRectMake((self.width-104)/2, 30, 104, 140);
    _detailImageButton.layer.cornerRadius = 10;
    _detailImageButton.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailButtonAction:)];
    [_detailImageButton addGestureRecognizer:tap];
    _detailImageButton.backgroundColor = [UIColor blueColor];
    [_detailImageButton sd_setImageWithURL:[NSURL URLWithString:[EDataSourceManager shareInstance].imageStr] placeholderImage:PlaceholderImage];
    
    [self configListViewHeader];
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, _detailImageButton.bottom+80, self.frame.size.width, self.frame.size.height - 170)];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor clearColor];
    _listView.bounces = YES;
    [self addSubview:_listView];
    _listView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(leftListView:footerWithRefreshing:)]) {
            [self.delegate leftListView:self footerWithRefreshing:@""];
        }
    }];

    
    //[_listView registerClass:[UITableViewCell class] forCellReuseIdentifier:kChapterCellID];
    [_listView registerClass:[EMarkCell class] forCellReuseIdentifier:kMarkCellID];
    self.backgroundColor = REWhiteColor;

    UIButton *otherBtn = [UIButton buttonWithType:0];
    otherBtn.frame = CGRectMake(70, self.frame.size.height - 40, self.frame.size.width - 140, 20);
    otherBtn.layer.borderWidth = 1.0;
    otherBtn.layer.cornerRadius = 2.0;
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [otherBtn setTitleColor:[UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:0];
    otherBtn.hidden = YES;
    [otherBtn setTitle:@"备用按钮" forState:0];
    otherBtn.layer.borderColor = [UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0].CGColor;
    [self addSubview:otherBtn];
    
}

- (void)configListViewHeader{
    
    NSArray *segmentedArray = @[@"目录"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentControl.frame = CGRectMake(15, _detailImageButton.bottom+30, self.bounds.size.width - 30 , 40);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    [self addSubview:_segmentControl];
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [_segmentControl setTitleTextAttributes:dict forState:0];
    
}

#pragma mark - User Action -
- (void)segmentAction:(UISegmentedControl *)sender{
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:{
            _isMenu = YES;
            _isMark = NO;
            _dataCount = [EDataSourceManager shareInstance].totalChapter;
            [_listView reloadData];
        }
            break;
        case 1:{
            _isMenu = NO;
            _isMark = YES;
            _dataSource = [EDataCenter e_getMark];
            [_listView reloadData];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)panEListView:(UIPanGestureRecognizer *)recongnizer{
    
    CGPoint touchPoint = [recongnizer locationInView:self];
    
    switch (recongnizer.state) {
        case UIGestureRecognizerStateBegan:{
            _panStartX = touchPoint.x;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            CGFloat offSetX = touchPoint.x - _panStartX;
            CGRect newFrame = self.frame;
            newFrame.origin.x += offSetX;
            if (newFrame.origin.x >= 0){//试图向上滑动 阻止
                
                newFrame.origin.x = 0;
                self.frame = newFrame;
                return;
            }else{
                self.frame = newFrame;
            }
            
            
        }
            
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            float duringTime = (self.frame.size.width + self.frame.origin.x)/self.frame.size.width * 0.25;
            if (self.frame.origin.x < 0) {
                [UIView animateWithDuration:duringTime animations:^{
                    self.frame = CGRectMake(-self.frame.size.width , 0,  self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(removeLeftListView)]) {
                        [self.delegate removeLeftListView];
                    }
    
                }];
                
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource and UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMark) {
        return 100;
    }
    
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isMark) {
        return _dataSource.count;
    }
    _dataCount = [EDataSourceManager shareInstance].totalChapter;
    return _dataCount;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EEveryChapter *chapter = [EDataSourceManager shareInstance].chapterInfoArray[indexPath.row];
    if (_isMark) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(leftListView:clickMark:)]) {
            [self.delegate leftListView:self clickMark:[_dataSource objectAtIndex:chapter.chapterNum-1]];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftListView:clickChapter:)]) {
        [self.delegate leftListView:self clickChapter:chapter.chapterNum-1];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMenu == YES) {
        
        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChapterCellID forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor clearColor];
//        EEveryChapter *chapter = [EDataSourceManager shareInstance].chapterInfoArray[indexPath.row];
//
//        if ([chapter.locked isEqualToString:@"0"]) {
//            NSString *str = chapter.chapterTitle;
//            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            cell.textLabel.text = [NSString stringWithFormat:@"%@",str];
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//            //cell.textLabel.text = [NSString stringWithFormat:@"第%ld章(vip)",indexPath.row + 1];
//        }else{
//            //cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row + 1];
//            NSString *str = chapter.chapterTitle;
//            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            cell.textLabel.text = [NSString stringWithFormat:@"%@",str];
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//
//        }
        EEveryChapter *chapter = [EDataSourceManager shareInstance].chapterInfoArray[indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChapterCellID];
            cell.backgroundColor = [UIColor clearColor];

            UIImageView *imageView = [UIImageView new];
            [cell.contentView addSubview:imageView];
            imageView.tag = 10;
            
            
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentLeft;
            label.tag = 20;
            [cell.contentView addSubview:label];
            
        }
        
        if (![chapter.locked isEqualToString:@"0"]) {
            UIImageView *imageView = [cell.contentView viewWithTag:10];
            imageView.frame = CGRectMake(20, 15, 20, 20);
            imageView.image = REImageName(@"is_vip");
            
            NSString *str = chapter.chapterTitle;
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            UILabel *label = [cell.contentView viewWithTag:20];
            label.text = [NSString stringWithFormat:@"%@",str];
            label.frame = CGRectMake(imageView.right+20, 15, cell.width-60, 20);
        } else {
            NSString *str = chapter.chapterTitle;
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            UILabel *label = [cell.contentView viewWithTag:20];
            label.frame = CGRectMake(0, 15, cell.width, 20);
            label.text = [NSString stringWithFormat:@"%@",str];
        }
        return cell;
        
    }else{
        
        EMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kMarkCellID forIndexPath:indexPath];
        cell.model = (EMarkModel *)[_dataSource objectAtIndex:indexPath.row];
        return cell;
        
    }
}


@end
