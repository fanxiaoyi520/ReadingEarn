//
//  REAppealViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REAppealViewController.h"
#import "REAppealModel.h"

@interface REAppealViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic ,strong)UIScrollView *appealScrollView;
@property (nonatomic ,strong)UICollectionView *imageCollectionView;
@property (nonatomic ,strong)NSMutableArray *imageDataList;
@property (nonatomic ,strong)NSMutableArray *uploadImageDataList;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)REAppealModel *appealModel;
@property (nonatomic ,strong)UIButton *submissionButton;
@end

@implementation REAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mutableDic = [NSMutableDictionary dictionary];
    self.view.backgroundColor = REBackColor;
    [self re_loadUI];
}

#pragma mark - 网络请求--------申诉
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

        if ([code isEqualToString:@"1"]) {
            for (UIView *view in self.appealScrollView.subviews) {
                [view removeFromSuperview];
            }
            [self.imageDataList removeAllObjects];
            [self.imageCollectionView reloadData];
            [self.mutableDic removeAllObjects];
            [self re_loadUI];
            [self showAlertMsg:msg Duration:2];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/otc_appeal",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"title":self.appealModel.title,
                                       @"content":self.appealModel.content,
                                       @"picture":self.appealModel.picture,
                                       @"mobile":self.appealModel.mobile,
                                       @"email":self.appealModel.email,
                                       @"ordid":self.waitingPayModel.ordid,
                                       @"order_id":self.waitingPayModel.pay_id
                                      };
    }
    return _requestA;
}

- (void)re_loadUI {
    
    [self appealScrollView];
    
    //1.
    NSArray *array = @[@"申诉标题",@"申诉内容"];
    for (int i=0; i<2; i++) {
        UILabel *titlelabel = [UILabel new];
        [self.appealScrollView addSubview:titlelabel];
        NSMutableAttributedString *titlelabelstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        titlelabel.attributedText = titlelabelstring;
        titlelabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        titlelabel.textAlignment = NSTextAlignmentLeft;
        titlelabel.frame = CGRectMake(20, 20+i*(20+66), 150, 20);
        
        if (i==0) {
            UITextField *titleTextField  = [[UITextField alloc] init];
            [titleTextField addTarget:self action:@selector(titleTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
            [self.appealScrollView addSubview:titleTextField];
            titleTextField.tag = 100+i;
            titleTextField.backgroundColor = REWhiteColor;
            titleTextField.layer.cornerRadius = 4;
            titleTextField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            titleTextField.font = REFont(14);
            titleTextField.frame = CGRectMake(20, titlelabel.bottom+8, REScreenWidth-40, 46);
        } else {
            UITextView *titleTextField  = [[UITextView alloc] init];
            [self.appealScrollView addSubview:titleTextField];
            titleTextField.tag = 100+i;
            titleTextField.delegate = self;
            titleTextField.backgroundColor = REWhiteColor;
            titleTextField.layer.cornerRadius = 4;
            titleTextField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            titleTextField.font = REFont(14);
            titleTextField.frame = CGRectMake(20, titlelabel.bottom+8, REScreenWidth-40, 200);
        }
    }
    
    //2.
    UILabel *titlelabel = [UILabel new];
    [self.appealScrollView addSubview:titlelabel];
    NSMutableAttributedString *titlelabelstring = [[NSMutableAttributedString alloc] initWithString:@"申诉图片 (假如已付款,请提交支付宝付款截图)" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
    titlelabel.attributedText = titlelabelstring;
    titlelabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    titlelabel.frame = CGRectMake(20, 346, 300, 20);
    
    UIButton *materialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.appealScrollView addSubview:materialButton];
    materialButton.layer.cornerRadius = 4;
    materialButton.backgroundColor = REWhiteColor;
    materialButton.frame = CGRectMake(20, titlelabel.bottom+8, REScreenWidth-40, 200);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(85, 85);
    layout.sectionInset = UIEdgeInsetsMake(10, 10 ,10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    self.imageCollectionView = collectionView;
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.frame = CGRectMake(0, 0, materialButton.width, materialButton.height);
    [self.imageCollectionView registerClass:[UICollectionViewCell class]
               forCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID"];
    [self.imageCollectionView registerClass:[UICollectionViewCell class]
               forCellWithReuseIdentifier:@"addCell"];
    [materialButton addSubview:collectionView];
    
    //3.
    NSArray *array2 = @[@"联系方式",@"联系邮箱"];
    for (int i=0; i<2; i++) {
        UILabel *titlelabel = [UILabel new];
        [self.appealScrollView addSubview:titlelabel];
        NSMutableAttributedString *titlelabelstring = [[NSMutableAttributedString alloc] initWithString:array2[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0]}];
        titlelabel.attributedText = titlelabelstring;
        titlelabel.textColor = [UIColor colorWithRed:44/255.0 green:72/255.0 blue:121/255.0 alpha:1.0];
        titlelabel.textAlignment = NSTextAlignmentLeft;
        titlelabel.frame = CGRectMake(20, 586+8+i*(20+66), 150, 20);
        
        UITextField *titleTextField  = [[UITextField alloc] init];
        [self.appealScrollView addSubview:titleTextField];
        titleTextField.backgroundColor = REWhiteColor;
        titleTextField.layer.cornerRadius = 4;
        [titleTextField addTarget:self action:@selector(titleTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
        titleTextField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        titleTextField.font = REFont(14);
        titleTextField.tag = 102+i;
        titleTextField.frame = CGRectMake(20, titlelabel.bottom+8, REScreenWidth-40, 46);
        if (i==0) {
            titleTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    //4.提交
    UIButton *submissionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.appealScrollView addSubview:submissionButton];
    submissionButton.titleLabel.font = REFont(17);
    submissionButton.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    [submissionButton addTarget:self action:@selector(submissionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    submissionButton.layer.cornerRadius = 22.5;
    [submissionButton setTitle:@"提交" forState:UIControlStateNormal];
    [submissionButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    submissionButton.frame = CGRectMake(32, 777, REScreenWidth-64, 45);
    self.submissionButton = submissionButton;
}

- (UIScrollView *)appealScrollView {
    if (!_appealScrollView) {
        _appealScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight)];
        _appealScrollView.contentSize = CGSizeMake(REScreenWidth, 942-NavHeight);
        [self.view addSubview:_appealScrollView];
        _appealScrollView.showsVerticalScrollIndicator = NO;
        _appealScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _appealScrollView;
}

- (NSMutableArray *)imageDataList {
    if (!_imageDataList) {
        _imageDataList = [NSMutableArray array];
    }
    return _imageDataList;
}

- (NSMutableArray *)uploadImageDataList {
    if (!_uploadImageDataList) {
        _uploadImageDataList = [NSMutableArray array];
    }
    return _uploadImageDataList;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageDataList.count+1;
}

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
      if (indexPath.row == self.imageDataList.count)
      {
          UICollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
          
          UIImageView *addImage = [UIImageView new];
          [addCell addSubview:addImage];
          addImage.frame = CGRectMake((addCell.width-85)/2, (addCell.height-85)/2, 85, 85);
          addImage .userInteractionEnabled = YES;
          addImage.image = REImageName(@"shizijia");
          return addCell;
      }
     
     //创建item / 从缓存池中拿 Item
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID" forIndexPath:indexPath];
     cell.backgroundColor = REWhiteColor;
     cell.layer.cornerRadius = 8;
     
     UIImageView *imageView = [UIImageView new];
     imageView.frame = CGRectMake(0, 0, cell.width, cell.height);
     imageView.userInteractionEnabled = YES;
     [cell addSubview:imageView];
     
     UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [deleButton setImage:REImageName(@"login_icon_delect_nor") forState:UIControlStateNormal];
     deleButton.frame = CGRectMake(cell.width-20, 0, 20, 20);
     [deleButton addTarget:self action:@selector(deleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [imageView addSubview:deleButton];
     
     if (self.imageDataList.count != 0) {
         ZZPhoto *zzPhoto = self.imageDataList[indexPath.item];
         imageView.image = zzPhoto.originImage;
     }
     return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.imageDataList.count) {
        [self.imageDataList removeAllObjects];
        ZZPhotoController *photoController = [[ZZPhotoController alloc]init];

        //设置最大选择张数
        photoController.selectPhotoOfMax = 5;

        [photoController showIn:self result:^(id responseObject){
            //responseObject 中元素类型为 ZZPhoto
            //返回结果集
            NSLog(@"%@",responseObject);
            NSArray *array = (NSArray *)responseObject;
            [self.imageDataList addObjectsFromArray:array];
            [self uploadMultiplePictures:array];
        }];
    }
}

- (void)deleButtonAction:(UIButton *)sender {
    [self.imageDataList removeObjectAtIndex:sender.tag];
    if (self.imageDataList.count == 0) {
        [self.mutableDic setValue:@"" forKey:@"picture"];
        REAppealModel *model = [REAppealModel mj_objectWithKeyValues:self.mutableDic];
        self.appealModel = model;
        
        if (![model.title isEqualToString:@""] && ![model.mobile isEqualToString:@""] && ![model.picture isEqualToString:@""] && ![model.content isEqualToString:@""]) {
            self.submissionButton.backgroundColor = REColor(247, 100, 66);
        } else {
            self.submissionButton.backgroundColor = REColor(206, 206, 206);
        }
    }

    [self.imageCollectionView refreshControl];
    [self.imageCollectionView reloadData];
}

#pragma mark - 上传图片
- (void)uploadMultiplePictures:(NSArray *)array {
    [self.uploadImageDataList removeAllObjects];
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    // 查询条件
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    NSString *url = [NSString stringWithFormat:@"%@/otc/get_file",HomePageDomainName];
    for (int i = 0; i < array.count; i++) {
        
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            // 这里的_photoArr是你存放图片的数组
                ZZPhoto *zzPhoto = array[i];
                UIImage *image = zzPhoto.originImage;
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                /*
                 *该方法的参数
                     1. appendPartWithFileData：要上传的照片[二进制流]
                     2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                     3. fileName：要保存在服务器上的文件名
                     4. mimeType：上传的文件的类型
                 */
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg"]; //
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            NSLog(@"---上传进度--- %@",uploadProgress);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"```上传成功``` %@",responseObject);
            NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [self.uploadImageDataList addObject:msg];
            if (i==array.count-1) {
                
                NSString *picture = [self.uploadImageDataList componentsJoinedByString:@","];
                [self.mutableDic setValue:picture forKey:@"picture"];
            
                REAppealModel *model = [REAppealModel mj_objectWithKeyValues:self.mutableDic];
                self.appealModel = model;
                if (![model.title isEqualToString:@""] && ![model.mobile isEqualToString:@""] && ![model.picture isEqualToString:@""] && ![model.content isEqualToString:@""]) {
                    self.submissionButton.backgroundColor = REColor(247, 100, 66);
                } else {
                    self.submissionButton.backgroundColor = REColor(206, 206, 206);
                }

                [self showAlertMsg:@"上传成功" Duration:2];
                [self.imageCollectionView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"xxx上传失败xxx %@", error);
            if (i==array.count-1) {
                [self showAlertMsg:@"上传失败" Duration:2];
                [self.imageCollectionView reloadData];
            }
        }];
    }
}

#pragma mark -
- (void)titleTextFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"title"];
    } else if (textField.tag == 102) {
        [self.mutableDic setValue:textField.text forKey:@"mobile"];
    } else if (textField.tag == 103) {
           [self.mutableDic setValue:textField.text forKey:@"email"];
    }
    REAppealModel *model = [REAppealModel mj_objectWithKeyValues:self.mutableDic];
    self.appealModel = model;
    
    if (![model.title isEqualToString:@""] && ![model.mobile isEqualToString:@""] && ![model.picture isEqualToString:@""] && ![model.content isEqualToString:@""]) {
        self.submissionButton.backgroundColor = REColor(247, 100, 66);
    } else {
        self.submissionButton.backgroundColor = REColor(206, 206, 206);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.mutableDic setValue:textView.text forKey:@"content"];
    REAppealModel *model = [REAppealModel mj_objectWithKeyValues:self.mutableDic];
    self.appealModel = model;
    
    if (![model.title isEqualToString:@""] && ![model.mobile isEqualToString:@""] && ![model.picture isEqualToString:@""] && ![model.content isEqualToString:@""]) {
        self.submissionButton.backgroundColor = REColor(247, 100, 66);
    } else {
        self.submissionButton.backgroundColor = REColor(206, 206, 206);
    }
}

- (void)submissionButtonAction:(UIButton *)sender {
    REAppealModel *model = [REAppealModel mj_objectWithKeyValues:self.mutableDic];
    self.appealModel = model;

    if ([model.title isEqualToString:@""]) {
        [self showAlertMsg:@"标题不能为空" Duration:2];
    } else if ([model.content isEqualToString:@""]) {
        [self showAlertMsg:@"内容不能为空" Duration:2];
    } else if ([model.picture isEqualToString:@""]) {
        [self showAlertMsg:@"图片不能为空" Duration:2];
    } else if ([model.mobile isEqualToString:@""]) {
        [self showAlertMsg:@"联系方式不能为空" Duration:2];
    } else {
        if (self.appealModel.email == nil) {
            [self.mutableDic setValue:@"" forKey:@"email"];
            REAppealModel *model = [REAppealModel mj_objectWithKeyValues:self.mutableDic];
            self.appealModel = model;
            
            [self requestNetwork];
        } else {
            [self requestNetwork];
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
