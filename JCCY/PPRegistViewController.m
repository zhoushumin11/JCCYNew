//
//  PPRegistViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/20.
//
//

#import "PPRegistViewController.h"
#import "EYInputPopupView.h"
#import "EYTextPopupView.h"

#import "AppDelegate.h"

@interface PPRegistViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

{
    NSTimer *timer;
    NSInteger seconds;
}
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIView *tapbackView;
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *getYanZhengBtn;

@end

@implementation PPRegistViewController
@synthesize mainView,tapbackView,phoneNumberField,passwordField,getYanZhengBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"会员设置";
    
    mainView = [[UIScrollView alloc] initWithFrame:PPMainFrame];
    mainView.backgroundColor = [UIColor colorFromHexRGB:@"f4f4f4"];
    mainView.scrollEnabled = NO;
    [self.view addSubview:mainView];
    

    
    //输入手机号
    phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, PPMainViewWidth, 50)];
    phoneNumberField.center = CGPointMake(PPMainViewWidth/2, 40);
    phoneNumberField.placeholder = @"+86";
    phoneNumberField.keyboardType = UIKeyboardTypeASCIICapable;
    phoneNumberField.delegate = self;
    phoneNumberField.tag = 102;
    phoneNumberField.backgroundColor = [UIColor whiteColor];
    phoneNumberField.returnKeyType = UIReturnKeyNext;
    [phoneNumberField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [phoneNumberField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    phoneNumberField.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
    [mainView addSubview:phoneNumberField];
    
    UILabel *phoneNumberName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    phoneNumberName.textColor = [UIColor grayColor];
    phoneNumberName.textAlignment = NSTextAlignmentCenter;
    phoneNumberName.text = @"手机号";
    phoneNumberName.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    
    
    phoneNumberField.leftView = phoneNumberName;
    phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    phoneNumberField.text = @"";
    
    
    //输入密码框
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 91, PPMainViewWidth, 50)];
    passwordField.center = CGPointMake(PPMainViewWidth/2, 90);
//    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"请输入您收到的验证码";
    passwordField.tag = 123456;
    passwordField.delegate = self;
    passwordField.backgroundColor = [UIColor whiteColor];
    [passwordField.layer setMasksToBounds:YES];
    passwordField.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
    passwordField.returnKeyType = UIReturnKeyGo;
    //    passwordField.font = SystemFont(15);
    passwordField.text = @"";// 123456
    UILabel *passwordName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    passwordName.textColor = [UIColor grayColor];
    passwordName.textAlignment = NSTextAlignmentCenter;
    passwordName.text = @"验证码";
    passwordName.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    
    passwordField.leftView = passwordName;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    [mainView addSubview:passwordField];
    
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, phoneNumberField.frame.origin.y + 50, PPMainViewWidth - 20, 0.3)];
    lineLabel.backgroundColor = [UIColor grayColor];
    [mainView addSubview:lineLabel];
    
    //获取验证码的button
    getYanZhengBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getYanZhengBtn.frame = CGRectMake(PPMainViewWidth - 110, phoneNumberField.frame.origin.y + 5, 100, 40);
    [getYanZhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getYanZhengBtn setTitleColor:[UIColor colorFromHexRGB:@"e56357"] forState:UIControlStateNormal];
    getYanZhengBtn.layer.masksToBounds = YES;
    getYanZhengBtn.layer.borderWidth = 1;
    [getYanZhengBtn.layer setCornerRadius:3];
    getYanZhengBtn.layer.borderColor=[UIColor colorFromHexRGB:@"e56357"].CGColor;
    [getYanZhengBtn addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:getYanZhengBtn];
    
    //绑定 button
    UIButton *bangdingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bangdingBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    bangdingBtn.frame = CGRectMake(35, 220, PPMainViewWidth-70, 45);
    bangdingBtn.center = CGPointMake(PPMainViewWidth/2, 170);
    
    [bangdingBtn.layer setMasksToBounds:YES];
    [bangdingBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    bangdingBtn.backgroundColor = [UIColor colorFromHexRGB:@"e60013"];
    [bangdingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bangdingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bangdingBtn addTarget:self action:@selector(bangdingPhone) forControlEvents:UIControlEventTouchUpInside];
    //    @selector(login)
    [mainView addSubview:bangdingBtn];
    



}

-(void)sendSMS{
    
    if (phoneNumberField.text.length == 0 ||phoneNumberField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeDefault];
    
    NSString *dJson = nil;
    @autoreleasepool {
        //得到自己当前的下属
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"phone\":\"%@\"}",87,token,phoneNumberField.text];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/User/send_code_phone/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          [WSProgressHUD showSuccessWithStatus:@"发送成功"];
                          [WSProgressHUD autoDismiss:2];
                          
                      }else{
                          [WSProgressHUD dismiss];
                          NSString *msg = [json objectForKey:@"info"];
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                          alert.tag = 20161122;
                          alert.delegate = self;
                          [alert show];
                      }
                  }
                      failedBlock:^(NSError *error) {
                          
                      }];
    }
    
    seconds = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 20161122) {
        if (buttonIndex == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel setupViewControllers];
        }
    }
}


-(void)bangdingPhone{
    if (phoneNumberField.text.length == 0 ||phoneNumberField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if (passwordField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    //绑定手机号
    
    NSString *dJson = nil;
    @autoreleasepool {
        //得到自己当前的下属
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"phone\":\"%@\",\"code\":\"%@\"}",87,token,phoneNumberField.text,passwordField.text];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/User/bind_code_phone/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          [WSProgressHUD showSuccessWithStatus:@"绑定成功"];
                          [WSProgressHUD autoDismiss:2];
                          //保存绑定信息
                          [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isBangding"];
                          
                          [self.navigationController popViewControllerAnimated:YES];
                      }else{
                          NSString *msg = [json objectForKey:@"info"];
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                          [alert show];
                      }
                  }
                      failedBlock:^(NSError *error) {
                          
                    }];
    }

    
}


//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        [getYanZhengBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
        [getYanZhengBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [getYanZhengBtn setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"%ld s",seconds];
        [getYanZhengBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [getYanZhengBtn setEnabled:NO];
        [getYanZhengBtn setTitle:title forState:UIControlStateNormal];
    }
}
//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                seconds = 60;
            }
        }
    }
}

-(void)dealloc{
    [timer invalidate];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 102) {
        [textField resignFirstResponder];
        [passwordField becomeFirstResponder];
    }else if(textField.tag == 123456){
        [self bangdingPhone];
    }
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
