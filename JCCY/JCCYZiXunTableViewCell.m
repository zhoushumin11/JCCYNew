//
//  JCCYZiXunTableViewCell.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/24.
//
//

#import "JCCYZiXunTableViewCell.h"

@implementation JCCYZiXunTableViewCell

@synthesize h_titleLabel,allcontentView,h_timeLabel,h_subtitleLabel;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        allcontentView = [[UIView alloc] init];
        h_titleLabel = [[UILabel alloc] init];
        h_timeLabel = [[UILabel alloc] init];
        h_subtitleLabel = [[UILabel alloc] init];

        
        allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:allcontentView];
        
        h_titleLabel.textColor = [UIColor blackColor];
        h_titleLabel.font = SystemFont(16);
        h_titleLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:h_titleLabel];
        
        h_subtitleLabel.textColor = [UIColor grayColor];
        h_subtitleLabel.font = SystemFont(14);
        h_subtitleLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:h_subtitleLabel];
        
        h_timeLabel.textColor = [UIColor grayColor];
        h_timeLabel.font = SystemFont(14);
        h_timeLabel.textAlignment = NSTextAlignmentCenter;
        [allcontentView addSubview:h_timeLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    h_titleLabel.frame = CGRectMake(8, 0, self.bounds.size.width-25,44);
    h_subtitleLabel.frame = CGRectMake(15,44,80,25);
    h_timeLabel.frame = CGRectMake(self.frame.size.width - 80, 44,80,25);
    
}

@end
