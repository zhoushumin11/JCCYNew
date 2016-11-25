//
//  FiemShowByTypeViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/26.
//
//

#import "FiemShowByTypeViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "FirmIMGCell.h"
#import "FirmStringCell.h"

#import "JCCYMyListViewController.h"

#import "SCAvatarBrowser.h"

@interface FiemShowByTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
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


@end

@implementation FiemShowByTypeViewController

@synthesize reFreshTimeLabel,reFreshBtn,reFreshTimeString,refreshTimeNum,mainHeadView,dataArray,mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实盘";
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
    
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
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, PPMainViewWidth,self.view.bounds.size.height-64-50-44-4) style:UITableViewStylePlain];
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
    cmheader.lastUpdatedTimeLabel.hidden = YES;
    
    mainTableView.mj_footer.hidden = YES;
    
    mainTableView.mj_header = cmheader;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self timerInvalidate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getServerData];
    //刷新我的信息
    [self initMyView];
}
-(void)initMyView{
    
    //初始化用户button
    UIButton *user_info_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    user_info_btn.frame = CGRectMake(-10, 0, 80, 44);
    user_info_btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [user_info_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [user_info_btn setTitle:@"" forState:UIControlStateNormal];
    [user_info_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [user_info_btn addTarget:self action:@selector(userInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化用户等级button
    UIButton *user_info_Level = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    user_info_Level.frame = CGRectMake(38, 12, 40, 20);
    user_info_Level.titleLabel.textAlignment = NSTextAlignmentLeft;
    [user_info_Level setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [user_info_Level addTarget:self action:@selector(userInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    userInfoView.backgroundColor = [UIColor clearColor];
    [userInfoView addSubview:user_info_btn];
    [userInfoView addSubview:user_info_Level];
    
    UIBarButtonItem *leftbarbtn = [[UIBarButtonItem alloc] initWithCustomView:userInfoView];
    self.navigationItem.leftBarButtonItem = leftbarbtn;
    
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_chinese_name"];
    if (nameStr.length > 4) {
        nameStr = [nameStr substringToIndex:4];
    }
    
    [user_info_btn setTitle:nameStr forState:UIControlStateNormal];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] isEqualToString:@"0"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] == nil) {
        [user_info_Level setBackgroundImage:[UIImage imageNamed:@"level0"] forState:UIControlStateNormal];//给button添加image
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] isEqualToString:@"1"]) {
        [user_info_Level setBackgroundImage:[UIImage imageNamed:@"level1"] forState:UIControlStateNormal];//给button添加image
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] isEqualToString:@"2"]) {
        [user_info_Level setBackgroundImage:[UIImage imageNamed:@"level2"] forState:UIControlStateNormal];//给button添加image
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] isEqualToString:@"3"]) {
        [user_info_Level setBackgroundImage:[UIImage imageNamed:@"level3"] forState:UIControlStateNormal];//给button添加image
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] isEqualToString:@"4"]) {
        [user_info_Level setBackgroundImage:[UIImage imageNamed:@"level4"] forState:UIControlStateNormal];//给button添加image
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] isEqualToString:@"5"]) {
        [user_info_Level setBackgroundImage:[UIImage imageNamed:@"level5"] forState:UIControlStateNormal];//给button添加image
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] isEqualToString:@"6"]) {
        [user_info_Level setBackgroundImage:[UIImage imageNamed:@"level6"] forState:UIControlStateNormal];//给button添加image
    }
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
    reFreshTimeLabel.font = [UIFont systemFontOfSize:16];
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
    reFreshTimeString = [NSString stringWithFormat:@"%@ 还有%ld秒自动刷新 ",nowDateStr,refreshTimeNum];
    //先获取文字的大小
    CGSize size  = GetWTextSizeFont(reFreshTimeString, 50, 16);//文字宽度
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
    CGSize size  = GetWTextSizeFont(reFreshTimeString, 50, 16);//文字宽度
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
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"platform\":\"%d\"}",87,token,0];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Live/index/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSArray *dataArr = [json objectForKey:@"data"];
                          if ([dataArr isEqual:[NSNull null]]) {
                              return;
                          }
                          //重置服务器更新时间倒计时
                          refreshTimeNum = 60;
                          //重新开始获取数据
                          [self runTimer];
                          
                          dataArray  = [NSMutableArray arrayWithArray:dataArr];
                          [mainTableView reloadData];
                      }else{
                          
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
                      //设置服务器访问的最大时间
                      if (refreshTimeNum < 360) {
                          refreshTimeNum+=60;
                      }
                      //重新开始获取数据
                      [self runTimer];
                      
                  }];
    }
}

#pragma mark ----- UITableViewDelegate ----

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *live_picStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_pic"];
    if (![live_picStr isEqual:[NSNull null]]) { //图片内容
        return 180;
    }else{
        CGSize strSize = GetHTextSizeFont([[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"], PPMainViewWidth - 120, 15);
        float wh = strSize.height + 60;
        if (wh < 110) {
            return  120;
        }
        return wh;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
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
        
        
        cell.userNameLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_teacher_name"];
        
        NSInteger num = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] integerValue];
        double i = [[NSNumber numberWithInteger:num] doubleValue]/1000;
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
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
        
        cell.contenImageView.tag = indexPath.row;
        [cell.contenImageView addTarget:self action:@selector(contenImageViewAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{//文字内容
        static NSString *identify = @"FirmStringCell";
        FirmStringCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (cell == nil) {
            cell = [[FirmStringCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_teacher_name"];
        
        NSInteger num = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] integerValue];
        double i = [[NSNumber numberWithInteger:num] doubleValue]/1000;
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
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
        
        CGSize strSize = GetHTextSizeFont([[dataArray objectAtIndex:indexPath.row] objectForKey:@"live_title"], PPMainViewWidth - 120, 15);
        cell.contenStringSuperView.frame = CGRectMake(90, 50, PPMainViewWidth - 100, strSize.height);
        cell.contenStringView.frame = CGRectMake(10, 0, PPMainViewWidth - 120, strSize.height);
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
