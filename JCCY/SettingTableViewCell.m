//
//  SettingTableViewCell.m
//  ParkProject
//
//  Created by yuanxuan on 16/8/1.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

@synthesize allcontentView,iConView,settingTitleLabel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iConView = [[UIButton alloc] init];
        self.allcontentView = [[UIView alloc] init];
        self.settingTitleLabel = [[UILabel alloc] init];
        
        //        progressView.hidden = no;
        
        self.allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.allcontentView];
        
        
        self.iConView.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.allcontentView addSubview:self.iConView];
        
        
        // 内容
        self.settingTitleLabel.textColor = [UIColor colorFromHexRGB:@"0a0a0a"];
        self.settingTitleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
        self.settingTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.allcontentView addSubview:self.settingTitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.iConView.frame = CGRectMake(10, 0, 50, 50);
    self.settingTitleLabel.frame = CGRectMake(70, 0, self.frame.size.width-50, 50);
    
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
