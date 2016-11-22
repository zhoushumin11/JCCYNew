//
//  HySideScrollingImagePicker.h
//  TestProject
//
//  Created by Apple on 15/6/25.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//HySideScrollingImagePicker 视图
typedef void(^CompleteAnimationBlock)(BOOL Complete);

typedef void(^SeletedImages)(NSArray *GetImageIndexs,NSDictionary *GetImagesDict , NSInteger Buttonindex);


@interface HySideScrollingImagePicker : UIView

@property (nonatomic,assign)BOOL isMultipleSelection;
@property (nonatomic, assign) NSInteger minCount;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic,strong) SeletedImages SeletedImages;
- (void)show:(UIViewController *)viewControl;
-(instancetype) initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)Titles;

-(void)DismissBlock:(CompleteAnimationBlock)block;

@end


typedef void(^SeletedButtonIndex)(NSInteger Buttonindex);

///HyActionSheet VIEW视图

@interface HyActionSheet : UIView

@property (nonatomic,strong)    SeletedButtonIndex ButtonIndex;

-(instancetype) initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)Titles AttachTitle:(NSString *)AttachTitle;

-(void) ChangeTitleColor:(UIColor *)color AndIndex:(NSInteger )index;

@end
