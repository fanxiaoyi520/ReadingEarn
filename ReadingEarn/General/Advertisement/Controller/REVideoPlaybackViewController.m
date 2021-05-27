//
//  REVideoPlaybackViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/24.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REVideoPlaybackViewController.h"
#import <SafariServices/SafariServices.h>

@interface REVideoPlaybackViewController ()

@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;
@end

@implementation REVideoPlaybackViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topNavBar clearNavBarBackgroundColor];
    [self.topNavBar changeBackImage:@"navbar_icon_return_nor"];
    self.view.backgroundColor = [UIColor blackColor];
    //网络视频路径
    NSString *webVideoPath = self.advertisementModel.video;
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:webVideoUrl];
    self.currentPlayerItem = playerItem;
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avLayer.frame = CGRectMake(0, 0, REScreenWidth, REScreenHeight);
    [self.view.layer addSublayer:avLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    //1.
    UIImageView *headImageView = [UIImageView new];
    [self.view addSubview:headImageView];
    headImageView.layer.cornerRadius = 15;
    headImageView.layer.masksToBounds = YES;
    headImageView.frame = CGRectMake(28, self.view.height-98, 30, 30);
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.advertisementModel.photo] placeholderImage:PlaceholderHead_Image];
    
    //2.
    UILabel *nameLabel = [UILabel new];
    [self.view addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = self.advertisementModel.name;
    nameLabel.textColor = REWhiteColor;
    nameLabel.font = REFont(16);
    nameLabel.frame = CGRectMake(headImageView.right + 8, self.view.height-91, 200, 16);
    
    //3.
    CGSize introducLabelsize = [ToolObject sizeWithText:self.advertisementModel.jitter_name withFont:REFont(14)];
    UILabel *introducLabel = [UILabel new];
    [self.view addSubview:introducLabel];
    introducLabel.textAlignment = NSTextAlignmentLeft;
    introducLabel.text = self.advertisementModel.jitter_name;
    introducLabel.textColor = REWhiteColor;
    introducLabel.font = REFont(14);
    introducLabel.frame = CGRectMake(28, self.view.height-60, introducLabelsize.width+10, 16);

    //4.
    UIImageView *yinyueImageView = [UIImageView new];
    [self.view addSubview:yinyueImageView];
    yinyueImageView.image = REImageName(@"yinyue_image");
    yinyueImageView.frame = CGRectMake(introducLabel.right, self.view.height-57, 14, 14);
}

#pragma mark - Action Methods
- (void)targetAction:(UIButton*)sender{
    switch (sender.tag) {
        case 555:  //播放
            [self play];
            break;
        case 556:  //暂停
            [self pause];
            break;
        default:
            break;
    }
}

- (void)play {
    //if (self.player.rate == 0){
        [self.player play];
    //}
}

- (void)pause {
    //if (self.player.rate != 0){
        [self.player pause];
    //}
}

- (void)tapAction:(UIGestureRecognizer *)tap {

    NSString *requestUrlString = self.advertisementModel.link;
    NSURL *requestUrl = [NSURL URLWithString: requestUrlString];
    if([[UIApplication sharedApplication] canOpenURL:requestUrl]) {
        [[UIApplication sharedApplication] openURL:requestUrl];
    } else {
        //没有安装应用，默认打开HTML5站
        requestUrl = [NSURL URLWithString:self.advertisementModel.link];
        [[UIApplication sharedApplication] openURL:requestUrl];
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
