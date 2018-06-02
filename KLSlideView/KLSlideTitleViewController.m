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
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation KLSlideTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    self.itemArray = [NSMutableArray arrayWithCapacity:0];

    self.slideView = [[KLSlideView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.slideView.backgroundColor = [UIColor whiteColor];
    KLCache *cache = [[KLCache alloc] initWithCount:1];
    KLTitleTabbarView *tabbar = [[KLTitleTabbarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    tabbar.normalColor = [UIColor blackColor];
    tabbar.selectedColor = [UIColor redColor];
    tabbar.font = [UIFont systemFontOfSize:15];
    tabbar.trackColor = [UIColor redColor];

    CGFloat width = self.view.frame.size.width / 5;
//    CGFloat width = 80;
    [self.itemArray addObjectsFromArray:@[[KLTitleTabbarItem itemWithTitle:@"全部" width:width],
                                          [KLTitleTabbarItem itemWithTitle:@"待分类" width:width],
                                          [KLTitleTabbarItem itemWithTitle:@"已分类" width:width],
                                          [KLTitleTabbarItem itemWithTitle:@"待分组" width:width],
                                          [KLTitleTabbarItem itemWithTitle:@"已分组" width:width]]];

    tabbar.tabbarItems = self.itemArray;

    self.slideView.tabbar = tabbar;
    self.slideView.cache = cache;
    self.slideView.delegate = self;
    self.slideView.tabbarBottomSpacing = 5;
    self.slideView.baseViewController = self;
    [self.slideView setup];
    self.slideView.selectedIndex = 0;
    [self.view addSubview:self.slideView];

    [self.slideView.tabbar tabbarViewBadgeDotWithIndex:2];
    [self.slideView.tabbar tabbarViewBadgeValue:2 index:2];
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
