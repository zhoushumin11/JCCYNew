//
//  PPBulletinDetailViewController.h
//  ParkProject
//
//  Created by 周书敏 on 16/8/3.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPBulletinDetailViewController : PPViewController

@property(nonatomic,strong) NSString *documentPath;
@property(nonatomic,strong) NSString *titleStr;//公告标题
@property(nonatomic,strong) NSString *isOutWebside; //是否为外链

@end
