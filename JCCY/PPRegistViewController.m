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

@interface PPRegistViewController ()<UITextFieldDelegate>
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
    phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    [mainView addSubview:getYanZhengBtn];
    
    //登录 button
    UIButton *login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    login.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    login.frame = CGRectMake(35, 220, PPMainViewWidth-70, 45);
    login.center = CGPointMake(PPMainViewWidth/2, 170);
    
    [login.layer setMasksToBounds:YES];
    [login.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    login.backgroundColor = [UIColor colorFromHexRGB:@"e60013"];
    [login setTitle:@"绑定" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    //    @selector(login)
    [mainView addSubview:login];
    



}

-(void)backAction{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
