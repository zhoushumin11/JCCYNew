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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResultAction:) name:JCCYAliPayNotificationCenter object:nil];
    
    //支付类型 默认支付宝
    pay_type = 1;
    //获取充值数据
    [self getChongZhiStatus];

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
            [btn.layer setBorderWidth:1.0];
            btn.layer.borderColor=[UIColor redColor].CGColor;
        }else{
            imageView.image = [UIImage imageNamed:@""];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.layer setBorderWidth:0];
            btn.layer.borderColor=[UIColor whiteColor].CGColor;
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
    
    payView = [[UIView alloc] initWithFrame:CGRectMake(10,buttonsView.frame.origin.y+ buttonsView.frame.size.height, PPMainViewWidth-20, 120)];
    payView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:payView];
    
    //确定 button
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quedingBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    quedingBtn.frame = CGRectMake(35, payView.frame.origin.y + payView.frame.size.height+30, PPMainViewWidth-70, 45);
    
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
    
    //创建充值说明view
    if (chongZhiShuoMingView==nil) {
        [self creatChongZhiShuoMingView];
    }
    
}

//创建支付
-(void)creatChongZhiShuoMingView{
    
    NSString *CHONGZHI_CONTENT = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHONGZHI_CONTENT"];

    CGSize size = GetHTextSizeFont(CHONGZHI_CONTENT, PPMainViewWidth-20, 14);
    
    chongZhiShuoMingView  = [[UIView alloc] initWithFrame:CGRectMake(10, payView.frame.origin.y + payView.frame.size.height+30+50, PPMainViewWidth - 20, size.height + 50)];
    
    chongZhiShuoMingView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:chongZhiShuoMingView];
    
    UILabel *chongzhishuominLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth-20, 30)];
    chongzhishuominLabel.text  = @"充值说明：";
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
    
    
    [mainScrollView setContentSize:CGSizeMake(PPMainViewWidth, payView.frame.origin.y + buttonsView.frame.origin.y + chongZhiShuoMingView.frame.origin.y + 10 + 20 + 30)];

    
    
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
    
    if (pay_type == 1) {
//        [self doAlipayPay];
        return;
    }else if(pay_type == 2){
        [self payByWeChat];
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
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"recharge_number\":\"%@\",\"conf_recharge_id\":\"%@\",\"recharge_amount\":\"%@\",\"recharge_gold\":\"%@\",\"pay_type\":\"%ld\"}",87,token,recharge_numberStr,conf_recharge_id,conf_recharge_amount,conf_recharge_gold,pay_type];
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
                          
                      }else{
                          //异常处理
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];

}


//调用支付宝支付
- (void)doAlipayPay
{

    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ALIPAY_APPID"];
    NSString *privateKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"ALIPAY_PRIVATE"];
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = recharge_number; //订单信息
    NSString *subjectString = [NSString stringWithFormat:@"梧桐证券%@RMB获得%@金币",conf_recharge_amount,conf_recharge_gold];
    order.biz_content.subject = subjectString; // 显示在支付宝里面的订单信息
    order.biz_content.out_trade_no = recharge_number; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    float rmb = [conf_recharge_amount floatValue];
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", rmb]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"com.jingchengkeji.wtband.ios";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSDictionary *datadic = [NSDictionary dictionaryWithDictionary:resultDic];
            NSLog(@"%@",datadic);
        }];
    }
}

-(void)aliPayResultAction:(NSNotification *)obj{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[obj object]];
    
    NSString *resultStatus = [dic objectForKey:@"resultStatus"];
    
    if ([resultStatus isEqualToString:@"9000"]) {
        NSLog(@"支付宝支付成功");
        
        JCCYPayStatusQueryViewController *jCCYPayStatusQueryViewController = [[JCCYPayStatusQueryViewController alloc] init];
        jCCYPayStatusQueryViewController.hidesBottomBarWhenPushed = YES;
        jCCYPayStatusQueryViewController.dingDangNumStr = recharge_number;
        [self.navigationController pushViewController:jCCYPayStatusQueryViewController animated:YES];
        
    }else{
        NSLog(@"支付宝支付失败");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"支付失败！"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        JCCYPayStatusQueryViewController *jCCYPayStatusQueryViewController = [[JCCYPayStatusQueryViewController alloc] init];
        jCCYPayStatusQueryViewController.hidesBottomBarWhenPushed = YES;
        jCCYPayStatusQueryViewController.dingDangNumStr = recharge_number;
        jCCYPayStatusQueryViewController.payType = [NSString stringWithFormat:@"%ld",pay_type];
        [self.navigationController pushViewController:jCCYPayStatusQueryViewController animated:YES];
    }
    
}

//调用微信支付
-(void)payByWeChat{
    
    [WXApi registerApp:[[NSUserDefaults standardUserDefaults] objectForKey:@"WX_APPID"] withDescription:@"梧桐证券"];

    
    [self wxpay];
}
//微信支付
- (void)wxpay
{
    [self weixin];
}

-(void)weixin{
    
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
    
    dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"recharge_number\":\"%@\",\"conf_recharge_id\":\"%@\",\"recharge_amount\":\"%@\",\"recharge_gold\":\"%@\",\"pay_type\":\"%ld\"}",87,token,recharge_numberStr,conf_recharge_id,conf_recharge_amount,conf_recharge_gold,pay_type];
    //获取类型接
    PPRDData *pprddata1 = [[PPRDData alloc] init];
    [pprddata1 startAFRequest:@"/index.php/Api/UserRecharge/do_ios_wx_recharge/"
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
                      
                  }else{
                      //异常处理
                  }
                  
              } failedBlock:^(NSError *error) {
                  
              }];
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
    NSString *noncestr  = [self genNonceStr];
    // 商户订单号
    NSString *orderNO   = [self genOutTradNo];
    
    //================================
    //预付单参数订单设置
    //================================
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    
    [packageParams setObject: WXAppId      forKey:@"appid"];       //开放平台appid
    [packageParams setObject: WXPartnerId  forKey:@"mch_id"];      //商户号
    [packageParams setObject: recharge_number     forKey:@"nonce_str"];   //随机串
    [packageParams setObject: orderType    forKey:@"trade_type"];  //支付类型，固定为APP
    [packageParams setObject: orderName    forKey:@"body"];        //订单描述，展示给用户
    [packageParams setObject: recharge_number      forKey:@"out_trade_no"];//商户订单号
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
    NSString *result = [NSString stringWithFormat:@"%@&key=%@", signString, WXAppId];
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
