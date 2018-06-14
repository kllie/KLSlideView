//
//  KLTitleTabbarView.m
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//


#import "KLTitleTabbarView.h"
#import "KLTools.h"

#define DT(x) [UIScreen mainScreen].bounds.size.width / 375.f * x

#define kViewTagBase 1000
#define kLabelTagBase 2000
#define kBadgeValueLabelTagBase 3000

@implementation KLTitleTabbarItem

+ (KLTitleTabbarItem *)itemWithTitle:(NSString *)title width:(CGFloat)width {
    return [[KLTitleTabbarItem alloc] initWithTitle:title width:width];
}

- (instancetype)initWithTitle:(NSString *)title width:(CGFloat)width {
    if (self = [super init]) {
        _title = title;
        _width = width;
    }
    return self;
}

@end

@interface KLTitleTabbarView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *trackView;

@end

@implementation KLTitleTabbarView

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.scrollView.frame = self.bounds;
}

#pragma mark - init methods

- (void)initView {
    _selectedIndex = -1;

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];

    _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - DT(2), self.bounds.size.width, DT(2))];
    [_scrollView addSubview:_trackView];
    _trackView.layer.cornerRadius = 2.0f;
}

#pragma mark - public methods

- (void)setBackgroundView:(UIView *)backgroundView {
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self insertSubview:backgroundView atIndex:0];
    }
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    NSInteger count = [self tabbarCount];
    for (int i = 0; i < count; i++) {
        if (i == self.selectedIndex) {
            continue;
        }
        UILabel *label = (UILabel *)[_scrollView viewWithTag:kLabelTagBase + i];
        label.textColor = normalColor;
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    UILabel *label = (UILabel *)[_scrollView viewWithTag:kLabelTagBase + self.selectedIndex];
    label.textColor = selectedColor;
}

- (void)setTrackColor:(UIColor *)trackColor{
    _trackColor = trackColor;
    _trackView.backgroundColor = trackColor;
}

- (void)setTrackHeight:(CGFloat)trackHeight {
    _trackHeight = trackHeight;
    _trackView.frame = CGRectMake(_trackView.frame.origin.x, _trackView.frame.origin.y, _trackView.frame.size.width, trackHeight);
}

- (void)setTrackBottomOffset:(CGFloat)trackBottomOffset {
    _trackBottomOffset = trackBottomOffset;
    _trackView.frame = CGRectMake(_trackView.frame.origin.x, self.bounds.size.height - _trackHeight - trackBottomOffset, _trackView.frame.size.width, _trackView.frame.size.height);
}

- (void)setTrackImage:(NSString *)trackImage {
    _trackImage = trackImage;
    _trackView.image = [UIImage imageNamed:trackImage];
}

- (void)setTabbarItems:(NSArray<KLTitleTabbarItem *> *)tabbarItems {
    if (_tabbarItems != tabbarItems) {
        _tabbarItems = tabbarItems;

        CGFloat height = self.bounds.size.height;
        CGFloat x = 0;
        NSInteger i = 0;
        for (KLTitleTabbarItem *item in tabbarItems) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, item.width, height)];
            backView.backgroundColor = [UIColor clearColor];
            backView.tag = kViewTagBase + i;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.width, height)];
            label.text = item.title;
            if (_font) {
                label.font = _font;
            } else {
                label.font = [UIFont systemFontOfSize:DT(14)];
            }
            label.backgroundColor = [UIColor clearColor];
            label.textColor = self.normalColor;
            [label sizeToFit];
            label.tag = kLabelTagBase + i;

            label.frame = CGRectMake((item.width - label.bounds.size.width) / 2, (height - label.bounds.size.height) / 2, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds));
            // add
            UILabel *badgeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DT(15), DT(15))];
            badgeValueLabel.center = CGPointMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y);
            badgeValueLabel.layer.masksToBounds = YES;
            badgeValueLabel.layer.cornerRadius = DT(15 / 2);
            badgeValueLabel.backgroundColor = [UIColor redColor];
            badgeValueLabel.textColor = [UIColor whiteColor];
            badgeValueLabel.textAlignment = NSTextAlignmentCenter;
            badgeValueLabel.font = [UIFont systemFontOfSize:DT(11)];
            badgeValueLabel.tag = kBadgeValueLabelTagBase + i;
            badgeValueLabel.hidden = YES;

            [backView addSubview:label];
            [backView addSubview:badgeValueLabel];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [backView addGestureRecognizer:tap];

            [_scrollView addSubview:backView];
            x += item.width;
            i++;
        }
        _scrollView.contentSize = CGSizeMake(x, height);
    }
}

#pragma mark - event response

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger i = tap.view.tag - kViewTagBase;
    self.selectedIndex = i;
    if (_delegate && [_delegate respondsToSelector:@selector(tabbarView:didSelectedIndex:)]) {
        [_delegate tabbarView:self didSelectedIndex:i];
    }
}

#pragma mark - protocol methods

- (NSInteger)tabbarCount {
    return self.tabbarItems.count;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex != selectedIndex) {
        if (_selectedIndex >= 0) {
            UILabel *fromLabel = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + _selectedIndex];
            fromLabel.textColor = self.normalColor;
        }
        if (selectedIndex >= 0 && selectedIndex < [self tabbarCount]) {
            UILabel *toLabel = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + selectedIndex];
            toLabel.textColor = self.selectedColor;

            UIView *selectedView = [self.scrollView viewWithTag:kViewTagBase + selectedIndex];
            CGRect rect = selectedView.frame;
            //选中的居中显示
            rect = CGRectMake(CGRectGetMidX(rect) - self.scrollView.bounds.size.width / 2, rect.origin.y, self.scrollView.bounds.size.width, rect.size.height);
            [self.scrollView scrollRectToVisible:rect animated:YES];

            // track view
            CGRect trackRect = [self.scrollView convertRect:toLabel.bounds fromView:toLabel];
            self.trackView.frame = CGRectMake(trackRect.origin.x, self.trackView.frame.origin.y, trackRect.size.width, CGRectGetHeight(self.trackView.bounds));
        }
        _selectedIndex = selectedIndex;
    }
}

- (void)tabbarViewFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent {
    UILabel *fromLabel = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + fromIndex];
    fromLabel.textColor = [KLTools getColorOfPercent:percent between:self.normalColor and:self.selectedColor];

    UILabel *toLabel = nil;
    if (toIndex >= 0 && toIndex < [self tabbarCount]) {
        toLabel = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + toIndex];
        toLabel.textColor = [KLTools getColorOfPercent:percent between:self.selectedColor and:self.normalColor];
    }

    // 计算track view位置和宽度
    CGRect fromLabelRect = [self.scrollView convertRect:fromLabel.bounds fromView:fromLabel];

    CGFloat fromX = fromLabelRect.origin.x;
    CGFloat fromWidth = fromLabel.frame.size.width;

    CGFloat toX = 0;
    CGFloat toWidth = 0;
    if (toLabel) {
        CGRect toLabelRect = [self.scrollView convertRect:toLabel.bounds fromView:toLabel];
        toWidth = toLabelRect.size.width;
        toX = toLabelRect.origin.x;
    } else {
        toWidth = fromWidth;
        if (toIndex > fromIndex) {
            toX = fromX + fromWidth;
        } else {
            toX = fromX - fromWidth;
        }
    }
    CGFloat width = toWidth * percent + fromWidth * (1 - percent);
    CGFloat x = fromX + (toX - fromX) * percent;
    self.trackView.frame = CGRectMake(x, self.trackView.frame.origin.y, width, CGRectGetHeight(self.trackView.bounds));
    _selectedIndex = toIndex;
}

- (void)tabbarViewBadgeValue:(NSInteger)value index:(NSInteger)index {
    if (index >= 0 && index < [self tabbarCount]) {
        UILabel *label = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + index];
        if (CGRectGetWidth(label.bounds) > 0) { // 如果参照Label宽度非0设置BadgeValue
            UILabel *badgeLabel = (UILabel *)[self.scrollView viewWithTag:kBadgeValueLabelTagBase + index];
            badgeLabel.frame = CGRectMake(0, 0, DT(15), DT(15));
            badgeLabel.center = CGPointMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y);
            badgeLabel.layer.masksToBounds = YES;
            badgeLabel.layer.cornerRadius = DT(15 / 2);
            if (value > 0) {
                badgeLabel.hidden = NO;
                if (value < 99) {
                    badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
                } else {
                    badgeLabel.text = @"99";
                }
            } else {
                badgeLabel.hidden = YES;
            }
        }
    }
}

- (void)tabbarViewBadgeDotWithIndex:(NSInteger)index {
    if (index >= 0 && index < [self tabbarCount]) {
        UILabel *label = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + index];
        if (CGRectGetWidth(label.bounds) > 0) { // 如果参照Label宽度非0设置BadgeDot
            UILabel *badgeLabel = (UILabel *)[self.scrollView viewWithTag:kBadgeValueLabelTagBase + index];
            badgeLabel.hidden = NO;
            badgeLabel.frame = CGRectMake(0, 0, DT(10), DT(10));
            badgeLabel.center = CGPointMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y);
            badgeLabel.layer.masksToBounds = YES;
            badgeLabel.layer.cornerRadius = DT(10 / 2);
            badgeLabel.text = @"";
        }
    }
}

@end
