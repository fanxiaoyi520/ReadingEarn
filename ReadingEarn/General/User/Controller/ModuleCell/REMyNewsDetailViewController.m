//
//  REMyNewsDetailViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyNewsDetailViewController.h"

@interface REMyNewsDetailViewController ()
@property (nonatomic, strong) DefaultServerRequest *requestA;
@end

@implementation REMyNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.frame = CGRectMake(40, NavHeight+20, REScreenWidth-40-21-16, 30);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.title attributes:@{NSFontAttributeName: REFont(17), NSForegroundColorAttributeName: [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0]}];
    titleLabel.attributedText = string;
    titleLabel.textColor = [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0];
    [self.view addSubview:titleLabel];
    
    
    NSData *data = [self.contentsStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                                               options:options
                                                    documentAttributes:nil
                                                                 error:nil];
    UITextView *textView = [UITextView new];
    textView.userInteractionEnabled = NO;
    textView.font = REFont(14);
    textView.attributedText = html;
    [self.view addSubview:textView];
    textView.frame = CGRectMake(20, NavHeight+50, REScreenWidth-40, REScreenHeight - NavHeight);

    [self requestNetwork];
}

#pragma mark - 网络请求--------用户信息
- (void)requestNetwork {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/ucenter_info",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestA;
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
