//
//  REModifyUserInformationViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REModifyUserInformationViewController.h"

@interface REModifyUserInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, copy)NSString *nameStr;
@property (nonatomic, strong)UIButton *changeButton;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) NSString *imageStr;

@end

@implementation REModifyUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = REBackColor;
    // Do any additional setup after loading the view.
    self.imageStr = @"";
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    self.nameStr = @"";
    [self re_loadUI];
}

//

#pragma mark - 网络请求--------修改用户信息
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
            if (self.changeNameOrHeadBlock) {
                self.changeNameOrHeadBlock(msg);
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/user_edit",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"nickname":self.nameStr,
                                       @"headimg":self.imageStr,
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    
    //1.
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headButton];
    headButton.frame = CGRectMake(100, NavHeight+24, REScreenWidth-200, 104);
    
    //2.
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.cornerRadius = 36;
    headImageView.layer.masksToBounds = YES;
    headImageView.image = PlaceholderHead_Image;
    self.headImageView = headImageView;
    [headButton addSubview:headImageView];
    headImageView.frame = CGRectMake((headButton.width-72)/2, 0, 72, 72);
    
    //3.
    UILabel *headLabel = [UILabel new];
    headLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *headLabelstring = [[NSMutableAttributedString alloc] initWithString:@"点击更换头像" attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    headLabel.attributedText = headLabelstring;
    headLabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
    [headButton addSubview:headLabel];
    headLabel.frame = CGRectMake(0, headImageView.bottom+12, headButton.width, 20);
    
    //4.
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.backgroundColor = REWhiteColor;
    backView.frame = CGRectMake(0, NavHeight+152, REScreenWidth, 56);
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:nameLabel];
    nameLabel.frame = CGRectMake(20, 18, 100, 20);
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:@"用户昵称" attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    nameLabel.attributedText = nameLabelstring;
    nameLabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
    
    UITextField *nameTextField = [UITextField new];
    [nameTextField addTarget:self action:@selector(nameTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
    nameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    nameTextField.borderStyle = UITextBorderStyleNone;
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.font = REFont(14);
    [backView addSubview:nameTextField];
    nameTextField.frame =CGRectMake(100, 18, REScreenWidth - 100, 20);
    
    //修改
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeButton = changeButton;
    changeButton.titleLabel.font = REFont(17);
    [changeButton setTitle:@"修改" forState:UIControlStateNormal];
    [changeButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [self.view addSubview:changeButton];
    [changeButton addTarget:self action:@selector(changeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    changeButton.layer.cornerRadius = 23;
    changeButton.frame = CGRectMake(32, NavHeight+298, REScreenWidth-64, 45);
}

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return _picker;
}

#pragma mark - 事件
- (void)headButtonAction:(UIButton *)sender {
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

- (void)nameTextFieldAction:(UITextField *)textField {
    self.nameStr = textField.text;
    if (![self.nameStr isEqualToString:@""]) {
        self.changeButton.backgroundColor = REColor(247, 100, 66);
    }
}

- (void)changeButtonAction:(UIButton *)sender {
    if ([self.nameStr isEqualToString:@""] && [self.imageStr isEqualToString:@""]) {
        [self showAlertMsg:@"请至少输入一个" Duration:2];
    } else {
        [self requestNetwork];
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
        self.headImageView.image = uploadImage;
        self.changeButton.backgroundColor = REColor(247, 100, 66);
        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        self.imageStr = msg;
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
