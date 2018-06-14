//
//  KLImageTabbarView.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "KLTabbarViewProtocol.h"

typedef NS_ENUM(NSInteger, KLTabbarViewImagePosition) {
    /** The title is on the left, and the image is on the right */
    KLTabbarViewImagePositionRight,
    /** The title is on the right, and the image is on the left */
    KLTabbarViewImagePositionLeft
};

@interface KLImageTabbarItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;

/**
 create a KLImageTabbarItem object

 @param title item title
 @param image item image
 @param selectedImage item selected image
 @param width item width
 @return a KLImageTabbarItem object
 */
+ (KLImageTabbarItem *)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage width:(CGFloat)width;

@end

@interface KLImageTabbarView : UIView <KLTabbarViewProtocol>

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
 This array is a item array, and the element is KLImageTabbarItem
 */
@property (nonatomic, strong) NSArray<KLImageTabbarItem *> *tabbarItems;

/**
 The position is in the KLTabbarViewImagePosition type, Default position is KLTabbarViewImagePositionRight
 */
@property (nonatomic, assign) KLTabbarViewImagePosition position;

// ----------------------
//  KLTabbarViewProtocol
// ----------------------

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign, readonly) NSInteger tabbarCount;
@property(nonatomic, weak) id<KLTabbarViewDelegate> delegate;

- (void)tabbarViewFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;
- (void)tabbarViewBadgeValue:(NSInteger)value index:(NSInteger)index;
- (void)tabbarViewBadgeDotWithIndex:(NSInteger)index;
@end
