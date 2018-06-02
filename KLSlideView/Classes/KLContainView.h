//
//  KLContainView.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLContainView;
@protocol KLContainViewDataSource <NSObject>

- (NSInteger)numberOfControllersInKLContainView:(KLContainView *)containView;
- (UIViewController *)containView:(KLContainView *)sender controllerIndex:(NSInteger)index;

@end

@protocol KLContainViewDelegate <NSObject>

@optional
- (void)containView:(KLContainView *)slide switchingFrom:(NSInteger)formIndex to:(NSInteger)toIndex percent:(float)percent;
- (void)containView:(KLContainView *)slide didSwitched:(NSInteger)index;
- (void)containView:(KLContainView *)slide cancelSwitched:(NSInteger)index;

@end

@interface KLContainView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) UIViewController *baseViewController;
@property (nonatomic, weak) id<KLContainViewDelegate> delegate;
@property (nonatomic, weak) id<KLContainViewDataSource> dataSource;

- (void)didSwitchedIndex:(NSInteger)index;

@end
