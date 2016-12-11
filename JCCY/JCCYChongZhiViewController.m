//
//  JCCYChongZhiViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/27.
//
//

#import "JCCYChongZhiViewController.h"

#import "JCCYPayStatusQueryViewController.h"

#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "payRequsestHandler.h"

#import "CommonUtil.h"
#import "GDataXMLNode.h"

@interface JCCYChongZhiViewController ()<UIScrollViewDelegate,WXApiDelegate>
{
    enum WXScene _scene;
    NSString *Token;
    long token_time;
}
@property(nonatomic,strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UIView *buttonsView; //金额选项view

@property(nonatomic,strong) UIView *payView;  //支付选项view

@property(nonatomic,strong) UIView *chongZhiShuoMingView;  //充值说明View


@property(nonatomic,assign) NSString *conf_recharge_id; //当前充值金额类型id
@property(nonatomic,assign) NSString *conf_recharge_amount; //当前充值金额
@property(nonatomic,assign) NSString *conf_recharge_gold; //当前充值到账金币数


@property(nonatomic,strong) NSString *recharge_number; //当前支付订单号


@property(nonatomic,assign) NSInteger pay_type; //充值的方式  1支付宝 2微信支付


@property(nonatomic,strong) NSMutableArray *dataArray;



@end

@implementation JCCYChongZhiViewController

@synthesize dataArray,mainScrollView,buttonsView,conf_recharge_id,payView,pay_type,conf_recharge_amount,conf_recharge_gold,recharge_number,chongZhiShuoMingView;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"在线充值";
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [NSMutableArray array];

    //支付宝支付通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResultAction:) name:JCCYAliPayNotificationCenter object:nil];
    //微信支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPaySucc) name:JCCYWeiXinPaySucc object:nil];
    //微信支付失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayFail) name:JCCYWeiXinPayFail object:nil];

    //判断有无网络
    
    BOOL isNetOK = [CoreStatus isNetworkEnable];
    if (isNetOK) {
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无网络,请检查网络设置！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    //支付类型 默认支付宝
    pay_type = 1;
    
//    NSArray *dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"getChongZhiStatusArray"];
//    if (dataArr == nil || dataArr.count == 0) {
//        //获取充值数据
        [self getChongZhiStatus];
 
//    }
//    else{//读取本地数据
//        dataArray = [NSMutableArray arrayWithArray:dataArr];
//        if (dataArray.count > 0) {
//            
//            conf_recharge_id = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_id"];
//            conf_recharge_amount = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_amount"];
//            conf_recharge_gold = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_gold"];
//            
//            [self creatViews];
//        }
//   
//    }
    


}
//微信支付通知
-(void)wechatPaySucc{
    JCCYPayStatusQueryViewController *jCCYPayStatusQueryViewController = [[JCCYPayStatusQueryViewController alloc] init];
    jCCYPayStatusQueryViewController.hidesBottomBarWhenPushed = YES;
    jCCYPayStatusQueryViewController.dingDangNumStr = recharge_number;
    jCCYPayStatusQueryViewController.payType = @"2";
    [self.navigationController pushViewController:jCCYPayStatusQueryViewController animated:YES];
}
-(void)wechatPayFail{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"微信支付失败"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}


//获取充值详情页数据
-(void)getChongZhiStatus{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
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
                          [[NSUserDefaults standardUserDefaults] setObject:dataArr forKey:@"getChongZhiStatusArray"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                          dataArray = [NSMutableArray arrayWithArray:dataArr];
                          if (dataArray.count > 0) {
                              
                              conf_recharge_id = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_id"];
                              conf_recharge_amount = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_amount"];
                              conf_recharge_gold = [[dataArray objectAtIndex:0] objectForKey:@"conf_recharge_gold"];
                              
                              [self creatViews];
                          }
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else{
                          //异常处理
                          [JCCYResult showResultWithResult:[NSString stringWithFormat:@"%ld",code] controller:self];
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}

#pragma  Mark 初始化页面

-(void)creatViews{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewHeight)];
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
        NSString *rmbStr = [NSString stringWithFormat:@"¥%@",[titleDic objectForKey:@"conf_recharge_amount"]];
        btn.titleEdgeInsets = UIEdgeInsetsMake(buttonH/3+10,0.0 , buttonH/4*3-10, 0.0);
        [btn setTitle:rmbStr forState:UIControlStateNormal];
        
        //设置副标题
        NSString *goldsStr = [NSString stringWithFormat:@"(%@金币)",[titleDic objectForKey:@"conf_recharge_gold"]];
        UILabel *rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonH/4*2+10, buttonW, buttonH/4)];
        rmbLabel.textColor = [UIColor grayColor];
        rmbLabel.textAlignment = NSTextAlignmentCenter;
        rmbLabel.text = goldsStr;
        [btn addSubview:rmbLabel];
        if (PPMainViewWidth < 350) {
            
            if (rmbStr.length < 10) {
                btn.titleLabel.font = [UIFont systemFontOfSize:18];

            }else{
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
            }
            
            if (goldsStr.length < 10) {
                rmbLabel.font = [UIFont systemFontOfSize:14];
            }else{
                rmbLabel.font = [UIFont systemFontOfSize:10];
            }
            
        }else{
            
            if (rmbStr.length < 10) {
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                
            }else{
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
            }
            
            if (goldsStr.length < 10) {
                rmbLabel.font = [UIFont systemFontOfSize:14];
            }else{
                rmbLabel.font = [UIFont systemFontOfSize:10];
            }
        }
        
        //设置选中背景imageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonW - 35, buttonH - 35, 35, 35)];
        if (PPMainViewWidth < 350) {
            imageView.frame = CGRectMake(buttonW - 25, buttonH - 25, 25, 25);
        }
        
        if (selectedIndex == i) {
            imageView.image = [UIImage imageNamed:@"JCCY_YiXuan"];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn.layer setBorderWidth:1.0];
            btn.layer.borderColor=[UIColor redColor].CGColor;
        }else{
            imageView.image = [UIImage imageNamed:@""];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.layer setBorderWidth:1.0];
            btn.layer.borderColor=[UIColor colorFromHexRGB:@"d9d9d9"].CGColor;
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
    
    payView = [[UIView alloc] initWithFrame:CGRectMake(10,buttonsView.frame.origin.y+ buttonsView.frame.size.height-10, PPMainViewWidth-20, 150)];
    payView.backgroundColor = [UIColor whiteColor];
    [payView.layer setBorderWidth:1.0];
    [payView.layer setMasksToBounds:YES];
    [payView.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    payView.layer.borderColor=[UIColor colorFromHexRGB:@"d9d9d9"].CGColor;
    [mainScrollView addSubview:payView];
    
    //确定 button
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    if (PPMainViewWidth < 350) {
        quedingBtn.frame = CGRectMake(10, payView.frame.origin.y + payView.frame.size.height+20, PPMainViewWidth-20, 50);
    }else{
        quedingBtn.frame = CGRectMake(10, payView.frame.origin.y + payView.frame.size.height+20, PPMainViewWidth-20, 50);
        
    }

    [quedingBtn.layer setMasksToBounds:YES];
    [quedingBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    quedingBtn.backgroundColor = [UIColor colorFromHexRGB:@"e60013"];
    [quedingBtn setTitle:@"确认" forState:UIControlStateNormal];
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quedingBtn addTarget:self action:@selector(quedingPhone) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:quedingBtn];
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"zhifubao_PayType",@"weixin_PayType", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"支付宝钱包充值",@"微信充值", nil];
    NSArray *subTitleArray = [NSArray arrayWithObjects:@"推荐支付宝用户使用",@"推荐有微信支付的账户的用户使用", nil];

    for (int i = 0; i<2; i++) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, (60*i)+(10*i)+10, PPMainViewWidth-20, 75)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [view addSubview:imageView];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(68, 5, 200, 20)];
        titleLable.textColor = [UIColor blackColor];
        titleLable.text = titleArray[i];
        [view addSubview:titleLable];
        
        UILabel *sublabel  = [[UILabel alloc] initWithFrame:CGRectMake(68, 30, PPMainViewWidth-20-68-40, 20)];
        sublabel.textColor = [UIColor grayColor];
        sublabel.text = subTitleArray[i];
        [view addSubview:sublabel];
        
        if (PPMainViewWidth < 350) {
            titleLable.font = [UIFont systemFontOfSize:16];
            sublabel.font = [UIFont systemFontOfSize:14];
        }else{
            titleLable.font = [UIFont systemFontOfSize:18];
            sublabel.font = [UIFont systemFontOfSize:16];
        }
        
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

        UIButton *chooseeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseeBtn1.frame = CGRectMake(0,0,PPMainViewWidth, 60);
        chooseeBtn1.tag = i;
        [chooseeBtn1 addTarget:self action:@selector(choosePayTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:chooseeBtn1];

        [payView addSubview:view];
    }
    
    //创建充值说明view
    if (chongZhiShuoMingView==nil) {
        [self creatChongZhiShuoMingView];
    }
    
}

//创建支付
-(void)creatChongZhiShuoMingView{
    
    NSString *CHONGZHI_CONTENT = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHONGZHI_CONTENT"];

    CGSize size = GetHTextSizeFont(CHONGZHI_CONTENT, PPMainViewWidth-20, 16);
    
    chongZhiShuoMingView  = [[UIView alloc] initWithFrame:CGRectMake(10, payView.frame.origin.y + payView.frame.size.height+25+60, PPMainViewWidth - 20, size.height + 50)];
    
    chongZhiShuoMingView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:chongZhiShuoMingView];
    
    UILabel *chongzhishuominLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth-20, 30)];
    chongzhishuominLabel.text  = @"充值说明：";
    chongzhishuominLabel.backgroundColor = [UIColor clearColor];
    chongzhishuominLabel.font = [UIFont systemFontOfSize:16];
    chongzhishuominLabel.textColor = [UIColor redColor];
    [chongZhiShuoMingView addSubview:chongzhishuominLabel];
    
    UITextView *chongzhishuominLabels = [[UITextView alloc] initWithFrame:CGRectMake(-4, 30, PPMainViewWidth-20, size.height+30)];
    chongzhishuominLabels.text  = CHONGZHI_CONTENT;
    chongzhishuominLabels.font = [UIFont systemFontOfSize:16];
    chongzhishuominLabels.backgroundColor = [UIColor clearColor];
    chongzhishuominLabels.editable = NO;
    chongzhishuominLabels.scrollEnabled = NO;
    chongzhishuominLabels.textColor = [UIColor blackColor];
    [chongZhiShuoMingView addSubview:chongzhishuominLabels];
    
    
    [mainScrollView setContentSize:CGSizeMake(PPMainViewWidth, payView.frame.origin.y + buttonsView.frame.origin.y + chongZhiShuoMingView.frame.origin.y + 10 + 30 + 30)];

    
    
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

//获取一个随机整数，范围在[from,to），包括from，包括to
-(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

//确定充值 1.首先提交到服务器 申请充值
-(void)quedingPhone{
    
    //判断有无网络
    BOOL isNetOK = [CoreStatus isNetworkEnable];
    if (isNetOK) {
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无网络,请检查网络设置！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nianyueriStr = [formatter stringFromDate:[NSDate date]];
    
    //获得3 - 9 随机码
    int num1 = [self getRandomNumber:3 to:9];
    
    //获得00 - 99 随机码
    int num2 = [self getRandomNumber:00 to:99];
    
    recharge_number = @"";
    
    NSString *recharge_numberStr = [NSString stringWithFormat:@"%@%d%d",nianyueriStr,num1,num2];
    recharge_number = recharge_numberStr;
    
    
        NSString *dJson = nil;
    
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"recharge_number\":\"%@\",\"conf_recharge_id\":\"%@\",\"recharge_amount\":\"%@\",\"recharge_gold\":\"%@\",\"pay_type\":\"%ld\"}",updata_id,token,recharge_numberStr,conf_recharge_id,conf_recharge_amount,conf_recharge_gold,pay_type];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/UserRecharge/do_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          if (pay_type == 1) {
                              
                              [self doAlipayPay];
                          }else if(pay_type == 2){
                              [self payByWeChat];
                          }
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else if (code == -110){
                          //退出登录
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutByService object:nil];
                          
                      }else{
                          //异常处理
                          [JCCYResult showResultWithResult:[NSString stringWithFormat:@"%ld",code] controller:self];

                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];

}


#pragma mark --- 支付宝支付开始 ----
//调用支付宝支付
- (void)doAlipayPay
{
    
    float rmb = [conf_recharge_amount floatValue];
    NSString *rmbStr = [NSString stringWithFormat:@"%.2f", rmb]; //商品价格
    NSString *subjectString = [NSString stringWithFormat:@"梧桐证券%@RMB获得%@金币",conf_recharge_amount,conf_recharge_gold];
    
    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:recharge_number productName:subjectString  productDescription:recharge_number amount:rmbStr notifyURL:kNotifyURL itBPay:@"30m"];
    
}

-(void)aliPayResultAction:(NSNotification *)obj{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[obj object]];
    
    NSString *resultStatus = [dic objectForKey:@"resultStatus"];
    
    if ([resultStatus isEqualToString:@"9000"]) {
        NSLog(@"支付宝支付成功");
        
        JCCYPayStatusQueryViewController *jCCYPayStatusQueryViewController = [[JCCYPayStatusQueryViewController alloc] init];
        jCCYPayStatusQueryViewController.hidesBottomBarWhenPushed = YES;
        jCCYPayStatusQueryViewController.dingDangNumStr = recharge_number;
        jCCYPayStatusQueryViewController.payType = @"1";
        [self.navigationController pushViewController:jCCYPayStatusQueryViewController animated:YES];
        
    }else{
        NSLog(@"支付宝支付失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"支付失败！"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
}

//调用微信支付
-(void)payByWeChat{
    
    [WXApi registerApp:[[NSUserDefaults standardUserDefaults] objectForKey:@"WX_APPID"] withDescription:@"梧桐证券"];
    
    [self getWeChatPayWithOrderName];
}

#pragma mark ---- 微信支付开始
// 调起微信支付，传进来商品名称和价格
- (void)getWeChatPayWithOrderName
{
    
    //----------------------------获取prePayId配置------------------------------
    // 订单标题，展示给用户
    NSString *subjectString = [NSString stringWithFormat:@"梧桐证券%@RMB获得%@金币",conf_recharge_amount,conf_recharge_gold];

    NSString* orderName = subjectString;
    // 订单金额,单位（分）, 1是0.01元
    float rmb = [conf_recharge_amount floatValue]*100;
    NSString *rmbStr = [NSString stringWithFormat:@"%0.f",rmb];
    NSString* orderPrice = rmbStr;
    // 支付类型，固定为APP
    NSString* orderType = @"APP";
    // 随机数串
    NSString *noncestr  = recharge_number;
    // 商户订单号
    NSString *orderNO   = recharge_number;
    
    //================================
    //预付单参数订单设置
    //================================
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    
    [packageParams setObject: WXAppId      forKey:@"appid"];       //开放平台appid
    [packageParams setObject: WXPartnerId  forKey:@"mch_id"];      //商户号
    [packageParams setObject: recharge_number     forKey:@"nonce_str"];   //随机串
    [packageParams setObject: orderType    forKey:@"trade_type"];  //支付类型，固定为APP
    [packageParams setObject: orderName    forKey:@"body"];        //订单描述，展示给用户
    [packageParams setObject: orderNO      forKey:@"out_trade_no"];//商户订单号
    [packageParams setObject: orderPrice   forKey:@"total_fee"];   //订单金额，单位为分
    [packageParams setObject: [CommonUtil getIPAddress:YES] forKey:@"spbill_create_ip"];//发器支付的机器ip
    [packageParams setObject: @"http://wutong.jingchengidea.com/Api/UserRechargeReturn/weixin_return/"  forKey:@"notify_url"];  //支付结果异步通知
    NSString *prePayid;
    
    prePayid = [self sendPrepay:packageParams];
    //---------------------------获取prePayId结束------------------------------
    
    
    if(prePayid){
        NSString *timeStamp = [self genTimeStamp];
        // 调起微信支付
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = WXPartnerId;
        request.prepayId = prePayid;
        request.package = @"Sign=WXPay";
        request.nonceStr = noncestr;
        request.timeStamp = [timeStamp intValue];
        
        // 这里要注意key里的值一定要填对， 微信官方给的参数名是错误的，不是第二个字母大写
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: WXAppId               forKey:@"appid"];
        [signParams setObject: WXPartnerId           forKey:@"partnerid"];
        [signParams setObject: request.nonceStr      forKey:@"noncestr"];
        [signParams setObject: request.package       forKey:@"package"];
        [signParams setObject: timeStamp             forKey:@"timestamp"];
        [signParams setObject: request.prepayId      forKey:@"prepayid"];
        
        //生成签名
        NSString *sign  = [self genSign:signParams];
        
        //添加签名
        request.sign = sign;
        
        [WXApi sendReq:request];
        
        
    } else{
        NSLog(@"获取prePayId失败！");
    }
    
}

// 发送给微信的XML格式数据
- (NSString *)genPackage:(NSMutableDictionary*)packageParams
{
    NSString *sign;
    NSMutableString *reqPars = [NSMutableString string];
    
    // 生成签名
    sign = [self genSign:packageParams];
    
    // 生成xml格式的数据, 作为post给微信的数据
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>"
         , categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign></xml>", sign];
    
    return [NSString stringWithString:reqPars];
}




// 获取prePayId
- (NSString *)sendPrepay:(NSMutableDictionary *)prePayParams
{
    
    // 获取提交预支付的xml格式数据
    NSString *send = [self genPackage:prePayParams];
    // 打印检查， 格式应该是xml格式的字符串
    NSLog(@"%@", send);
    
    // 转换成NSData
    /** 获取prePayId的url, 这是官方给的接口 */
    NSString * const getPrePayIdUrl = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
    NSData *data_send = [send dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:getPrePayIdUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data_send];
    
    NSError *error = nil;
    // 拿到data后, 用xml解析， 这里随便用什么方法解析
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (!error) {
        // 1.根据data初始化一个GDataXMLDocument对象
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        // 2.拿出根节点
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *return_code = [[rootElement elementsForName:@"return_code"] lastObject];
        GDataXMLElement *return_msg = [[rootElement elementsForName:@"return_msg"] lastObject];
        GDataXMLElement *result_code = [[rootElement elementsForName:@"result_code"] lastObject];
        GDataXMLElement *prepay_id = [[rootElement elementsForName:@"prepay_id"] lastObject];
        // 如果return_code和result_code都为SUCCESS, 则说明成功
        NSLog(@"return_code---%@", [return_code stringValue]);
        // 返回信息，通常返回一些错误信息
        NSLog(@"return_msg---%@", [return_msg stringValue]);
        NSLog(@"result_code---%@", [result_code stringValue]);
        // 拿到这个就成功一大半啦
        NSLog(@"prepay_id---%@", [prepay_id stringValue]);
        
        return [prepay_id stringValue];
    } else {
        return nil;
    }
}

#pragma mark - 生成各种参数

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

/**
 * 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"myt_%@", [self genTimeStamp]];
}

- (NSString *)genOutTradNo
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}


#pragma mark - 签名
/** 签名 */
- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序, 因为微信规定 ---> 参数名ASCII码从小到大排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //生成 ---> 微信规定的签名格式
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    // 拼接API密钥
    NSString *result = [NSString stringWithFormat:@"%@&key=%@", signString, WXPayKey];
    // 打印检查
    NSLog(@"result = %@", result);
    // md5加密
    NSString *signMD5 = [CommonUtil md5:result];
    // 微信规定签名英文大写
    signMD5 = signMD5.uppercaseString;
    // 打印检查
    NSLog(@"signMD5 = %@", signMD5);
    return signMD5;
}


#pragma mark ---- 微信支付 end
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
