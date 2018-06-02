//
//  ViewController.m
//  KLSlideView
//
//  Created by zhaobinhua on 2018/6/2.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "ViewController.h"
#import "KLSlideTitleViewController.h"
#import "KLSlideImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(20, 100, 100, 30);
    [titleButton setTitle:@"纯文字样式" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleButton addTarget:self action:@selector(titleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(20, 150, 100, 30);
    [imageButton setTitle:@"图文样式" forState:UIControlStateNormal];
    [imageButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    imageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [imageButton addTarget:self action:@selector(imageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageButton];
}

- (void)titleButtonAction {
    
    KLSlideTitleViewController *controller = [[KLSlideTitleViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)imageButtonAction {
    
    KLSlideImageViewController *controller = [[KLSlideImageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
