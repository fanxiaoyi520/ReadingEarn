//
//  RECommentViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RECommentViewController.h"
#import "RECommentListViewController.h"

@interface RECommentViewController ()<UITextViewDelegate>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *str;
@end

@implementation RECommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = REBackColor;
    [self re_loadUI];
    __weak typeof (self)weekself = self;
    self.topNavBar.backBlock = ^{
        __strong typeof (weekself)strongself = weekself;
        [strongself.navigationController popViewControllerAnimated:YES];
        if (strongself.backBlock) {
            strongself.backBlock(strongself.book_id);
        }
    };
}

#pragma mark - 请求数据 ----------获取分章列表
- (void)requestNetWrokA {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"1"]) {
            if (self.backBlock) {
                self.backBlock(self.book_id);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/send_discuss",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"book_id":self.book_id,
                                       @"token":token,
                                       @"content":self.str,
                                       @"content_id":self.contents_id
                                      };
    }
    return _requestA;
}

- (void)re_loadUI {
    self.str = @"";
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0.07493285834789276, 0.1682761013507843);
    gl.endPoint = CGPointMake(1, 1);
    gl.cornerRadius = 14;
    gl.masksToBounds = YES;
    gl.colors = @[(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    gl.frame = CGRectMake(REScreenWidth-68-12, REStatusHeight+12, 68, 28);
    [self.topNavBar.layer addSublayer:gl];

    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:commentButton];
    commentButton.titleLabel.font = REFont(14);
    commentButton.backgroundColor = [UIColor clearColor];
    [commentButton setTitle:@"发表" forState:UIControlStateNormal];
    commentButton.frame = CGRectMake(REScreenWidth-68-12, REStatusHeight+12, 68, 28);
    [commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topNavBar addSubview:commentButton];
    
    
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, 8+NavHeight, REScreenWidth, 194);
    bgView.backgroundColor = REWhiteColor;
    bgView.userInteractionEnabled = YES;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.textColor = REColor(153, 153, 153);
    [bgView addSubview:textView];
    textView.backgroundColor = REBackColor;
    textView.delegate = self;
    textView.frame = CGRectMake(16, 16, REScreenWidth-32, 162);
    
    UILabel *label = [UILabel new];
    [textView addSubview:label];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"期待您的精彩评论" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    label.frame = CGRectMake(16, 12, 200, 20);
    self.label = label;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.label.hidden = YES;
    self.str = textView.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.label.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        self.label.hidden = NO;
    }
}


- (void)commentButtonAction:(UIButton *)sender {
    [self requestNetWrokA];
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
