//
//  RedPacketTableViewCell.h
//  JCCY
//
//  Created by 周书敏 on 2016/11/29.
//
//

#import <UIKit/UIKit.h>

@interface RedPacketTableViewCell : UITableViewCell

@property(nonatomic,strong) UIView *allcontentView;
@property(nonatomic,strong) UILabel *r_titleLabel;     //标题
@property(nonatomic,strong) UILabel *r_EndDaysLabel;     //剩余天数
@property(nonatomic,strong) UILabel *r_UseInfoLabel;     //使用说明
@property(nonatomic,strong) UIButton *r_imgBtn;        //标签按钮
@property(nonatomic,strong) UIButton *r_enterInBtn;        //进入按钮
@property(nonatomic,strong) UIButton *r_buyBtn;        //购买按钮



@end
