//
//  ZDPayNetRequestManager.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayNetRequestManager.h"
#import "ZDPayFuncTool.h"

static NSString *const SALT = @"md5_key";
@implementation ZDPayNetRequestManager
+ (instancetype)sharedSingleton {
    static ZDPayNetRequestManager *_payNetRequestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _payNetRequestManager = [[ZDPayNetRequestManager alloc] init];
    });
    return _payNetRequestManager;
}

- (void)zd_netRequestVC:(ZDPayRootViewController *)requestVC
                 Params:(id)params
             postUrlStr:(NSString *)urlStr
                suscess:(void (^)(id _Nullable responseObject))suscess {
    NSParameterAssert(params);
    NSParameterAssert(urlStr);
    
    NSDictionary *responseDic = @{
        @"isUser":@"heheh",
        @"isSetPwd":@"heheh",
        @"bankList":@[
                @{
                    @"bankName":@"adfdsafsaf",
                    @"cardId":@"adfdsafsaf",
                    @"cardPic":@"adfdsafsaf",
                    @"cardNum":@"adfdsafsaf",
                    @"cardType":@"adfdsafsaf",
                    @"serialNumber":@"adfdsafsaf",
                    @"cardBgPic":@"adfdsafsaf",
                },
                @{
                    @"bankName":@"adfdsafsaf",
                    @"cardId":@"adfdsafsaf",
                    @"cardPic":@"adfdsafsaf",
                    @"cardNum":@"adfdsafsaf",
                    @"cardType":@"adfdsafsaf",
                    @"serialNumber":@"adfdsafsaf",
                    @"cardBgPic":@"adfdsafsaf",
                },
        ],
        @"payList":@[
                @{
                    @"payType":@"payTypePic",
                    @"payTypePic":@"payTypePic"
                },
                @{
                    @"payType":@"payTypePic",
                    @"payTypePic":@"payTypePic"
                },
        ],
        /**测试*/
        @"surplusTime":@"1000",
        @"amountMoney":@"1976.00",
        @"orderNumber":@"231312421441"
    };
    suscess(responseDic);
    
    /**
    NSString *signData = [self encodedSendingBody:params];
    NSString *s = [self encryptSendingBody:params];
    NSString *encryptData = [[EncryptAndDecryptTool sharedSingleton] AESEncryptWithString:s andKey:@"1234567890secret"];

    NSDictionary *paramsDic = @{
        @"signData":signData,
        @"service":@"1",
        @"encryptData":encryptData,
        @"merId":@"1000000",
        @"sdkVersion":@"1",
        @"version":@"1.0"
    };
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [MBProgressHUD showHUDAddedTo:requestVC.view animated:YES];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:paramsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:requestVC.view animated:YES];
        suscess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:requestVC.view animated:YES];
        if (error) {
        NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString * receive = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];

        //字符串再生成NSData
        NSData *data = [receive dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict:%@",[dict objectForKey:@"message"]);
            [requestVC showMessage:[dict objectForKey:@"message"] target:nil];
        }
    }];
     */
}

/**
 对字符串/数组/字典的加密 ----以上修改之后可直接上传返回的字符串
 */
- (NSString*)encryptSendingBody:(id)params{
    NSString * dataStr;
    if ([params isKindOfClass:[NSString class]]) {
        dataStr = params;
    }else{
        NSError*error;
        NSData * data =  [NSJSONSerialization dataWithJSONObject:params
                                                         options:0
                                                           error:&error];
        dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return dataStr;
}

- (NSString*)encodedSendingBody:(id)params{
    NSString * dataStr;
    if ([params isKindOfClass:[NSString class]]) {
        dataStr = params;
    }else{
        NSError*error;
        NSData * data =  [NSJSONSerialization dataWithJSONObject:params
                                                         options:0
                                                           error:&error];
        dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    //aes签名
    NSString *encryptStr = [[EncryptAndDecryptTool sharedSingleton] AESEncryptWithString:dataStr andKey:@"1234567890secret"];
    //加签 将所有参与签名的参数名按照字母ASCII码从小到大顺序排序，拼接成”paramName1=value1&paramName2=value2”
    NSDictionary *paramsDic = @{
        @"encryptData":encryptStr,
        @"service":@"1",
        @"merId":@"1000000",
        @"sdkVersion":@"1",
        @"version":@"1.0",
    };
    NSArray *dicAarray = paramsDic.allKeys;
    NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range =NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray2 = [dicAarray sortedArrayUsingComparator:sort];
    NSString *printStr = @"";
    for(int i = 0; i < [resultArray2 count]; i++){
        printStr = [printStr stringByAppendingFormat:@"&%@", [paramsDic objectForKey:[resultArray2 objectAtIndex:i]]];
    }
    printStr = [printStr stringByAppendingFormat:@"&%@",SALT];
    NSString *md532 = [[EncryptAndDecryptTool sharedSingleton] md5_32:printStr upperCase:YES];
    return  md532;
}

@end
