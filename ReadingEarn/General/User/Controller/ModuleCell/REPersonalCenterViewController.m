//
//  REPersonalCenterViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REPersonalCenterViewController.h"
#import "REChangeLoginPasswordViewController.h"
#import "REChangePaymentPasswordViewController.h"
#import "REModifyUserInformationViewController.h"
#import "REBindingAlipayViewController.h"
#import "RERealNameAuthenticationViewController.h"
#import "REAlipayRealNameAuthenticationViewController.h"

@interface REPersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *personalTableView;
@property (nonatomic ,strong)NSArray *personalArray;
@end

@implementation REPersonalCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = REWhiteColor;
    //self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
    self.personalArray = [[RESingleton sharedRESingleton] personalCenterArray];
    [self re_loadUI];
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self personalTableView];
}

- (UITableView *)personalTableView {
    if (!_personalTableView) {
        _personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _personalTableView.delegate = self;
        _personalTableView.backgroundColor = REWhiteColor;
        _personalTableView.dataSource = self;
        [self.view addSubview:_personalTableView];
    }
    return _personalTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row != self.personalArray.count-1) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        [cell.contentView addSubview:lineView];
        lineView.tag = 10;
        
        //1.
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 20;
        [cell.contentView addSubview:label];
    }
    
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(22, 47.5, REScreenWidth-44, 0.5);
    
    //1.
    UILabel *label = [cell.contentView viewWithTag:20];
    label.frame = CGRectMake(24, 15, REScreenWidth-24-21-16, 21);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.personalArray[indexPath.row] attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = REBackColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([ToolObject onlineAuditJudgment] == YES) {
        if (indexPath.row == 0) {
            REChangeLoginPasswordViewController *vc = [REChangeLoginPasswordViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            REChangePaymentPasswordViewController *vc = [REChangePaymentPasswordViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            __weak typeof (self)weekself = self;
            vc.changePayPwdTipsBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                if (strongself.changePayPwdTipsBlock) {
                    self.changePayPwdTipsBlock(msg);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            REModifyUserInformationViewController *vc = [REModifyUserInformationViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            __weak typeof (self)weekself = self;
            vc.changeNameOrHeadBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                if (strongself.changeNameOrHeadBlock) {
                    self.changeNameOrHeadBlock(msg);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            REBindingAlipayViewController *vc = [REBindingAlipayViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            __weak typeof (self)weekself = self;
            vc.bindingAlipayBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                if (strongself.bindingAlipayBlock) {
                    self.bindingAlipayBlock(msg);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            REAlipayRealNameAuthenticationViewController *vc = [REAlipayRealNameAuthenticationViewController new];
            vc.naviTitle = @"实名认证";
            [self.navigationController pushViewController:vc animated:YES];
//            RERealNameAuthenticationViewController *vc = [RERealNameAuthenticationViewController new];
//            vc.naviTitle = self.personalArray[indexPath.row];
//            __weak typeof (self)weekself = self;
//            vc.identityAuthenticationBlock = ^(NSString * _Nonnull msg) {
//                __strong typeof (weekself)strongself = weekself;
//                if (strongself.identityAuthenticationBlock) {
//                    self.identityAuthenticationBlock(msg);
//                }
//            };
//            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSLog(@"退出登录");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"确定退出登录吗"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      NSLog(@"action = %@", action);
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      NSLog(@"action = %@", action);
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"token"];
                RELoginViewController *vc = [RELoginViewController new];
                RERootNavigationViewController *nav = [[RERootNavigationViewController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = NO;
                [self presentViewController:nav animated:NO completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];

                
                                                                  }];

            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        if (indexPath.row == 0) {
            REChangeLoginPasswordViewController *vc = [REChangeLoginPasswordViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            REChangePaymentPasswordViewController *vc = [REChangePaymentPasswordViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            __weak typeof (self)weekself = self;
            vc.changePayPwdTipsBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                if (strongself.changePayPwdTipsBlock) {
                    self.changePayPwdTipsBlock(msg);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            REModifyUserInformationViewController *vc = [REModifyUserInformationViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            __weak typeof (self)weekself = self;
            vc.changeNameOrHeadBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                if (strongself.changeNameOrHeadBlock) {
                    self.changeNameOrHeadBlock(msg);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            RERealNameAuthenticationViewController *vc = [RERealNameAuthenticationViewController new];
            vc.naviTitle = self.personalArray[indexPath.row];
            __weak typeof (self)weekself = self;
            vc.identityAuthenticationBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                if (strongself.identityAuthenticationBlock) {
                    self.identityAuthenticationBlock(msg);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSLog(@"退出登录");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"确定退出登录吗"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      NSLog(@"action = %@", action);
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      NSLog(@"action = %@", action);
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"token"];
                RELoginViewController *vc = [RELoginViewController new];
                RERootNavigationViewController *nav = [[RERootNavigationViewController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = NO;
                [self presentViewController:nav animated:NO completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];

                
                                                                  }];

            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
