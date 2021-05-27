//
//  EDataSourceManager.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EDataSourceManager.h"
#import "EDataCenter.h"
#import "ECommonHeader.h"
#import "EHUDView.h"
#import "FilterHTML.h"
@implementation EDataSourceManager

+ (EDataSourceManager *)shareInstance{
    static EDataSourceManager *dataSource;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        dataSource = [[EDataSourceManager alloc] init];
    });
    
    return dataSource;
}

- (EEveryChapter *)openChapter:(NSInteger)clickChapter{

    _currentChapterIndex = clickChapter;
    
    EEveryChapter *chapter = [[EEveryChapter alloc] init];
// **************此处为原先读本地的小说源******************
//    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
//    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    
    chapter.chapterContent = [self readChapterContentsWithChapterNo:_currentChapterIndex needDownLoad:YES];
    chapter.chapterNum = _currentChapterIndex;
    return chapter;
}

//- (EEveryChapter *)openChapter {
//
//    NSUInteger index = [EDataCenter e_getChapterBefore];
//
//    _currentChapterIndex = index;
//
//    EEveryChapter *chapter = [[EEveryChapter alloc] init];
//// **************此处为原先读本地的小说源******************
////    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
////    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
////    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
//
////    EEveryChapter *chapters = [EDataSourceManager shareInstance].chapterInfoArray[0];
////    chapter.chapterContent = [self readChapterContentsWithChapterNo:chapters.chapterNum needDownLoad:YES];
////    chapter.chapterNum = chapters.chapterNum;
//    chapter.chapterContent = [self readChapterContentsWithChapterNo:_currentChapterIndex needDownLoad:YES];
//    chapter.chapterNum = _currentChapterIndex;
//
//    return chapter;
//}

- (EEveryChapter *)openChapters:(NSString *)chapter_number {
    
    NSUInteger index = [EDataCenter e_getChapterBefore:chapter_number];
    
    _currentChapterIndex = index;
    
    EEveryChapter *chapter = [[EEveryChapter alloc] init];
// **************此处为原先读本地的小说源******************
//    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
//    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];

//    EEveryChapter *chapters = [EDataSourceManager shareInstance].chapterInfoArray[0];
//    chapter.chapterContent = [self readChapterContentsWithChapterNo:chapters.chapterNum needDownLoad:YES];
//    chapter.chapterNum = chapters.chapterNum;
    chapter.chapterContent = [self readChapterContentsWithChapterNo:_currentChapterIndex needDownLoad:YES];
    chapter.chapterNum = _currentChapterIndex;
    
    return chapter;
}

- (NSUInteger)openPage{
    
    NSUInteger index = [EDataCenter e_getPageBefore];
    return index;
    
}


- (EEveryChapter *)nextChapter{
    
//    if (_currentChapterIndex >= _totalChapter) {
//        //[E_HUDView showMsg:@"没有更多内容了" inView:nil];
//        return nil;
//        
//    }else{
        _currentChapterIndex++;
        EEveryChapter *chapter = [EEveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex,YES);
        
        return chapter;
        
//    }
    
}

- (EEveryChapter *)preChapter{
    
    if (_currentChapterIndex <= 1) {
       // [E_HUDView showMsg:@"已经是第一页了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex --;
        
        EEveryChapter *chapter = [EEveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex ,YES);
        
        return chapter;
    }
}

- (void)resetTotalString{
    
    _totalString = [NSMutableString string];
    _everyChapterRange = [NSMutableArray array];
    
    for (int i = 1; i <  INT_MAX; i ++) {
        
        if (readTextData(i,NO).length > 0) {
            
            NSUInteger location = _totalString.length;
            [_totalString appendString:readTextData(i,NO)];
            NSUInteger length = _totalString.length - location;
            NSRange chapterRange = NSMakeRange(location, length);
            [_everyChapterRange addObject:NSStringFromRange(chapterRange)];
            
            
        }else{
            break;
        }
    }
    
}

- (NSInteger)getChapterBeginIndex:(NSInteger)page{
    
    NSInteger index = 0;
    for (int i = 1; i < page; i ++) {
        
        if (readTextData(i,NO).length > 0) {
            
            index += readTextData(i,NO).length;
            // NSLog(@"index == %ld",index);
            
        }else{
            break;
        }
    }
    return index;
}

- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord{
    //关键字为空 则返回空数组
    if (keyWord == nil || [keyWord isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *searchResult = [[NSMutableArray alloc] initWithCapacity:0];//内容
    NSMutableArray *whichChapter = [[NSMutableArray alloc] initWithCapacity:0];//内容所在章节
    NSMutableArray *locationResult = [[NSMutableArray alloc] initWithCapacity:0];//搜索内容所在range
    NSMutableArray *feedBackResult = [[NSMutableArray alloc] initWithCapacity:0];//上面3个数组集合
    
    
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < keyWord.length; i ++) {
        
        [blankWord appendString:@" "];
    }
    
    //一次搜索20条
    for (int i = 0; i < 20; i++) {
        
        if ([_totalString rangeOfString:keyWord options:1].location != NSNotFound) {
            
            NSInteger newLo = [_totalString rangeOfString:keyWord options:1].location;
            NSInteger newLen = [_totalString rangeOfString:keyWord options:1].length;
            // NSLog(@"newLo == %ld,, newLen == %ld",newLo,newLen);
            int temp = 0;
            for (int j = 0; j < _everyChapterRange.count; j ++) {
                if (newLo > NSRangeFromString([_everyChapterRange objectAtIndex:j]).location) {
                    temp ++;
                }else{
                    break;
                }
                
            }
            
            [whichChapter addObject:[NSString stringWithFormat:@"%d",temp]];
            [locationResult addObject:NSStringFromRange(NSMakeRange(newLo, newLen))];
            
            NSRange searchRange = NSMakeRange(newLo, [self doRandomLength:newLo andPreOrNext:NO] == 0?newLen:[self doRandomLength:newLo andPreOrNext:NO]);
            
            NSString *completeString = [[_totalString substringWithRange:searchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [searchResult addObject:completeString];
            
            
            
            [_totalString replaceCharactersInRange:NSMakeRange(newLo, newLen) withString:blankWord];
            
        }else{
            break;
        }
    }
    
    [feedBackResult addObject:searchResult];
    [feedBackResult addObject:whichChapter];
    [feedBackResult addObject:locationResult];
    return feedBackResult;
    
}

- (NSInteger)doRandomLength:(NSInteger)location andPreOrNext:(BOOL)sender{
    
    //获取1到x之间的整数
    if (sender == YES) {
        
        NSInteger temp = location;
        NSInteger value = (arc4random() % 13) + 5;
        location -=value;
        if (location<0) {
            location = temp;
        }
        
        return location;
        
    }else{
        
        NSInteger value = (arc4random() % 20) + 20;
        if (location + value >= _totalString.length) {
            value = 0;
        }else{
            //do nothing
        }
        
        return value;
    }
}

static NSString *readTextData(NSUInteger index , bool downLoad){
 // **************此处为原先读本地的小说源******************   
//    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",index];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
//    NSString *content = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    NSString *content = [[EDataSourceManager shareInstance] readChapterContentsWithChapterNo:index needDownLoad:downLoad];
    return content;
}




////////////
- (void)downloadContentsWithChapterNo:(NSInteger)chapterNo{
    NSString *chapterNoStr = [NSString stringWithFormat:@"%ld",(long)chapterNo];
    WS(weakSelf);
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/novel/get_contents",HomePageDomainName];
    //初始化一个AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //请求体，参数（NSDictionary 类型）
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSDictionary *parameters = @{
                             @"bookid":self.book_id,
                             @"chaps":chapterNoStr,
                             @"token":token,
                            };
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress:%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
        NSString *chapter_name = [dic objectForKey:@"chapter_name"];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if ([code isEqualToString:@"1"]) {
            NSString *contents = [dic objectForKey:@"contents"];
            NSString *splicingContents = [NSString stringWithFormat:@"</p><p>%@</p><p>%@",chapter_name,contents];

            NSString *dd = [FilterHTML filterHTMLTag:splicingContents];
            NSString *ss = [FilterHTML filterHTML:dd];
            [dic setValue:ss forKey:@"contents"];
            EEveryChapter *everyChapter = [EEveryChapter mj_objectWithKeyValues:dic];
            weakSelf.everyChapter = everyChapter;
            [weakSelf handleResultModel:everyChapter];
            [weakSelf prepareToReading:everyChapter];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [EHUDView showMsg:msg inView:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

- (NSString *)readChapterContentsWithChapterNo:(NSInteger)chapterNo needDownLoad:(BOOL)flag{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    
    NSString *newFielPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Chapter%zd.txt",chapterNo]];
    
    NSString *content = [NSString stringWithContentsOfFile:newFielPath encoding:NSUTF8StringEncoding error:nil];
    if (content.length > 0) {//如果有 就读取
        return content;
    }else{//没有就下载
        if (flag) {
            [self downloadContentsWithChapterNo:chapterNo];
        }
        
        return @"";
    }
    
}


- (void)handleResultModel:(EEveryChapter *)everyChapter{

    if (everyChapter.chapterContent.length > 0) {//存本地
        NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
        
        NSString *newFielPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Chapter%zd.txt",everyChapter.chapterNum]];
                                
        NSError *error = nil;
                                
        BOOL isSucceed = [everyChapter.chapterContent writeToFile:newFielPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"isSucceed = %d",isSucceed);
        
    }
}

- (void)prepareToReading:(EEveryChapter *)everyChapter{
    if (everyChapter.chapterNum == _currentChapterIndex) {
        if (_readingBlock) {
            _readingBlock(_currentChapterIndex);
        }
    }
}


////章节信息
- (void)downloadChapterInfo:(NSString *)bookId withImageStr:(NSString *)imageStr withPage:(NSInteger)page finish:(void(^)(void))downloadFinsih{
    if (page == 1) {
        [self.chapterInfoArray removeAllObjects];
    }
    self.book_id = bookId;
    self.imageStr = imageStr;
    NSString *chapterInfoUrl = [NSString stringWithFormat:@"%@/novel/get_chapter_data",HomePageDomainName];
    //url
    NSString *urlString = chapterInfoUrl;
    //初始化一个AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求体数据为json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置响应体数据为json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //请求体，参数（NSDictionary 类型）
    WS(weakSelf);

    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *parameters = @{@"token":token,
                                 @"bookid":bookId,
                                 @"page":pageStr,
                                 @"limit":@"500",
                                 @"order":@"ase"
                                 };
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress:%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);

        NSArray *array = responseObject[@"data"];
        [weakSelf.chapterInfoArray addObjectsFromArray:[EEveryChapter mj_objectArrayWithKeyValuesArray:array]];
        weakSelf.totalChapter = weakSelf.chapterInfoArray.count;
        downloadFinsih();

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

- (UIColor *)getThemeImage{

    NSInteger themeID = [EDataCenter e_getReadTheme];
    UIImage *_themeImage;
    if (themeID == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)themeID]];
    }
    
    if (_themeImage == nil) {
         return [UIColor whiteColor];
    }else{
         return [UIColor colorWithPatternImage:_themeImage];
    }
    
}

- (BOOL)isVipStatus{

    return self.isVip;

}

- (void)setVipStatus:(BOOL)isVip{

    self.isVip = isVip;
}

#pragma mark - Getter -
- (NSMutableArray *)chapterInfoArray{

    if (!_chapterInfoArray) {
        _chapterInfoArray = [[NSMutableArray alloc] init];
    }
    return _chapterInfoArray;
}

- (void)removeDataBase:(NSString*)name {
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *baseSavePath = [documentPath stringByAppendingString:@"/IOSBundle/ios_patch/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [fileManager enumeratorAtPath:documentPath];  //baseSavePath 为文件夹的路径
    NSMutableArray *filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    NSString *file;
    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        if([[file pathExtension] isEqualToString:name])  //取得后缀名为.pat的文件名
        {
            //[filePathArray addObject:[documentPath stringByAppendingPathComponent:file]];//存到数组
            NSString *bundlePath = [documentPath stringByAppendingPathComponent:file];
            [fileManager removeItemAtPath:bundlePath error:nil];
        }
    }
    //NSString *patch1Path = [filePathArray lastObject];
}

@end
