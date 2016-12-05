//
//  HomeNormalCell.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/23.
//
//

#import "HomeNormalCell.h"

@implementation HomeNormalCell
@synthesize h_titleLabel,allcontentView,lineLabel;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        allcontentView = [[UIView alloc] init];
        h_titleLabel = [[UILabel alloc] init];
        
        
        allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:allcontentView];
        
        h_titleLabel.textColor = [UIColor blackColor];
//        h_titleLabel.font = SystemFont(15);
        h_titleLabel.font = [UIFont systemFontOfSize:18];
        
        h_titleLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:h_titleLabel];
        
        lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = [UIColor colorFromHexRGB:@"d9d9d9"];
        [allcontentView addSubview:lineLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    h_titleLabel.frame = CGRectMake(10, 0, self.bounds.size.width-30,self.frame.size.height);
    lineLabel.frame = CGRectMake(10, 0.5, self.frame.size.width-20, 0.5);
}


@end
