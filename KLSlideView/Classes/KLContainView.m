//
//  KLContainView.m
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import "KLContainView.h"

#define kPanSwitchOffsetThreshold 50.0f

@interface KLContainView ()

@property (nonatomic, assign) NSInteger oldIndex;
@property (nonatomic, assign) NSInteger panToIndex;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint panStartPoint;

@property (nonatomic, strong) UIViewController *oldController;
@property (nonatomic, strong) UIViewController *willController;

@property (nonatomic, assign) BOOL isSwitching;
@end

@implementation KLContainView

#pragma mark - life cycle

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isPanGesture) {
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
        [self addGestureRecognizer:self.pan];
    }
}

#pragma mark - init methods

- (void)initView{
    self.oldIndex = -1;
    self.isSwitching = NO;
}

#pragma mark - event response

- (void)panHandler:(UIPanGestureRecognizer *)pan{
    if (self.oldIndex < 0) {
        return;
    }
    CGPoint point = [pan translationInView:self];

    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = point;
        [self.oldController beginAppearanceTransition:NO animated:YES];
    } else if (pan.state == UIGestureRecognizerStateChanged){
        NSInteger panToIndex = -1;
        float offsetx = point.x - self.panStartPoint.x;

        if (offsetx > 0) {
            panToIndex = self.oldIndex - 1;
        } else if(offsetx < 0){
            panToIndex = self.oldIndex + 1;
        }

        if (panToIndex != self.panToIndex) {
            if (self.willController) {
                [self removeWillController];
            }
        }
        if (panToIndex < 0 || panToIndex >= [self.dataSource numberOfControllersInKLContainView:self]) {
            self.panToIndex = panToIndex;
            [self repositionForOffsetX:offsetx / 2.0f];
        } else {
            if (panToIndex != self.panToIndex) {
                self.willController = [self.dataSource containView:self controllerIndex:panToIndex];
                [self.baseViewController addChildViewController:self.willController];
                [self.willController willMoveToParentViewController:self.baseViewController];
                [self.willController beginAppearanceTransition:YES animated:YES];
                [self addSubview:self.willController.view];

                self.panToIndex = panToIndex;
            }
            [self repositionForOffsetX:offsetx];
        }
    } else if (pan.state == UIGestureRecognizerStateEnded){
        float offsetx = point.x - self.panStartPoint.x;
        if (self.panToIndex >= 0 && self.panToIndex < [self.dataSource numberOfControllersInKLContainView:self] && self.panToIndex != self.oldIndex) {
            if (fabs(offsetx) > kPanSwitchOffsetThreshold) {
                NSTimeInterval animatedTime = 0;
                animatedTime = fabs(self.frame.size.width - fabs(offsetx)) / self.frame.size.width * 0.4;
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView animateWithDuration:animatedTime animations:^{
                    [self repositionForOffsetX:offsetx > 0 ? self.bounds.size.width : -self.bounds.size.width];
                } completion:^(BOOL finished) {
                    [self removeOldController];
                    if (self.panToIndex >= 0 && self.panToIndex < [self.dataSource numberOfControllersInKLContainView:self]) {
                        [self.willController endAppearanceTransition];
                        [self.willController didMoveToParentViewController:self.baseViewController];
                        self.oldIndex = self.panToIndex;
                        self.oldController = self.willController;
                        self.willController = nil;
                        self.panToIndex = -1;
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(containView:didSwitched:)]) {
                        [self.delegate containView:self didSwitched:self.oldIndex];
                    }
                }];
            } else {
                [self backToOldWithOffsetX:offsetx];
            }
        } else {
            [self backToOldWithOffsetX:offsetx];
        }
    }
}

#pragma mark - public methods

- (NSInteger)selectedIndex {
    return self.oldIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex != self.oldIndex) {
        [self didSwitchedIndex:selectedIndex];
    }
}

- (void)didSwitchedIndex:(NSInteger)index{
    if (index == self.oldIndex) {
        return;
    }
    if (self.isSwitching) {
        return;
    }

    if (self.oldController != nil && self.oldController.parentViewController == self.baseViewController) {
        self.isSwitching = YES;
        UIViewController *oldvc = self.oldController;
        UIViewController *newvc = [self.dataSource containView:self controllerIndex:index];

        [oldvc willMoveToParentViewController:nil];
        [self.baseViewController addChildViewController:newvc];

        CGRect nowRect = oldvc.view.frame;
        CGRect leftRect = CGRectMake(nowRect.origin.x - nowRect.size.width, nowRect.origin.y, nowRect.size.width, nowRect.size.height);
        CGRect rightRect = CGRectMake(nowRect.origin.x + nowRect.size.width, nowRect.origin.y, nowRect.size.width, nowRect.size.height);

        CGRect newStartRect;
        CGRect oldEndRect;
        if (index > _oldIndex) {
            newStartRect = rightRect;
            oldEndRect = leftRect;
        } else {
            newStartRect = leftRect;
            oldEndRect = rightRect;
        }
        newvc.view.frame = newStartRect;
        [newvc willMoveToParentViewController:self.baseViewController];

        [self.baseViewController transitionFromViewController:oldvc toViewController:newvc duration:0.4 options:0 animations:^{
            newvc.view.frame = nowRect;
            oldvc.view.frame = oldEndRect;
        } completion:^(BOOL finished) {
            [oldvc removeFromParentViewController];
            [newvc didMoveToParentViewController:self.baseViewController];

            if (self.delegate && [self.delegate respondsToSelector:@selector(containView:didSwitched:)]) {
                [self.delegate containView:self didSwitched:index];
            }
            self.isSwitching = NO;
        }];
        _oldIndex = index;
        self.oldController = newvc;
    } else {
        [self showIndex:index];
    }
    self.willController = nil;
    _panToIndex = -1;
}

#pragma mark - private methods

- (void)showIndex:(NSInteger)index{
    if (_oldIndex != index) {
        [self removeOldController];

        UIViewController *vc = [self.dataSource containView:self controllerIndex:index];
        [self.baseViewController addChildViewController:vc];
        vc.view.frame = self.bounds;
        [self addSubview:vc.view];
        [vc didMoveToParentViewController:self.baseViewController];
        _oldIndex = index;
        self.oldController = vc;

        if (self.delegate && [self.delegate respondsToSelector:@selector(containView:didSwitched:)]) {
            [self.delegate containView:self didSwitched:index];
        }
    }
}

- (void)removeOldController{
    [self removeController:self.oldController];
    [self.oldController endAppearanceTransition];
    self.oldController = nil;
    _oldIndex = -1;
}

- (void)removeWillController {
    [self.willController beginAppearanceTransition:NO animated:NO];
    [self removeController:self.willController];
    [self.willController endAppearanceTransition];
    self.willController = nil;
    _panToIndex = -1;
}

- (void)removeController:(UIViewController *)controller {
    UIViewController *vc = controller;
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

- (void)repositionForOffsetX:(CGFloat)offsetx{
    float x = 0.0f;
    if (self.panToIndex < self.oldIndex) {
        x = self.bounds.origin.x - self.bounds.size.width + offsetx;
    } else if (self.panToIndex > self.oldIndex){
        x = self.bounds.origin.x + self.bounds.size.width + offsetx;
    }
    UIViewController *oldvc = self.oldController;
    oldvc.view.frame = CGRectMake(self.bounds.origin.x + offsetx, self.bounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    if (self.panToIndex >= 0 && self.panToIndex < [self.dataSource numberOfControllersInKLContainView:self]) {
        UIViewController *vc = self.willController;
        vc.view.frame = CGRectMake(x, self.bounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(containView:switchingFrom:to:percent:)]) {
        [self.delegate containView:self switchingFrom:self.oldIndex to:self.panToIndex percent:fabs(offsetx)/self.bounds.size.width];
    }
}

- (void)backToOldWithOffsetX:(CGFloat)offsetx{
    NSTimeInterval animatedTime = 0;
    animatedTime = 0.3;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self repositionForOffsetX:0];
    } completion:^(BOOL finished) {
        if (self.panToIndex >= 0 && self.panToIndex < [self.dataSource numberOfControllersInKLContainView:self] && self.panToIndex != self.oldIndex) {
            [self.oldController beginAppearanceTransition:YES animated:NO];
            [self removeWillController];
            [self.oldController endAppearanceTransition];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(containView:cancelSwitched:)]) {
            [self.delegate containView:self cancelSwitched:self.oldIndex];
        }
    }];
}

@end
