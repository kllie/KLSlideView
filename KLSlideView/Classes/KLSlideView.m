//
//  KLSlideView.m
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import "KLSlideView.h"

#define kDefaultTabbarBottomSpacing 0

@interface KLSlideView ()

@property (nonatomic, strong) KLContainView *slideContainView;
@end

@implementation KLSlideView

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSlideContainView];
}

- (void)layoutSlideContainView{
    self.tabbar.frame = CGRectMake(self.tabbar.frame.origin.x, self.tabbar.frame.origin.y, CGRectGetWidth(self.tabbar.bounds), self.tabbar.frame.size.height);
    self.slideContainView.frame = CGRectMake(self.bounds.origin.x, self.tabbar.frame.size.height + self.tabbarBottomSpacing, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.tabbar.frame.size.height - self.tabbarBottomSpacing);
}


#pragma mark - init methods

- (void)initView {
    self.tabbarBottomSpacing = kDefaultTabbarBottomSpacing;
}

#pragma mark - public methods

- (void)setup {
    self.tabbar.delegate = self;
    [self addSubview:self.tabbar];

    self.slideContainView = [[KLContainView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.tabbar.frame.size.height + self.tabbarBottomSpacing, self.bounds.size.width, self.bounds.size.height - self.tabbar.frame.size.height - self.tabbarBottomSpacing)];
    self.slideContainView.delegate = self;
    self.slideContainView.dataSource = self;
    self.slideContainView.baseViewController = self.baseViewController;
    [self addSubview:self.slideContainView];
}

- (void)setBaseViewController:(UIViewController *)baseViewController {
    _baseViewController = baseViewController;
    self.slideContainView.baseViewController = baseViewController;

}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.slideContainView setSelectedIndex:selectedIndex];
    [self.tabbar setSelectedIndex:selectedIndex];
}

#pragma mark - delegate methods

- (void)tabbarView:(id)sender didSelectedIndex:(NSInteger)index {
    [self.slideContainView setSelectedIndex:index];
}

- (NSInteger)numberOfControllersInKLContainView:(KLContainView *)containView {
    return [self.delegate numberOfTabsInKLSlideView:self];
}

- (UIViewController *)containView:(KLContainView *)sender controllerIndex:(NSInteger)index {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)index];
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    } else {
        UIViewController *controller = [self.delegate slideView:self controllerIndex:index];
        [self.cache setObject:controller forKey:key];
        return controller;
    }
}

- (void)containView:(KLContainView *)slide switchingFrom:(NSInteger)formIndex to:(NSInteger)toIndex percent:(float)percent {
    [self.tabbar tabbarViewFrom:formIndex to:toIndex percent:percent];
}

- (void)containView:(KLContainView *)slide didSwitched:(NSInteger)index {
    _selectedIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didSelectedIndex:)]) {
        [self.delegate slideView:self didSelectedIndex:index];
    }
}

- (void)containView:(KLContainView *)slide cancelSwitched:(NSInteger)index {
    [self.tabbar setSelectedIndex:index];
}

@end
