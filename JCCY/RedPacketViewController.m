//
//  ThreeViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import "RedPacketViewController.h"

#import "RedPacketTableViewCell.h"

#import "JCCYBuyVipViewController.h"
#import "FiemShowByTypeViewController.h"

#import "JCCYMyListViewController.h"

#import "NSString+WPAttributedMarkup.h"


@interface RedPacketViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation RedPacketViewController
@synthesize mainTableView,dataArray;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self get_info];
//    [self initMyView];
}
#pragma mark --- 更新会员信息 ----
-(void)get_info{
        NSString *dJson = nil;
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
                              
                              [mainTableView reloadData];
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


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    dataArray = [NSMutableArray array];
    
    NSString *ZANSHANG_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZANSHANG_USE_CONTENT"];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_zangshang",@"imgName",@"赞赏",@"title",@"ffa800",@"color",ZANSHANG_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic1];
    
    NSString *ZUANSHI_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZUANSHI_USE_CONTENT"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_zuanshi",@"imgName",@"钻石",@"title",@"18a3dc",@"color",ZUANSHI_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic2];
    
    NSString *HUANGJIN_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUANGJIN_USE_CONTENT"];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_huangjin",@"imgName",@"黄金",@"title",@"ff6e4e",@"color",HUANGJIN_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic3];
    
    
    [self setUpNav];
    
    [self creatMainView];
    
}

- (void)setUpNav
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"liveRadioPlayingBack"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//创建主视图
-(void)creatMainView{
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth,self.view.bounds.size.height) style:UITableViewStylePlain];
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
    MJRefreshNormalHeader *cmheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];//@selector(loadMylogList)
    cmheader.lastUpdatedTimeLabel.hidden = YES;
    
    mainTableView.mj_footer.hidden = YES;
    
    mainTableView.mj_header = cmheader;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
    
    [mainTableView  reloadData];
    
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
    user_info_Level.frame = CGRectMake(size.width, 13, 40, 18);
    user_info_Level.titleLabel.textAlignment = NSTextAlignmentLeft;
    [user_info_Level setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [user_info_Level addTarget:self action:@selector(userInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    userInfoView.backgroundColor = [UIColor clearColor];
    [userInfoView addSubview:user_info_btn];
    [userInfoView addSubview:user_info_Level];
    
    UIBarButtonItem *leftbarbtn = [[UIBarButtonItem alloc] initWithCustomView:userInfoView];
    self.navigationItem.leftBarButtonItem = leftbarbtn;
    
    
    
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

-(void)refreshTableView{
    if ([mainTableView.mj_header isRefreshing]) {
        [mainTableView.mj_header endRefreshing];
    }
    dataArray = [NSMutableArray array];
    
    NSString *ZANSHANG_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZANSHANG_USE_CONTENT"];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_zangshang",@"imgName",@"赞赏",@"title",@"ffa800",@"color",ZANSHANG_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic1];
    
    NSString *ZUANSHI_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZUANSHI_USE_CONTENT"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_zuanshi",@"imgName",@"钻石",@"title",@"18a3dc",@"color",ZUANSHI_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic2];
    
    NSString *HUANGJIN_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUANGJIN_USE_CONTENT"];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_huangjin",@"imgName",@"黄金",@"title",@"ff6e4e",@"color",HUANGJIN_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic3];
    
    [self get_info];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *info = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"info"];
    CGSize strSize = GetHTextSizeFont(info, PPMainViewWidth - 120, 15);
    return 65+strSize.height+40+20+20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"RedPacketTableViewCell";
    
    RedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[RedPacketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.contentView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    cell.allcontentView.frame = CGRectMake(0, 0, PPMainViewWidth, 135);
    cell.allcontentView.layer.masksToBounds = YES;
    [cell.allcontentView setBorderWidth:0.5];
    [cell.allcontentView setBorderColor:[UIColor colorFromHexRGB:@"d9d9d9"]];
    
    [cell.r_imgBtn setImage:[UIImage imageNamed:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imgName"]] forState:UIControlStateNormal];
    cell.r_titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    
    NSNumber *present_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"present_time"];
    NSNumber *time_service_1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"time_service_1"];
    NSNumber *time_service_2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"time_service_2"];
    NSNumber *time_service_3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"time_service_3"];
    
    //服务器当前时间
    double i0 = [present_time doubleValue];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *present_timeStr = [dateFormat stringFromDate:nd];
    
    //赞赏到期时间
    double i1 = [time_service_1 doubleValue];
    NSDate *nd1 = [NSDate dateWithTimeIntervalSince1970:i1];
    NSString *time_service_1Str = [dateFormat stringFromDate:nd1];
    //钻石到期时间
    double i2 = [time_service_2 doubleValue];
    NSDate *nd2 = [NSDate dateWithTimeIntervalSince1970:i2];
    NSString *time_service_2Str = [dateFormat stringFromDate:nd2];
    //黄金到期时间
    double i3 = [time_service_3 doubleValue];
    NSDate *nd3 = [NSDate dateWithTimeIntervalSince1970:i3];
    NSString *time_service_3Str = [dateFormat stringFromDate:nd3];
    
    NSDictionary* style1 = @{@"red": [UIColor redColor]};
    
    if (indexPath.row == 0) {
        NSDateFormatter *fomart = [[NSDateFormatter alloc] init];
        fomart.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *daoqiTime = [fomart dateFromString:time_service_1Str];
        NSDate *dangqianTime = [fomart dateFromString:present_timeStr];
        
        NSTimeInterval daoqiTimeI = [daoqiTime timeIntervalSince1970];
        NSTimeInterval dangqianTimeI = [dangqianTime timeIntervalSince1970];
        NSTimeInterval cha=daoqiTimeI-dangqianTimeI;
        
        div_t d = div(cha, 86400);
        int days = d.quot;
        NSString *daystr = @"";
        if (days>=0) {
            daystr = [NSString stringWithFormat:@"剩余%d天",days];
            [cell.r_enterInBtn setHidden:NO];
        }else{
            daystr = @"剩余0天";
            [cell.r_enterInBtn setHidden:YES];
        }
        
        NSString *ds = [NSString stringWithFormat:@"%@",time_service_1];
        
        if ([ds isEqualToString:@"0"] ) {
            days = 0;
        }
        NSString *dasss = [NSString stringWithFormat:@"剩余<red>%d</red>天",days];
        cell.r_EndDaysLabel.attributedText = [dasss attributedStringWithStyleBook:style1];

//        cell.r_EndDaysLabel.text = daystr;
    }else if (indexPath.row == 1){
        NSDateFormatter *fomart = [[NSDateFormatter alloc] init];
        fomart.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *daoqiTime = [fomart dateFromString:time_service_2Str];
        NSDate *dangqianTime = [fomart dateFromString:present_timeStr];
        
        NSTimeInterval daoqiTimeI = [daoqiTime timeIntervalSince1970];
        NSTimeInterval dangqianTimeI = [dangqianTime timeIntervalSince1970];
        NSTimeInterval cha=daoqiTimeI-dangqianTimeI;
        
        div_t d = div(cha, 86400);
        int days = d.quot;
        NSString *daystr = @"";
        if (days>=0) {
            daystr = [NSString stringWithFormat:@"剩余%d天",days];
            [cell.r_enterInBtn setHidden:NO];
        }else{
            daystr = @"剩余0天";
            [cell.r_enterInBtn setHidden:YES];
        }
        NSString *ds = [NSString stringWithFormat:@"%@",time_service_2];
        
        if ([ds isEqualToString:@"0"] ) {
            days = 0;
        }
        NSString *dasss = [NSString stringWithFormat:@"剩余<red>%d</red>天",days];
        cell.r_EndDaysLabel.attributedText = [dasss attributedStringWithStyleBook:style1];
    
    }else if (indexPath.row == 2){
        NSDateFormatter *fomart = [[NSDateFormatter alloc] init];
        fomart.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *daoqiTime = [fomart dateFromString:time_service_3Str];
        NSDate *dangqianTime = [fomart dateFromString:present_timeStr];
        
        NSTimeInterval daoqiTimeI = [daoqiTime timeIntervalSince1970];
        NSTimeInterval dangqianTimeI = [dangqianTime timeIntervalSince1970];
        NSTimeInterval cha=daoqiTimeI-dangqianTimeI;
        
        div_t d = div(cha, 86400);
        int days = d.quot;
        NSString *daystr = @"";
        if (days>=0) {
            daystr = [NSString stringWithFormat:@"剩余%d天",days];
            [cell.r_enterInBtn setHidden:NO];
        }else{
            daystr = @"剩余0天";
            [cell.r_enterInBtn setHidden:YES];
        }
        NSString *ds = [NSString stringWithFormat:@"%@",time_service_3];
        
        if ([ds isEqualToString:@"0"] ) {
            days = 0;
        }
            NSString *dasss = [NSString stringWithFormat:@"剩余<red>%d</red>天",days];
            cell.r_EndDaysLabel.attributedText = [dasss attributedStringWithStyleBook:style1];
        }
    
    
    cell.r_enterInBtn.backgroundColor = [UIColor colorFromHexRGB:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"color"]];
    [cell.r_buyBtn setTitleColor:[UIColor colorFromHexRGB:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"color"]] forState:UIControlStateNormal];
    cell.r_buyBtn.layer.borderColor=[UIColor colorFromHexRGB:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"color"]].CGColor;
    
    NSString *info = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"info"];
    CGSize strSize = GetHTextSizeFont(info, PPMainViewWidth - 120, 15);
    
    cell.r_UseInfoLabel.frame = CGRectMake(100, 50, PPMainViewWidth - 120, strSize.height);
    
    cell.r_buyBtn.frame = CGRectMake((PPMainViewWidth-120)/2+105, 65+strSize.height, (PPMainViewWidth-120)/2-5, 40);
    cell.r_enterInBtn.frame = CGRectMake(100, 65+strSize.height, (PPMainViewWidth-120)/2-10, 40);
    
    cell.allcontentView.frame = CGRectMake(0, 0, PPMainViewWidth, 65+strSize.height+40+20);
    
    cell.r_UseInfoLabel.text = info;
    cell.r_buyBtn.tag = indexPath.row+100;
    [cell.r_buyBtn addTarget:self action:@selector(rBuyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.r_enterInBtn.tag = indexPath.row+200;
    [cell.r_enterInBtn addTarget:self action:@selector(rEnterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *present_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"present_time"];
    NSNumber *time_service_1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"time_service_1"];
    NSNumber *time_service_2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"time_service_2"];
    NSNumber *time_service_3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"time_service_3"];
    
    //服务器当前时间
    double i0 = [present_time doubleValue];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *present_timeStr = [dateFormat stringFromDate:nd];
    
    //赞赏到期时间
    double i1 = [time_service_1 doubleValue];
    NSDate *nd1 = [NSDate dateWithTimeIntervalSince1970:i1];
    NSString *time_service_1Str = [dateFormat stringFromDate:nd1];
    //钻石到期时间
    double i2 = [time_service_2 doubleValue];
    NSDate *nd2 = [NSDate dateWithTimeIntervalSince1970:i2];
    NSString *time_service_2Str = [dateFormat stringFromDate:nd2];
    //黄金到期时间
    double i3 = [time_service_3 doubleValue];
    NSDate *nd3 = [NSDate dateWithTimeIntervalSince1970:i3];
    NSString *time_service_3Str = [dateFormat stringFromDate:nd3];
    
    
    if (indexPath.row == 0) {
        NSDateFormatter *fomart = [[NSDateFormatter alloc] init];
        fomart.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *daoqiTime = [fomart dateFromString:time_service_1Str];
        NSDate *dangqianTime = [fomart dateFromString:present_timeStr];
        
        NSTimeInterval daoqiTimeI = [daoqiTime timeIntervalSince1970];
        NSTimeInterval dangqianTimeI = [dangqianTime timeIntervalSince1970];
        NSTimeInterval cha=daoqiTimeI-dangqianTimeI;
        
        div_t d = div(cha, 86400);
        int days = d.quot;
        if (days>0) {
            FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
            fiemShowByTypeViewController.typeString = @"1";
            fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
        }
        
        NSString *ds = [NSString stringWithFormat:@"%@",time_service_1];
        
        if ([ds isEqualToString:@"0"] || days == 0) {
            JCCYBuyVipViewController *jCCYBuyVipViewController = [[JCCYBuyVipViewController alloc] init];
            jCCYBuyVipViewController.hidesBottomBarWhenPushed = YES;
            jCCYBuyVipViewController.buyType = 0;
            [self.navigationController pushViewController:jCCYBuyVipViewController animated:YES];
        }
        
    }else if (indexPath.row == 1){
        NSDateFormatter *fomart = [[NSDateFormatter alloc] init];
        fomart.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *daoqiTime = [fomart dateFromString:time_service_2Str];
        NSDate *dangqianTime = [fomart dateFromString:present_timeStr];
        
        NSTimeInterval daoqiTimeI = [daoqiTime timeIntervalSince1970];
        NSTimeInterval dangqianTimeI = [dangqianTime timeIntervalSince1970];
        NSTimeInterval cha=daoqiTimeI-dangqianTimeI;
        
        div_t d = div(cha, 86400);
        int days = d.quot;
        if (days>0) {
            FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
            fiemShowByTypeViewController.typeString = @"2";
            fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
        }

        NSString *ds = [NSString stringWithFormat:@"%@",time_service_2];
        
        if ([ds isEqualToString:@"0"] || days == 0) {
            JCCYBuyVipViewController *jCCYBuyVipViewController = [[JCCYBuyVipViewController alloc] init];
            jCCYBuyVipViewController.hidesBottomBarWhenPushed = YES;
            jCCYBuyVipViewController.buyType = 1;
            [self.navigationController pushViewController:jCCYBuyVipViewController animated:YES];        }
        
    }else if (indexPath.row == 2){
        NSDateFormatter *fomart = [[NSDateFormatter alloc] init];
        fomart.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *daoqiTime = [fomart dateFromString:time_service_3Str];
        NSDate *dangqianTime = [fomart dateFromString:present_timeStr];
        
        NSTimeInterval daoqiTimeI = [daoqiTime timeIntervalSince1970];
        NSTimeInterval dangqianTimeI = [dangqianTime timeIntervalSince1970];
        NSTimeInterval cha=daoqiTimeI-dangqianTimeI;
        
        div_t d = div(cha, 86400);
        int days = d.quot;
        if (days>0) {
            FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
            fiemShowByTypeViewController.typeString = @"3";
            fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
        }
        NSString *ds = [NSString stringWithFormat:@"%@",time_service_3];
        
        if ([ds isEqualToString:@"0"] || days == 0) {
            JCCYBuyVipViewController *jCCYBuyVipViewController = [[JCCYBuyVipViewController alloc] init];
            jCCYBuyVipViewController.hidesBottomBarWhenPushed = YES;
            jCCYBuyVipViewController.buyType = 2;
            [self.navigationController pushViewController:jCCYBuyVipViewController animated:YES];        }
    }
}


//点击购买
-(void)rBuyBtnAction:(UIButton *)btn{
    
    JCCYBuyVipViewController *jCCYBuyVipViewController = [[JCCYBuyVipViewController alloc] init];
    jCCYBuyVipViewController.hidesBottomBarWhenPushed = YES;
    jCCYBuyVipViewController.buyType = btn.tag - 100;
    [self.navigationController pushViewController:jCCYBuyVipViewController animated:YES];
}

//点击进入
-(void)rEnterBtnAction:(UIButton *)btn{
    if (btn.tag == 200) {
        FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
        fiemShowByTypeViewController.typeString = @"1";
        fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];

    }else if (btn.tag == 201){
        FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
        fiemShowByTypeViewController.typeString = @"2";
        fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
    }else if (btn.tag == 202){
        FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
        fiemShowByTypeViewController.typeString = @"3";
        fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
    }
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
