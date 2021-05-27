//
//  REBindingAlipayViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBindingAlipayViewController.h"
#import "REBindingAlipayModel.h"

@interface REBindingAlipayViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong)REBindingAlipayModel *bindingAlipayModel;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImageView *QRcodeImageView;
@property (strong, nonatomic) UIButton *bindingButton;
@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UIImageView *joinImageView;
@property (strong, nonatomic)  UILabel *imageLabel;
@property (strong, nonatomic)  NSString *auditStatusStr;
@property (strong, nonatomic)  UILabel *tipsLabel;
@property (strong, nonatomic)  NSDictionary *dic;
@property (copy, nonatomic)  NSString *status;
@end

@implementation REBindingAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setObject:@"" forKey:@"name"];
    [self.mutableDic setObject:@"" forKey:@"pay_number"];
    [self.mutableDic setObject:@"" forKey:@"pay_code"];

    self.view.backgroundColor = REBackColor;
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    [self requestNetworkB];
}

#pragma mark - 网络请求--------绑定支付宝
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
            [self showAlertMsg:msg Duration:1];
        } else {
            [self showAlertMsg:msg Duration:1];
            if (self.bindingAlipayBlock) {
                self.bindingAlipayBlock(msg);
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/user_operation/user_pay_voucher",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"name":self.bindingAlipayModel.self_ID,
                                       @"pay_code":self.bindingAlipayModel.QRcodePicture,
                                       @"pay_number":self.bindingAlipayModel.alipayAccount
                                      };
    }
    return _requestA;
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
        _requestB.requestURI = [NSString stringWithFormat:@"%@/user_operation/user_pay",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestB;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    //1.
    UILabel *tipsLabel = [UILabel new];
    self.tipsLabel = tipsLabel;
    tipsLabel.backgroundColor = REColor(253, 253, 232);
    tipsLabel.font = REFont(17);
    tipsLabel.textColor = REColor(193, 193, 193);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.frame = CGRectMake(0, NavHeight, REScreenWidth, ratioH(40));
    [self.view addSubview:tipsLabel];
    NSString *str = [NSString stringWithFormat:@"  认证状态:%@",self.auditStatusStr];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    self.tipsLabel.attributedText = string;
    [ToolObject LabelAttributedString:self.tipsLabel FontNumber:REFont(14) AndRange:NSMakeRange(7, self.auditStatusStr.length) AndColor:REColor(255, 100, 62)];

    //2.
    NSArray *labelArray = @[@"请输入真是姓名(与身份证上保持一致)",@"请输入支付宝",@"上传收款二维码(上传示例)"];
    for (int i=0; i<3; i++) {
        UILabel *label = [UILabel new];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:labelArray[i] attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(20, NavHeight+ratioH(60)+i*(ratioH(20)+ratioH(66)), REScreenWidth-40, ratioH(20));
        label.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        [self.view addSubview:label];
        
        UITextField *textField = [UITextField new];
        textField.tag = 100+i;
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.layer.cornerRadius = 4;
        textField.backgroundColor = REWhiteColor;
        textField.borderStyle = UITextBorderStyleNone;
        textField.frame = CGRectMake(20, NavHeight+ratioH(88) + i*(ratioH(40)+ratioH(46)), REScreenWidth-40, ratioH(46));
        if (i!=2) {
            [self.view addSubview:textField];
        }
    }
    
    //3.
    UIImageView *QRcodeImageView = [UIImageView new];
    QRcodeImageView.layer.cornerRadius = 4;
    QRcodeImageView.layer.masksToBounds = YES;
    QRcodeImageView.backgroundColor = REWhiteColor;
    [self.view addSubview:QRcodeImageView];
    QRcodeImageView.frame = CGRectMake(20, NavHeight+ratioH(88)+(ratioH(40)+ratioH(46))*2, REScreenWidth-40, ratioH(200));
    QRcodeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQRcodeImageViewAction:)];
    tap.delegate = self;
    [QRcodeImageView addGestureRecognizer:tap];
    self.QRcodeImageView = QRcodeImageView;
    QRcodeImageView.image = REImageName(@"WechatIMG6_shili.jpeg");
    
    UIImageView *coverImageView = [UIImageView new];
    coverImageView.layer.cornerRadius = 4;
    coverImageView.layer.masksToBounds = YES;
    [QRcodeImageView addSubview:coverImageView];
    coverImageView.backgroundColor = REColor(0, 0, 0);
    coverImageView.alpha = 0.4;
    coverImageView.hidden = YES;
    self.coverImageView = coverImageView;
    coverImageView.frame = CGRectMake(0, 0, QRcodeImageView.width, QRcodeImageView.height);
    
    
    UIImageView *joinImageView = [UIImageView new];
    joinImageView.image = REImageName(@"shizijia");
    joinImageView.frame = CGRectMake((QRcodeImageView.width-36)/2, ratioH(74),ratioH(36), ratioH(36));
    [QRcodeImageView addSubview:joinImageView];
    self.joinImageView = joinImageView;
    
    UILabel *imageLabel = [UILabel new];
    [QRcodeImageView addSubview:imageLabel];
    imageLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *imageLabelstring = [[NSMutableAttributedString alloc] initWithString:@"点击上传收款二维码(上传示例)" attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    imageLabel.frame =CGRectMake(0, ratioH(108), QRcodeImageView.width, 20);
    imageLabel.attributedText = imageLabelstring;
    imageLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.imageLabel = imageLabel;
    
    //4.
    UIButton *bindingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bindingButton addTarget:self action:@selector(bindingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    bindingButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    bindingButton.frame = CGRectMake(32, QRcodeImageView.bottom+ratioH(32), REScreenWidth-64, ratioH(45));
    bindingButton.layer.cornerRadius = ratioH(22.5);
    bindingButton.titleLabel.font = REFont(17);
    [bindingButton setTitle:@"绑定" forState:UIControlStateNormal];
    [bindingButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [self.view addSubview:bindingButton];
    self.bindingButton = bindingButton;
    
    //未认证0 审核中1 审核失败2  审核成功3
    if ([self.status isEqualToString:@"3"]) {
        REBindingAlipayModel *model = [REBindingAlipayModel mj_objectWithKeyValues:self.dic];
        self.bindingAlipayModel = model;

        for (int i=0; i<2; i++) {
            UITextField *tex = [self.view viewWithTag:100+i];
            tex.userInteractionEnabled = NO;
            if (i==0) {
                tex.text = self.bindingAlipayModel.self_ID;
            } else if (i==1) {
                tex.text = self.bindingAlipayModel.alipayAccount;
            }
        }
        [QRcodeImageView sd_setImageWithURL:[NSURL URLWithString:self.bindingAlipayModel.QRcodePicture] placeholderImage:PlaceholderImage];
        self.QRcodeImageView.userInteractionEnabled = NO;
        self.bindingButton.userInteractionEnabled = NO;
        imageLabel.hidden = YES;
        joinImageView.hidden = YES;
    } else {
        for (int i=0; i<2; i++) {
            UITextField *tex = [self.view viewWithTag:100+i];
            tex.userInteractionEnabled = YES;
        }
        self.QRcodeImageView.userInteractionEnabled = YES;
        self.bindingButton.userInteractionEnabled = YES;
    }
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
        [self.mutableDic setValue:textField.text forKey:@"name"];
    } else {
        [self.mutableDic setValue:textField.text forKey:@"pay_number"];
    }

    REBindingAlipayModel *bindingAlipayModel = [REBindingAlipayModel mj_objectWithKeyValues:self.mutableDic];
    self.bindingAlipayModel = bindingAlipayModel;
    if (![self.bindingAlipayModel.self_ID isEqualToString:@""] && ![self.bindingAlipayModel.alipayAccount isEqualToString:@""] && ![self.bindingAlipayModel.QRcodePicture isEqualToString:@""]) {
        self.bindingButton.backgroundColor = REColor(247, 100, 66);
    } else {
        self.bindingButton.backgroundColor = REColor(206, 206, 206);
    }
}

- (void)bindingButtonAction:(UIButton *)sender {
    REBindingAlipayModel *bindingAlipayModel = [REBindingAlipayModel mj_objectWithKeyValues:self.mutableDic];
    self.bindingAlipayModel = bindingAlipayModel;
    if ([self.bindingAlipayModel.self_ID isEqualToString:@""]) {
        [self showAlertMsg:@"昵称不能为空" Duration:2];
    } else if ([self.bindingAlipayModel.alipayAccount isEqualToString:@""]) {
        [self showAlertMsg:@"账号不能为空" Duration:2];
    } else {
        if ([self.bindingAlipayModel.QRcodePicture isEqualToString:@""]) {
            [self showAlertMsg:@"收款二维码不能为空" Duration:2];
        } else {
            [self requestNetwork];
        }
    }
}

- (void)tapQRcodeImageViewAction:(UIGestureRecognizer *)tap {
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
        self.QRcodeImageView.image = uploadImage;
        self.joinImageView.image = REImageName(@"binding_sure");
        self.imageLabel.hidden = YES;
        self.coverImageView.hidden = NO;
        self.joinImageView.frame = CGRectMake((self.QRcodeImageView.width-32)/2, ratioH(74),ratioH(32), ratioH(32));
        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        [self.mutableDic setValue:msg forKey:@"pay_code"];

        REBindingAlipayModel *bindingAlipayModel = [REBindingAlipayModel mj_objectWithKeyValues:self.mutableDic];
        self.bindingAlipayModel = bindingAlipayModel;
        if (![self.bindingAlipayModel.self_ID isEqualToString:@""] && ![self.bindingAlipayModel.alipayAccount isEqualToString:@""] && ![self.bindingAlipayModel.QRcodePicture isEqualToString:@""]) {
            self.bindingButton.backgroundColor = REColor(247, 100, 66);
        } else {
            self.bindingButton.backgroundColor = REColor(206, 206, 206);
        }

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
