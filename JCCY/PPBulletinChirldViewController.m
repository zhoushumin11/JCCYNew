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

@interface PPBulletinChirldViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NJBannerView *adBannerView;//广告滚动页
@property (nonatomic,strong) UIView *mainTableViewHeaderView; //表头视图

@end



@implementation PPBulletinChirldViewController
@synthesize waitLabel;
@synthesize dataArray,scrollNewsArray,adBannerView,mainTableViewHeaderView;


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
    _bulletinlistTableView.mj_footer.hidden = YES;
    
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
    scrollNewsArray = list;
    
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
                                @"ad_type":ad_type,
                                @"index":[NSString stringWithFormat:@"%d",i]
                                };
        [currentDatas addObject:newsa];
        [titleList addObject:ad_title];
        
    }
    NJBannerView *bannerV = [[NJBannerView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewWidth*0.52)];
    
    bannerV.titles = titleList;
    bannerV.datas = currentDatas;
    
    adBannerView = bannerV;
    
    mainTableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewWidth*0.52)];
    mainTableViewHeaderView.backgroundColor = [UIColor colorFromHexRGB:@"f4f4f4"];
    
    [mainTableViewHeaderView addSubview:adBannerView];
    
    _bulletinlistTableView.tableHeaderView = mainTableViewHeaderView;
    
    
    __weak PPBulletinChirldViewController *weakSelf = self;
    bannerV.linkAction = ^(NSDictionary *linkDict)
    {
        [weakSelf endterNewsPage:linkDict];
    };
    
    if ([_bulletinlistTableView.mj_header isRefreshing]) {
        [_bulletinlistTableView.mj_header endRefreshing];
    }
    
}
//滚动新闻点击事件
-(void)endterNewsPage:(NSDictionary *)dic{
    
    int i = [[dic objectForKey:@"index"] intValue];
    
    NSString *titleStr = [[scrollNewsArray objectAtIndex:i] objectForKey:@"title"];
    
//    PPBulletinDetailViewController *pPBulletinDetailViewController = [[PPBulletinDetailViewController alloc] init];
//    pPBulletinDetailViewController.hidesBottomBarWhenPushed = YES;
//    pPBulletinDetailViewController.documentPath = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
//    pPBulletinDetailViewController.titleStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//    [self.navigationController pushViewController:pPBulletinDetailViewController animated:YES];
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
    
    NSString *titleStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *aStr = @"【";
    NSString *bStr = @"】";
    NSString *columnStr = [[self.columnArray objectAtIndex:self.nowIndex] objectForKey:@"typename"];
    
    NSString *columnSSS = [[aStr stringByAppendingString:columnStr] stringByAppendingString:bStr];
    
    titleStr = [NSString stringWithFormat:@"%@%@",columnSSS,titleStr];
    cell.h_titleLabel.text = titleStr;
    cell.h_subtitleLabel.text = @"梧桐证券";
    
    NSNumber *num = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    double i = [num doubleValue]/1000;
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:i];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm"];
    NSString *timeStr = [dateFormat stringFromDate:nd];
    
    cell.h_timeLabel.text = timeStr;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PPBulletinDetailViewController *pPBulletinDetailViewController = [[PPBulletinDetailViewController alloc] init];
    pPBulletinDetailViewController.hidesBottomBarWhenPushed = YES;
    pPBulletinDetailViewController.documentPath = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    pPBulletinDetailViewController.titleStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    [self.navigationController pushViewController:pPBulletinDetailViewController animated:YES];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end