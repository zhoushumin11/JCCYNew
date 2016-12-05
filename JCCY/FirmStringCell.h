//
//  FirmStringCell.h
//  JCCY
//
//  Created by 周书敏 on 2016/11/25.
//
//

#import <UIKit/UIKit.h>

@interface FirmStringCell : UITableViewCell
@property(nonatomic,strong) UIView *allcontentView;
@property(nonatomic,strong) UIButton *iConView; //用户图片
@property(nonatomic,strong) UILabel *userNameLabel; //用户名
@property(nonatomic,strong) UILabel *timeLabel; //发布时间
@property(nonatomic,strong) UILabel *contenStringView; //内容
@property(nonatomic,strong) UIButton *contenStringSuperView; //内容父视图
@property(nonatomic,strong) UILabel *lineLabel;

@end
