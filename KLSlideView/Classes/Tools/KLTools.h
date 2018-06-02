//
//  KLTools.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KLTools : NSObject

/**
 create a color by percentage and between color1 and color2

 @param percent percent
 @param color1 color1
 @param color2 color2
 @return a color
 */
+ (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2;

@end
