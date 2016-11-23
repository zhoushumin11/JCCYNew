//
//  YXMainViewController.m
//  YXRollView
//
//  Created by 风中的少年 on 15/9/8.
//  Copyright (c) 2015年 风中的少年. All rights reserved.
//
#define DCScreenW    [UIScreen mainScreen].bounds.size.width
#define DCScreenH    [UIScreen mainScreen].bounds.size.height

#import "PPYXMainViewController.h"
#import "PPSXTitleLable.h"



@interface PPYXMainViewController ()<UIScrollViewDelegate>
/// 标签的滚动label
@property (weak, nonatomic) UIScrollView *smallScview;
/// 显示视图的滚动view
@property (nonatomic,assign) CGFloat beginOffsetX;

@property(nonatomic,strong)NSArray *VCArr;
@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, weak) UILabel *shangyigetitlelabel;

@end

@implementation PPYXMainViewController

-(instancetype)initWithSubViewControllers:(NSArray *)subViewControllers
{
    if(self = [super init])
    {
        _VCArr = subViewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScview.showsHorizontalScrollIndicator = NO;
    self.smallScview.showsVerticalScrollIndicator = NO;
    [self addLable];
    [self addVCView];
    
    PPSXTitleLable *lable = [self.smallScview.subviews firstObject];
    lable.scale = 1.0;
}

-(void)addVCView
{

    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, DCScreenW, DCScreenH -44)];
    self.contentView = contentView;
    self.contentView.bounces = NO;
    contentView.delegate = self;
    contentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentView];
    
    NSUInteger count = self.VCArr.count;
    for (int i=0; i<count; i++) {
        UIViewController *vc = self.VCArr[i];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i*DCScreenW, 0, DCScreenW, DCScreenH -44);
        [contentView addSubview:vc.view];
    }
    contentView.contentSize = CGSizeMake(count*DCScreenW, DCScreenH-44);
    contentView.pagingEnabled = YES;
}


/** 添加标题栏 */
- (void)addLable
{
    NSString *titleAll = @"";
    
    CGFloat titleWidth = 10*self.VCArr.count;
    
    for (int j = 0; j < self.VCArr.count; j++) {
        UIViewController *vc = self.VCArr[j];
        NSString *string = vc.title;
        titleAll = [titleAll stringByAppendingString:string];
    }
    
    CGSize size1 =[titleAll sizeWithAttributes:@{NSFontAttributeName:SystemFont(16)}];

    titleWidth = titleWidth + size1.width;
    
    UIScrollView *smallScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PPMainViewWidth,44)];
    
    smallScrollView.showsHorizontalScrollIndicator = NO;
    smallScrollView.showsVerticalScrollIndicator = NO;
    smallScrollView.backgroundColor = [UIColor colorFromHexRGB:@"f9f9f9"];
    self.smallScview = smallScrollView;
    self.smallScview.bounces = NO;
    
    [self.view addSubview:smallScrollView];
    CGFloat lblX = 20;
    ///这里可以修改标签的个数
    for (int i = 0; i < self.VCArr.count; i++) {
        UIViewController *vc = self.VCArr[i];
        
        NSString *string = vc.title;
        CGSize size = GetWTextSizeFont(string, 40, 18);

        
        CGFloat lblW = size.width;
        CGFloat lblH = 40;
        PPSXTitleLable *lbl1 = [[PPSXTitleLable alloc]init];
        lbl1.frame = CGRectMake(lblX, 0, lblW, lblH);

        if (i == 0) {
            lblX = lblX + lbl1.frame.size.width+5;
        }else{
            lblX = lblX + lbl1.frame.size.width;

        }
        
        lbl1.text =vc.title;
        lbl1.font = SystemFont(16);
        [self.smallScview addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    UILabel *linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.smallScview.bounds.size.height-1, self.smallScview.bounds.size.width, 1)];
    linelabel.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    [self.smallScview addSubview:linelabel];
    self.smallScview.contentSize = CGSizeMake(titleWidth+20, 0);
    
    
}

/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    PPSXTitleLable *titlelable = (PPSXTitleLable *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.contentView.frame.size.width;
    
    CGFloat offsetY = self.contentView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.contentView setContentOffset:offset animated:YES];
    
    
}

#pragma mark - ******************** scrollView代理方法

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentView.frame.size.width;
    //发送改变通知
    NSString *indexString = [NSString stringWithFormat:@"%li",index];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexString,@"index", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YXMainViewControllerAction" object:dic];

    if (self.VCArr.count <= 5) {

    }else{
        // 滚动标题栏
        
        if (index == 0) {
            PPSXTitleLable *titleLable = (PPSXTitleLable *)self.smallScview.subviews[index];
            CGFloat offsetx = titleLable.center.x - self.smallScview.frame.size.width * 0.5;
            CGFloat offsetMax = self.smallScview.contentSize.width - self.smallScview.frame.size.width;
            if (offsetx < 0) {
                offsetx = 0;
            }else if (offsetx > offsetMax){
                offsetx = offsetMax;
            }
            CGPoint offset = CGPointMake(offsetx, self.smallScview.contentOffset.y);
            [self.smallScview setContentOffset:offset animated:YES];
        }else{
            PPSXTitleLable *titleLable = (PPSXTitleLable *)self.smallScview.subviews[index];
            CGFloat offsetx = titleLable.center.x - self.smallScview.frame.size.width * 0.5;
            CGFloat offsetMax = self.smallScview.contentSize.width - self.smallScview.frame.size.width;
            if (offsetx < 0) {
                offsetx = 0;
            }else if (offsetx > offsetMax){
                offsetx = offsetMax;
            }
            CGPoint offset = CGPointMake(offsetx+20, self.smallScview.contentOffset.y);
            [self.smallScview setContentOffset:offset animated:YES];
        }
        
 
    }

    
    // 添加控制器
    UIViewController *newsVc = self.VCArr[index];
    if (newsVc.view.superview) return;
    newsVc.view.frame = scrollView.bounds;
    [self.contentView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YXMainViewControllerActioning" object:nil];
    
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    PPSXTitleLable *labelLeft = self.smallScview.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    
    if (rightIndex < self.VCArr.count) {
        PPSXTitleLable *labelRight = self.smallScview.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}

@end
