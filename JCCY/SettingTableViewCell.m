//
//  SettingTableViewCell.m
//  ParkProject
//
//  Created by yuanxuan on 16/8/1.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

@synthesize allcontentView,iConView,settingTitleLabel,allViewBtn;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iConView = [[UIButton alloc] init];
        self.allcontentView = [[UIView alloc] init];
        self.settingTitleLabel = [[UILabel alloc] init];
        allViewBtn = [[UIButton alloc] init];
        
        //        progressView.hidden = no;
        
        self.allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.allcontentView];
        
        
        self.iConView.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.allcontentView addSubview:self.iConView];
        
        
        
        // 内容
        self.settingTitleLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
//        self.settingTitleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
        self.settingTitleLabel.font = [UIFont systemFontOfSize:16];
        self.settingTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.allcontentView addSubview:self.settingTitleLabel];
        
        [allViewBtn setBackgroundColor:[UIColor clearColor]];
        [self.allcontentView addSubview:allViewBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.iConView.frame = CGRectMake(10, 5, 50, 50);
    self.settingTitleLabel.frame = CGRectMake(60, 0, self.frame.size.width-50, self.frame.size.height-0.5);
    allViewBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
