//
//  TwoViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import "FirmViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "FirmIMGCell.h"
#import "FirmStringCell.h"

#import "JCCYMyListViewController.h"

#import "SCAvatarBrowser.h"

#import "JCCYNoDataView.h"

#import "CalculateHeight.h"
#import "JJLabel.h"

@interface FirmViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer *timer;
}

@property (strong, nonatomic) UIImageView *avatar;

@property(nonatomic,strong) NSString *reFreshTimeString; //刷新时间字符
@property(nonatomic,assign) NSInteger refreshTimeNum; //多少秒要刷新
@property(nonatomic,strong) UILabel *reFreshTimeLabel; //刷新的时间
@property(nonatomic,strong) UIButton *reFreshBtn;  //刷新按钮
@property(nonatomic,strong) UIView *mainHeadView; //刷新视图

@property(nonatomic,strong) NSMutableArray *dataArray; //列表数据
@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) JCCYNoDataView *noDataView;


@end

@implementation FirmViewController

@synthesize reFreshTimeLabel,reFreshBtn,reFreshTimeString,refreshTimeNum,mainHeadView,dataArray,mainTableView,noDataView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实盘";
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    dataArray = [NSMutableArray array];
    
    NSString *LIVE_REFRESH_SECOND = [[NSUserDefaults standardUserDefaults] objectForKey:@"LIVE_REFRESH_SECOND"];
    if ([LIVE_REFRESH_SECOND isEqual:[NSNull null]] || LIVE_REFRESH_SECOND == nil) {
        refreshTimeNum = 60;
    }else{
        refreshTimeNum = [LIVE_REFRESH_SECOND integerValue];
    }
    
    //创建顶部视图
    [self creatHeadViews];
    //创建表视图
    [self creatMainTableView];
    
}
-(void)creatMainTableView{
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, PPMainViewWidth,PPMainViewHeight-50-64-49) style:UITableViewStylePlain];
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.separatorInset = UIEdgeInsetsZero;
    //        _bulletinlistTableView.tableHeaderView = [[UIView alloc] init];
    if ([mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    mainTableView.separatorColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    MJRefreshNormalHeader *cmheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getServerData)];
    mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreTableView)];
    mainTableView.mj_footer.hidden = NO;
    
    cmheader.lastUpdatedTimeLabel.hidden = YES;
    mainTableView.mj_header = cmheader;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
}

-(void)refreshMoreTableView{
    if ([mainTableView.mj_footer isRefreshing]) {
        [mainTableView.mj_footer endRefreshing];
    }
    [mainTableView.mj_footer endRefreshingWithNoMoreData];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self timerInvalidate];

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSString *LIVE_REFRESH_SECOND = [[NSUserDefaults standardUserDefaults] objectForKey:@"LIVE_REFRESH_SECOND"];
    if ([LIVE_REFRESH_SECOND isEqual:[NSNull null]] || LIVE_REFRESH_SECOND == nil) {
        refreshTimeNum = 60;
    }else{
        refreshTimeNum = [LIVE_REFRESH_SECOND integerValue];
    }
    
    [self getServerData];
    //刷新我的信息
    [self initMyView];
}
-(void)initMyView{
    
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_chinese_name"];
    if (nameStr.length > 4) {
        nameStr = [nameStr substringToIndex:4];
    }
        
    CGSize size = GetWTextSizeFont(nameStr, 44, 16);
    
    //初始化用户button
    UIButton *user_info_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    user_info_btn.frame = CGRectMake(-10, 0, size.width+10, 44);
    user_info_btn.titleLabel.font = [UIFont systemFontOfSize:16];
    user_info_btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [user_info_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [user_info_btn setTitle:@"" forState:UIControlStateNormal];
    [user_info_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [user_info_btn addTarget:self action:@selector(userInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化用户等级button
    UIButton *user_info_Level = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    user_info_Level.frame = CGRectMake(size.width, 13, 49, 21);
    user_info_Level.titleLabel.textAlignment = NSTextAlignmentCenter;
    [user_info_Level setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [user_info_Level addTarget:self action:@selector(userInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    userInfoView.backgroundColor = [UIColor clearColor];
    [userInfoView addSubview:user_info_btn];
    [userInfoView addSubview:user_info_Level];
    
    UIBarButtonItem *leftbarbtn = [[UIBarButtonItem alloc] initWithCustomView:userInfoView];
    self.navigationItem.leftBarButtonItem = leftbarbtn;
    

    
    [user_info_btn setTitle:nameStr forState:UIControlStateNormal];
    
    
    NSString *levelString = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"];
    [user_info_Level setBackgroundImage:[UIImage imageNamed:@"levelBGIMG"] forState:UIControlStateNormal];//给button添加image
    user_info_Level.titleLabel.font = [UIFont systemFontOfSize:14];

    if (levelString == nil || [levelString isEqual:[NSNull null]]) {
        levelString = @"0";
    }
    
    [user_info_Level setTitle:[NSString stringWithFormat:@"Lv.%@",levelString] forState:UIControlStateNormal];
}

#pragma mark ---跳入用户详情页 -----
-(void)userInfoBtnAction{
    JCCYMyListViewController  *jCCYMyListViewController = [[JCCYMyListViewController alloc] init];
    jCCYMyListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jCCYMyListViewController animated:YES];
}

-(void)creatHeadViews{
    //刷新视图
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    
    mainHeadView = [[UIView alloc] initWithFrame:CGRectZero];;
    
    [headView addSubview:mainHeadView];
    
    //刷新label
    reFreshTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    reFreshTimeLabel.font = [UIFont systemFontOfSize:14];
    reFreshTimeLabel.textColor = [UIColor blackColor];
    [mainHeadView addSubview:reFreshTimeLabel];
    
    //刷新button
    reFreshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reFreshBtn.frame = CGRectZero;
    [reFreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
    [reFreshBtn setTitleColor:[UIColor colorFromHexRGB:@"e7505a"] forState:UIControlStateNormal];
    reFreshBtn.layer.masksToBounds = YES;
    reFreshBtn.layer.borderWidth = 1;
    [reFreshBtn.layer setCornerRadius:3];
    reFreshBtn.layer.borderColor=[UIColor colorFromHexRGB:@"e7505a"].CGColor;
    [reFreshBtn addTarget:self action:@selector(reFreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [mainHeadView addSubview:reFreshBtn];
    
    [headView addSubview:mainHeadView];
    
    [self.view addSubview:headView];
    
    //访问服务器
    [self getServerData];


}

#pragma mark -- 初始化直播数据
-(void)initZhiboDatas{
    
    NSString *nowDateStr = [[PPToolsClass sharedTools] getcurrentDate:[NSDate date]];
    reFreshTimeString = [NSString stringWithFormat:@"   %@ 还有%ld秒自动刷新 ",nowDateStr,refreshTimeNum];
    //先获取文字的大小
    CGSize size  = GetWTextSizeFont(reFreshTimeString, 50, 14);//文字宽度
    reFreshTimeLabel.frame = CGRectMake(0, 0, size.width+30, 50);//Label位置
    reFreshBtn.frame = CGRectMake(size.width+20, 10, 70, 30);//按钮位置
    reFreshTimeLabel.text = reFreshTimeString;
    mainHeadView.frame = CGRectMake((PPMainViewWidth-(size.width+10+30+70))/2, 0, size.width+10+30+70, 50);//刷新视图位置
    mainHeadView.center = mainHeadView.superview.center;
}

-(void)initZhiboDatas11{
    
    NSString *nowDateStr = [[PPToolsClass sharedTools] getcurrentDate:[NSDate date]];
    reFreshTimeString = [NSString stringWithFormat:@"%@  正在刷新...",nowDateStr];
    //先获取文字的大小
    CGSize size  = GetWTextSizeFont(reFreshTimeString, 50, 14);//文字宽度
    reFreshTimeLabel.frame = CGRectMake(0, 0, size.width+30, 50);//Label位置
    reFreshBtn.frame = CGRectMake(size.width+20, 10, 70, 30);//按钮位置
    reFreshTimeLabel.text = reFreshTimeString;
    mainHeadView.frame = CGRectMake((PPMainViewWidth-(size.width+10+30+70))/2, 0, size.width+10+30+70, 50);//刷新视图位置
    mainHeadView.center = mainHeadView.superview.center;
}

#pragma mark --- 计时器初始化 -----
-(void)runTimer{
    if (timer) {
        return;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
}
#pragma mark --- 计时器运行 -----
-(void)timeAction{
    
    //刷新头视图
    [self initZhiboDatas];
    
    //倒计时-1
    refreshTimeNum--;
    //当倒计时到0时，做需要的操作
    if(refreshTimeNum==-1){
        //刷新
        [self reFreshBtnAction];
        //显示刷新视图
        [self initZhiboDatas11];
        //停止计时
        [self timerInvalidate];
        
    }
}

#pragma mark --- 计时器停止 -----

-(void)timerInvalidate{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


#pragma mark --- 刷新 -----
-(void)reFreshBtnAction{
    
    [self getServerData];
}


//获取直播数据
-(void)getServerData{
    
    //显示刷新视图
    [self initZhiboDatas11];
    NSString *dJson = nil;

        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"platform\":\"%d\"}",updata_id,token,0];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Live/index/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      if (noDataView) {
                          [noDataView removeFromSuperview];
                          mainTableView.hidden = NO;
                      }
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSArray *dataArr = [json objectForKey:@"data"];
                          if ([dataArr isEqual:[NSNull null]]) {
                              if (!noDataView) {
                                  noDataView = [[JCCYNoDataView alloc] initWithFrame:CGRectMake(PPMainViewWidth/2-100, 200, 200, 200)];
                                  [self.view addSubview:noDataView];
                                  mainTableView.hidden = YES;
                              }else{
                                  [self.view addSubview:noDataView];
                                  mainTableView.hidden = YES;
                              }
                              return;
                          }
                          //重置服务器更新时间倒计时
                          refreshTimeNum = 60;
                          //重新开始获取数据
                          [self runTimer];
                          
                          dataArray  = [NSMutableArray arrayWithArray:dataArr];
                          [mainTableView reloadData];
                          [mainTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

                          

                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else{
                          [JCCYResult showResultWithResult:[NSString stringWithFormat:@"%ld",code] controller:self];
 
                    }
                      
                  } failedBlock:^(NSError *error) {
                      if (!noDataView) {
                          noDataView = [[JCCYNoDataView alloc] initWithFrame:CGRectMake(PPMainViewWidth/2-100, 200, 200, 200)];
                          [self.view addSubview:noDataView];
                          mainTableView.hidden = YES;
                      }else{
                          [self.view addSubview:noDataView];
                          mainTableView.hidden = YES;
                      }
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
                      //设置服务器访问的最大时间
                      if (refreshTimeNum < 300) {
                          refreshTimeNum+=60;
                      }
                      //重新开始获取数据
                      [self runTimer];
                      
                  }];

}

#pragma mark ----- UITableViewDelegate ----

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *live_picStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_pic"];
    if (![live_picStr isEqual:[NSNull null]]) { //图片内容
        return 190;
    }else{
//    CGSize strSize = GetHTextSizeFont([[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"], PPMainViewWidth - 120, 15);
//    CGFloat h = [CalculateHeight getSpaceLabelHeight:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"] withWidth:PPMainViewWidth - 120];

        JJLabel *spaceLab = [[JJLabel alloc] init];
        spaceLab.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"];
        spaceLab.numberOfLines = 0;
        spaceLab.backgroundColor = [UIColor clearColor];
        spaceLab.lineSpace = 0.0f;
        spaceLab.characterSpace = 0.0f;
        spaceLab.font = [UIFont systemFontOfSize:15];
        spaceLab.isCopy = NO;
        
        CGFloat labHeight = [spaceLab getLableHeightWithMaxWidth:(PPMainViewWidth - 120)];
        
        float wh = labHeight +100 ;
//        if (wh < 110) {
//            return  120;
//        }else if (wh < 150){
//            return 150;
//        }
        if (wh>90 && wh < 135) {
            return 135;
        }
        
        if (wh<90) {
            return 120;
        }
        
        return wh;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return mainHeadView;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *live_picStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_pic"];
    if (![live_picStr isEqual:[NSNull null]]) { //图片内容
        static NSString *identify = @"FirmIMGCell";
        FirmIMGCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[FirmIMGCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        cell.userNameLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_teacher_name"];
        
        NSInteger num = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] integerValue];
        double i = [[NSNumber numberWithInteger:num] doubleValue];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *timeStr = [dateFormat stringFromDate:nd];
        cell.timeLabel.text = timeStr;
        
        NSString *icon_picStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_teacher_pic"];
        
        
        //设置头像图片
        [cell.iConView sd_setImageWithURL:[NSURL URLWithString:icon_picStr] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                [cell.iConView setImage:[UIImage imageNamed:@"user_head_default"] forState:UIControlStateNormal];
            }
        }];
        
        //设置内容图片
        [cell.contenImageView sd_setImageWithURL:[NSURL URLWithString:live_picStr] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image == nil) {
                [cell.contenImageView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
        }];
        
        UILabel *linelabels = [[UILabel alloc] initWithFrame:CGRectMake(10, 185.5, PPMainViewWidth - 20, 0.5)];
        linelabels.backgroundColor = [UIColor colorFromHexRGB:@"d9d9d9"];
        [cell addSubview:linelabels];
        

        cell.contenImageView.tag = indexPath.row;
        [cell.contenImageView addTarget:self action:@selector(contenImageViewAction:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else{//文字内容
        static NSString *identify = @"FirmStringCell";
//        FirmStringCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        FirmStringCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[FirmStringCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        if (indexPath.row == dataArray.count-1) {
            cell.lineLabel.hidden = YES;
        }else{
            cell.lineLabel.hidden = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_teacher_name"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        NSInteger num = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] integerValue];
        double i = [[NSNumber numberWithInteger:num] doubleValue];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *timeStr = [dateFormat stringFromDate:nd];
        cell.timeLabel.text = timeStr;
        
        NSString *icon_picStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_teacher_pic"];
        
        //设置头像图片
        [cell.iConView sd_setImageWithURL:[NSURL URLWithString:icon_picStr] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                [cell.iConView setImage:[UIImage imageNamed:@"user_head_default"] forState:UIControlStateNormal];
            }
        }];
        
        cell.contenStringView.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"];
        NSString *colorStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title_color"];
        colorStr = [colorStr substringFromIndex:1];
        cell.contenStringView.textColor = [UIColor colorFromHexRGB:colorStr];
        
//        CGSize strSize = GetHTextSizeFont([[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"], PPMainViewWidth - 120, 15);
        
        CGFloat h = [CalculateHeight getSpaceLabelHeight:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"] withWidth:PPMainViewWidth - 120];

        
        {

            NSString *titleStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"];
            JJLabel *spaceLab = [[JJLabel alloc] init];
            spaceLab.text = titleStr;
            spaceLab.numberOfLines = 0;
            spaceLab.backgroundColor = [UIColor clearColor];
            spaceLab.lineSpace = 0.0f;
            spaceLab.characterSpace = 0.0f;
            spaceLab.isCopy = NO;
            spaceLab.font = [UIFont systemFontOfSize:15];
            spaceLab.textColor = [UIColor colorFromHexRGB:colorStr];

            CGFloat labHeight = [spaceLab getLableHeightWithMaxWidth:(PPMainViewWidth - 120)];
            cell.contenStringSuperView.frame = CGRectMake(90, 50, PPMainViewWidth - 100, labHeight+20);
            spaceLab.frame = CGRectMake(10, 10, PPMainViewWidth - 120, labHeight);
            [cell.contenStringSuperView addSubview:spaceLab];
        }

//        cell.contenStringSuperView.frame = CGRectMake(90, 50, PPMainViewWidth - 100, h+14);
//        cell.contenStringView.frame = CGRectMake(10, 7, PPMainViewWidth - 120, h);
        
//        cell.contentTextView.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"];
//        NSString *colorStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title_color"];
//        colorStr = [colorStr substringFromIndex:1];
//        cell.contentTextView.textColor = [UIColor colorFromHexRGB:colorStr];
//        
//        CGSize strSize = GetHTextSizeFont([[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"], PPMainViewWidth - 120, 15);
//        cell.contentTextView.frame = CGRectMake(90, 50, PPMainViewWidth - 120, strSize.height+10);

        
        
        return cell;
    }
    
}

-(void)contenImageViewAction:(UIButton *)btn{
    NSString *imagePath = [[dataArray objectAtIndex:btn.tag] objectForKey:@"live_pic_xx"];
    
    self.avatar = [[UIImageView alloc] init];
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [SCAvatarBrowser showImageView:self.avatar];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
