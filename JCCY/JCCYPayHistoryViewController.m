//
//  JCCYPayHistoryViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/25.
//
//

#import "JCCYPayHistoryViewController.h"

@interface JCCYPayHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation JCCYPayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值记录";
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewHeight) style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    
    //获取数据
    [self getdata];
    
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
    view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/2, 44)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"等级";
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/2, 0, PPMainViewWidth/2, 44)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.text = @"所需积分";
    lable2.backgroundColor = [UIColor clearColor];
    lable2.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:lable2];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/2, 44)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"level_name"];
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/2, 0, PPMainViewWidth/2, 44)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"level_cost"];
    lable2.backgroundColor = [UIColor clearColor];
    lable2.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:lable2];
    
    if ((indexPath.row+1 )% 2 == 0) {
        cell.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    //    "level_cost" = 0;
    //    "level_id" = "Lv.0";
    //    "level_name" = "Lv.0";
    
    
    return cell;
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
