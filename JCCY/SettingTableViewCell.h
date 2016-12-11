//
//  SettingTableViewCell.h
//  ParkProject
//
//  Created by yuanxuan on 16/8/1.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property(nonatomic,strong) UIView *allcontentView;
@property(nonatomic,strong) UIButton *iConView; //用户图片
@property(nonatomic,strong) UILabel *settingTitleLabel;    //用户名

@property(nonatomic,strong) UIButton *allViewBtn; //所有行点击btn

@end
