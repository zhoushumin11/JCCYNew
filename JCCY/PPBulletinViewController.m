//
//  PPBulletinViewController.m
//  ParkProject
//
//  Created by yuanxuan on 16/6/27.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPBulletinViewController.h"
#import "PPYXMainViewController.h"

#import "HomeNormalCell.h"
#import "PPBulletinDetailViewController.h"
#import "PPBulletinChirldViewController.h"

#import "UIImageView+WebCache.h"



@interface PPBulletinViewController (){
    NSInteger vcindex;
    BOOL isRefresh;//是否刷新过
}
@property(nonatomic,strong) NSMutableArray *arrayvcs;

@property(nonatomic,strong) NSMutableArray *columnArray;//栏目数据
@property(nonatomic,strong) NSMutableArray *dataArray;//表数据
@property(nonatomic,strong) NSMutableArray *chirldViewArray;//子视图数据
@property(nonatomic,strong) NSMutableArray *scrollNewsArray;//滚动数据

@property(nonatomic,strong) NSMutableArray *didLoadViewArray;//加载过了的栏目id数组


@property(nonatomic,strong) PPYXMainViewController *tabBarVC;


@property(nonatomic,strong) PPBulletinChirldViewController *pPBulletinChirldViewController;
@end

@implementation PPBulletinViewController

@synthesize dataArray,columnArray,tabBarVC,chirldViewArray,pPBulletinChirldViewController,didLoadViewArray,scrollNewsArray;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.clipsToBounds = NO;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"5f97f6"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIndex:) name:@"YXMainViewControllerAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIndexing:) name:@"YXMainViewControllerActioning" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewData) name:@"refreshTableViewData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoreTableViewData) name:@"refreshMoreTableViewData" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshZixunxiaoxiById:) name:@"refreshZixunxiaoxiById" object:nil];

    self.title = @"资讯消息";
    //数据初始化
    vcindex = 0;
    dataArray = [NSMutableArray array];
    columnArray = [NSMutableArray array];
    chirldViewArray = [NSMutableArray array];
    didLoadViewArray = [NSMutableArray array];
    scrollNewsArray = [NSMutableArray array];

    //接口获取栏目
    [self getonlineSliderData];
    //还没刷新
    isRefresh = NO;
    
    //刷新广告
    [self getAdData];
    
}

#pragma mark-- 通过id 刷新视图 --- 
-(void)refreshZixunxiaoxiById:(NSNotification *)obj{
    NSString *ad_parameter = [obj object];
    self.colunmId_index = ad_parameter;
    [self getonlineSliderData];
}

#pragma mark ---- 获取首页广告数据---
-(void)getAdData{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"ad_category\":\"%d\"}",updata_id,token,2];
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
                          
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else{
                          //异常处理
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}





-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [WSProgressHUD dismiss];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

//正在滑动
-(void)changeIndexing:(NSNotification *)obj{
    
    
}

#pragma mark -----滑动页面返回的当前页面号---
-(void)changeIndex:(NSNotification *)obj{
    
    NSInteger index = [[[obj object] objectForKey:@"index"] integerValue];
    
    NSString *columnIdstring = [[columnArray objectAtIndex:index] objectForKey:@"typeid"];

    //是否加载过当前界面
    BOOL isload = [didLoadViewArray containsObject: columnIdstring];
    if (isload) {
        vcindex = index;
        return;
    }else{
        if (index == vcindex) {
            return;
        }
        vcindex = index;
        
        NSString *columnIdstring = [[columnArray objectAtIndex:vcindex] objectForKey:@"typeid"];
        [self getonlineData:columnIdstring];
        [didLoadViewArray addObject:columnIdstring];
        
    }


}


#pragma mark - onlineList 获取栏目数据
- (void)getonlineSliderData
{
    NSString *dJson = nil;
    @autoreleasepool {
        [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeDefault];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"arctype_id\":\"%d\",\"page\":\"%d\"}",updata_id,token,0,1];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_arctype/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }
                      
                      NSMutableArray *vcArray = [NSMutableArray array];

                      NSArray *dateArray = [json objectForKey:@"data"];
                      
                      if (dateArray.count == 0) {
                          [WSProgressHUD dismiss];
                          //没有数据时设置错误状态图
                          UIImageView *backimage = [[UIImageView alloc] initWithFrame:CGRectMake(0,-64, PPMainViewWidth, PPMainViewHeight)];
                          backimage.image = [UIImage imageNamed:@"BulletinDefault.png"];
                          [self.view addSubview:backimage];
                          return ;
                      }
                      
                      //如果传了id 就要排序
                      if ([self.colunmId_index isEqualToString:@""] || self.colunmId_index == nil) {
                          columnArray = [NSMutableArray arrayWithArray:dateArray];

                      }else{
                          NSMutableArray *data_paixu = [NSMutableArray arrayWithArray:dateArray];
                          for (int j = 0; j<data_paixu.count; j++) {
                              NSString *typeid = [[data_paixu objectAtIndex:j] objectForKey:@"typeid"];
                              NSDictionary *fisrtDic = [data_paixu objectAtIndex:j];
                              if ([typeid isEqualToString:self.colunmId_index]) {
                                  [data_paixu removeObjectAtIndex:j];
                                  [data_paixu insertObject:fisrtDic atIndex:0];
                              }
                          }
                          columnArray = [NSMutableArray arrayWithArray:data_paixu];
                      }
   
 
                      for (int i = 0; i<columnArray.count; i++) {
                          pPBulletinChirldViewController = [[PPBulletinChirldViewController alloc] init];
                          pPBulletinChirldViewController.title = [[columnArray objectAtIndex:i] objectForKey:@"typename"];
                          [vcArray addObject:pPBulletinChirldViewController];
                      }
                      
                      chirldViewArray = vcArray;
                      
                      if (tabBarVC.view) {
                          [tabBarVC.view removeFromSuperview];
                      }
                      
                      tabBarVC = [[PPYXMainViewController alloc]initWithSubViewControllers:vcArray];
                      
                      tabBarVC.view.frame = CGRectMake(0, 0, PPMainViewWidth, PPMainViewHeight );
                      [self.view addSubview:tabBarVC.view];
                      [self addChildViewController:tabBarVC];
                      
                      
                      
                      //刷新第0个视图
                      NSString *columnIdstring = [[columnArray objectAtIndex:vcindex] objectForKey:@"typeid"];
                      [self getonlineData:columnIdstring];
                      
                      
                  }
                      failedBlock:^(NSError *error) {
                          [WSProgressHUD dismiss];
                      }];
    }
}

#pragma mark ---- 下拉刷新---
-(void)refreshTableViewData{
    //刷新广告
    [self getAdData];
    NSString *columnIDStr = [[columnArray objectAtIndex:vcindex] objectForKey:@"typeid"];
    [self getonlineData:columnIDStr];
}

- (void)getonlineData:(NSString *)columnIDStr //根据当前选择的类型刷新相关类型
{
    NSString *dJson = nil;
    @autoreleasepool {
        [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeDefault];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"arctype_id\":\"%d\",\"page\":\"%d\"}",updata_id,token,[columnIDStr intValue],1];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Archives/index/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                    NSInteger code = [[json objectForKey:@"code"] integerValue];
                      
                      if (code == 1) {//接口响应正确
                          PPBulletinChirldViewController *ui = chirldViewArray[vcindex];
                          if ([ui.bulletinlistTableView.mj_header isRefreshing]) {
                              [ui.bulletinlistTableView.mj_header endRefreshing];
                          }
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSArray *dataArrrays = [dataDic objectForKey:@"list"];
                          NSDictionary *pageDic = [dataDic objectForKey:@"page"];
                          
                          if (![dataArrrays isEqual:[NSNull null]]) {
                              dataArray = [NSMutableArray arrayWithArray:dataArrrays];
                          }else{
                              dataArray = [NSMutableArray array];
                          }
                          
//                          if (dataArray.count < 20) {
//                              ui.bulletinlistTableView.mj_footer.hidden = YES;
//                              [ui.bulletinlistTableView.mj_footer endRefreshingWithNoMoreData];
//                          }else{
//                              [ui.bulletinlistTableView.mj_footer resetNoMoreData];
//                              ui.bulletinlistTableView.mj_footer.hidden = NO;
//                          }
                          
                          ui.columnArray = columnArray;
                          ui.nowIndex = vcindex;
                          ui.dataArray = dataArray;
                          ui.pageMainDic = pageDic;
                          [ui creatScrollNews:scrollNewsArray];
                          [ui.bulletinlistTableView reloadData];
                          if ([dataArray count] == 0) {
                              ui.waitLabel.hidden = NO;
                          }
                          [WSProgressHUD dismiss];
                          ui.view.frame = CGRectMake(PPMainViewWidth*vcindex, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);

                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else{
                          [WSProgressHUD dismiss];
                      }
                      
                  }
                      failedBlock:^(NSError *error) {
                          [WSProgressHUD dismiss];
                      }];
    }

}

#pragma mark --- 上拉加载更多 ----
-(void)refreshMoreTableViewData{
    
    PPBulletinChirldViewController *ui = chirldViewArray[vcindex];
    NSDictionary *pageDic = ui.pageMainDic;
    NSInteger nowPageNum = [[pageDic objectForKey:@"now_page"] integerValue];
    NSString *columnIDStr = [[columnArray objectAtIndex:vcindex] objectForKey:@"typeid"];
    @autoreleasepool {
        NSString *dJson = nil;
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"arctype_id\":\"%d\",\"page\":\"%ld\"}",updata_id,token,[columnIDStr intValue],nowPageNum];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Archives/index/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      
                      if (code == 1) {//接口响应正确
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSArray *dataArrrays = [dataDic objectForKey:@"list"];
                          NSInteger datacount = [ui.dataArray count];
                          NSDictionary *pageDic = [dataDic objectForKey:@"page"];
                          ui.columnArray = columnArray;
                          ui.nowIndex = vcindex;
                          ui.pageMainDic = pageDic;
                          ui.dataArray = [NSMutableArray arrayWithArray:[ui.dataArray arrayByAddingObjectsFromArray:dataArrrays]];
                          if (dataArray.count == datacount) {
                              ui.bulletinlistTableView.mj_footer.hidden = YES;
                              [ui.bulletinlistTableView.mj_footer endRefreshingWithNoMoreData];
                          }
                          
                          [ui.bulletinlistTableView reloadData];
                          
                          if ([ui.bulletinlistTableView.mj_footer isRefreshing]) {
                              [ui.bulletinlistTableView.mj_footer endRefreshing];
                          }
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else{//接口返回错误
                          if ([ui.bulletinlistTableView.mj_footer isRefreshing]) {
                              [ui.bulletinlistTableView.mj_footer endRefreshing];
                          }
                      }
                      
                  }
                      failedBlock:^(NSError *error) {
                          if ([ui.bulletinlistTableView.mj_footer isRefreshing]) {
                              [ui.bulletinlistTableView.mj_footer endRefreshing];
                          }
                      }];
    }
    
    
}

-(void)creatVC:(NSMutableArray *)vcArray{
    
    @autoreleasepool {
        
        //获取类型接口
//        PPRDData *pprddata1 = [[PPRDData alloc] init];
//        [pprddata1 startAFRequest:@"wap/notice/getNoticeTopList"
//                      requestdata:nil
//                   timeOutSeconds:10
//                  completionBlock:^(NSDictionary *json) {
                    //刷新视图
        
//                  }
//                      failedBlock:^(NSError *error) {
//                          //刷新视图
//                          for (int i = 0; i<vcArray.count; i++) {
//                              PPBulletinChirldViewController *ui = vcArray[i];
//                              if (vcindex == i) {
//                                  ui.dataArray = dataArray;
//                                  [ui.bulletinlistTableView reloadData];
//                                  
//                              }
//                              ui.view.frame = CGRectMake(PPMainViewWidth*i, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
//                          }
//     
//
//                      }];
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
