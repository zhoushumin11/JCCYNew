//
//  OneViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import "HomeViewController.h"
#import "NJBannerView.h"
#import "TAPageControl.h"
//绑定手机号
#import "PPRegistViewController.h"

//UITableViewCell
#import "HomeFirstCell.h"
#import "HomeNormalCell.h"

#import "UIImageView+WebCache.h"

//咨询中心
#import "PPBulletinViewController.h"

//资讯详情
#import "PPBulletinDetailViewController.h"

//用户资料
#import "JCCYMyListViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *user_info_btn; //用户信息button
@property (nonatomic, strong) UIButton *user_info_Level; //用户等级

@property(nonatomic,strong) NSMutableArray *dataArray;//表数据
@property(nonatomic,strong) NSMutableArray *scrollNewsArray;//滚动数据
//主表视图
@property(nonatomic,strong) UITableView *mainTableView;

@property (nonatomic, strong) NJBannerView *adBannerView;//广告滚动页

@property (nonatomic,strong) UIView *mainTableViewHeaderView; //表头视图


@end

@implementation HomeViewController

@synthesize user_info_btn,mainTableView,dataArray,scrollNewsArray,adBannerView,user_info_Level,mainTableViewHeaderView;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //刷新我的信息
    [self initMyView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"首页";
    
    
    
    //检查是否绑定手机号了
    BOOL isBangding = [[NSUserDefaults standardUserDefaults] objectForKey:@"isBangding"];
    if (!isBangding) {
        PPRegistViewController *pPRegistViewController = [[PPRegistViewController alloc] init];
        pPRegistViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pPRegistViewController animated:YES];
        
    }
    
    //初始化tableView的数据
    dataArray = [NSMutableArray array];
    scrollNewsArray = [NSMutableArray array];
    
    //初始化用户button
    user_info_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    user_info_btn.frame = CGRectMake(-10, 0, 80, 44);
    user_info_btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [user_info_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [user_info_btn setTitle:@"" forState:UIControlStateNormal];
    [user_info_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [user_info_btn addTarget:self action:@selector(userInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化用户等级button
    user_info_Level = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    
    //创建主视图
    [self creatMainView];
}
#pragma mark - 创建没有广告的首页头视图
-(void)creatOnlyBtnHeaderView{
    mainTableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 134)];
    
    UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, PPMainViewWidth*0.52, PPMainViewWidth, 80)];
    NSArray *buttonTitleArr = [NSArray arrayWithObjects:@"实盘",@"赞赏",@"钻石",@"黄金", nil];
    NSArray *buttonImgArr = [NSArray arrayWithObjects:@"shipan_home_btn",@"zanshang_home_btn",@"zuanshi_home_btn",@"huangjin_home_btn", nil];
    
    float ww = PPMainViewWidth/4 ;
    
    for (int i = 0; i<buttonTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*ww, 0, ww, ww);
        //        [btn setBackgroundImage:[UIImage imageNamed:buttonImgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:buttonImgArr[i]] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.tag = 2016+i;
        [btn addTarget:self action:@selector(homeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ww-30, ww, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = buttonTitleArr[i];
        [btn addSubview:label];
        [btnsView addSubview:btn];
    }
    
    //添加资讯消息按钮
    UIView *zixunMsgView = [[UIView alloc] initWithFrame:CGRectMake(0,ww +10, PPMainViewWidth, 44)];
    zixunMsgView.backgroundColor = [UIColor whiteColor];

    UIImageView *imgVc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 40, 40)];
    imgVc.image = [UIImage imageNamed:@"zixun_home.png"];
    [zixunMsgView addSubview:imgVc];
    
    UILabel *goLabel = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth - 40,0,40,44)];
    goLabel.text = @">";
    goLabel.textColor = [UIColor grayColor];
    goLabel.textAlignment = NSTextAlignmentCenter;
    [zixunMsgView addSubview:goLabel];
    
    //资讯信息label
    UILabel *zixunTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44,0,80,44)];
    zixunTitleLabel.text = @"资讯消息";
    zixunTitleLabel.textColor = [UIColor grayColor];
    [zixunMsgView addSubview:zixunTitleLabel];
    
    UIButton *zixunBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zixunBtn.frame = CGRectMake(0, 0, PPMainViewWidth, 44);
    [zixunBtn addTarget:self action:@selector(zixunBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [zixunBtn setBackgroundColor:[UIColor clearColor]];
    [zixunMsgView addSubview:zixunBtn];
    [mainTableViewHeaderView addSubview:btnsView];
    [mainTableViewHeaderView addSubview:zixunMsgView];
    mainTableView.tableHeaderView = mainTableViewHeaderView;
    
    
    
}
#pragma mark - 首页新闻滚动图
- (void)creatScrollNews:(NSMutableArray *)list
{
    if (self.adBannerView) {
        [self.adBannerView removeFromSuperview];
        self.adBannerView = nil;
    }
    
    NSMutableArray *currentDatas = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < [list count]; i++) {
        
        NSDictionary *newsdict = [list objectAtIndex:i];
        
        
        NSString *ad_pic = [newsdict objectForKey:@"ad_pic"];
        NSString *ad_category = [newsdict objectForKey:@"ad_category"];
        NSString *ad_id = [newsdict objectForKey:@"ad_id"];
        NSString *ad_parameter = [newsdict objectForKey:@"ad_parameter"];
        NSString *ad_title = [newsdict objectForKey:@"ad_title"];
        NSString *ad_type = [newsdict objectForKey:@"ad_type"];
//        NSString *time = [[newsdict objectForKey:@"time"] stringValue];
        
        NSDictionary *newsa = @{@"img":ad_pic,
                                @"ad_category":ad_category,
                                @"ad_id":ad_id,
                                @"ad_parameter":ad_parameter,
                                @"ad_title":ad_title,
                                @"ad_type":ad_type
                                };
        [currentDatas addObject:newsa];
        [titleList addObject:ad_title];
        
    }
    NJBannerView *bannerV = [[NJBannerView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewWidth*0.52)];
    
    bannerV.titles = nil;
    bannerV.datas = currentDatas;
    
    adBannerView = bannerV;
    
    UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, PPMainViewWidth*0.52, PPMainViewWidth, 80)];
    NSArray *buttonTitleArr = [NSArray arrayWithObjects:@"实盘",@"赞赏",@"钻石",@"黄金", nil];
    NSArray *buttonImgArr = [NSArray arrayWithObjects:@"shipan_home_btn",@"zanshang_home_btn",@"zuanshi_home_btn",@"huangjin_home_btn", nil];
    
    float ww = PPMainViewWidth/4 ;
    
    for (int i = 0; i<buttonTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*ww, 0, ww, ww);
//        [btn setBackgroundImage:[UIImage imageNamed:buttonImgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:buttonImgArr[i]] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.tag = 2016+i;
        [btn addTarget:self action:@selector(homeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ww-30, ww, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = buttonTitleArr[i];
        [btn addSubview:label];
        [btnsView addSubview:btn];
    }
    
    //添加资讯消息按钮
    UIView *zixunMsgView = [[UIView alloc] initWithFrame:CGRectMake(0,PPMainViewWidth*0.52+ww+10 , PPMainViewWidth, 44)];
    zixunMsgView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgVc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    imgVc.image = [UIImage imageNamed:@"zixun_home.png"];
    [zixunMsgView addSubview:imgVc];
    
    //>label
    UILabel *goLabel = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth - 40,0,40,44)];
    goLabel.text = @">";
    goLabel.textColor = [UIColor grayColor];
    goLabel.textAlignment = NSTextAlignmentCenter;
    [zixunMsgView addSubview:goLabel];
    
    //资讯信息label
    UILabel *zixunTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44,0,80,44)];
    zixunTitleLabel.text = @"资讯消息";
    zixunTitleLabel.textColor = [UIColor grayColor];
    [zixunMsgView addSubview:zixunTitleLabel];
    
    UIButton *zixunBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zixunBtn.frame = CGRectMake(0, 0, PPMainViewWidth, 44);
    [zixunBtn addTarget:self action:@selector(zixunBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [zixunBtn setBackgroundColor:[UIColor clearColor]];
    [zixunMsgView addSubview:zixunBtn];
    
    
    mainTableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewWidth*0.52 + ww+10+44)];
    mainTableViewHeaderView.backgroundColor = [UIColor colorFromHexRGB:@"f4f4f4"];
    
    [mainTableViewHeaderView addSubview:btnsView];
    [mainTableViewHeaderView addSubview:adBannerView];
    [mainTableViewHeaderView addSubview:zixunMsgView];

    mainTableView.tableHeaderView = mainTableViewHeaderView;
    
    
    __weak HomeViewController *weakSelf = self;
    bannerV.linkAction = ^(NSDictionary *linkDict)
    {
        [weakSelf endterNewsPage:linkDict];
    };
    
    if ([mainTableView.mj_header isRefreshing]) {
        [mainTableView.mj_header endRefreshing];
    }
    
}

//资讯消息栏点击事件
-(void)zixunBtnAction{
    PPBulletinViewController *jCCYNewsMainViewController = [[PPBulletinViewController alloc] init];
    jCCYNewsMainViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jCCYNewsMainViewController animated:YES];
}

//首页button响应事假
-(void)homeBtnAction:(UIButton *)btn{
    if (btn.tag == 2016) {//实盘
        
    }else if (btn.tag == 2017){//赞赏
        
    }else if (btn.tag == 2018){//钻石
        
    }else if (btn.tag == 2019){//黄金
        
    }
}

//滚动新闻点击事件
-(void)endterNewsPage:(NSDictionary *)dic{
    
}

-(void)initMyView{
    
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
//创建主视图
-(void)creatMainView{
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
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
    
    mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreTableView)];
    mainTableView.mj_footer.hidden = YES;
    
    mainTableView.mj_header = cmheader;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
    
    
    
    //获取首页广告数据
    [self getAdData];
    //获取列表数据
    [self getTableListData];

}

//获取首页新闻数据
-(void)getTableListData{
        NSString *dJson = nil;
        @autoreleasepool {
            
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            
            dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"arctype_id\":\"%d\",\"page\":\"%d\"}",87,token,0,1];
            //获取类型接
            PPRDData *pprddata1 = [[PPRDData alloc] init];
            [pprddata1 startAFRequest:@"/index.php/Api/Archives/index/"
                          requestdata:dJson
                       timeOutSeconds:10
                      completionBlock:^(NSDictionary *json) {
                          
//                          {
//                              "arctype_id" = 4;
//                              id = 44;
//                              "is_delete" = 0;
//                              "is_effect" = 1;
//                              level = 0;
//                              pic = "http://wutong.jingchengidea.com/upload/other/image/20161108147859526112.jpg";
//                              pubdate = "2016-11-08";
//                              sort = 50;
//                              time = 1478595250;
//                              title = "\U8bc1\U5238\U4fdd\U8bc1\U91d1\U4e0a\U5468\U51c0\U8f6c\U516561\U4ebf\U5143 \U8fde\U7eed\U4e24\U5468\U51c0\U8f6c\U5165";
//                              url = "http://wutong.jingchengidea.com/index.php?m=Api&c=ArchivesIndex&a=view&a_id=44";
//                          }
                          
                          NSInteger code = [[json objectForKey:@"code"] integerValue];
                          if (code == 1) {
                              NSDictionary *dataDic = [json objectForKey:@"data"];
                              NSArray *listArr = [dataDic objectForKey:@"list"];
                              dataArray = [NSMutableArray arrayWithArray:listArr];
                              if (dataArray.count>0) {
                                  //刷新列表
                                  [mainTableView reloadData];
                                  
                              }else{

                              }
                              
                              
                          }else{
                              //异常处理
                          }
                          
                      } failedBlock:^(NSError *error) {
                          
                      }];
        }
}


//获取首页广告数据
-(void)getAdData{
        NSString *dJson = nil;
        @autoreleasepool {
            
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            
            dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"ad_category\":\"%d\"}",87,token,1];
            //获取类型接口
            PPRDData *pprddata1 = [[PPRDData alloc] init];
            [pprddata1 startAFRequest:@"/index.php/Api/AdImages/index/"
                          requestdata:dJson
                       timeOutSeconds:10
                      completionBlock:^(NSDictionary *json) {
                          
                          NSInteger code = [[json objectForKey:@"code"] integerValue];
                          if (code == 1) {
                              NSArray *dataArr = [json objectForKey:@"data"];
                              scrollNewsArray = [NSMutableArray arrayWithArray:dataArr];
                              if (scrollNewsArray.count>0) {
                                  //创建广告图
                                  [self creatScrollNews:scrollNewsArray];
                              }else{
                                  //如果没有广告 直接创建4个按钮
                                  [self creatOnlyBtnHeaderView];
                              }

                              
                          }else{
                              //异常处理
                          }
                          
                      } failedBlock:^(NSError *error) {
                          
                      }];
        }
}




#pragma mark ---跳入用户详情页 -----
-(void)userInfoBtnAction{
    JCCYMyListViewController  *jCCYMyListViewController = [[JCCYMyListViewController alloc] init];
    jCCYMyListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jCCYMyListViewController animated:YES];
}

//下拉刷新
-(void)refreshTableView{
    //获取首页广告数据
    [self getAdData];
    //获取列表数据
    [self getTableListData];
    if ([mainTableView.mj_header isRefreshing]) {
        [mainTableView.mj_header endRefreshing];
    }
}

//上拉加载更多
-(void)refreshMoreTableView{
    
}

#pragma mark --- UITableViewDelegate -----

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        HomeFirstCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[HomeFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"];
        }
        
        NSString *imageUrl = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
        
        [cell.h_imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
        }];
        
        cell.h_titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        return cell;
        
    }else{
        static NSString *identify = @"PPBulletinCell";
        HomeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[HomeNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
            
        }
        cell.h_titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        return cell;
    }
    

    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int level = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"level"] intValue];
    
    NSInteger user_level = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] intValue];
    
    if (user_level > level || user_level == level ) {
        PPBulletinDetailViewController *pPBulletinDetailViewController = [[PPBulletinDetailViewController alloc] init];
        pPBulletinDetailViewController.hidesBottomBarWhenPushed = YES;
        pPBulletinDetailViewController.documentPath = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
        pPBulletinDetailViewController.titleStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:pPBulletinDetailViewController animated:YES];
    }else{
        [WSProgressHUD showWithStatus:@"权限不足" maskType:WSProgressHUDMaskTypeDefault];
        [WSProgressHUD autoDismiss:1];
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
