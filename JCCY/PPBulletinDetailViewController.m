//
//  PPBulletinDetailViewController.m
//  ParkProject
//
//  Created by 周书敏 on 16/8/3.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#define DOWNLOADFILE @"DOWNLOADFILE"

#import "PPBulletinDetailViewController.h"


@interface PPBulletinDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIScrollViewDelegate>

{
    UIView *webBrowserView;
    float dragging;
    UIImageView *navBarHairlineImageView;

}

@property(nonatomic,strong) UIWebView *webview;



@end
@implementation PPBulletinDetailViewController

UIActivityIndicatorView  *activityIndicator;

@synthesize documentPath,webview;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

    documentPath = [documentPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    [self createWEBView];
}



-(void)createWEBView
{
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewHeight-64)];
    webview.scrollView.scrollEnabled = YES;
    webview.backgroundColor = [UIColor whiteColor];
    webview.scalesPageToFit =NO;
    webview.delegate =self;
    webview.scrollView.delegate = self;
    webview.scrollView.bounces=NO;


    [self.view addSubview:webview];
    

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:documentPath]];
    [webview loadRequest:urlRequest];
}





#pragma mark webview loading animation
-(void)webViewDidStartLoad:(UIWebView *)webView
{

    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    [activityIndicator setCenter:self.view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
}

-(void)fileButtonAction:(UIButton *)btn{
    if ([webview subviews]) {
        
        NSInteger height = [[webview stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
        NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %ld);", height];
        [webview stringByEvaluatingJavaScriptFromString:javascript];
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float a = scrollView.contentOffset.y;
    if (a < 120) {
        self.title = @"";
    }else{
        self.title = self.titleStr;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dragging = scrollView.contentOffset.y;
}


#pragma mark -UIWebViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    
}


- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
