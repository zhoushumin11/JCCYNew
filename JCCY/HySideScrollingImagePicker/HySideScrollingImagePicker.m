//
//  HySideScrollingImagePicker.m
//  TestProject
//
//  Created by Apple on 15/6/25.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "HySideScrollingImagePicker.h"
#import "SideScrollingLayout.h"
#import "HCollectionViewCell.h"
#import "SideScrollingCheckCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetsLibraryD.h"

#define kImageSpacing 5.0f
#define kCollectionViewHeight 178.0f
#define kSubTitleHeight 65.0f
#define ItemHeight 50.0f
#define H [UIScreen mainScreen].bounds.size.height
#define W [UIScreen mainScreen].bounds.size.width
#define Color [UIColor colorWithRed:26/255.0f green:178.0/255.0f blue:10.0f/255.0f alpha:1]
#define Spacing 7.0f


@interface HySideScrollingImagePicker ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,copy)NSString *cancelStr;

@property (nonatomic,strong)NSArray *ButtonTitles;

@property (nonatomic,weak) UIView * BottomView;

@property (nonatomic,weak)UICollectionView *CollectionView;

@property (nonatomic, strong) NSMapTable *indexPathToCheckViewTable;

@property (nonatomic, strong) ALAssetsGroup *group;

@property (nonatomic,strong) NSMutableArray *allArr;

@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (nonatomic, strong) NSMutableArray *selectedItemIndexs;

@property (nonatomic, strong) NSMutableDictionary *selectedImagesDict;

@property (nonatomic,strong) NSIndexPath	*lastIndexPath;



@property (nonatomic,strong) NSMutableArray *assetsGroups;

@property (nonatomic,strong) AssetsLibraryD *lib;

@end

@implementation HySideScrollingImagePicker
@synthesize selectedCount,minCount;
-(NSMutableArray *)assetsGroups{
    if (!_assetsGroups) {
        _assetsGroups=[[NSMutableArray alloc]init];
    }
    return _assetsGroups;
}

-(AssetsLibraryD *)lib{
    if (!_lib) {
        _lib = [[AssetsLibraryD alloc] init];
    }
    
    return _lib;
}

-(instancetype) initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)Titles{
    
    self = [super init];
    if (self) {
        __weak HySideScrollingImagePicker *weakSlef = self;
        _lib = [[AssetsLibraryD alloc] init];
        
        _lib.GetImageBlock = ^(NSArray *ImgsData){
            
            if (ImgsData.count != 0) {
                weakSlef.cancelStr = str;
                weakSlef.ButtonTitles = Titles;
                [weakSlef LoadUI];
            }
            
            
        };
        
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
            NSLog(@"This application is not authorized to access photo data.");
        }else if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied){
            NSLog(@"用户已经明确否认了这一应用程序访问数据的照片。");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"读取失败"
                                                           message:@"请打开 设置-隐私-照片 来进行设置"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            
        }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized){
            NSLog(@"SER已授权该应用程序访问数据的照片。");
            _cancelStr = str;
            _ButtonTitles = Titles;
            [self LoadUI];
        }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined){
            NSLog(@"用户还没有做出选择的问候这个应用程序");
        }
    }
    return self;
}

-(void)LoadUI{
    self.selectedIndexes = [[NSMutableArray alloc] init];
    self.selectedItemIndexs = [[NSMutableArray alloc] init];
    self.selectedImagesDict = [[NSMutableDictionary alloc] init];
    /*self*/
    [self setFrame:CGRectMake(0, 0, W, H)];
    [self setBackgroundColor:[UIColor clearColor]];
    /*end*/
    
    /*buttomView*/
    UIView *ButtomView = [[UIView alloc] init];
    
    ButtomView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:226.0f/255.f blue:236.0f/255.0f alpha:1];
    CGFloat height = ((ItemHeight+0.5f)+Spacing) + (_ButtonTitles.count * (ItemHeight+0.5f)) + kCollectionViewHeight;
    [ButtomView setFrame:CGRectMake(0, H, W, height)];
    _BottomView = ButtomView;
    [self addSubview:ButtomView];
    /*end*/
    
    /*CanceBtn*/
    UIButton *Cancebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Cancebtn setBackgroundColor:[UIColor whiteColor]];
    [Cancebtn setFrame:CGRectMake(0, CGRectGetHeight(ButtomView.bounds) - ItemHeight, W, ItemHeight)];
    [Cancebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Cancebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [Cancebtn setTitle:_cancelStr forState:UIControlStateNormal];
    [Cancebtn addTarget:self action:@selector(SelectedButtons:) forControlEvents:UIControlEventTouchUpInside];
    [Cancebtn setTag:100];
    [_BottomView addSubview:Cancebtn];
    /*end*/
    
    /*Items*/
    for (NSString *Title in _ButtonTitles) {
        
        NSInteger index = [_ButtonTitles indexOfObject:Title];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        CGFloat hei = (50.5 * _ButtonTitles.count)+Spacing;
        CGFloat y = (CGRectGetMinY(Cancebtn.frame) + (index * (ItemHeight+0.5))) - hei;
        
        [btn setFrame:CGRectMake(0, y, W, ItemHeight)];
        [btn setTag:(index + 100)+1];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

        [btn setTitle:Title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(SelectedButtons:) forControlEvents:UIControlEventTouchUpInside];
        [_BottomView addSubview:btn];
    }
    /*END*/
    
    /*CollectionView*/
    
    // Configure the flow layout
    SideScrollingLayout *flow = [[SideScrollingLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = kImageSpacing;
    
    // Configure the collection view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsSelection = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.collectionViewLayout = flow;
    [collectionView registerClass:[HCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [collectionView registerClass:[SideScrollingCheckCell class] forSupplementaryViewOfKind:@"check" withReuseIdentifier:@"CheckCell"];
    collectionView.contentInset = UIEdgeInsetsMake(0, 6, 0, 6);
    
    [ButtomView addSubview:collectionView];
    self.CollectionView = collectionView;
    
    self.CollectionView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.indexPathToCheckViewTable = [NSMapTable strongToWeakObjectsMapTable];
    
    [self.CollectionView setFrame:CGRectMake(0, 5, W, kCollectionViewHeight-10)];
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.CollectionView.bounds)/2 - 10 , CGRectGetHeight(self.CollectionView.bounds)/2 - 10, 20, 20)];
    act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [act startAnimating];
    [self.CollectionView addSubview:act];
    
    /*enb*/
    
    typeof(self) __weak weak = self;
    
    _lib.GetImageBlock = ^(NSArray *ImgsData){
        
        weak.allArr = [NSMutableArray arrayWithArray:ImgsData];
        [weak.CollectionView reloadData];
        [act stopAnimating];
        
    };
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [ButtomView setFrame:CGRectMake(0, H - height, W, height+10)];
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weak action:@selector(dismiss:)];
        tap.delegate = self;
        [weak addGestureRecognizer:tap];
        
        [ButtomView setFrame:CGRectMake(0, H - height, W, height)];
    }];
}

- (void)show:(UIViewController *)viewControl
{
    [viewControl.view.window addSubview:self];
}

-(void)SelectedButtons:(UIButton *)btns{
    
    typeof(self) __weak weak = self;
    [self DismissBlock:^(BOOL Complete) {
        weak.SeletedImages(weak.selectedIndexes,self.selectedImagesDict,btns.tag-100);
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    if (_allArr.count >100) {
        return 100;
    }else{
        return _allArr.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    HCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    ALAsset *asset = [_allArr objectAtIndex:_allArr.count-indexPath.item-1];
    UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    
    cell.imageView.image = image;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    SideScrollingCheckCell *checkView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CheckCell" forIndexPath:indexPath];
    [self.indexPathToCheckViewTable setObject:checkView forKey:indexPath];
    if ([[collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
        if ([self.selectedItemIndexs containsObject:indexPath]) {
            [checkView setChecked:YES];
        }
        
    }
    
    
    return checkView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
{
//    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self toggleSelectionAtIndexPath:indexPath CollectionView:collectionView];
    NSLog(@"didDeselectItem");
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
//    if ([self.selectedIndexes count]>1) {
//        
//    }else{
    if (self.selectedIndexes.count >= self.minCount-selectedCount) {
        NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",self.minCount];
        if (minCount == 0) {
            format = [NSString stringWithFormat:@"您已经选满了图片呦."];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:format delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
        return;
    }
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self toggleSelectionAtIndexPath:indexPath CollectionView:collectionView];
//    }
    
    NSLog(@"didSelectItem");
}

- (void)toggleSelectionAtIndexPath:(NSIndexPath *)indexPath CollectionView:(UICollectionView *)collectionView
{
    UIButton *Ti = (UIButton *)[_BottomView viewWithTag:101];
    
    //获取到当前的图片cell
    HCollectionViewCell *cell = (HCollectionViewCell *)[self.CollectionView cellForItemAtIndexPath:indexPath];
    //当前选择的按钮cell
    SideScrollingCheckCell *checkmarkView = [self.indexPathToCheckViewTable objectForKey:indexPath];
    
    if (_isMultipleSelection) {
        // Manage internal selection state
        if ([[collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
            [checkmarkView setChecked:YES];
            if ([self.selectedIndexes containsObject:[NSNumber numberWithInteger:indexPath.item]]) {

            }else{
                [self.selectedItemIndexs addObject:indexPath];
                [self.selectedIndexes addObject:[NSNumber numberWithInteger:indexPath.item]];
                ALAsset *asset = [_allArr objectAtIndex:_allArr.count-indexPath.item-1];
                ALAssetRepresentation* representation = [asset defaultRepresentation];
//                获取资源图片的高清图
                UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                image = [self imageCompressForSize:image targetSize:CGSizeMake(image.size.width, image.size.height)];
//                UIImage *image =  [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                [self.selectedImagesDict setObject:image forKey:[NSNumber numberWithInteger:indexPath.item]];
            }
        }else{
            [checkmarkView setChecked:NO];
            if ([self.selectedIndexes containsObject:[NSNumber numberWithInteger:indexPath.item]]) {
                [self.selectedIndexes removeObject:[NSNumber numberWithInteger:indexPath.item]];
                [self.selectedImagesDict removeObjectForKey:[NSNumber numberWithInteger:indexPath.item]];
                [self.selectedItemIndexs removeObject:indexPath];

            }else{
                
            }
        }
//        if ([self.selectedIndexes containsObject:cell.imageView.image]) {
//            [self.selectedIndexes removeObject:cell.imageView.image];
//            [cell setSelected:NO];
//            [checkmarkView setChecked:NO];
//        } else {
//            [self.selectedIndexes addObject:cell.imageView.image];
//            [cell setSelected:YES];
//            [checkmarkView setChecked:YES];
//        }
    }else{
//        [self.selectedIndexes addObject:cell.imageView.image];
//        [cell setSelected:YES];
//        [checkmarkView setChecked:YES];
//        typeof(self) __weak weak = self;
//        [self DismissBlock:^(BOOL Complete) {
//            weak.SeletedImages(self.selectedIndexes,MAXFLOAT);
//        }];
        
    }
    if (self.selectedIndexes.count == 0) {
        
        [Ti setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Ti setTitle:[_ButtonTitles objectAtIndex:Ti.tag-101] forState:UIControlStateNormal];
        
    }else{
        
        [Ti setTitle:[NSString stringWithFormat:@"选择(%ld张)",self.selectedIndexes.count] forState:UIControlStateNormal];
        [Ti setTitleColor:Color forState:UIControlStateNormal];
        
    }
}

-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    ALAsset *asset = [_allArr objectAtIndex:_allArr.count-indexPath.row-1];
    
    UIImage *imageAtPath = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    
    CGFloat imageHeight = imageAtPath.size.height;
    CGFloat viewHeight = collectionView.bounds.size.height;
    CGFloat scaleFactor = viewHeight/imageHeight;
    
    CGSize scaledSize = CGSizeApplyAffineTransform(imageAtPath.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
//    NSLog(@"%@",NSStringFromCGSize(scaledSize));
//    CGSize scaledSize1 = CGSizeMake(100, 100);
    return scaledSize;
}

-(void)DismissBlock:(CompleteAnimationBlock)block{
    
    
    typeof(self) __weak weak = self;
    CGFloat height = ((ItemHeight+0.5f)+Spacing) + (_ButtonTitles.count * (ItemHeight+0.5f)) + kCollectionViewHeight;
    
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        [_BottomView setFrame:CGRectMake(0, H, W, height)];
        
    } completion:^(BOOL finished) {
        
        block(finished);
        [self removeFromSuperview];
        
    }];
    
}

-(void)dismiss:(UITapGestureRecognizer *)tap{
    
    if( CGRectContainsPoint(self.frame, [tap locationInView:_BottomView])) {
        NSLog(@"tap");
    } else{
        
        [self DismissBlock:^(BOOL Complete) {
            
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self) {
        return NO;
    }
    
    return YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

@class HyActionSheet;

@interface HyActionSheet ()<UIGestureRecognizerDelegate>

@property (nonatomic,copy)      NSString *CancelStr;

@property (nonatomic,strong)    NSArray *Titles;

@property (nonatomic,weak)      UIView *ButtomView;

@property (nonatomic,copy)      NSString *AttachTitle;

@end

@implementation HyActionSheet

-(instancetype) initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)Titles AttachTitle:(NSString *)AttachTitle{
    
    self = [super init];
    
    if (self) {
        
        _AttachTitle = AttachTitle;
        _CancelStr = str;
        _Titles = Titles;
        [self loadUI];
        
    }
    
    return self;
}

-(void)loadUI{
    
    /*self*/
    [self setFrame:CGRectMake(0, 0, W, H)];
    [self setBackgroundColor:[UIColor clearColor]];
    /*end*/
    
    /*buttomView*/
    UIView *ButtomView = [[UIView alloc] init];
    
    ButtomView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:226.0f/255.f blue:236.0f/255.0f alpha:1];
    CGFloat height;
    
    if ([self isBlankString:_AttachTitle]) {
        height = ((ItemHeight+0.5f)+Spacing) + (_Titles.count * (ItemHeight+0.5f));
    }else{
        height  = ((ItemHeight+0.5f)+Spacing) + (_Titles.count * (ItemHeight+0.5f)) + kSubTitleHeight;
    }
    
    [ButtomView setFrame:CGRectMake(0, H , W, height)];
    _ButtomView = ButtomView;
    [self addSubview:ButtomView];
    /*end*/
    
    /*CanceBtn*/
    UIButton *Cancebtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [Cancebtn setBackgroundColor:[UIColor whiteColor]];
    [Cancebtn setFrame:CGRectMake(0, CGRectGetHeight(ButtomView.bounds) - ItemHeight, W, ItemHeight)];
    [Cancebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Cancebtn setTitle:_CancelStr forState:UIControlStateNormal];
    [Cancebtn addTarget:self action:@selector(SelectedButtons:) forControlEvents:UIControlEventTouchUpInside];
    [Cancebtn setTag:100];
    [_ButtomView addSubview:Cancebtn];
    /*end*/
    
    /*Items*/
    for (NSString *Title in _Titles) {
        
        NSInteger index = [_Titles indexOfObject:Title];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat hei = (50.5 * _Titles.count)+Spacing;
        CGFloat y = (CGRectGetMinY(Cancebtn.frame) + (index * (ItemHeight+0.5))) - hei;
        
        [btn setFrame:CGRectMake(0, y, W, ItemHeight)];
        [btn setTag:(index + 100)+1];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:Title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(SelectedButtons:) forControlEvents:UIControlEventTouchUpInside];
        [_ButtomView addSubview:btn];
    }
    /*END*/
    
    if ([self isBlankString:_AttachTitle]) {
        
    }else{
        
        UILabel *AttachTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, kSubTitleHeight)];
        AttachTitleView.backgroundColor = [UIColor whiteColor];
        AttachTitleView.font = [UIFont systemFontOfSize:12.0f];
        AttachTitleView.textColor = [UIColor grayColor];
        AttachTitleView.text = _AttachTitle;
        AttachTitleView.textAlignment = 1;
        
        [_ButtomView addSubview:AttachTitleView];
        
    }
    
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [ButtomView setFrame:CGRectMake(0, H - height, W, height+10)];
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weak action:@selector(dismiss:)];
        tap.delegate = self;
        [weak addGestureRecognizer:tap];
        
        [ButtomView setFrame:CGRectMake(0, H - height, W, height)];
    }];
    
}

-(void)SelectedButtons:(UIButton *)btns{
    
    typeof(self) __weak weak = self;
    [self DismissBlock:^(BOOL Complete) {
        
        weak.ButtonIndex(btns.tag-100);
        
    }];
    
    
}

-(void) ChangeTitleColor:(UIColor *)color AndIndex:(NSInteger )index{
    
    UIButton *btn = (UIButton *)[_ButtomView viewWithTag:index + 100];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
}

-(void)dismiss:(UITapGestureRecognizer *)tap{
    
    if( CGRectContainsPoint(self.frame, [tap locationInView:_ButtomView])) {
        NSLog(@"tap");
    } else{
        
        [self DismissBlock:^(BOOL Complete) {
            
        }];
    }
}

-(void)DismissBlock:(CompleteAnimationBlock)block{
    
    
    typeof(self) __weak weak = self;
    CGFloat height = ((ItemHeight+0.5f)+Spacing) + (_Titles.count * (ItemHeight+0.5f)) + kCollectionViewHeight;
    
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        [_ButtomView setFrame:CGRectMake(0, H, W, height)];
        
    } completion:^(BOOL finished) {
        
        block(finished);
        [self removeFromSuperview];
        
    }];
    
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end




