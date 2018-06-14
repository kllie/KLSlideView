//
//  KLTitleTabbarView.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLTabbarViewProtocol.h"

@interface KLTitleTabbarItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat width;

/**
 Create a KLTitleTabbarItem object

 @param title tabbar item title 
 @param width tabbar item width
 @return a KLTitleTabbarItem object
 */
+ (KLTitleTabbarItem *)itemWithTitle:(NSString *)title width:(CGFloat)width;

@end

@interface KLTitleTabbarView : UIView <KLTabbarViewProtocol>

/**
 The back ground view of the tabbar
 */
@property(nonatomic, strong) UIView *backgroundView;

/** 
 The normal color of the tabbar title, Default is [UIColor grayColor]
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 The selected color of the tabbar title, Default is [UIColor redColor]
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 The font of the tabbar title, Default is [UIFont systemFontOfSize:14]
 */
@property (nonatomic, strong) UIFont *font;

/**
 The small slider color, Default is [UIColor redColor]
 */
@property (nonatomic, strong) UIColor *trackColor;

/**
 The small slider height, Default is 4px
 */
@property (nonatomic, assign) CGFloat trackHeight;

/**
 The small slider bottom offset, Default is 0
 */
@property (nonatomic, assign) CGFloat trackBottomOffset;

/**
 The tabbar bottom line color, height is 2px, Default is [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 The small slider back ground image, Default is nil
 */
@property (nonatomic, strong) NSString *trackImage;

/**
 This array is a item array, and the element is KLTitleTabbarItem
 */
@property (nonatomic, strong) NSArray<KLTitleTabbarItem *> *tabbarItems;

// ----------------------
//  KLTabbarViewProtocol
// ----------------------
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign, readonly) NSInteger tabbarCount;
@property (nonatomic, weak) id<KLTabbarViewDelegate> delegate;

- (void)tabbarViewFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;
- (void)tabbarViewBadgeValue:(NSInteger)value index:(NSInteger)index;
- (void)tabbarViewBadgeDotWithIndex:(NSInteger)index;

@end
