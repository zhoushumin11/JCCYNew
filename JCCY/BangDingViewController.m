//
//  BangDingViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/12/1.
//
//

#import "BangDingViewController.h"

#import "EYInputPopupView.h"
#import "EYTextPopupView.h"

#import "AppDelegate.h"

@interface BangDingViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

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

@implementation BangDingViewController
@synthesize mainView,tapbackView,phoneNumberField,passwordField,getYanZhengBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"手机绑定";
    
    UILabel *titleLabels = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, 64)];
    titleLabels.backgroundColor = [UIColor colorFromHexRGB:@"e60013"];
    titleLabels.textAlignment = NSTextAlignmentCenter;
    titleLabels.text = @"手机绑定";
    titleLabels.textColor = [UIColor whiteColor];
    titleLabels.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleLabels];
    
    mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, PPMainViewWidth, PPMainViewHeight -64)];
    mainView.backgroundColor = [UIColor colorFromHexRGB:@"f4f4f4"];
    mainView.scrollEnabled = NO;
    [self.view addSubview:mainView];
    
    //输入手机号
    phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, PPMainViewWidth, 50)];
    phoneNumberField.center = CGPointMake(PPMainViewWidth/2, 40);
    phoneNumberField.placeholder = @"+86";
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;

    phoneNumberField.delegate = self;
    phoneNumberField.tag = 654321;
    phoneNumberField.backgroundColor = [UIColor whiteColor];
    phoneNumberField.returnKeyType = UIReturnKeyNext;
    [phoneNumberField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [phoneNumberField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    phoneNumberField.font = [UIFont systemFontOfSize:15];
    [mainView addSubview:phoneNumberField];
    
    UILabel *phoneNumberName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    phoneNumberName.textColor = [UIColor grayColor];
    phoneNumberName.textAlignment = NSTextAlignmentCenter;
    phoneNumberName.text = @"手机号";
    phoneNumberName.font = [UIFont systemFontOfSize:17];
    
    
    phoneNumberField.leftView = phoneNumberName;
    phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    phoneNumberField.text = @"";
    
    
    //输入密码框
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 91, PPMainViewWidth, 50)];
    passwordField.center = CGPointMake(PPMainViewWidth/2, 90);
    //    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"请输入您收到的验证码";
    passwordField.keyboardType = UIKeyboardTypeNumberPad;
    passwordField.tag = 123456;
    passwordField.delegate = self;
    passwordField.backgroundColor = [UIColor whiteColor];
    [passwordField.layer setMasksToBounds:YES];
    passwordField.font = [UIFont systemFontOfSize:15];
    passwordField.returnKeyType = UIReturnKeyGo;
    //    passwordField.font = SystemFont(15);
    passwordField.text = @"";// 123456
    UILabel *passwordName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    passwordName.textColor = [UIColor grayColor];
    passwordName.textAlignment = NSTextAlignmentCenter;
    passwordName.text = @"验证码";
    passwordName.font = [UIFont systemFontOfSize:17];
    
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
    bangdingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    bangdingBtn.frame = CGRectMake(35, 220, PPMainViewWidth-70, 50);
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
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"phone\":\"%@\"}",updata_id,token,phoneNumberField.text];
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
                          seconds = 60;
                          timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }else if (code == -112){
                          //手机号已被绑定
                          NSString *msg = [json objectForKey:@"info"];
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                          alert.tag = 2016;
                          alert.delegate = self;
                          [alert show];
                          return ;
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
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

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
        
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"phone\":\"%@\",\"code\":\"%@\"}",updata_id,token,phoneNumberField.text,passwordField.text];
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
                          [[NSUserDefaults standardUserDefaults] setObject:phoneNumberField.text forKey:@"user_phone"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                          [self dismissViewControllerAnimated:YES completion:nil];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
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
        [getYanZhengBtn setTitleColor:[UIColor colorFromHexRGB:@"e56357"] forState:UIControlStateNormal];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (phoneNumberField == textField || passwordField == textField)
    {
        if (textField.tag == 654321) {
            if ([aString length] > 11) {
                textField.text = [aString substringToIndex:11];
                return NO;
            }
        }else if (textField.tag == 123456){
            if ([aString length] > 4) {
                textField.text = [aString substringToIndex:4];
                return NO;
            }
        }
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
