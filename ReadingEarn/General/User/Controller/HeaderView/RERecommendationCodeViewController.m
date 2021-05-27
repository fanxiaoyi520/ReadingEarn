//
//  RERecommendationCodeViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERecommendationCodeViewController.h"

@interface RERecommendationCodeViewController ()<UIActionSheetDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UIImageView *sentImg;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *myview;
@end

@implementation RERecommendationCodeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    //self.switchNavigationBarHidden = YES;
    [super viewDidLoad];
    [self.topNavBar clearNavBarBackgroundColor];
    // Do any additional setup after loading the view.
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
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            self.dic = (NSDictionary *)response.responseObject;
            [self re_loadUI];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/user_referral",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestA;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.myview]) {
        return YES;
    }
    return NO;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    //1.
    UIImageView *imageView = [UIImageView new];
    self.imageView = imageView;
    [self.view addSubview:imageView];
    imageView.image = REImageName(@"tuijianma");
    imageView.frame = CGRectMake(0, 0, REScreenWidth, REScreenHeight);

    //此视图的设置相应s长按手势，防止导航栏返回按钮不能响应
    UIView *view = [UIView new];
    self.myview = view;
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    view.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
    UILongPressGestureRecognizer*longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    longTap.delegate = self;
    [view addGestureRecognizer:longTap];

    //2.
    UILabel *recodeLabel = [UILabel new];
    recodeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:recodeLabel];
    NSMutableAttributedString *recodeLabelstring = [[NSMutableAttributedString alloc] initWithString:[self.dic objectForKey:@"data"] attributes:@{NSFontAttributeName: REFont(30), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:35/255.0 blue:35/255.0 alpha:1.0]}];
    recodeLabel.attributedText = recodeLabelstring;
    recodeLabel.textColor = [UIColor colorWithRed:255/255.0 green:35/255.0 blue:35/255.0 alpha:1.0];
    recodeLabel.frame = CGRectMake(32, ratioH(289), REScreenWidth-64, ratioH(42));
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:copyButton];
    copyButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    copyButton.layer.cornerRadius = 18;
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    copyButton.titleLabel.font = REFont(18);
    copyButton.frame = CGRectMake((REScreenWidth-88)/2, recodeLabel.bottom+5, 88, ratioH(36));
    [copyButton addTarget:self action:@selector(copyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
   
    //3.
    UIImageView *codeImageView = [UIImageView new];
    codeImageView.image=[ToolObject createNonInterpolatedUIImageFormCIImage:[ToolObject creatQRcodeWithUrlstring:[self.dic objectForKey:@"link"]] withSize:150];
    codeImageView.frame = CGRectMake((REScreenWidth-ratioH(124))/2, copyButton.bottom+16, ratioH(124), ratioH(124));
    [self.view addSubview:codeImageView];
}

- (void)copyButtonAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"link"]];
    [self showAlertMsg:@"复制成功" Duration:2];
}

 -(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state==UIGestureRecognizerStateBegan){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:@"确定要保存图片到手机？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UIImageWriteToSavedPhotosAlbum([self interceptionScreen],self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);

    }];

    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:true completion:nil];
    }
}

- (UIImage *)interceptionScreen {
    //开启一个图片的上下文
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    //拿到我们开启的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //把需要截屏View的layer渲染到上下文中
    [self.view.layer renderInContext:ctx];
    //从上下文中拿出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //因为上下文是我们自己开启的，所以用完之后要关闭掉
    UIGraphicsEndImageContext();
    return img;
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(void*)contextInfo {
    NSString*message =@"呵呵";
    if(!error) {
        message =@"成功保存到相册";
        [self showAlertMsg:message Duration:2];
    } else {
        message = [error description];
        [self showAlertMsg:message Duration:2];
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
