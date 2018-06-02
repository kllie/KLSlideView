//
//  PageViewController.m
//  KLSlideView
//
//  Created by Neville on 2017/7/10.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 20)];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.pageLabel];
}

@end
