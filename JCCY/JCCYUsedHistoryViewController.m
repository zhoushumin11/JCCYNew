//
//  JCCYUsedHistoryViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/25.
//
//

#import "JCCYUsedHistoryViewController.h"

@interface JCCYUsedHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UITableView *mainTableView;

@end

@implementation JCCYUsedHistoryViewController
@synthesize dataArray,mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消费记录";
    
    dataArray = [NSMutableArray array];
    
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
    
    
}

-(void)refreshMoreTableView{
    
    
}



-(void)getdata{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",87,token];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_conf/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          
                          
                      }
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, PPMainViewWidth, 44)];
    view.backgroundColor = [UIColor grayColor];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/3, 44)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = [UIColor whiteColor];
    lable1.text = @"消费时间";
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/3, 0, PPMainViewWidth/3, 44)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor whiteColor];
    lable2.text = @"消费的项目";
    lable2.backgroundColor = [UIColor clearColor];
    lable2.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:lable2];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/3*2, 0, PPMainViewWidth/3, 44)];
    lable3.textAlignment = NSTextAlignmentCenter;
    lable3.textColor = [UIColor whiteColor];
    lable3.text = @"消费金币";
    lable3.backgroundColor = [UIColor clearColor];
    lable3.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:lable3];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/3, 44)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = [UIColor blackColor];
    lable1.text = @"2016-11-10";
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/3, 0, PPMainViewWidth/3, 44)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor blackColor];
    lable2.text = @"钻石";
    lable2.backgroundColor = [UIColor clearColor];
    lable2.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lable2];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/3*2, 0, PPMainViewWidth/3, 44)];
    lable3.textAlignment = NSTextAlignmentCenter;
    lable3.text = @"2000";
    lable3.textColor = [UIColor redColor];
    lable3.backgroundColor = [UIColor clearColor];
    lable3.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lable3];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
