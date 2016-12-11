//
//  PPMyListViewController.m
//  ParkProject
//
//  Created by yuanxuan on 16/6/27.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "JCCYMyListViewController.h"
#import "SettingTableViewCell.h"
#import "UIButton+WebCache.h"

#import "JCCYLevelInfoViewController.h"

#import "JCCYSettingViewController.h"

#import "JCCYUsedHistoryViewController.h"
#import "JCCYPayHistoryViewController.h"

#import "JCCYChongZhiViewController.h"

#import "AppDelegate.h"

#define HEADHEIGHT (PPMainViewWidth*0.5)

@interface JCCYMyListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIImageView *navBarHairlineImageView;
}
@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) NSMutableArray *settingList;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIButton *iconImgView;
@property (nonatomic, strong) UILabel *iconImgLabel;
@property (nonatomic, strong) NSMutableArray *levelArray; //会员等级数组

@property (nonatomic, strong) NSString *KEFU_TELPHONE; //客服电话

@property (nonatomic, strong) UIButton *levelImgView;


@end

@implementation JCCYMyListViewController
@synthesize settingTableView,settingList,iconImgLabel,iconImgView,headImgView,headView,levelImgView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
    //添加一个通知 来修改重新登录的人的资料图
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    self.title = @"个人中心";
    
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, 40, 40);
    settingButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [settingButton setImage:[UIImage imageNamed:@"setting_shezhi"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:settingButton];;
    self.navigationItem.rightBarButtonItem = barBtn;
    
    self.settingList = [NSMutableArray arrayWithCapacity:0];

    NSDictionary *collectDict = [NSDictionary dictionaryWithObjectsAndKeys:@"在线充值",@"title",[UIImage imageNamed:@"user_info_zxcz"],@"img", nil];
    [settingList addObject:collectDict];
    
    NSDictionary *clearCacheDict = [NSDictionary dictionaryWithObjectsAndKeys:@"充值记录",@"title",[UIImage imageNamed:@"user_info_czjl"],@"img", nil];
    [settingList addObject:clearCacheDict];
    
    NSDictionary *feedbackDict = [NSDictionary dictionaryWithObjectsAndKeys:@"消费记录",@"title",[UIImage imageNamed:@"user_info_xfjl"],@"img", nil];
    [settingList addObject:feedbackDict];
    
    NSDictionary *aboutusDict = [NSDictionary dictionaryWithObjectsAndKeys:@"客服电话：",@"title",[UIImage imageNamed:@"user_info_kfdh"],@"img", nil];
    [settingList addObject:aboutusDict];
    
    self.levelArray = [NSMutableArray array];
    
    //刷新用户信息
    [self updataUserInfo];
    
    [self createSettingView];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self getUserInfo];
}
-(void)getUserInfo{
    
    NSString *dJson = nil;
    //得到自己当前的下属
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

    dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
    //获取类型接口
    PPRDData *pprddata1 = [[PPRDData alloc] init];
    [pprddata1 startAFRequest:@"/index.php/Api/User/get_info/"
                  requestdata:dJson
               timeOutSeconds:10
              completionBlock:^(NSDictionary *json) {
                  NSInteger code = [[json objectForKey:@"code"] integerValue];
                  if (code == 1) {
                      
                      NSDictionary *dataDic = [json objectForKey:@"data"];
                      
                      NSUInteger scores = [[dataDic objectForKey:@"scores"] integerValue];
                      NSUInteger golds = [[dataDic objectForKey:@"golds"] integerValue];
                      NSUInteger present_time = [[dataDic objectForKey:@"present_time"] integerValue];
                      NSUInteger time_service_1 = [[dataDic objectForKey:@"time_service_1"] integerValue];
                      NSUInteger time_service_2 = [[dataDic objectForKey:@"time_service_2"] integerValue];
                      NSUInteger time_service_3 = [[dataDic objectForKey:@"time_service_3"] integerValue];
                      NSString *user_chinese_name = [dataDic objectForKey:@"user_chinese_name"];
                      NSString *user_city = [dataDic objectForKey:@"user_city"];
                      NSString *user_level = [dataDic objectForKey:@"user_level"];
                      NSString *user_phone = [dataDic objectForKey:@"user_phone"];
                      NSString *user_pic = [dataDic objectForKey:@"user_pic"];
                      NSString *user_province = [dataDic objectForKey:@"user_province"];
                      
                      NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
                      [userDefauls setObject:[NSNumber numberWithInteger:golds] forKey:@"golds"];
                      [userDefauls setObject:[NSNumber numberWithInteger:scores] forKey:@"scores"];
                      [userDefauls setObject:[NSNumber numberWithInteger:present_time] forKey:@"present_time"];
                      [userDefauls setObject:[NSNumber numberWithInteger:time_service_1] forKey:@"time_service_1"];
                      [userDefauls setObject:[NSNumber numberWithInteger:time_service_2] forKey:@"time_service_2"];
                      [userDefauls setObject:[NSNumber numberWithInteger:time_service_3] forKey:@"time_service_3"];
                      [userDefauls setObject:user_chinese_name forKey:@"user_chinese_name"];
                      [userDefauls setObject:user_city forKey:@"user_city"];
                      [userDefauls setObject:user_level forKey:@"user_level"];
                      [userDefauls setObject:user_phone forKey:@"user_phone"];
                      [userDefauls setObject:user_pic forKey:@"user_pic"];
                      [userDefauls setObject:user_province forKey:@"user_province"];
                      [userDefauls synchronize];

                      [settingTableView reloadData];
                  }else if (code == -2){
                      //检查信息更新
                      [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                      
                  }else if (code == -110){
                      //退出登录
                      [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                      
                  }else{
                      
                  }
              }
                  failedBlock:^(NSError *error) {
                      
            }];
    
}

#pragma mark ---- 设置界面----

-(void)settingAction{
    JCCYSettingViewController *jCCYSettingViewController = [[JCCYSettingViewController alloc] init];
    jCCYSettingViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jCCYSettingViewController animated:YES];
}

-(void)updataUserInfo{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_conf/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSString *levelDataStr = [dataDic objectForKey:@"USER_LEVEL"];
                          
                          NSString *kefuPhoneNum = [dataDic objectForKey:@"KEFU_TELPHONE"];
                          
                          self.KEFU_TELPHONE = kefuPhoneNum;
                          [settingTableView reloadData];
                          NSData *levelData = [levelDataStr dataUsingEncoding:NSASCIIStringEncoding];
                          NSArray *levelArr = [self toArrayOrNSDictionary:levelData];
                          self.levelArray = [NSMutableArray arrayWithArray:levelArr];
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}


//将JSON串转化为NSDictionary或NSArray
- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

- (void)createSettingView
{
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewHeight) style:UITableViewStylePlain];
    [self.view addSubview:settingTableView];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.backgroundColor = [UIColor clearColor];
    settingTableView.separatorInset = UIEdgeInsetsZero;
    if ([settingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [settingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([settingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [settingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    settingTableView.separatorColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, HEADHEIGHT)];
    
    UIImageView *back_imgView = [[UIImageView alloc] initWithFrame:self.headView.frame];
    [back_imgView setContentMode:UIViewContentModeScaleAspectFill];
    back_imgView.clipsToBounds = YES;
    back_imgView.image = [UIImage imageNamed:@"user_info_backGImg"];
    [self.headView addSubview:back_imgView];
    
    //头像
    self.iconImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconImgView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.headView addSubview:iconImgView];
    
    //等级
    self.levelImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.levelImgView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.levelImgView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self setLevelImg]; //设置图标
    [self.headView addSubview:self.levelImgView];
    
    //姓名
    self.iconImgLabel = [[UILabel alloc] init];
    self.iconImgLabel.textColor = [UIColor whiteColor];
    self.iconImgLabel.textAlignment = NSTextAlignmentRight;
    self.iconImgLabel.clipsToBounds = YES;
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_chinese_name"];
    self.iconImgLabel.text = nameStr;
    [self.headView addSubview:self.iconImgLabel];
    
    
    if (PPMainViewWidth<350) {
        self.iconImgView.frame = CGRectMake(PPMainViewWidth/2-38,self.headView.center.y-55+10-13, 76, 76);
        self.iconImgView.clipsToBounds = YES;
        self.iconImgView.layer.cornerRadius = 38;
        self.iconImgView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        self.iconImgView.layer.borderWidth = 2;
        
        
        self.iconImgLabel.frame = CGRectMake(PPMainViewWidth/2-98,self.headView.center.y+25, 95, 30);
        self.iconImgLabel.font = SystemFont(17);
        
        self.levelImgView.frame = CGRectMake(PPMainViewWidth/2+6,self.headView.center.y+29, 45,20);



    }else{
        self.iconImgView.frame = CGRectMake(PPMainViewWidth/2-50,self.headView.center.y-70,100, 100);
        self.iconImgView.clipsToBounds = YES;
        self.iconImgView.layer.cornerRadius = 50;
        self.iconImgView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        self.iconImgView.layer.borderWidth = 2;
        
        self.levelImgView.frame = CGRectMake(PPMainViewWidth/2+5,self.headView.center.y+54, 45, 20);
        
        self.iconImgLabel.frame = CGRectMake(PPMainViewWidth/2-87,self.headView.center.y+50, 85, 30);
        self.iconImgLabel.font = SystemFont(17);
    }
    
    
    // 与图像高度一样防止数据被遮挡
    self.settingTableView.tableHeaderView = headView;
    
    NSString *user_headImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"];

   [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:user_headImg] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
       if (image == nil) {
           [self.iconImgView setImage:[UIImage imageNamed:@"user_head_default"] forState:UIControlStateNormal];
       }
       
    }];

    
}


-(void)setLevelImg{
    
    NSString *levelString = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"];
    [self.levelImgView setBackgroundImage:[UIImage imageNamed:@"levelBGIMG"] forState:UIControlStateNormal];//给button添加image

    self.levelImgView.titleLabel.font = [UIFont systemFontOfSize:14];


    if (levelString == nil || [levelString isEqual:[NSNull null]]) {
        levelString = @"0";
    }
    
    [self.levelImgView setTitle:[NSString stringWithFormat:@"Lv.%@",levelString] forState:UIControlStateNormal];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101010) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.KEFU_TELPHONE]]];
        }else{
            return;
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {////充值记录
        
        JCCYPayHistoryViewController *jCCYPayHistoryViewController = [[JCCYPayHistoryViewController alloc] init];
        jCCYPayHistoryViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jCCYPayHistoryViewController animated:YES];
    }else if (indexPath.row == 2){//消费记录
        JCCYUsedHistoryViewController *sCCYUsedHistoryViewController = [[JCCYUsedHistoryViewController alloc] init];
        sCCYUsedHistoryViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sCCYUsedHistoryViewController animated:YES];
    }else if (indexPath.row == 3){ //客服电话
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打客服电话？" delegate:self cancelButtonTitle:@"拨打" otherButtonTitles:@"取消", nil];
        alertView.tag = 101010;
        [alertView show];
    }else if (indexPath.row == 0){//在线充值
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.jCCYMyListViewController = self;
        
        JCCYChongZhiViewController *jCCYChongZhiViewController = [[JCCYChongZhiViewController alloc] init];
        jCCYChongZhiViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jCCYChongZhiViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 90)];
    tableHeadView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    UIView *toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 75)];
    toolsView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/2, 6, 1, 60)];
    lineLabel.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    [toolsView addSubview:lineLabel];
    
    //添加两个模块
    //视图一
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/2 - 1, 75)];
    
    //金币数Label
    NSString *jingbiNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"golds"] stringValue];
    if (jingbiNum.length == 0 || jingbiNum == nil) {
        jingbiNum = @"0";
    }
    CGSize size1 = GetWTextSizeFont(jingbiNum, 30, 20);
    
    UILabel *jingbiNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4-15+10, 15, size1.width+50, 30)];
    jingbiNumLabel.textColor = [UIColor colorFromHexRGB:@"ee7700"];
    jingbiNumLabel.font = [UIFont systemFontOfSize:20];

    jingbiNumLabel.text = jingbiNum;
    [view1 addSubview:jingbiNumLabel];
    //图片
    UIButton *img1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    img1Btn.frame = CGRectMake(PPMainViewWidth/4-65+10, 18, 50, 50);
    img1Btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [img1Btn setImage:[UIImage imageNamed:@"setting_jinbi"] forState:UIControlStateNormal];
    [view1 addSubview:img1Btn];
    
    //金币label
    UILabel *jingbiLabel = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4-15+10, 38, 60, 25)];
    jingbiLabel.text = @"金币";
    jingbiLabel.textColor = [UIColor grayColor];
    jingbiLabel.font = [UIFont systemFontOfSize:14];
    
    [view1 addSubview:jingbiLabel];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, view1.bounds.size.width, view1.bounds.size.height);
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(jinbiAction) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn1];
    
    //视图二
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(PPMainViewWidth/2 +1, 0, PPMainViewWidth/2 - 1, 75)];

    //图片
    UIButton *img2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    img2Btn.frame = CGRectMake(PPMainViewWidth/4-65+10, 18, 50, 50);
    img2Btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [img2Btn setImage:[UIImage imageNamed:@"setting_jifen"] forState:UIControlStateNormal];
    [view2 addSubview:img2Btn];
    
    //积分数Label
    NSString *jifenNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scores"] stringValue];
    if (jifenNum.length == 0 || jifenNum == nil) {
        jifenNum = @"0";
    }
    CGSize size2 = GetWTextSizeFont(jifenNum, 25, 20);
    UILabel *jifenNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4-15+10 ,15,size2.width+50, 25)];
    jifenNumLabel.textColor = [UIColor grayColor];
    jifenNumLabel.font = [UIFont systemFontOfSize:20];

    jifenNumLabel.text = jifenNum;
    [view2 addSubview:jifenNumLabel];
    
    //积分label
    UILabel *jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4-15+10,38, 60, 25)];
    jifenLabel.text = @"积分";
    jifenLabel.textColor = [UIColor grayColor];
    jifenLabel.font = [UIFont systemFontOfSize:14];
    [view2 addSubview:jifenLabel];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, view2.bounds.size.width, view2.bounds.size.height);
    [btn2 addTarget:self action:@selector(jifenAction) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:btn2];
    
    [toolsView addSubview:view1];
    [toolsView addSubview:view2];
    
    [tableHeadView addSubview:toolsView];
    
    return tableHeadView;
}
//点击积分
-(void)jifenAction{
    JCCYLevelInfoViewController *jCCYLevelInfoViewController = [[JCCYLevelInfoViewController alloc] init];
    jCCYLevelInfoViewController.hidesBottomBarWhenPushed = YES;
    jCCYLevelInfoViewController.levelArray = self.levelArray;
    [self.navigationController pushViewController:jCCYLevelInfoViewController animated:YES];
}
//点击金币
-(void)jinbiAction{
    JCCYPayHistoryViewController *jCCYPayHistoryViewController = [[JCCYPayHistoryViewController alloc] init];
    jCCYPayHistoryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jCCYPayHistoryViewController animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"settingTableView";
    SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    }

    NSString *title = [[self.settingList objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.settingTitleLabel.text = title;
    [cell.iConView setImage:[[self.settingList objectAtIndex:indexPath.row] objectForKey:@"img"] forState:UIControlStateNormal];
    
    cell.allViewBtn.tag = indexPath.row;
    [cell.allViewBtn addTarget:self action:@selector(allViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == 0||indexPath.row == 1 || indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *linelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60-0.5, PPMainViewWidth-20, 0.5)];
        linelabel.backgroundColor = [UIColor colorFromHexRGB:@"d9d9d9"];
        [cell.allcontentView addSubview:linelabel];
    }else{
        NSString *kefuTelephone = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEFU_TELPHONE"];
        cell.settingTitleLabel.text = [NSString stringWithFormat:@"客服电话：%@",kefuTelephone];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;
}

-(void)allViewBtnAction:(UIButton *)btn{
    if (btn.tag == 1) {////充值记录
        
        JCCYPayHistoryViewController *jCCYPayHistoryViewController = [[JCCYPayHistoryViewController alloc] init];
        jCCYPayHistoryViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jCCYPayHistoryViewController animated:YES];
    }else if (btn.tag == 2){//消费记录
        JCCYUsedHistoryViewController *sCCYUsedHistoryViewController = [[JCCYUsedHistoryViewController alloc] init];
        sCCYUsedHistoryViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sCCYUsedHistoryViewController animated:YES];
    }else if (btn.tag == 3){ //客服电话
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打客服电话？" delegate:self cancelButtonTitle:@"拨打" otherButtonTitles:@"取消", nil];
        alertView.tag = 101010;
        [alertView show];
    }else if (btn.tag == 0){//在线充值
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.jCCYMyListViewController = self;
        JCCYChongZhiViewController *jCCYChongZhiViewController = [[JCCYChongZhiViewController alloc] init];
        jCCYChongZhiViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jCCYChongZhiViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 清理缓存图片
- (void)clearTmpPics
{
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = [NSString stringWithFormat:@"清除缓存(%@)",[self getDataSizeString:size]];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
    
    //    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:clearCacheName delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    [settingTableView reloadData];
}

#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(NSUInteger) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%ldB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%ldK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%ldM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%ldMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%ld.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%ldG", nSize/1073741824];
    }
    
    return string;
}


@end
