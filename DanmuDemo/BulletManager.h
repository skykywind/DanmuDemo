//
//  BulletManager.h
//  DanmuDemo
//
//  Created by AtronJia on 16/8/16.
//  Copyright © 2016年 Artron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletView.h"

@interface BulletManager : NSObject

/**
 *  回调block，给加载弹幕的view 传递 BulletView
 */
@property (nonatomic,copy) void(^generateViewBlock)(BulletView *view);

/**
 *  轨道数量
 */
@property (nonatomic, assign)NSInteger trajectoryNumber;

/**
 *  弹幕开始执行
 */
- (void)start;

/**
 *  弹幕结束
 */
- (void)stop;

@end
