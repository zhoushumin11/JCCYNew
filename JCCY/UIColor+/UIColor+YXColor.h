//
//  UIColor+YXColor.h
//  baicaoji
//
//  Created by yuanxuan on 14-5-13.
//  Copyright (c) 2014年 baicaoji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YXColor)
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)alpha;
@end
