//
//  FilterHTML.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterHTML : NSObject
 //过滤
 /**
  * 过滤标签
  */
 +(NSString *)filterHTML:(NSString *)str;
 +(NSString *)filterHTMLImage:(NSString *)str;
/**
 * 替换部分标签
 */
+ (NSString *)filterHTMLTag:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
