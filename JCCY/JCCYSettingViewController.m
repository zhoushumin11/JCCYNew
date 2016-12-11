//
//  JCCYSettingViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/24.
//
//

#import "JCCYSettingViewController.h"
#import "PPRegistViewController.h"
#import "UIButton+WebCache.h"

@interface JCCYSettingViewController ()<UIAlertViewDelegate>


@property(nonatomic,strong) UILabel *huancunLabel;
@property(nonatomic,strong) UILabel *mobileLabel;
@property(nonatomic,strong) UIButton *bangdingBtn;


@end

@implementation JCCYSettingViewController

@synthesize mobileLabel,bangdingBtn,huancunLabel;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSString *mobileStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_phone"];
    if (mobileStr == nil || mobileStr.length == 0 || [mobileStr isEqualToString:@"0"]) {
        mobileLabel.text = @"未绑定";
    }else{
        mobileLabel.text = mobileStr;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    self.title = @"会员设置";
    
    UIView *settingView = [[UIView alloc] initWithFrame:CGRectMake(0, 10+64, PPMainViewWidth, 180)];
    settingView.backgroundColor = [UIColor whiteColor];
    
    UILabel *shoujihaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,80, 60)];
    shoujihaoLabel.textColor = [UIColor grayColor];
    shoujihaoLabel.text = @"手机号";
    shoujihaoLabel.font = [UIFont systemFontOfSize:18];
    [settingView addSubview:shoujihaoLabel];
    
    mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0,200, 60)];
    mobileLabel.textColor = [UIColor blackColor];
    NSString *mobileStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_phone"];
    [settingView addSubview:mobileLabel];
    
    bangdingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bangdingBtn.frame = CGRectMake(PPMainViewWidth - 80, 12, 70, 35);
    [bangdingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bangdingBtn setTitleColor:[UIColor colorFromHexRGB:@"e56357"] forState:UIControlStateNormal];
    bangdingBtn.layer.masksToBounds = YES;
    bangdingBtn.layer.borderWidth = 1;
    [bangdingBtn.layer setCornerRadius:3];
    bangdingBtn.layer.borderColor=[UIColor colorFromHexRGB:@"e56357"].CGColor;
    [bangdingBtn addTarget:self action:@selector(bangdingAction) forControlEvents:UIControlEventTouchUpInside];
    [settingView addSubview:bangdingBtn];

    
    if (mobileStr == nil || mobileStr.length == 0 || [mobileStr isEqualToString:@"0"]) {
        mobileLabel.text = @"未绑定";
    }else{
        mobileLabel.text = mobileStr;
    }
    
    
    //缓存
    UILabel *huancunTLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60,80, 60)];
    huancunTLabel.textColor = [UIColor grayColor];
    huancunTLabel.text = @"清空缓存";
    huancunTLabel.font = [UIFont systemFontOfSize:18];
    [settingView addSubview:huancunTLabel];
    
    huancunLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60,200, 60)];
    huancunLabel.textColor = [UIColor blackColor];
    
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    NSString *sizeStr = [self getDataSizeString:size];
    huancunLabel.text = sizeStr;
    [settingView addSubview:huancunLabel];
    
    UIButton *clearHuancunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearHuancunBtn.frame = CGRectMake(0, 60, PPMainViewWidth, 60);
    [clearHuancunBtn setBackgroundColor:[UIColor clearColor]];
    [clearHuancunBtn addTarget:self action:@selector(clearTmpPics) forControlEvents:UIControlEventTouchUpInside];
    [settingView addSubview:clearHuancunBtn];
    
    
    //版本
    UILabel *banbenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120,80, 60)];
    banbenLabel.textColor = [UIColor grayColor];
    banbenLabel.text = @"版本";
    banbenLabel.font = [UIFont systemFontOfSize:18];
    [settingView addSubview:banbenLabel];
    
    UILabel *banbenNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 120,200, 60)];
    banbenNumLabel.textColor = [UIColor blackColor];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    banbenNumLabel.text = [NSString stringWithFormat:@"%@.0",appVersion];
    [settingView addSubview:banbenNumLabel];
    
    
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, PPMainViewWidth - 20, 0.3)];
    lineLabel.backgroundColor = [UIColor grayColor];
    [settingView addSubview:lineLabel];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, PPMainViewWidth - 20, 0.3)];
    lineLabel2.backgroundColor = [UIColor grayColor];
    [settingView addSubview:lineLabel2];
    
    [self.view addSubview:settingView];
    
    
    //退出 button
    UIButton *tuichuBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tuichuBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    tuichuBtn.frame = CGRectMake(10, 280, PPMainViewWidth-20, 50);
    [tuichuBtn.layer setMasksToBounds:YES];
    [tuichuBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    tuichuBtn.backgroundColor = [UIColor colorFromHexRGB:@"e60013"];
    [tuichuBtn setTitle:@"退出" forState:UIControlStateNormal];
    [tuichuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tuichuBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tuichuBtn];
    
}

- (void)logout:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTIFACTION object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    
}


#pragma 清理缓存图片
- (void)clearTmpPics
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要清理缓存？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.tag = 20161125;
    [alert show];


}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 20161125) {
        if (buttonIndex == 0) {
            NSUInteger size = [[SDImageCache sharedImageCache] getSize];
            NSString *clearCacheName = [NSString stringWithFormat:@"清除缓存(%@)",[self getDataSizeString:size]];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] cleanDisk];
            [[SDImageCache sharedImageCache] clearDisk];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:clearCacheName delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            //刷新数据
            NSUInteger size1 = [[SDImageCache sharedImageCache] getSize];
            NSString *sizeStr = [self getDataSizeString:size1];
            huancunLabel.text = sizeStr;
        }else{
            return;
        }
    }
    

}

#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(NSUInteger) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%ldB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%ldK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%ldM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%ldMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%ld.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%ldG", nSize/1073741824];
    }
    
    return string;
}


//绑定手机号
-(void)bangdingAction{
    PPRegistViewController *pPRegistViewController = [[PPRegistViewController alloc] init];
    pPRegistViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pPRegistViewController animated:YES];
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
