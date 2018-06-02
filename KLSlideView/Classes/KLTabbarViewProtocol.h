//
//  KLTabbarViewProtocol.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLTabbarViewDelegate <NSObject>

@optional
- (void)tabbarView:(id)sender didSelectedIndex:(NSInteger)index;

@end


@protocol KLTabbarViewProtocol <NSObject>

/** The selected index of Tabbar */
@property (nonatomic, assign) NSInteger selectedIndex;
/** The item count of Tabbar */
@property (nonatomic, assign, readonly) NSInteger tabbarCount;

@property (nonatomic, weak) id<KLTabbarViewDelegate> delegate;

/**
 Slide the Tabbar start position to the end position

 @param fromIndex start index
 @param toIndex end index
 @param percent The precent of the absolute distance to the KLContainView width
 */
- (void)tabbarViewFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;

/**
 Set badge number

 @param value The maximum value is 99, The minimum value is 1
 @param index This index is set badge number index
 */
- (void)tabbarViewBadgeValue:(NSInteger)value index:(NSInteger)index;

/**
 Set badge dot

 @param index This index is set badge dot index
 */
- (void)tabbarViewBadgeDotWithIndex:(NSInteger)index;

@end
