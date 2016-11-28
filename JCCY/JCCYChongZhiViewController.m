//
//  JCCYChongZhiViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/27.
//
//

#import "JCCYChongZhiViewController.h"

@interface JCCYChongZhiViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UIView *buttonsView;

@property(nonatomic,strong) UIView *payView;

@property(nonatomic,assign) NSString *conf_recharge_id; //当前充值金额类型id
@property(nonatomic,assign) NSString *conf_recharge_amount; //当前充值金额
@property(nonatomic,assign) NSString *conf_recharge_gold; //当前充值到账金币数

@property(nonatomic,assign) NSInteger pay_type; //充值的方式  1支付宝 2微信支付


@property(nonatomic,strong) NSMutableArray *dataArray;



@end

@implementation JCCYChongZhiViewController

@synthesize dataArray,mainScrollView,buttonsView,conf_recharge_id,payView,pay_type,conf_recharge_amount,conf_recharge_gold;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线充值";
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [NSMutableArray array];
    //支付类型 默认支付宝
    pay_type = 1;
    //获取充值数据
    [self getChongZhiStatus];
    
}

//获取充值详情页数据
-(void)getChongZhiStatus{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",87,token];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
//                          {
//                              "conf_recharge_amount" = "500.00";
//                              "conf_recharge_gold" = 5000;
//                              "conf_recharge_id" = 2;
//                              sort = 3;
//                          }
                          NSArray *dataArr = [json objectForKey:@"data"];
                          dataArray = [NSMutableArray arrayWithArray:dataArr];
                          if (dataArray.count > 0) {
                              
                              conf_recharge_id = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_id"];
                              conf_recharge_amount = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_amount"];
                              conf_recharge_gold = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_gold"];
                              
                              [self creatViews];
                          }
                          
                      }else{
                          //异常处理
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}

#pragma  Mark 初始化页面

-(void)creatViews{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, PPMainViewWidth, PPMainViewHeight)];
    mainScrollView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    mainScrollView.delegate = self;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, PPMainViewWidth - 10, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.text = @"请选择充值金额";
    [mainScrollView addSubview:label];
    
    [self.view addSubview:mainScrollView];
    
    //创建购买选项按钮
    [self creatButtons:0];
    
    
    
}

-(void)creatButtons:(NSInteger)selectedIndex{
    
    float viewY = (dataArray.count/3+1) *(((PPMainViewWidth-40)/3)-30) +(dataArray.count * 10);
    
    buttonsView  = [[UIView alloc] initWithFrame:CGRectMake(0, 50, PPMainViewWidth, viewY)];
    
    
    for (int i= 0; i<dataArray.count; i++) {
        float buttonW = (PPMainViewWidth-40)/3;
        float buttonH = buttonW - 30;
        float yindex = i/3;
        float xindex = i%3;
        NSDictionary *titleDic = [dataArray objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(10+(xindex*10)+(buttonW*xindex), (yindex*10)+(buttonH*yindex), buttonW, buttonH);
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        //设置标题
        btn.titleLabel.font = [UIFont systemFontOfSize:22];
        btn.titleEdgeInsets = UIEdgeInsetsMake( buttonH/4,0.0 , buttonH/4*3, 0.0);
        

        [btn setTitle:[NSString stringWithFormat:@"¥%@",[titleDic objectForKey:@"conf_recharge_amount"]] forState:UIControlStateNormal];
        
        //设置副标题
        UILabel *rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonH/4*2, buttonW, buttonH/4)];
        rmbLabel.textColor = [UIColor grayColor];
        rmbLabel.textAlignment = NSTextAlignmentCenter;
        rmbLabel.text = [NSString stringWithFormat:@"(%@金币)",[titleDic objectForKey:@"conf_recharge_gold"]];
        [btn addSubview:rmbLabel];
        
        //设置选中背景imageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonW - 20, buttonH - 20, 20, 20)];
        if (selectedIndex == i) {
            imageView.image = [UIImage imageNamed:@"JCCY_YiXuan"];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            imageView.image = [UIImage imageNamed:@""];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [btn addSubview:imageView];
        
        [btn addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [buttonsView addSubview:btn];
    }
    
    [mainScrollView addSubview:buttonsView];
    
    if (payView) {
        
    }else{
        //创建支付类型按钮
        [self creatPayTypeBtns];
    }
}
#pragma mark ---创建支付类型按钮 --
-(void)creatPayTypeBtns{
    
    //设置支付类型按钮
    [self creatPayTypeBtn:0];
    

    
}

#pragma 创建支付类型按钮
-(void)creatPayTypeBtn:(NSInteger)payType{
    
    payView = [[UIView alloc] initWithFrame:CGRectMake(10,20+buttonsView.frame.origin.y+ buttonsView.frame.size.height, PPMainViewWidth-20, 120)];
    payView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:payView];
    
    //确定 button
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quedingBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    quedingBtn.frame = CGRectMake(35, payView.frame.origin.y + payView.frame.size.height+10, PPMainViewWidth-70, 45);
    
    [quedingBtn.layer setMasksToBounds:YES];
    [quedingBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    quedingBtn.backgroundColor = [UIColor colorFromHexRGB:@"e60013"];
    [quedingBtn setTitle:@"确认" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quedingBtn addTarget:self action:@selector(quedingPhone) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:quedingBtn];
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"zhifubao_PayType",@"weixin_PayType", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"支付宝钱包充值",@"微信充值", nil];
    NSArray *subTitleArray = [NSArray arrayWithObjects:@"推荐支付宝用户使用",@"推荐有微信支付的账户的用户使用", nil];

    for (int i = 0; i<2; i++) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, (60*i), PPMainViewWidth-20, 60)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [view addSubview:imageView];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(58, 5, 200, 20)];
        titleLable.textColor = [UIColor grayColor];
        titleLable.font = [UIFont systemFontOfSize:18];
        titleLable.text = titleArray[i];
        [view addSubview:titleLable];
        
        UILabel *sublabel  = [[UILabel alloc] initWithFrame:CGRectMake(58, 30, PPMainViewWidth-20-58-40, 20)];
        sublabel.textColor = [UIColor grayColor];
        sublabel.font = [UIFont systemFontOfSize:16];
        sublabel.text = subTitleArray[i];
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
    
}
#pragma mark --- 充值金额类型按钮点击事件 --
-(void)typeBtnAction:(UIButton *)btn{
    NSInteger btnTag = btn.tag;
    conf_recharge_id = [[dataArray objectAtIndex:btnTag] objectForKey:@"conf_recharge_id"];
    conf_recharge_amount = [[dataArray objectAtIndex:btnTag] objectForKey:@"conf_recharge_amount"];
    conf_recharge_gold = [[dataArray objectAtIndex:btnTag] objectForKey:@"conf_recharge_gold"];
    
    [self creatButtons:btnTag];
}


//支付类型
-(void)choosePayTypeBtnAction:(UIButton *)btn{
    pay_type = btn.tag+1;
    [self creatPayTypeBtn:btn.tag];
}

//确定充值 1.首先提交到服务器 申请充值
-(void)quedingPhone{
    
    
    NSString *recharge_number = nil;
    
    
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"recharge_number\":\"%@\",\"conf_recharge_id\":\"%@\",\"recharge_amount\":\"%@\",\"recharge_gold\":\"%@\",\"pay_type\":\"%ld\"}",87,token,recharge_number,conf_recharge_id,conf_recharge_amount,conf_recharge_gold,pay_type];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/UserRecharge/do_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          if (pay_type == 1) {
                              [self payByAlipay];
                          }else if(pay_type == 2){
                              [self payByWeChat];
                          }
                          
                      }else{
                          //异常处理
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}

//调用支付宝支付
-(void)payByAlipay{
 
    [self payStatusChaXun];
}

//调用微信支付
-(void)payByWeChat{
    
    [self payStatusChaXun];
}

#pragma mark ---- 充值状态查询 ----
-(void)payStatusChaXun{
    
    
    NSString *recharge_number = nil;
    
    
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"recharge_number\":\"%@\"}",87,token,recharge_number];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/UserRecharge/check_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSLog(@"充值成功");
                      }else{
                          //异常处理
                          NSLog(@"充值失败");

                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];
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
