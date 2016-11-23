//
//  PPBulletinChirldViewController.h
//  ParkProject
//
//  Created by 周书敏 on 16/8/9.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPBulletinChirldViewController : PPViewController

@property(nonatomic,strong) NSString *columnId;
@property(nonatomic,strong) NSMutableArray *dataArray;//表数据
@property(nonatomic,strong) NSMutableArray *scrollNewsArray;//滚动数据
@property (nonatomic, strong) UILabel *waitLabel;
@property(nonatomic,strong) UITableView *bulletinlistTableView;

//-(void)refreshheardViewImages;
- (void)creatScrollNews:(NSMutableArray *)list;

@end
