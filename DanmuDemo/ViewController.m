//
//  ViewController.m
//  DanmuDemo
//
//  Created by AtronJia on 16/8/16.
//  Copyright © 2016年 Artron. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
@interface ViewController ()
@property (nonatomic,strong)BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[BulletManager alloc] init];
    self.manager.trajectoryNumber = 5;
    __weak typeof(self) weakSelf = self;
    self.manager.generateViewBlock = ^(BulletView *view) {
        [weakSelf addBulletView:view];
    };
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [self.view addSubview:btn];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"stop" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickstopBtn) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(250, 100, 100, 40);
    [self.view addSubview:btn1];
}


- (void)clickstopBtn {
    [self.manager stop];
}
- (void)clickBtn {
    NSLog(@"开始执行");
    [self.manager start];
}

- (void)addBulletView:(BulletView *)view {
    CGFloat padding = 10; //弹幕photo起始位置为－padding，此处修正了一下
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width + padding, 300 + view.trajectory * 40, CGRectGetWidth(view.bounds), 30);
    [self.view addSubview:view];
    [view startAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
