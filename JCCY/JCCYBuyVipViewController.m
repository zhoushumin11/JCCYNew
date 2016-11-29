//
//  JCCYBuyVipViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/29.
//
//

#import "JCCYBuyVipViewController.h"
#import "AppDelegate.h"

@interface JCCYBuyVipViewController ()

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation JCCYBuyVipViewController

@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dataArray = [NSMutableArray array];
    
    //获取公共信息
    [self get_info];
    //获取购买列表
    [self getBuyListInfo];
    
}

#pragma mark --- 更新会员信息 ----
-(void)get_info{
    @autoreleasepool {
        NSString *dJson = nil;
        @autoreleasepool {
            
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",87,token];
            //获取类型接口
            PPRDData *pprddata1 = [[PPRDData alloc] init];
            [pprddata1 startAFRequest:@"/index.php/Api/User/get_info/"
                          requestdata:dJson
                       timeOutSeconds:10
                      completionBlock:^(NSDictionary *json) {
                          NSInteger code = [[json objectForKey:@"code"] integerValue];
                          if (code == 1) {
                              
                          }else{
                              
                          }
                          
                          
                      } failedBlock:^(NSError *error) {
                          
                      }];
        }
    }
}


#pragma mark --- 获取购买列表 ----
-(void)getBuyListInfo{
    @autoreleasepool {
        NSString *dJson = nil;
        @autoreleasepool {
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",87,token];
            //获取类型接口
            PPRDData *pprddata1 = [[PPRDData alloc] init];
            [pprddata1 startAFRequest:@"/index.php/Api/Update/update_cost_service/"
                          requestdata:dJson
                       timeOutSeconds:10
                      completionBlock:^(NSDictionary *json) {
                          NSInteger code = [[json objectForKey:@"code"] integerValue];
                          
                          if (code == 1) {
                              NSArray *dataArr = [json objectForKey:@"data"];
                              if ([dataArr isEqual:[NSNull null]] || dataArr.count == 0) {
                                  return;
                              }
                              
                              for (int i = 0; i<dataArr.count; i++) {
                                  NSDictionary *dic = [dataArr objectAtIndex:i];
                                  NSInteger service_type = [[dic objectForKey:@"service_type"] integerValue];
                                  if (service_type == self.buyType) {
                                      [dataArray addObject:dic];
                                  }
                                  
                              }
                              //创建列表
                              [self creatTableView];
                              
                          }else{
                              
                          }
                          
                          
                      } failedBlock:^(NSError *error) {
                          
                      }];
        }
    }
}

-(void)creatTableView{
    
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
