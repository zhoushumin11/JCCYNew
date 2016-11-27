//
//  JCCYPayTypeButtonView.h
//  JCCY
//
//  Created by 周书敏 on 2016/11/27.
//
//

#import <UIKit/UIKit.h>

@protocol AppaddDelegate;

@interface JCCYPayTypeButtonView : UIScrollView

@property (nonatomic, assign) id<AppaddDelegate> appSelectdelegate;
@property(nonatomic,strong) UIImageView *imageview;
@property(nonatomic,strong) NSMutableDictionary *selectdeletebtnList;//选择删除button
- (void)createView:(NSMutableArray *)tabList integer:(NSInteger)integer;

@end

@protocol AppaddDelegate <NSObject>

- (void)selectAppbtn:(NSInteger)tabtag;
- (void)selectdeleteAppbtn:(NSInteger)tabtag;

@end
