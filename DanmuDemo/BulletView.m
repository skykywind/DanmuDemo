//
//  BulletView.m
//  DanmuDemo
//
//  Created by AtronJia on 16/8/16.
//  Copyright © 2016年 Artron. All rights reserved.
//

#import "BulletView.h"

#define Padding 10
#define PhotoWidth 30
@interface BulletView ()

@property (nonatomic, strong)UILabel *lbComment;        // label
@property (nonatomic, strong)UIImageView *photoImg;     // photo

@property (nonatomic, strong)NSArray *colors;           // 随机色数组
@end

@implementation BulletView

//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment image:(UIImage *)photoImg {

    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        CGFloat width = [comment sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + PhotoWidth, 30);
        self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + PhotoWidth, 0, width, 30);
        
        self.photoImg.frame = CGRectMake(-Padding, -Padding , Padding+PhotoWidth, Padding+PhotoWidth);
        self.photoImg.layer.cornerRadius = (Padding + PhotoWidth)/2;
        self.photoImg.image = photoImg;
    }
    
    return self;
}
/**
 *  开始动画
 */
- (void)startAnimation {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    // 得到完全进入屏幕的时间
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    CGFloat delayTime = arc4random()%10 * 0.2; //延迟0～2s看起来效果更好
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration +delayTime];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:delayTime options:UIViewAnimationOptionCurveLinear animations:^{
        
        frame.origin.x -= wholeWidth;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}



//完全进入屏幕时回调（追加下一条评论）
- (void)enterScreen {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}
/**
 *  停止动画
 */
- (void)stopAnimation {
    //停止追加新的弹幕
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (UILabel *)lbComment {
    
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [self.colors objectAtIndex:(arc4random()%self.colors.count)];
        [self addSubview:_lbComment];
    }
    return _lbComment;
}
- (UIImageView *)photoImg {
    
    if (!_photoImg) {
        _photoImg = [UIImageView new];
        _photoImg.clipsToBounds = YES;
        _photoImg.backgroundColor =[UIColor cyanColor];
        _photoImg.layer.borderColor = [UIColor redColor].CGColor;
        _photoImg.layer.borderWidth = 1;
        _photoImg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_photoImg];
    }
    return _photoImg;
}

- (NSArray *)colors {
    if (!_colors) {
        _colors= @[[UIColor orangeColor], [UIColor greenColor], [UIColor whiteColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor purpleColor], [UIColor brownColor], [UIColor grayColor], [UIColor darkGrayColor]];
    }
    return _colors;
}
@end
