//
//  BulletView.h
//  DanmuDemo
//
//  Created by AtronJia on 16/8/16.
//  Copyright © 2016年 Artron. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  标注弹幕label在屏幕中的位置
 */
typedef NS_ENUM(NSInteger, MoveStatus) {
    /**
     *  开始进入屏幕
     */
    Start,
    /**
     *  完全进入屏幕
     */
    Enter,
    /**
     *  完全移出屏幕
     */
    End
};

@interface BulletView : UIView


@property (nonatomic, assign)NSInteger trajectory;  //标识进入的是第几条轨道轨道

// 根据在屏幕中的状态进行回调的block
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);


/**
 *  初始化弹幕
 *
 *  @param comment  弹幕文字
 *  @param photoImg 头像
 *
 *  @return self
 */
- (instancetype)initWithComment:(NSString *)comment image:(UIImage *)photoImg;

/**
 *  开始动画
 */
- (void)startAnimation;

/**
 *  停止动画
 */
- (void)stopAnimation;



@end
