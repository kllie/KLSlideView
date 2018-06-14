//
//  KLSlideTitleViewController.m
//  KLSlideView
//
//  Created by Neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import "KLSlideTitleViewController.h"
#import "KLSlideView.h"
#import "PageViewController.h"

@interface KLSlideTitleViewController ()<KLSlideViewDelegate>

@property (nonatomic, strong) KLSlideView *slideView;
@property (nonatomic, strong) KLTitleTabbarView *tabbar;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation KLSlideTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];

    [self.slideView.tabbar tabbarViewBadgeDotWithIndex:2];
    [self.slideView.tabbar tabbarViewBadgeValue:2 index:2];
}

- (KLSlideView *)slideView {
    if (!_slideView) {
        _slideView = [[KLSlideView alloc] initWithFrame:CGRectZero];
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.cache = [[KLCache alloc] initWithCount:self.itemArray.count];
        _slideView.delegate = self;
        _slideView.baseViewController = self;
        _slideView.tabbarBottomSpacing = 5;
        _slideView.selectedIndex = 0;
        _slideView.lineColor = [UIColor blueColor];
        _slideView.tabbar = self.tabbar;
    }
    return _slideView;
}

- (KLTitleTabbarView *)tabbar {
    if (!_tabbar) {
        _tabbar = [[KLTitleTabbarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        _tabbar.normalColor = [UIColor blackColor];
        _tabbar.selectedColor = [UIColor redColor];
        _tabbar.font = [UIFont systemFontOfSize:14];
        _tabbar.trackColor = [UIColor redColor];
        _tabbar.trackHeight = 5;
        _tabbar.trackBottomOffset = 10;
        _tabbar.tabbarItems = self.itemArray;
        
    }
    return _tabbar;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *titleArray = @[@"全部", @"待分类", @"已分类", @"待分组", @"已分组"];
        CGFloat width = self.view.frame.size.width / titleArray.count;
        for (NSString *title in titleArray) {
            [_itemArray addObject:[KLTitleTabbarItem itemWithTitle:title width:width]];
        }
    }
    return _itemArray;
}

- (NSInteger)numberOfTabsInKLSlideView:(KLSlideView *)slideView {
    return self.itemArray.count;
}
- (UIViewController *)slideView:(KLSlideView *)slideView controllerIndex:(NSInteger)index {
    PageViewController *page = [[PageViewController alloc] init];
    page.view.backgroundColor = [UIColor colorWithRed:arc4random() %256/256.0 green:arc4random() %256/256.0 blue:arc4random() %256/256.0 alpha:1];
    page.pageLabel.text = ((KLTitleTabbarItem *)self.itemArray[index]).title;
    return page;
}

@end
