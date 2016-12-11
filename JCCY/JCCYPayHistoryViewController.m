//
//  JCCYPayHistoryViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/25.
//
//

#import "JCCYPayHistoryViewController.h"

@interface JCCYPayHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger now_page; //当前分页
}
@property(nonatomic,strong) NSDictionary *pageDic;//分页字典

@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UITableView *mainTableView;

@end

@implementation JCCYPayHistoryViewController


@synthesize mainTableView,dataArray,pageDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值记录";
    
    dataArray = [NSMutableArray array];
    self.pageDic = [NSDictionary dictionary];
    now_page = 1;
    
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
    
    
    //获取数据
    [self getdata];
    
}

-(void)refreshTableView{
    [self getdata];
    
}

-(void)refreshMoreTableView{
    
    NSString *pageNumsss = [[pageDic objectForKey:@"now_page"] stringValue];
    if ([pageNumsss isEqual:[NSNull null]]) {
        return;
    }
    [self getdata:[pageNumsss integerValue]];
}

-(void)getdata{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"page\":\"%d\"}",updata_id,token,1];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/UserRecharge/list_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSArray *listArray = [dataDic objectForKey:@"list"];
                          
                          if ([listArray isEqual:[NSNull null]]) {
                              return;
                          }
                          NSMutableArray *arraysss = [NSMutableArray array];
                          
                          for (int i = 0; i<listArray.count; i++) {
                              NSDictionary *dic = [listArray objectAtIndex:i];
                              BOOL isSucc = [[dic objectForKey:@"is_success"] boolValue];
                              if (isSucc) {
                                  [arraysss addObject:dic];
                              }
                          }
                          
                          
                          dataArray = [NSMutableArray arrayWithArray:arraysss];
                          NSDictionary *pageDicNow = [dataDic objectForKey:@"page"];
                          self.pageDic = pageDicNow;
                          
                          [mainTableView reloadData];
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }
                  } failedBlock:^(NSError *error) {
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
            }];
     }
}

-(void)getdata:(NSInteger)nowPage{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"page\":\"%ld\"}",updata_id,token,nowPage];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/UserRecharge/list_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
                      
                      if ([mainTableView.mj_footer isRefreshing]) {
                          [mainTableView.mj_footer endRefreshing];
                      }
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSArray *listArray = [dataDic objectForKey:@"list"];
                          
                          if ([listArray isEqual:[NSNull null]]) {
                              return;
                          }
                          
                          NSMutableArray *arraysss = [NSMutableArray array];
                          
                          for (int i = 0; i<listArray.count; i++) {
                              NSDictionary *dic = [listArray objectAtIndex:i];
                              BOOL isSucc = [[dic objectForKey:@"is_success"] boolValue];
                              if (isSucc) {
                                  [arraysss addObject:dic];
                              }
                          }
                          
                          dataArray = [NSMutableArray arrayWithArray:[dataArray arrayByAddingObjectsFromArray:arraysss]];
                          NSDictionary *pageDicNow = [dataDic objectForKey:@"page"];
                          self.pageDic = [pageDicNow mutableCopy];
                          
                          [mainTableView reloadData];
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }
                  } failedBlock:^(NSError *error) {
                      if ([mainTableView.mj_header isRefreshing]) {
                          [mainTableView.mj_header endRefreshing];
                      }
                      if ([mainTableView.mj_footer isRefreshing]) {
                          [mainTableView.mj_footer endRefreshing];
                      }
            }];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, PPMainViewWidth, 44)];
    view.backgroundColor = [UIColor grayColor];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/4, 44)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = [UIColor whiteColor];
    lable1.text = @"充值时间";
    lable1.backgroundColor = [UIColor clearColor];
    [view addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4, 0, PPMainViewWidth/4, 44)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor whiteColor];
    lable2.text = @"充值金额";
    lable2.backgroundColor = [UIColor clearColor];
    [view addSubview:lable2];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4*2, 0, PPMainViewWidth/4, 44)];
    lable3.textAlignment = NSTextAlignmentCenter;
    lable3.textColor = [UIColor whiteColor];
    lable3.text = @"兑换金币";
    lable3.backgroundColor = [UIColor clearColor];
    [view addSubview:lable3];
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4*3, 0, PPMainViewWidth/4, 44)];
    lable4.textAlignment = NSTextAlignmentCenter;
    lable4.textColor = [UIColor whiteColor];
    lable4.text = @"充值方式";
    lable4.backgroundColor = [UIColor clearColor];
    [view addSubview:lable4];
    
    if (PPMainViewWidth < 350) {
        lable1.font = [UIFont systemFontOfSize:16];
        lable2.font = [UIFont systemFontOfSize:16];
        lable3.font = [UIFont systemFontOfSize:16];
        lable4.font = [UIFont systemFontOfSize:16];
    }else{
        lable1.font = [UIFont systemFontOfSize:16];
        lable2.font = [UIFont systemFontOfSize:16];
        lable3.font = [UIFont systemFontOfSize:16];
        lable4.font = [UIFont systemFontOfSize:16];
    }

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count > 0) {
        return dataArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (dataArray.count > 0) {
        static NSString *identify = @"cell";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/4+10, 55)];
        lable1.textAlignment = NSTextAlignmentCenter;
        lable1.textColor = [UIColor colorFromHexRGB:@"333333"];
        int num = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] intValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        lable1.text = confromTimespStr;
        lable1.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lable1];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4, 0, PPMainViewWidth/4, 55)];
        lable2.textAlignment = NSTextAlignmentCenter;
        lable2.textColor = [UIColor redColor];
        NSString *sss1 = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"recharge_amount"];
        NSString *rmbString = [NSString stringWithFormat:@"¥%@",sss1];
        lable2.text = rmbString;
        lable2.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lable2];
        
        UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4*2, 0, PPMainViewWidth/4, 55)];
        lable3.textAlignment = NSTextAlignmentCenter;
        NSString *sss2 = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"recharge_gold"];
        NSString *goldString = [NSString stringWithFormat:@"¥%@",sss2];
        lable3.text = goldString;
        lable3.textColor = [UIColor colorFromHexRGB:@"333333"];
        lable3.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lable3];
        
        UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/4*3, 0, PPMainViewWidth/4, 55)];
        lable4.textAlignment = NSTextAlignmentCenter;
        NSString *sss3 = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"pay_type"];
        NSString *pay_type = @"";
        
        if (![sss3 isEqual:[NSNull null]]) {
            if ([sss3 isEqualToString:@"1"]) {
                pay_type = @"支付宝";
            }else if ([sss3 isEqualToString:@"2"]){
                pay_type = @"微信";
            }else{
                pay_type = @"系统充值";
            }
        }else{
            pay_type = @"系统充值";
        }
        
        lable4.text = pay_type;
        lable4.textColor = [UIColor colorFromHexRGB:@"333333"];
        lable4.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lable4];
        
        if (PPMainViewWidth<350) {
            lable1.font = [UIFont systemFontOfSize:16];
            lable2.font = [UIFont systemFontOfSize:16];
            lable3.font = [UIFont systemFontOfSize:16];
            lable4.font = [UIFont systemFontOfSize:16];
        }else{
            lable1.font = [UIFont systemFontOfSize:16];
            lable2.font = [UIFont systemFontOfSize:16];
            lable3.font = [UIFont systemFontOfSize:16];
            lable4.font = [UIFont systemFontOfSize:16];
        }
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54.5, PPMainViewWidth, 0.5)];
        lineLabel.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
        [cell.contentView addSubview:lineLabel];
        if (indexPath.row == dataArray.count-1) {
            lineLabel.hidden = YES;
        }else{
            lineLabel.hidden = NO;
        }
        
        return cell;
    }else{
        static NSString *identify = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *nodatalabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 44)];
        nodatalabel.textAlignment = NSTextAlignmentCenter;
        nodatalabel.font = [UIFont systemFontOfSize:14];
        nodatalabel.text = @"暂无数据";
        nodatalabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nodatalabel];
        return  cell;
    }

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
