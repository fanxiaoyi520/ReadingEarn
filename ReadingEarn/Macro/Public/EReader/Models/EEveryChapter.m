//
//  EEveryChapter.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EEveryChapter.h"

@implementation EEveryChapter

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"chapterId" : @"chapter_number",
             @"chapterContent" : @"contents",
             @"chapterNum" : @"chapter_number",
             //@"chapterIsFree" : @"is_free",
//             @"chapterIsFree" : @"locked",
             @"chapterTitle":@"chapter_name"
             };
}

@end
