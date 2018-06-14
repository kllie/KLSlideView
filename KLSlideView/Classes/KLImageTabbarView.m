//
//  KLImageTabbarView.m
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import "KLImageTabbarView.h"
#import "KLTools.h"

#define DT(x) [UIScreen mainScreen].bounds.size.width / 375.f * x

#define kImageSpacingX 3.0f

#define kViewTagBase 1000
#define kLabelTagBase 2000
#define kImageTagBase 3000
#define kSelectedImageTagBase 4000
#define kBadgeValueLabelTagBase 5000

@implementation KLImageTabbarItem

+ (KLImageTabbarItem *)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage width:(CGFloat)width {
    return [[KLImageTabbarItem alloc] initWithTitle:title image:image selectedImage:selectedImage width:width];
}
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage width:(CGFloat)width {
    if (self = [super init]) {
        _title = title;
        _image = image;
        _width = width;
        _selectedImage = selectedImage;
    }
    return self;
}

@end

@interface KLImageTabbarView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *trackView;

@end

@implementation KLImageTabbarView

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

- (void)setTabbarItems:(NSArray<KLImageTabbarItem *> *)tabbarItems {
    if (_tabbarItems != tabbarItems) {
        _tabbarItems = tabbarItems;

        CGFloat height = self.bounds.size.height;
        CGFloat x = 0.0f;
        NSInteger i = 0;
        for (KLImageTabbarItem *item in tabbarItems) {
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

            UIImageView *imageView = [[UIImageView alloc] initWithImage:item.image];
            [imageView sizeToFit];
            imageView.tag = kImageTagBase + i;

            UIImageView *selectImageView = [[UIImageView alloc] initWithImage:item.selectedImage];
            [selectImageView sizeToFit];
            selectImageView.alpha = 0.0;
            selectImageView.tag = kSelectedImageTagBase + i;

            // add
            UILabel *badgeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DT(15), DT(15))];
            badgeValueLabel.backgroundColor = [UIColor redColor];
            badgeValueLabel.textColor = [UIColor whiteColor];
            badgeValueLabel.textAlignment = NSTextAlignmentCenter;
            badgeValueLabel.font = [UIFont systemFontOfSize:DT(11)];
            badgeValueLabel.tag = kBadgeValueLabelTagBase + i;
            badgeValueLabel.hidden = YES;

            [backView addSubview:label];
            [backView addSubview:imageView];
            [backView addSubview:selectImageView];
            [backView addSubview:badgeValueLabel];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [backView addGestureRecognizer:tap];

            [_scrollView addSubview:backView];
            x += item.width;
            i++;
        }
        _scrollView.contentSize = CGSizeMake(x, height);
        [self layoutTabbar];
    }
}
#pragma mark -event response

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
            UIImageView *fromImageView = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + _selectedIndex];
            UIImageView *fromSelectedIamgeView = (UIImageView *)[self.scrollView viewWithTag:kSelectedImageTagBase + _selectedIndex];
            fromLabel.textColor = self.normalColor;
            fromImageView.alpha = 1.0f;
            fromSelectedIamgeView.alpha = 0.0f;
        }
        if (selectedIndex >= 0 && selectedIndex < [self tabbarCount]) {
            UILabel *toLabel = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + selectedIndex];
            UIImageView *toImageView = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + selectedIndex];
            UIImageView *toSelectedIamgeView = (UIImageView *)[self.scrollView viewWithTag:kSelectedImageTagBase + selectedIndex];
            toLabel.textColor = self.selectedColor;
            toImageView.alpha = 0.0f;
            toSelectedIamgeView.alpha = 1.0f;

            UIView *selectedView = [self.scrollView viewWithTag:kViewTagBase + selectedIndex];
            CGRect selectedViewRect = selectedView.frame;
            //选中的居中显示
            selectedViewRect = CGRectMake(CGRectGetMidX(selectedViewRect) - self.scrollView.bounds.size.width / 2, selectedViewRect.origin.y, self.scrollView.bounds.size.width, selectedViewRect.size.height);
            [self.scrollView scrollRectToVisible:selectedViewRect animated:YES];

            // track view
            CGRect toLabelRect = [self.scrollView convertRect:toLabel.bounds fromView:toLabel];
            CGRect toImageViewRect = [self.scrollView convertRect:toImageView.bounds fromView:toImageView];

            if (self.position == KLTabbarViewImagePositionRight) {
                self.trackView.frame = CGRectMake(toLabelRect.origin.x, self.trackView.frame.origin.y, toLabelRect.size.width + toImageViewRect.size.width + kImageSpacingX, CGRectGetHeight(self.trackView.bounds));
            }
            if (self.position == KLTabbarViewImagePositionLeft) {
                self.trackView.frame = CGRectMake(toImageViewRect.origin.x, self.trackView.frame.origin.y, toLabelRect.size.width + toImageViewRect.size.width + kImageSpacingX, CGRectGetHeight(self.trackView.bounds));
            }
        }
        _selectedIndex = selectedIndex;
    }
}

- (void)tabbarViewFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent {
    UILabel *fromLabel = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + fromIndex];
    UIImageView *fromImageView = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + fromIndex];
    UIImageView *fromSelectedIamgeView = (UIImageView *)[self.scrollView viewWithTag:kSelectedImageTagBase + fromIndex];
    fromLabel.textColor = [KLTools getColorOfPercent:percent between:self.normalColor and:self.selectedColor];
    fromImageView.alpha = percent;
    fromSelectedIamgeView.alpha = (1.0 - percent);

    UILabel *toLabel = nil;
    UIImageView *toImageView = nil;
    UIImageView *toSelectedIamgeView = nil;
    if (toIndex >= 0 && toIndex < [self tabbarCount]) {
        toLabel = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + toIndex];
        toImageView = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + toIndex];
        toSelectedIamgeView = (UIImageView *)[self.scrollView viewWithTag:kSelectedImageTagBase + toIndex];
        toLabel.textColor = [KLTools getColorOfPercent:percent between:self.selectedColor and:self.normalColor];
        toImageView.alpha = (1.0 - percent);
        toSelectedIamgeView.alpha = percent;
    }

    // 计算track view位置和宽度
    CGRect fromLabelRect = [self.scrollView convertRect:fromLabel.bounds fromView:fromLabel];
    CGRect fromImageRect = [self.scrollView convertRect:fromImageView.bounds fromView:fromImageView];

    CGFloat fromX = 0;
    if (self.position == KLTabbarViewImagePositionRight) {
        fromX = fromLabelRect.origin.x;
    }
    if (self.position == KLTabbarViewImagePositionLeft) {
        fromX = fromImageRect.origin.x;
    }
    CGFloat fromWidth = fromLabelRect.size.width + fromImageRect.size.width + kImageSpacingX;
    CGFloat toX = 0;
    CGFloat toWidth;
    if (toLabel && toImageView) {
        CGRect toLabelRect = [self.scrollView convertRect:toLabel.bounds fromView:toLabel];
        CGRect toImageRect = [self.scrollView convertRect:toImageView.bounds fromView:toImageView];
        if (self.position == KLTabbarViewImagePositionRight) {
            toX = toLabelRect.origin.x;
        }
        if (self.position == KLTabbarViewImagePositionLeft) {
            toX = toImageRect.origin.x;
        }
        toWidth = toLabelRect.size.width + toImageRect.size.width + kImageSpacingX;
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
        UIView *view = nil;
        if (self.position == KLTabbarViewImagePositionRight) {
            view = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + index];
            if (CGRectGetWidth(view.bounds) == 0) { // 如果未设置图片，默认取标题作为参考坐标
                view = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + index];
            }
        }
        if (self.position == KLTabbarViewImagePositionLeft) {
            view = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + index];
            if (CGRectGetWidth(view.bounds) == 0) { // 如果未设置标题，默认取图片作为参考坐标
                view = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + index];
            }
        }
        if (CGRectGetWidth(view.bounds) > 0) {  // 如果Width宽度非0时设置BadgeValue，否则不设置
            UILabel *badgeLabel = (UILabel *)[self.scrollView viewWithTag:kBadgeValueLabelTagBase + index];
            badgeLabel.frame = CGRectMake(0, 0, DT(15), DT(15));
            badgeLabel.center = CGPointMake(CGRectGetMaxX(view.frame), CGRectGetMinY(view.frame));
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
        UIView *view = nil;
        if (self.position == KLTabbarViewImagePositionRight) {
            view = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + index];
            if (CGRectGetWidth(view.bounds) == 0) { // 如果未设置图片，默认取标题作为参考坐标
                view = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + index];
            }
        }
        if (self.position == KLTabbarViewImagePositionLeft) {
            view = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + index];
            if (CGRectGetWidth(view.bounds) == 0) { // 如果未设置标题，默认取图片作为参考坐标
                view = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + index];
            }
        }
        if (CGRectGetWidth(view.bounds) > 0) {  // 如果Width宽度非0时设置BadgeDot，否则不设置
            UILabel *badgeLabel = (UILabel *)[self.scrollView viewWithTag:kBadgeValueLabelTagBase + index];
            badgeLabel.hidden = NO;
            badgeLabel.frame = CGRectMake(0, 0, DT(10), DT(10));
            badgeLabel.center = CGPointMake(CGRectGetMaxX(view.frame), CGRectGetMinY(view.frame));
            badgeLabel.layer.masksToBounds = YES;
            badgeLabel.layer.cornerRadius = DT(10 / 2);
            badgeLabel.text = @"";
        }
    }
}

#pragma mark - private methods

- (void)layoutTabbar {
    CGFloat height = self.bounds.size.height;
    NSInteger i = 0;
    for (KLImageTabbarItem *item in self.tabbarItems) {
        UILabel *label = (UILabel *)[self.scrollView viewWithTag:kLabelTagBase + i];
        UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:kImageTagBase + i];
        UIImageView *selectedIamgeView = (UIImageView *)[self.scrollView viewWithTag:kSelectedImageTagBase + i];
        UILabel *badgeLabel = (UILabel *)[self.scrollView viewWithTag:kBadgeValueLabelTagBase + i];
        
        if (self.position == KLTabbarViewImagePositionRight) {
            label.frame = CGRectMake((item.width - CGRectGetWidth(label.bounds) - CGRectGetWidth(imageView.bounds) - kImageSpacingX) / 2, (height - CGRectGetHeight(label.bounds)) / 2, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds));
            imageView.frame = CGRectMake(CGRectGetMaxX(label.frame) + kImageSpacingX, (height - CGRectGetHeight(imageView.bounds)) / 2, CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds));
            badgeLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) - CGRectGetWidth(badgeLabel.bounds) / 2, imageView.frame.origin.y - CGRectGetHeight(badgeLabel.bounds) / 2, CGRectGetWidth(badgeLabel.bounds), CGRectGetHeight(badgeLabel.bounds));
        }
        if (self.position == KLTabbarViewImagePositionLeft) {
            imageView.frame = CGRectMake((item.width - CGRectGetWidth(label.bounds) - CGRectGetWidth(imageView.bounds) - kImageSpacingX) / 2, (height - CGRectGetHeight(imageView.bounds)) / 2, CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds));
            label.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + kImageSpacingX, (height - CGRectGetHeight(label.bounds)) / 2, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds));
            badgeLabel.frame = CGRectMake(CGRectGetMaxX(label.frame) - CGRectGetWidth(badgeLabel.bounds) / 2, label.frame.origin.y - CGRectGetHeight(badgeLabel.bounds) / 2, CGRectGetWidth(badgeLabel.bounds), CGRectGetHeight(badgeLabel.bounds));
        }
        selectedIamgeView.frame = imageView.frame;
        i++;
    }
}

@end
