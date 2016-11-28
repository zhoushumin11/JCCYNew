//
//  JCCYPayStatusQueryViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/28.
//
//

#import "JCCYPayStatusQueryViewController.h"

@interface JCCYPayStatusQueryViewController ()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *tishiLabel;

@property(nonatomic,strong) UIView *succ_View; //成功之后的界面

@end

@implementation JCCYPayStatusQueryViewController
@synthesize dingDangNumStr,imageView,tishiLabel,succ_View;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    [self payStatusChaXun];
    
    self.title = @"充值查询";
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PPMainViewWidth/2 - 50, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"pay_success"];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, PPMainViewWidth-20, 30)];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    tishiLabel.font = [UIFont boldSystemFontOfSize:22];
    tishiLabel.textColor = [UIColor blackColor];
    tishiLabel.text = @"正在充值，请耐心等待...";
    
    [self.view addSubview:tishiLabel];
    
    
}


#pragma mark ---- 充值状态查询 ----
-(void)payStatusChaXun{
    
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"recharge_number\":\"%@\"}",87,token,dingDangNumStr];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/UserRecharge/check_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          
                          NSDictionary *dic = [json objectForKey:@"data"];
                          if ([dic isEqual:[NSNull null]]) {
                              return;
                          }
                          
                          BOOL is_success = [[dic objectForKey:@"is_success"] boolValue];
                          if(!is_success){//初始化充值成功状态的视图
//                            [self creatSuccViewByrecharge_amount:[dic objectForKey:@"recharge_amount"] recharge_gold:[dic objectForKey:@"recharge_gold"]];
                              [self creatSuccViewByrecharge_amount:@"1" recharge_gold:@"1000"];
                          }else{
                              
                          }

                          
                      }else{
                          //异常处理
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}

-(void)creatSuccViewByrecharge_amount:(NSString *)recharge_amount recharge_gold:(NSString *)recharge_gold{
    self.title = @"充值成功";
    tishiLabel.text = @"充值成功";
    succ_View = [[UIView alloc] initWithFrame:CGRectMake(0, 300, PPMainViewWidth, 150)];
    succ_View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:succ_View];
    
    UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, PPMainViewWidth, 50)];
    payTypeLabel.textColor = [UIColor grayColor];
    payTypeLabel.font = [UIFont systemFontOfSize:18];
    if ([self.payType isEqualToString:@"1"]) {
        payTypeLabel.text = @"支付宝";
    }else if([self.payType isEqualToString:@"2"]){
        payTypeLabel.text = @"微信";
    }
    [succ_View addSubview:payTypeLabel];
    
    UILabel *recharge_goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 50)];
    recharge_goldLabel.textColor = [UIColor grayColor];
    recharge_goldLabel.font = [UIFont systemFontOfSize:18];
    recharge_goldLabel.text = @"充值金额";
    [succ_View addSubview:recharge_goldLabel];
    
    UILabel *recharge_amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 150, 50)];
    recharge_amountLabel.textColor = [UIColor grayColor];
    recharge_amountLabel.font = [UIFont systemFontOfSize:18];
    recharge_amountLabel.text = @"充值金币";
    [succ_View addSubview:recharge_amountLabel];
    
    
    UILabel *recharge_goldLa = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth - 160, 50, 150, 50)];
    recharge_goldLa.textColor = [UIColor grayColor];
    recharge_goldLa.font = [UIFont systemFontOfSize:18];
    recharge_goldLa.textAlignment = NSTextAlignmentRight;
    recharge_goldLa.text = [NSString stringWithFormat:@"¥%@",recharge_gold];
    [succ_View addSubview:recharge_goldLa];
    
    UILabel *recharge_amountLa = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth - 160, 100, 150, 50)];
    recharge_amountLa.textColor = [UIColor grayColor];
    recharge_amountLa.font = [UIFont systemFontOfSize:18];
    recharge_amountLa.textAlignment = NSTextAlignmentRight;
    recharge_amountLa.text = [NSString stringWithFormat:@"%@",recharge_amount];
    [succ_View addSubview:recharge_amountLa];
    
    
    
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
