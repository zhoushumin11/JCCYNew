//
//  FirmIMGCell.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/25.
//
//

#import "FirmIMGCell.h"

@implementation FirmIMGCell


@synthesize allcontentView,iConView,userNameLabel,timeLabel,contenImageView,lineLabel;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iConView = [[UIButton alloc] init];
        self.allcontentView = [[UIView alloc] init];
        self.userNameLabel = [[UILabel alloc] init];
        self.timeLabel = [[UILabel alloc] init];
        self.contenImageView = [[UIButton alloc] init];
        
        self.allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.allcontentView];
        
        //头像
        self.iConView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.iConView.clipsToBounds = YES;
        self.iConView.layer.cornerRadius = 25;
        [self.allcontentView addSubview:self.iConView];
        
        //内容图片
        self.contenImageView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.contenImageView.clipsToBounds  = YES;
        self.contenImageView.layer.cornerRadius = 8;
        [self.allcontentView addSubview:self.contenImageView];
        
        //姓名
        self.userNameLabel.textColor = [UIColor colorFromHexRGB:@"0a0a0a"];
        //        self.settingTitleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
        self.userNameLabel.font = [UIFont systemFontOfSize:15];
        self.userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.allcontentView addSubview:self.userNameLabel];
        
        //时间
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.allcontentView addSubview:self.timeLabel];
        
        self.lineLabel.backgroundColor = [UIColor colorFromHexRGB:@"d9d9d9"];
        [self.allcontentView addSubview:self.lineLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.iConView.frame = CGRectMake(20, 10, 50, 50);
    self.userNameLabel.frame = CGRectMake(15,75, 60, 30);
    self.timeLabel.frame = CGRectMake(90, 10, 200, 30);
    self.contenImageView.frame = CGRectMake(90, 50, 200, 120);
    self.lineLabel.frame = CGRectMake(10, self.frame.size.height-0.5, self.frame.size.width-20, 0.5);

    
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
