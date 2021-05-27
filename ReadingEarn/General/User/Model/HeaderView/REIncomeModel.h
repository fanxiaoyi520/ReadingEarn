//
//  REIncomeModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REIncomeModel : RERootModel
//account = "4320.00";
//addtime = 1574993325;
//expend = "0.00";
//id = 143;
//income = "1000.00";
//money = "1000.00";
//name = "\U63a8\U5e7f\U6536\U76ca";
//remark = "\U63a8\U5e7f\U83b7\U53d6 4320.00000000 YC \U5956\U52b1 ";
//symbol = YC;
//type = popularize;
//"user_id" = 802874;
@property (nonatomic ,copy)NSString *account;
@property (nonatomic ,copy)NSString *addtime;
@property (nonatomic ,copy)NSString *expend;
@property (nonatomic ,copy)NSString *income_id;
@property (nonatomic ,copy)NSString *income;
@property (nonatomic ,copy)NSString *money;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *symbol;
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,copy)NSString *user_id;

@end

NS_ASSUME_NONNULL_END
