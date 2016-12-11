//
//  PPBulletinChirldViewController.m
//  ParkProject
//
//  Created by 周书敏 on 16/8/9.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPBulletinChirldViewController.h"
#import "UIImageView+WebCache.h"
#import "PPBulletinDetailViewController.h"
#import "NJBannerView.h"
#import "TAPageControl.h"

#import "JCCYZiXunTableViewCell.h"

#import "FiemShowByTypeViewController.h"
#import "JCCYChongZhiViewController.h"

#import "RedPacketViewController.h"
#import "PPNavigationController.h"

#import "SDCycleScrollView.h"

@interface PPBulletinChirldViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *adBannerView;//广告滚动页
@property (nonatomic,strong) UIView *mainTableViewHeaderView; //表头视图
@property (nonatomic,strong) NSMutableArray *bannerDataArray;

@end



@implementation PPBulletinChirldViewController
@synthesize waitLabel;
@synthesize dataArray,scrollNewsArray,adBannerView,mainTableViewHeaderView,bannerDataArray;


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
    _bulletinlistTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth,self.view.bounds.size.height-64-44) style:UITableViewStylePlain];
    _bulletinlistTableView.backgroundColor = [UIColor clearColor];
    _bulletinlistTableView.separatorInset = UIEdgeInsetsZero;
    //        _bulletinlistTableView.tableHeaderView = [[UIView alloc] init];
    if ([_bulletinlistTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_bulletinlistTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_bulletinlistTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_bulletinlistTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _bulletinlistTableView.separatorColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    MJRefreshNormalHeader *cmheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];//@selector(loadMylogList)
    cmheader.lastUpdatedTimeLabel.hidden = YES;
    
    _bulletinlistTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreTableView)];
    _bulletinlistTableView.mj_footer.hidden = NO;
    
    _bulletinlistTableView.mj_header = cmheader;
    _bulletinlistTableView.delegate = self;
    _bulletinlistTableView.dataSource = self;
    
    [self.view addSubview:_bulletinlistTableView];
    
    self.waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 50)];
    waitLabel.textColor = [UIColor colorFromHexRGB:@"929292"];
    waitLabel.font = SystemFont(17);
    waitLabel.text = @"暂无数据";
    waitLabel.textAlignment = NSTextAlignmentCenter;
    waitLabel.center = CGPointMake(PPMainViewWidth/2, PPMainViewHeight/2-64-44);
    waitLabel.hidden = YES;
    [self.view addSubview:waitLabel];
    
}

#pragma mark - 首页新闻滚动图
- (void)creatScrollNews:(NSMutableArray *)list
{
    if (self.adBannerView) {
        [self.adBannerView removeFromSuperview];
        self.adBannerView = nil;
    }
    
    scrollNewsArray = [NSMutableArray array];
    bannerDataArray = [NSMutableArray array];
    scrollNewsArray = list;
    
    NSMutableArray *currentDatas = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *imgList = [NSMutableArray arrayWithCapacity:0];
    
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
        [imgList addObject:ad_pic];
        
    }
    
    bannerDataArray = currentDatas;
    SDCycleScrollView *bannerV = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewWidth*0.52)];
    bannerV.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    bannerV.titlesGroup = titleList;
    bannerV.imageURLStringsGroup = imgList;
    bannerV.autoScrollTimeInterval = 3.0;
    bannerV.delegate = self;
    
    adBannerView = bannerV;
    
    mainTableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewWidth*0.52)];
    mainTableViewHeaderView.backgroundColor = [UIColor colorFromHexRGB:@"f4f4f4"];
    
    [mainTableViewHeaderView addSubview:adBannerView];
    
    _bulletinlistTableView.tableHeaderView = mainTableViewHeaderView;
    
    
//    __weak PPBulletinChirldViewController *weakSelf = self;
//    bannerV.linkAction = ^(NSDictionary *linkDict)
//    {
//        [weakSelf endterNewsPage:linkDict];
//    };
    
    if ([_bulletinlistTableView.mj_header isRefreshing]) {
        [_bulletinlistTableView.mj_header endRefreshing];
    }
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (bannerDataArray.count-1<index) {
        return;
    }
    NSDictionary *dic = [bannerDataArray objectAtIndex:index];
    [self endterNewsPage:dic];
    
}


//滚动新闻点击事件
-(void)endterNewsPage:(NSDictionary *)dic{
    
    NSInteger ad_type = [[dic objectForKey:@"ad_type"] integerValue];
    if (ad_type == 0) {//0为网页外链 ad_parameter为网址
        NSString *ad_parameter = [dic objectForKey:@"ad_parameter"];
        PPBulletinDetailViewController *pPBulletinDetailViewController = [[PPBulletinDetailViewController alloc] init];
        pPBulletinDetailViewController.hidesBottomBarWhenPushed = YES;
        pPBulletinDetailViewController.documentPath = ad_parameter;
        pPBulletinDetailViewController.titleStr = [dic objectForKey:@"ad_title"];
        [self.navigationController pushViewController:pPBulletinDetailViewController animated:YES];
    }else if (ad_type == 1){//1为文章栏目ad_parameter为栏目id
        NSString *ad_parameter = [dic objectForKey:@"ad_parameter"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZixunxiaoxiById" object:ad_parameter];
        
    }else if (ad_type == 2){//为直播间ad_parameter为直播间类别0免费1赞赏2钻石 3黄金
        NSString *ad_parameter = [dic objectForKey:@"ad_parameter"];
        if ([ad_parameter isEqualToString:@"0"]) {
            FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
            fiemShowByTypeViewController.typeString = @"0";
            fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];        }else if ([ad_parameter isEqualToString:@"1"]){
            FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
            fiemShowByTypeViewController.typeString = @"1";
            fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
        }else if ([ad_parameter isEqualToString:@"2"]){
            FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
            fiemShowByTypeViewController.typeString = @"2";
            fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
        }else if ([ad_parameter isEqualToString:@"3"]){
            FiemShowByTypeViewController *fiemShowByTypeViewController = [[FiemShowByTypeViewController alloc] init];
            fiemShowByTypeViewController.typeString = @"3";
            fiemShowByTypeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fiemShowByTypeViewController animated:YES];
        }
        
    }else if (ad_type == 3){//为金币充值页面
        JCCYChongZhiViewController *jCCYChongZhiViewController = [[JCCYChongZhiViewController alloc] init];
        jCCYChongZhiViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jCCYChongZhiViewController animated:YES];
    }else if (ad_type == 4){//为购买红包里盘页面
        RedPacketViewController *plusVC = [[RedPacketViewController alloc] init];
        PPNavigationController *navVc = [[PPNavigationController alloc] initWithRootViewController:plusVC];
        [self presentViewController:navVc animated:YES completion:nil];    }
}



-(void)refreshTableView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableViewData" object:nil];
}

-(void)refreshMoreTableView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMoreTableViewData" object:nil];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
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
    
    static NSString *identify = @"JCCYZiXunTableViewCell";
    JCCYZiXunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[JCCYZiXunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
        
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILabel *linelabels = [[UILabel alloc] initWithFrame:CGRectMake(10, 69.5, PPMainViewWidth - 20, 0.5)];
    linelabels.backgroundColor = [UIColor colorFromHexRGB:@"d9d9d9"];
    [cell addSubview:linelabels];
    
    waitLabel.hidden = YES;
    
    NSString *titleStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *aStr = @"【";
    NSString *bStr = @"】";
    NSString *columnStr = [[self.columnArray objectAtIndex:self.nowIndex] objectForKey:@"typename"];
    
    NSString *columnSSS = [[aStr stringByAppendingString:columnStr] stringByAppendingString:bStr];
    
    titleStr = [NSString stringWithFormat:@"%@%@",columnSSS,titleStr];
    cell.h_titleLabel.text = titleStr;
    
    NSString *dateStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"pubdate"];
    
    cell.h_subtitleLabel.text = dateStr;
    
    int levels = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"level"] intValue];
    NSString *levelStr = @"";
    if (levels == 0) {
        cell.h_quanxianLabel.text = levelStr;
    }else{
        levelStr = [NSString stringWithFormat:@"%d",levels];
        levelStr = [@"LV." stringByAppendingString:levelStr];
        cell.h_quanxianLabel.text = levelStr;
    }
    
//    NSNumber *num = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"];
//    double i = [num doubleValue]/1000;
//    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"hh:mm"];
//    NSString *timeStr = [dateFormat stringFromDate:nd];
    
//    cell.h_timeLabel.text = timeStr;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
        [ALToastView toastInView:self.view withText:@"您的权限不足无法阅读"];
    }
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
