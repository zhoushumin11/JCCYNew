//
//  OneViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import "HomeViewController.h"
#import "NJBannerView.h"

//绑定手机号
#import "PPRegistViewController.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *user_info_btn; //用户信息button

@property(nonatomic,strong) NSMutableArray *dataArray;//表数据
@property(nonatomic,strong) NSMutableArray *scrollNewsArray;//滚动数据
//主表视图
@property(nonatomic,strong) UITableView *mainTableView;

@property (nonatomic, strong) NJBannerView *adBannerView;//广告滚动页


@end

@implementation HomeViewController

@synthesize user_info_btn,mainTableView,dataArray,scrollNewsArray,adBannerView;


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
    user_info_btn.frame = CGRectMake(0, 0, 150, 44);
    user_info_btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [user_info_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [user_info_btn setTitle:@"" forState:UIControlStateNormal];
    [user_info_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    user_info_btn.imageEdgeInsets = UIEdgeInsetsMake(5,50,5,13);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素

    [user_info_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [user_info_btn addTarget:self action:@selector(userInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn = [[UIBarButtonItem alloc] initWithCustomView:user_info_btn];
    self.navigationItem.leftBarButtonItem = leftbarbtn;
    
    //创建主视图
    [self creatMainView];
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
    
    bannerV.titles = titleList;
    bannerV.datas = currentDatas;
    
    __weak HomeViewController *weakSelf = self;
    bannerV.linkAction = ^(NSDictionary *linkDict)
    {
        [weakSelf endterNewsPage:linkDict];
    };
    mainTableView.tableHeaderView = bannerV;
    adBannerView = bannerV;
    
    if ([mainTableView.mj_header isRefreshing]) {
        [mainTableView.mj_header endRefreshing];
    }
    
}

//滚动新闻点击事件
-(void)endterNewsPage:(NSDictionary *)dic{
    
}

-(void)initMyView{
    [user_info_btn setTitle:@"王小小" forState:UIControlStateNormal];
    [user_info_btn setImage:[UIImage imageNamed:@"redPack_bar@2x"] forState:UIControlStateNormal];//给button添加image
}
//创建主视图
-(void)creatMainView{
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth,self.view.bounds.size.height-64-44) style:UITableViewStylePlain];
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

}

//获取首页广告数据
-(void)getAdData{
    @autoreleasepool {
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
                              //创建广告图
                              [self creatScrollNews:scrollNewsArray];
                              
                          }else{
                              //异常处理
                          }
                          
                      } failedBlock:^(NSError *error) {
                          
                      }];
        }
    }
}
//跳入用户详情页
-(void)userInfoBtnAction{
    
}

//下拉刷新
-(void)refreshTableView{
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
    
    static NSString *identify = @"PPBulletinCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
        
    }
    
//    cell.bulletinTitleLabel.text = titleStr;
//    //        cell.bulletinTimeLabel.text = createTime;
//    NSString *sender = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"noticeAuthor"];
//    cell.bulletinSenderLabel.text = [NSString stringWithFormat:@"%@     %@",sender,createTime];
//    
//    cell.bulletinDetailLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"noticeTitle"];
//    cell.bulletinTypeLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"columnName"];;
//    
//    NSString *imageUrl = nil;
//    
//    NSString *noticeId = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"noticeId"];
//    
//    imageUrl = [[NSString stringWithFormat:@"%@storage/getObject?sourceQc={\"search\":{\"EQ_BIZ_FORM_ID\":\"%@\", \"ORDER_CREATE_TIME\":\"DESC\",\"EQ_BIZ_FORM_KEY\":\"noticeImg\"}}",[PPAPPDataClass sharedappData].severUrl,noticeId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [cell.bulletinimgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"pp_gg_img"] options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
    return cell;
    //    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
