//
//  JCCYBuyVipViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/29.
//
//

#import "JCCYBuyVipViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"

@interface JCCYBuyVipViewController ()<UIAlertViewDelegate>

@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UIView *userInfoView; //用户金币余额view

@property(nonatomic,strong) UIView *payView;  //支付选项view

@property(nonatomic,strong) UIView *chongZhiShuoMingView;  //充值说明View

@property(nonatomic,strong) NSString *serviceStr; //当前购买服务类型

@property(nonatomic,assign) NSInteger pay_typeIndex; //充值index


@end

@implementation JCCYBuyVipViewController

@synthesize dataArray,mainScrollView,userInfoView,payView,chongZhiShuoMingView,serviceStr,pay_typeIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dataArray = [NSMutableArray array];
    pay_typeIndex = 0;
    //获取公共信息
    [self get_info];
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
                              
                              NSDictionary *dataDic = [json objectForKey:@"data"];
                              
                              NSUInteger scores = [[dataDic objectForKey:@"scores"] integerValue];
                              NSUInteger golds = [[dataDic objectForKey:@"golds"] integerValue];
                              NSUInteger present_time = [[dataDic objectForKey:@"present_time"] integerValue];
                              NSUInteger time_service_1 = [[dataDic objectForKey:@"time_service_1"] integerValue];
                              NSUInteger time_service_2 = [[dataDic objectForKey:@"time_service_2"] integerValue];
                              NSUInteger time_service_3 = [[dataDic objectForKey:@"time_service_3"] integerValue];
                              NSString *user_chinese_name = [dataDic objectForKey:@"user_chinese_name"];
                              NSString *user_city = [dataDic objectForKey:@"user_city"];
                              NSString *user_level = [dataDic objectForKey:@"user_level"];
                              NSString *user_phone = [dataDic objectForKey:@"user_phone"];
                              NSString *user_pic = [dataDic objectForKey:@"user_pic"];
                              NSString *user_province = [dataDic objectForKey:@"user_province"];
                              
                              NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
                              [userDefauls setObject:[NSNumber numberWithInteger:golds] forKey:@"golds"];
                              [userDefauls setObject:[NSNumber numberWithInteger:scores] forKey:@"scores"];
                              [userDefauls setObject:[NSNumber numberWithInteger:present_time] forKey:@"present_time"];
                              [userDefauls setObject:[NSNumber numberWithInteger:time_service_1] forKey:@"time_service_1"];
                              [userDefauls setObject:[NSNumber numberWithInteger:time_service_2] forKey:@"time_service_2"];
                              [userDefauls setObject:[NSNumber numberWithInteger:time_service_3] forKey:@"time_service_3"];
                              [userDefauls setObject:user_chinese_name forKey:@"user_chinese_name"];
                              [userDefauls setObject:user_city forKey:@"user_city"];
                              [userDefauls setObject:user_level forKey:@"user_level"];
                              [userDefauls setObject:user_phone forKey:@"user_phone"];
                              [userDefauls setObject:user_pic forKey:@"user_pic"];
                              [userDefauls setObject:user_province forKey:@"user_province"];
                              [userDefauls synchronize];
                              //创建userInfoView
                              [self creatUserInfoView];
                          }
                      } failedBlock:^(NSError *error) {
                          
                      }];
        }
    }
}

-(void)creatUserInfoView{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewHeight-64)];
    mainScrollView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 130)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    
    NSString *golds = [[[NSUserDefaults standardUserDefaults] objectForKey:@"golds"] stringValue];
    
    CGSize size = GetWTextSizeFoldFont(golds, 70, 28);
    
    
    UILabel *goldNumlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width+20, 70)];
    goldNumlabel.textColor = [UIColor blackColor];
    goldNumlabel.font = [UIFont boldSystemFontOfSize:28];
    goldNumlabel.text = golds;
    [userInfoView addSubview:goldNumlabel];
    
    UILabel *goldslabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width+25, 20,40, 40)];
    goldslabel.textColor = [UIColor blackColor];
    goldslabel.font = [UIFont systemFontOfSize:16];
    goldslabel.text = @"金币";
    [userInfoView addSubview:goldslabel];
    
    UILabel *dangqianyuelabel = [[UILabel alloc] initWithFrame:CGRectMake(10,70,70, 30)];
    dangqianyuelabel.textColor = [UIColor blackColor];
    dangqianyuelabel.font = [UIFont systemFontOfSize:16];
    dangqianyuelabel.text = @"当前余额";
    [userInfoView addSubview:dangqianyuelabel];
    
    NSString *user_headImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"];
    
    UIButton *iconImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    iconImgView.frame = CGRectMake(PPMainViewWidth-90,20, 70, 70);
    iconImgView.clipsToBounds = YES;
    iconImgView.layer.cornerRadius = 35;
    iconImgView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    iconImgView.layer.borderWidth = 2;
    iconImgView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [userInfoView addSubview:iconImgView];
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:user_headImg] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            [iconImgView setImage:[UIImage imageNamed:@"user_head_default"] forState:UIControlStateNormal];
        }
    }];
    
    [mainScrollView addSubview:userInfoView];
    
    //当前购买的类型
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(10, 130, 300, 40))];
    [mainScrollView addSubview:label];
    serviceStr = nil;
    if (self.buyType == 0) {
        serviceStr = @"赞赏";
    }else if(self.buyType == 1){
        serviceStr = @"钻石";
    }else if(self.buyType == 2){
        serviceStr = @"黄金";
    }

    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:16];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您当前正在购买%@服务",serviceStr]];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:serviceStr].location, [[noteStr string] rangeOfString:serviceStr].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    [label setAttributedText:noteStr];
    [self.view addSubview:mainScrollView];
    
    [self getBuyListInfo];
}

#pragma mark --- 获取购买列表 ----
-(void)getBuyListInfo{
    NSString *dJson = nil;
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
                          if (service_type == self.buyType+1) {
                              [dataArray addObject:dic];
                          }
                      }
                      //创建列表
                      [self creatTableView:0];
                      
                  }else{
                      [JCCYResult showResultWithResult:[json objectForKey:@"code"] controller:self];

                  }
                  
              } failedBlock:^(NSError *error) {
                  
              }];
    
}



-(void)creatTableView:(NSInteger)payType{
    
    payView = [[UIView alloc] initWithFrame:CGRectMake(0,170, PPMainViewWidth, dataArray.count*60)];
    payView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:payView];
    
    //确定 button
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quedingBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    quedingBtn.frame = CGRectMake(35, 170+30+(dataArray.count*60), PPMainViewWidth-70, 45);
    
    [quedingBtn.layer setMasksToBounds:YES];
    [quedingBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    quedingBtn.backgroundColor = [UIColor colorFromHexRGB:@"e60013"];
    [quedingBtn setTitle:@"购买" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quedingBtn addTarget:self action:@selector(quedingPay) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:quedingBtn];
    
    for (int i = 0; i<dataArray.count; i++) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, (60*i), PPMainViewWidth-20, 60)];

        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
        titleLable.textColor = [UIColor blackColor];
        titleLable.font = [UIFont systemFontOfSize:18];
        NSString *goldString = [[dataArray objectAtIndex:i] objectForKey:@"gold_cost"];
        NSString *dayString = [[dataArray objectAtIndex:i] objectForKey:@"service_days"];
        titleLable.text = [NSString stringWithFormat:@"%@金币 / %@天",goldString,dayString];
        [view addSubview:titleLable];
        
        UILabel *sublabel  = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, PPMainViewWidth-10, 0.5)];
        sublabel.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
        [view addSubview:sublabel];

        
        UIButton *chooseeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseeBtn.frame = CGRectMake(PPMainViewWidth - 20 - 40, 10, 40, 40);
        
        chooseeBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        if (payType == i) {
            [chooseeBtn setImage:[UIImage imageNamed:@"payType_selected"] forState:UIControlStateNormal];
        }else{
            [chooseeBtn setImage:[UIImage imageNamed:@"payType_DisSelected"] forState:UIControlStateNormal];
        }
        
        chooseeBtn.tag = i;
        
        [chooseeBtn addTarget:self action:@selector(choosePayTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:chooseeBtn];
        
        [payView addSubview:view];
    }
    
    //创建充值说明view
    if (chongZhiShuoMingView==nil) {
        [self creatChongZhiShuoMingView];
    }
}

//支付类型
-(void)choosePayTypeBtnAction:(UIButton *)btn{
    pay_typeIndex = btn.tag;
    [self creatTableView:btn.tag];
}

//说明视图
-(void)creatChongZhiShuoMingView{
    
    NSString *CHONGZHI_CONTENT = nil;
    
    if (self.buyType == 0) {
        CHONGZHI_CONTENT = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZANSHANG_CONTENT"];
    }else if(self.buyType == 1){
        CHONGZHI_CONTENT = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZUANSHI_CONTENT"];
    }else if(self.buyType == 2){
        CHONGZHI_CONTENT = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUANGJIN_CONTENT"];
    }

    
    CGSize size = GetHTextSizeFont(CHONGZHI_CONTENT, PPMainViewWidth-20, 14);
    
    chongZhiShuoMingView  = [[UIView alloc] initWithFrame:CGRectMake(10, 170+30+(dataArray.count*60) + 45 +30, PPMainViewWidth - 20, size.height + 50)];
    
    chongZhiShuoMingView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:chongZhiShuoMingView];
    
    UILabel *chongzhishuominLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth-20, 30)];
    chongzhishuominLabel.text  = [NSString stringWithFormat:@"%@说明：",serviceStr];
    chongzhishuominLabel.backgroundColor = [UIColor clearColor];
    chongzhishuominLabel.font = [UIFont systemFontOfSize:14];
    chongzhishuominLabel.textColor = [UIColor redColor];
    [chongZhiShuoMingView addSubview:chongzhishuominLabel];
    
    UITextView *chongzhishuominLabels = [[UITextView alloc] initWithFrame:CGRectMake(0, 30, PPMainViewWidth-20, size.height+20)];
    chongzhishuominLabels.text  = CHONGZHI_CONTENT;
    chongzhishuominLabels.font = [UIFont systemFontOfSize:14];
    chongzhishuominLabels.backgroundColor = [UIColor clearColor];
    chongzhishuominLabels.editable = NO;
    chongzhishuominLabels.textColor = [UIColor blackColor];
    [chongZhiShuoMingView addSubview:chongzhishuominLabels];
    
    
    [mainScrollView setContentSize:CGSizeMake(PPMainViewWidth,170+30+(dataArray.count*60) + 45 +30 + size.height + 50)];
    
}

#pragma mark mark --- 确定购买 -----
-(void)quedingPay{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定购买此服务?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 2016;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2016) {
        if (buttonIndex == 0) {
            [self doPay];
        }else{
            return;
        }
    }
}

-(void)doPay{
    
    NSString *dJson = nil;
    NSString *conf_cost_service_id = [[dataArray objectAtIndex:pay_typeIndex] objectForKey:@"conf_cost_service_id"];
    NSString *gold_cost = [[dataArray objectAtIndex:pay_typeIndex] objectForKey:@"gold_cost"];
    NSString *service_days = [[dataArray objectAtIndex:pay_typeIndex] objectForKey:@"service_days"];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"conf_cost_service_id\":\"%@\",\"service_type\":\"%ld\",\"cost_gold\":\"%@\",\"days\":\"%@\"}",87,token,conf_cost_service_id,self.buyType+1,gold_cost,service_days];
    //获取类型接口
    PPRDData *pprddata1 = [[PPRDData alloc] init];
    [pprddata1 startAFRequest:@"/index.php/Api/UserCost/do_cost_service/"
                  requestdata:dJson
               timeOutSeconds:10
              completionBlock:^(NSDictionary *json) {
                  NSInteger code = [[json objectForKey:@"code"] integerValue];
                  
                  if (code == 1) {
                      [WSProgressHUD showWithStatus:@"购买成功"];
                      [WSProgressHUD autoDismiss:1];
                      [self.navigationController popViewControllerAnimated:YES];
                  }else if(code == -107){
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉,您的余额不足,购买该服务失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                      [alert show];
                  }
                  
              } failedBlock:^(NSError *error) {
                  
              }];
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
