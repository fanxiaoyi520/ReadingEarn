//
//  RERealNameAuthenticationViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERealNameAuthenticationViewController.h"
#import "REIdentityAuthModel.h"

@interface RERealNameAuthenticationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) UIScrollView *realNameScrollView;
@property (strong, nonatomic)  NSString *auditStatusStr;
@property (strong, nonatomic)  UILabel *tipsLabel;
@property (strong, nonatomic)  NSDictionary *dic;
@property (strong, nonatomic)REIdentityAuthModel *identityAuthModel;
@property (strong, nonatomic)NSMutableDictionary *mutableDic;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImageView *clickImageView;
@property (copy, nonatomic) NSString *status;
@end

@implementation RERealNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;

    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setObject:@"" forKey:@"real_name"];
    [self.mutableDic setObject:@"" forKey:@"id_card"];
    [self.mutableDic setObject:@"" forKey:@"front_pic"];
    [self.mutableDic setObject:@"" forKey:@"negative_pic"];

    [self requestNetworkB];
}

#pragma mark - 网络请求--------审核状态
- (void)requestNetworkB {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([code isEqualToString:@"1"]) {
            self.auditStatusStr = msg;
            self.status = status;
            self.dic = (NSDictionary *)response.responseObject[@"data"];
            [self re_loadUI];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/ucenter/user_certification",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestB;
}

#pragma mark - 网络请求--------提交
- (void)requestNetworkA {
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
            [self showAlertMsg:msg Duration:1];
            if (self.identityAuthenticationBlock) {
                self.identityAuthenticationBlock(msg);
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/certification",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"real_name":self.identityAuthModel.real_name,
                                       @"id_card":self.identityAuthModel.id_card,
                                       @"front_pic":self.identityAuthModel.front_pic,
                                       @"negative_pic":self.identityAuthModel.negative_pic
                                      };
    }
    return _requestA;
}


#pragma mark - 加载UI
- (void)re_loadUI {
    [self realNameScrollView];
    
    //1.
    UILabel *tipsLabel = [UILabel new];
    self.tipsLabel = tipsLabel;
    tipsLabel.backgroundColor = REColor(253, 253, 232);
    tipsLabel.font = REFont(17);
    tipsLabel.textColor = REColor(193, 193, 193);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.frame = CGRectMake(0, NavHeight, REScreenWidth, 40);
    [self.view addSubview:tipsLabel];
    NSString *str = [NSString stringWithFormat:@"  认证状态:%@",self.auditStatusStr];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    self.tipsLabel.attributedText = string;
    [ToolObject LabelAttributedString:self.tipsLabel FontNumber:REFont(14) AndRange:NSMakeRange(7, self.auditStatusStr.length) AndColor:REColor(255, 100, 62)];

    UILabel *tishiLabel = [UILabel new];
    NSString *tishi = @"注:身份证图片必须带有’阅赚‘认证专用";
    NSMutableAttributedString *tishiLabelstring = [[NSMutableAttributedString alloc] initWithString:tishi attributes:@{NSFontAttributeName: REFont(17), NSForegroundColorAttributeName: REColor(247, 100, 66)}];
    tishiLabel.attributedText = tishiLabelstring;
    [self.realNameScrollView addSubview:tishiLabel];
    tishiLabel.frame = CGRectMake(20, 184, REScreenWidth-40, 25);
    
    //2.
    NSArray *labelArray = @[@"个人名称",@"身份证号"];
    NSArray *defaultImageArray;
    NSArray *p;
    //未认证0 审核中1 审核失败2  审核成功3
    
    if (![self.status isEqualToString:@"3"]) {
        p = @[@"请输入姓名",@"请输入身份证号码"];
        defaultImageArray = @[@"WechatIMG1",@"WechatIMG2"];
    } else {
        p = @[[self.dic objectForKey:@"real_name"],[self.dic objectForKey:@"id_card"]];
        defaultImageArray = @[[self.dic objectForKey:@"front_pic"],[self.dic objectForKey:@"negative_pic"]];
    }

    for (int i=0; i<2; i++) {
        
        //a.
        UILabel *label = [UILabel new];
        NSMutableAttributedString *labelstring = [[NSMutableAttributedString alloc] initWithString:labelArray[i] attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        label.attributedText = labelstring;
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(20, 70+i*(20+36), REScreenWidth-40, 20);
        label.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        [self.realNameScrollView addSubview:label];
        
        UITextField *textField = [UITextField new];
        textField.tag = 100+i;
        textField.placeholder = p[i];
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.borderStyle = UITextBorderStyleNone;
        textField.frame = CGRectMake(96, 52 + i*(56), REScreenWidth-96, 56);
        [self.realNameScrollView addSubview:textField];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        [self.realNameScrollView addSubview:lineView];
        lineView.frame = CGRectMake(20, 108+i*(55.5+0.5), REScreenWidth-40, 0.5);
        
        //b.
        UIImageView *shenfenzhengImageView = [UIImageView new];
        shenfenzhengImageView.userInteractionEnabled = YES;
        [self.realNameScrollView addSubview:shenfenzhengImageView];
        shenfenzhengImageView.frame = CGRectMake(38, 184+50+i*(189+20), REScreenWidth-76, 189);
        shenfenzhengImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        shenfenzhengImageView.layer.shadowColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:0.30].CGColor;
        shenfenzhengImageView.layer.shadowOffset = CGSizeMake(0,3);
        shenfenzhengImageView.layer.shadowRadius = 6;
        shenfenzhengImageView.layer.shadowOpacity = 1;
        shenfenzhengImageView.layer.cornerRadius = 8;

        UIImageView *defaultImageView = [UIImageView new];
        defaultImageView.tag = 300+i;
        defaultImageView.userInteractionEnabled = YES;
        [shenfenzhengImageView addSubview:defaultImageView];
        defaultImageView.frame = CGRectMake(42, 14, shenfenzhengImageView.width-84, 162);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQRcodeImageViewAction:)];
        [defaultImageView addGestureRecognizer:tap];

        //未认证0 审核中1 审核失败2  审核成功3
        if (![self.status isEqualToString:@"3"]) {
            textField.userInteractionEnabled = YES;
            shenfenzhengImageView.userInteractionEnabled = YES;
            defaultImageView.userInteractionEnabled = YES;
            defaultImageView.image = REImageName(defaultImageArray[i]);
        } else {
            textField.userInteractionEnabled = NO;
            shenfenzhengImageView.userInteractionEnabled = NO;
            defaultImageView.userInteractionEnabled = NO;
            [defaultImageView sd_setImageWithURL:[NSURL URLWithString:defaultImageArray[i]] placeholderImage:REImageName(defaultImageArray[i])];
        }
    }
    
    //提交
    UIButton *submissionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.realNameScrollView addSubview:submissionButton];
    submissionButton.titleLabel.font = REFont(17);
    submissionButton.backgroundColor = REColor(247, 100, 66);
    submissionButton.layer.cornerRadius = ratioH(22.5);
    submissionButton.frame = CGRectMake(32, 628+50, REScreenWidth-64, 45);
    [submissionButton setTitle:@"提交" forState:UIControlStateNormal];
    [submissionButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [submissionButton addTarget:self action:@selector(submissionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![self.status isEqualToString:@"3"]) {
        submissionButton.userInteractionEnabled = YES;
    } else {
        submissionButton.userInteractionEnabled = NO;
    }
}

- (UIScrollView *)realNameScrollView {
    if (!_realNameScrollView) {
        _realNameScrollView = [UIScrollView new];
        _realNameScrollView.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
        _realNameScrollView.showsHorizontalScrollIndicator = NO;
        _realNameScrollView.contentSize = CGSizeMake(REScreenWidth, 728);
        _realNameScrollView.showsVerticalScrollIndicator = YES;
        [self.view addSubview:_realNameScrollView];
    }
    return _realNameScrollView;
}

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return _picker;
}

#pragma mark - 事件
- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        [self.mutableDic setObject:textField.text forKey:@"real_name"];
    } else if (textField.tag == 101) {
        [self.mutableDic setObject:textField.text forKey:@"id_card"];
    }
    
    REIdentityAuthModel *model = [REIdentityAuthModel mj_objectWithKeyValues:self.mutableDic];
    self.identityAuthModel = model;
}

- (void)submissionButtonAction:(UIButton *)sender {
    REIdentityAuthModel *model = [REIdentityAuthModel mj_objectWithKeyValues:self.mutableDic];
    self.identityAuthModel = model;
    if ([self.identityAuthModel.real_name isEqualToString:@""]) {
        [self showAlertMsg:@"姓名不能为空" Duration:2];
    } else if ([self.identityAuthModel.id_card isEqualToString:@""]) {
        [self showAlertMsg:@"身份证不能为空" Duration:2];
    } else if ([self.identityAuthModel.front_pic isEqualToString:@""]) {
        [self showAlertMsg:@"请上传身份证正面" Duration:2];
    } else if ([self.identityAuthModel.negative_pic isEqualToString:@""]) {
        [self showAlertMsg:@"请上传身份证反面" Duration:2];
    } else {
        [self requestNetworkA];
    }
}

- (void)tapQRcodeImageViewAction:(UIGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    self.clickImageView = imageView;
    BOOL isPicker = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.modalPresentationStyle = 0;
    isPicker = true;
    if (isPicker) {
        [self presentViewController:self.picker animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 相册
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [YQImageCompressTool CompressToImageAtBackgroundWithImage:image ShowSize:CGSizeMake(75, 75) FileSize:100 block:^(UIImage *resultImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self personalUploadHeadImgInterfaceWithImage:resultImage withPicker:picker];
        });
    }];
}

#pragma mark - 上传图片
- (void)personalUploadHeadImgInterfaceWithImage:(UIImage *)uploadImage  withPicker:(UIImagePickerController *)picker {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/ucenter/get_file",HomePageDomainName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(uploadImage, 1.0);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self showAlertMsg:@"上传成功" Duration:2];
        self.clickImageView.image = uploadImage;
        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        if (self.clickImageView.tag == 300) {
            [self.mutableDic setValue:msg forKey:@"front_pic"];
        } else {
            [self.mutableDic setValue:msg forKey:@"negative_pic"];
        }
        REIdentityAuthModel *model = [REIdentityAuthModel mj_objectWithKeyValues:self.mutableDic];
        self.identityAuthModel = model;
        [picker dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showAlertMsg:@"上传失败" Duration:2];
    }];
}

//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
