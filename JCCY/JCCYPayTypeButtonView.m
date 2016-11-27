//
//  JCCYPayTypeButtonView.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/27.
//
//

#import "JCCYPayTypeButtonView.h"

@implementation JCCYPayTypeButtonView

@synthesize appSelectdelegate,selectdeletebtnList;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectdeletebtnList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)createView:(NSMutableArray *)tabList integer:(NSInteger)integer
{
    [selectdeletebtnList removeAllObjects];
    NSInteger xindex = 0;
    NSInteger yindex = 0;
    NSInteger tabw = (self.bounds.size.width-50)/3;
    NSInteger tabh = (self.bounds.size.width-50)/3;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for(int i=0;i<tabList.count;i++){//tabList.count
        xindex = i%3;  //当前x轴位置
        yindex = i/3;  //当前y轴位置
        
        NSLog(@"%li",yindex);
        
        NSMutableDictionary *tabdict = [tabList objectAtIndex:i];
        NSString *tabimgname = [tabdict objectForKey:@"tabimgname"];
        NSString *tabtitle = [tabdict objectForKey:@"tabtitle"];
        NSInteger tabtag = [[tabdict objectForKey:@"tabtag"] integerValue];
        
        UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(10+15*xindex+tabw*xindex, 10+15*yindex+tabh*yindex, tabw, tabh)];
        tabView.clipsToBounds = YES;
        tabView.layer.cornerRadius = 5;
        //        tabView.backgroundColor = [UIColor colorFromHexRGB:@"18900f"];
        //        tabView.backgroundColor = [UIColor grayColor];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, tabView.bounds.size.width - 20, tabView.bounds.size.width - 20)];
        
        UILabel *titlelable = [[UILabel alloc] initWithFrame:CGRectMake(10, 8+tabView.bounds.size.height -30, imageview.bounds.size.width, 15)];
        titlelable.textAlignment = NSTextAlignmentCenter;
        titlelable.font = [UIFont systemFontOfSize:12];
        titlelable.textColor = [UIColor blackColor];
        
        imageview.image = [UIImage imageNamed:tabimgname];
        titlelable.text = tabtitle;
        
        [tabView addSubview:imageview];
        [tabView addSubview:titlelable];
        
        [self addSubview:tabView];

        UIButton *tabbtn = [UIButton buttonWithType:UIButtonTypeCustom];//按下按钮
        [tabbtn setFrame:CGRectMake(10+15*xindex+tabw*xindex, 20+15*yindex+tabh*yindex, tabw, tabh)];
        tabbtn.tag = tabtag;
        [tabbtn addTarget:self action:@selector(selectAppbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tabbtn];
        
        
        UIButton *selectdeletebtn = [UIButton buttonWithType:UIButtonTypeCustom];//按下按钮
        [selectdeletebtn setFrame:CGRectMake(10+15*xindex+tabw*xindex, 20+15*yindex+tabh*yindex, tabw, tabh)];
        selectdeletebtn.tag = tabtag;
        [selectdeletebtn addTarget:self action:@selector(selectdeleteAppBtn:) forControlEvents:UIControlEventTouchUpInside];
        selectdeletebtn.hidden = YES;
        [self addSubview:selectdeletebtn];
        [selectdeletebtnList setObject:selectdeletebtn forKey:[NSNumber numberWithInteger:tabtag]];

        selectdeletebtn.hidden = NO;
        [selectdeletebtn setImage:[UIImage imageNamed:@"JCCY_YiXuan"] forState:UIControlStateNormal];
        tabbtn.hidden = YES;
        tabbtn.enabled = NO;
       
        
    }
    
    [self setContentSize:CGSizeMake(self.bounds.size.width, 20+15+tabh)];
    
}
- (void)selectdeleteAppBtn:(UIButton *)btn{
    if ([appSelectdelegate respondsToSelector:@selector(selectdeleteAppbtn:)]) {
        [appSelectdelegate selectdeleteAppbtn:btn.tag];
    }
}
- (void)selectAppbtn:(UIButton *)btn
{
    if ([appSelectdelegate respondsToSelector:@selector(selectAppbtn:)]) {
        [appSelectdelegate selectAppbtn:btn.tag];
    }
}

@end
