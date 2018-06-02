//
//  KLSlideView.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KLContainView.h"
#import "KLTitleTabbarView.h"
#import "KLImageTabbarView.h"
#import "KLCache.h"

@class KLSlideView;
@protocol KLSlideViewDelegate<NSObject>

@required
- (NSInteger)numberOfTabsInKLSlideView:(KLSlideView *)slideView;
- (UIViewController *)slideView:(KLSlideView *)slideView controllerIndex:(NSInteger)index;

@optional
- (void)slideView:(KLSlideView *)slideView didSelectedIndex:(NSInteger)index;

@end

@interface KLSlideView : UIView <KLTabbarViewDelegate, KLContainViewDelegate, KLContainViewDataSource>

/** 
 KLSlideView base controller, Default is nil
 */
@property (nonatomic, weak) UIViewController *baseViewController;
/** 
 The selected index of KLSlideView, Default is 0
 */
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<KLSlideViewDelegate> delegate;

// ---------
//  tabbar
// ---------

/**
 The tabbar of KLSlideView
 */
@property (nonatomic, strong) UIView <KLTabbarViewProtocol> *tabbar;
/**
 The specing between the bottom of tabbar and the top of KLContainView
 */
@property (nonatomic, assign) CGFloat tabbarBottomSpacing;

// --------
//  cache
// --------

/**
 The cache of KLSlideView
 */
@property (nonatomic, strong) id<KLCacheProtocol> cache;

- (void)setup;

@end
