//
//  BulletManager.m
//  DanmuDemo
//
//  Created by AtronJia on 16/8/16.
//  Copyright © 2016年 Artron. All rights reserved.
//

#import "BulletManager.h"

@interface BulletManager ()

//弹幕的数据源
@property (nonatomic, strong)NSMutableArray *dataSource;

//弹幕使用过程中的数组变量
@property (nonatomic, strong)NSMutableArray *bulletComments;

//存储弹幕view的数组变量
@property (nonatomic, strong)NSMutableArray *bulletViews;

//当前是否在进行动画
@property (nonatomic)BOOL isAnimating;

@end

@implementation BulletManager

/**
 *  Start Animation
 */
-(void)start {
    if (self.isAnimating) {
        return;
    }
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    self.isAnimating = YES;
    [self initBulletComment];
}

/**
 *  Stop Animation
 */
- (void)stop {
    if (!self.isAnimating) {
        return;
    }
    self.isAnimating = NO;
    
    //遍历数组,停止动画并清空view数组
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view =nil;
    }];
    [self.bulletViews removeAllObjects];
}

/**
 *  初始化轨迹和弹幕
 */
- (void)initBulletComment {
    NSMutableArray *trajectorys = [NSMutableArray array];
    for (int i = 0; i< (self.trajectoryNumber ? self.trajectoryNumber : 3); i++) {
        [trajectorys addObject:[NSNumber numberWithInt:i]];
    }
    
    //获取随机轨迹
    for (int i = 0; i<(self.trajectoryNumber ? self.trajectoryNumber : 3); i++) {
        if (self.bulletComments.count>0) {
            NSInteger index = arc4random()%trajectorys.count;
            NSInteger trajectory = [trajectorys[index] integerValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组取数据
            NSString *comment = self.bulletComments[0];
            [self.bulletComments removeObjectAtIndex:0];
            
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

/**
 *  创建view
 *
 *  @param comment    弹幕文字内容
 *  @param trajectory 轨迹index
 */
- (void)createBulletView:(NSString *)comment trajectory:(NSInteger)trajectory {
    if (!self.isAnimating) {
        return;
    }
    UIImage *img = [UIImage imageNamed:@"10_10.jpg"];
    BulletView *view = [[BulletView alloc] initWithComment:comment image:img];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;
    
    view.moveStatusBlock = ^(MoveStatus status){
        if (!self.isAnimating) {
            return ;
        }
        switch (status) {
            case Start:{
                //弹幕开始进入
                [weakSelf.bulletViews addObject:weakView];
                break;
            }
            case Enter:{
                //弹幕进去后判断是否还有数据，有则进入该轨道
                NSString *comment =[weakSelf nextComment];
                if (comment) {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            default:{
                //  End
                //移出屏幕后要销毁
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                if (weakSelf.bulletViews.count == 0) {
                    //最后一条数据已经结束滚动，开始循环
                    self.isAnimating = NO;
                    [weakSelf start];
                }
                break;
            }
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}


// 如果有下一条数据就显示
- (NSString *)nextComment {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = self.bulletComments[0];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:@"弹幕1～～～～～～～",@"弹幕2～～",@"弹幕3～～～～～～～～～～～～",@"弹幕4～～～～～～～",@"弹幕5～～～～～～～",@"弹幕6～～～～～～～",@"弹幕7～～～～～",@"弹幕8～",@"弹幕9～～～～～",@"弹幕10～～～～～",@"弹幕11～～～～～",@"弹幕12～～～～^^～～～", nil];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
