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

@property(nonatomic,assign) NSString *conf_recharge_id; //当前充值金额类型id


@property(nonatomic,strong) NSMutableArray *dataArray;



@end

@implementation JCCYChongZhiViewController

@synthesize dataArray,mainScrollView,buttonsView,conf_recharge_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线充值";
    
    dataArray = [NSMutableArray array];
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
    
    float viewY = (dataArray.count/3+1) *(PPMainViewWidth/3) +(dataArray.count * 10);
    
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
}

#pragma mark --- 充值金额类型按钮点击事件 -- 
-(void)typeBtnAction:(UIButton *)btn{
    NSInteger btnTag = btn.tag;
    conf_recharge_id = [[dataArray objectAtIndex:btnTag] objectForKey:@"conf_recharge_id"];
    [self creatButtons:btnTag];
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
