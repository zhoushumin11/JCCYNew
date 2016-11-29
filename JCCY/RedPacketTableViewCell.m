//
//  RedPacketTableViewCell.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/29.
//
//

#import "RedPacketTableViewCell.h"

@implementation RedPacketTableViewCell

@synthesize r_buyBtn,r_imgBtn,r_enterInBtn,r_titleLabel,r_EndDaysLabel,r_UseInfoLabel,allcontentView;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        allcontentView = [[UIView alloc] init];
        r_buyBtn = [[UIButton alloc] init];
        r_imgBtn = [[UIButton alloc] init];
        r_enterInBtn = [[UIButton alloc] init];
        r_titleLabel = [[UILabel alloc] init];
        r_EndDaysLabel = [[UILabel alloc] init];
        r_UseInfoLabel = [[UILabel alloc] init];
        
        
        allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:allcontentView];
        
        //头像
        r_imgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        r_imgBtn.clipsToBounds = YES;
        r_imgBtn.layer.cornerRadius = 25;
        [self.allcontentView addSubview:r_imgBtn];
        //进入button
        [r_enterInBtn setTitle:@"立即进入" forState:UIControlStateNormal];
        r_enterInBtn.layer.masksToBounds = YES;
        r_enterInBtn.layer.cornerRadius = 3;
        [r_enterInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.allcontentView addSubview:r_enterInBtn];
        //购买button
        [r_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        r_buyBtn.layer.masksToBounds = YES;
        r_buyBtn.layer.cornerRadius = 3;
        [r_buyBtn.layer setBorderWidth:1.0];
        [self.allcontentView addSubview:r_buyBtn];
        //标题
        r_titleLabel.textColor = [UIColor blackColor];
        r_titleLabel.font = [UIFont systemFontOfSize:18];
        r_titleLabel.textAlignment = NSTextAlignmentCenter;
        [allcontentView addSubview:r_titleLabel];
        //剩余天数
        r_EndDaysLabel.textColor = [UIColor blackColor];
        r_EndDaysLabel.font = [UIFont systemFontOfSize:16];
        r_EndDaysLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:r_EndDaysLabel];
        //使用说明
        r_UseInfoLabel.textColor = [UIColor blackColor];
        r_UseInfoLabel.font = [UIFont systemFontOfSize:14];
        r_UseInfoLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:r_UseInfoLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20);
    r_imgBtn.frame = CGRectMake(20, 20, 50, 50);
    r_titleLabel.frame = CGRectMake(10,75,70,25);
    r_EndDaysLabel.frame = CGRectMake(80, 15,PPMainViewWidth - 80,25);
    r_UseInfoLabel.frame = CGRectMake(80, 50,PPMainViewWidth - 80,25);
    r_enterInBtn.frame = CGRectMake(80, 80,(PPMainViewWidth-100)/2-5,40);
    r_buyBtn.frame = CGRectMake((PPMainViewWidth-100)/2+90,80 ,(PPMainViewWidth-100)/2-5,40);
    
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
