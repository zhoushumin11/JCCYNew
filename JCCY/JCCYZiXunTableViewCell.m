//
//  JCCYZiXunTableViewCell.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/24.
//
//

#import "JCCYZiXunTableViewCell.h"

@implementation JCCYZiXunTableViewCell

@synthesize h_titleLabel,allcontentView,h_quanxianLabel,h_subtitleLabel;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        allcontentView = [[UIView alloc] init];
        h_titleLabel = [[UILabel alloc] init];
        h_quanxianLabel = [[UILabel alloc] init];
        h_subtitleLabel = [[UILabel alloc] init];

        
        allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:allcontentView];
        
        h_titleLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        h_titleLabel.font = [UIFont systemFontOfSize:16];
        
        h_titleLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:h_titleLabel];
        
        h_subtitleLabel.textColor = [UIColor grayColor];
        h_subtitleLabel.font = [UIFont systemFontOfSize:14];
        h_subtitleLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:h_subtitleLabel];
        
        h_quanxianLabel.textColor = [UIColor colorFromHexRGB:@"ff8a00"];
        h_quanxianLabel.font = [UIFont systemFontOfSize:14];
        h_quanxianLabel.textAlignment = NSTextAlignmentCenter;
        [allcontentView addSubview:h_quanxianLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    h_titleLabel.frame = CGRectMake(8, 2, self.bounds.size.width-25,44);
    h_subtitleLabel.frame = CGRectMake(15,36,80,25);
    h_quanxianLabel.frame = CGRectMake(80, 36,80,25);
    
}

@end
