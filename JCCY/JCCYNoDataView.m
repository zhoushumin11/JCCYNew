//
//  JCCYNoDataView.m
//  JCCY
//
//  Created by 周书敏 on 2016/12/1.
//
//

#import "JCCYNoDataView.h"

@implementation JCCYNoDataView

@synthesize imgBtn,nodataLabel;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        imgBtn = [[UIButton alloc] init];
        nodataLabel = [[UILabel alloc] init];
        
        [imgBtn setImage:[UIImage imageNamed:@"default_noDataImg"] forState:UIControlStateNormal];
        [imgBtn setImage:[UIImage imageNamed:@"default_noDataImg"] forState:UIControlStateHighlighted];
        imgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 30, 15);
        [imgBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imgBtn];
        
        nodataLabel.textColor = [UIColor grayColor];
        nodataLabel.text = @"暂无数据";
        nodataLabel.font = [UIFont boldSystemFontOfSize:18];
        nodataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nodataLabel];
    }
    
    return self;
}
-(void)buttonAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATA_MYViews object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    imgBtn.frame = CGRectMake(15, 15, self.frame.size.width-30, self.frame.size.height-30);
    nodataLabel.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
}

@end
