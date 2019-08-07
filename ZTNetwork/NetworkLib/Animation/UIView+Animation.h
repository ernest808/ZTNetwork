//
//  UIView+Animation.h
//  SeqTool
//
//  Created by user on 14-11-10.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    DirectionTypeLeft,
    DirectionTypeRight
}DirectionType;

typedef void (^UIViewAnimationBlock)();

@interface UIView (Animation)

/**
 *  弹出视图
 *
 *  @param duration   时间间隔
 *  @param outvalue   最后大小（原大小为1）
 *  @param completion 完成后执行的Block
 */
-(void)AnimationPopOut:(CGFloat)duration outvalue:(CGFloat)outvalue completion:(void (^)(void))completion;
/**
 *  上下抖动
 *
 *  @param interval   时间间隔
 *  @param delay      时间延迟
 *  @param completion 完成后执行的Block
 */
-(void)AnimationUpAndDownAnimation:(float)interval delay:(float)delay completion:(void (^)(void))completion;
/**
 *  移除上下抖动动画
 */
-(void)RemoveAnimationUpAndDown;
/**
 *  心跳动画
 *
 *  @param duration   时间间隔
 *  @param scale      放大大小
 *  @param completion 完成后执行的Block
 */
-(void)AnimationHeartbeatAnimation:(float)duration scale:(float)scale completion:(void (^)(void))completion;
/**
 *  移除心跳动画
 */
-(void)RemoveAnimationHeartbeat;
/**
 *  闪圈动画
 *
 *  @param position   位置
 *  @param color      颜色
 *  @param radius     半径
 *  @param duration   播放时间
 *  @param inteval    时间间隔
 *  @param completion 完成后执行的Block
 */
-(void)AnimationSpread:(CGPoint)position color:(UIColor*)color radius:(CGFloat)radius duration:(CGFloat)duration inteval:(CGFloat)inteval completion:(void (^)(void))completion;
/**
 *  弹入弹出窗
 *
 *  @param duration   时间间隔
 *  @param type       类型：In/Out
 *  @param completion 完成后执行的Block
 */
-(void)AnimationPopInOut:(CGFloat)duration type:(NSString*)type completion:(void (^)(void))completion;
/**
 *  渐变改变图片动画
 *
 *  @param image      修改后的图片
 *  @param duration   时间间隔
 *  @param completion 完成后执行的Block
 */
-(void)AnimationChangeImage:(UIImage*)image duration:(CGFloat)duration completion:(void (^)(void))completion;
/**
 *  翻转动画
 *
 *  @param flipTransition 翻转类型
 *  @param duration       时间间隔
 */
-(void)AnimationFlip:(UIViewAnimationTransition)flipTransition duration:(float)duration;
/**
 *  修改大小动画
 *
 *  @param oldFrame   旧Frame
 *  @param newFrame   新Frame
 *  @param duration   时间间隔
 *  @param completion 完成后执行的Block
 */
-(void)AnimationChangeFrame:(CGRect)oldFrame newFrame:(CGRect)newFrame duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion;
/**
 *  旋转动画
 *
 *  @param duration   时间间隔
 *  @param fromValue  开始Value
 *  @param toValue    结束Value
 *  @param completion 完成后执行的Block
 */
-(void)AnimationRotation:(CGFloat)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue completion:(void (^)(void))completion;
/**
 *  升起动画
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param completion 完成后执行的Block
 */
-(void)AnimationRising:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion;
/**
 *  闪光动画
 *
 *  @param repeatCount 重复次数
 *  @param duration    时间间隔
 *  @param delay       延迟时间
 *  @param maskWidth   完成后执行的Block
 */
-(void)AnimationShine:(float)repeatCount duration:(CFTimeInterval)duration delay:(CGFloat)delay maskWidth:(CGFloat)maskWidth;
/**
 *  Y轴方向的闪光动画
 *
 *  @param repeatCount 重复次数
 *  @param duration    时间间隔
 *  @param delay       延迟时间
 *  @param maskHeight  完成后执行的Block
 */
-(void)AnimationShineY:(float)repeatCount duration:(CFTimeInterval)duration delay:(CGFloat)delay maskHeight:(CGFloat)maskHeight;
-(void)RemoveAnimationShine;
/**
 *  从左到右显示图片
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param completion 完成后执行的Block
 */
-(void)AnimationShowToRight:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion;

/**
 *  从上到下显示图片
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param completion 完成后执行的Block
 */
-(void)AnimationShowToBottom:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion;

/**
 *  从右到左显示图片
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param completion 完成后执行的Block
 */
-(void)AnimationShowToLeft:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion;

/**
 *  从右下到左上显示图片
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param completion 完成后执行的Block
 */
-(void)AnimationShowToLeftTop:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion;

/**
 *  从右上到左下显示图片
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param completion 完成后执行的Block
 */
-(void)AnimationShowToLeftBottom:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion;

/**
 *  渐变显示
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param FadeIn     是否显示
 *  @param completion 完成后执行的Block
 */
-(void)AnimationFade:(CGFloat)duration delay:(CGFloat)delay FadeIn:(BOOL)FadeIn completion:(void (^)(void))completion;
/**
 *  水波纹动画
 *
 *  @param newView  新的界面
 *  @param duration 时间间隔
 */
-(void)AnimationRipple:(UIView*)newView duration:(CGFloat)duration;
/**
 *  翻转到左边
 *
 *  @param duration 时间间隔
 */
-(void)AnimationFlipFromLeft:(CGFloat)duration;
/**
 *  翻转到右边
 *
 *  @param duration 时间间隔
 */
-(void)AnimationFlipFromRight:(CGFloat)duration;
/**
 *  翻牌动画
 *
 *  @param duration  时间间隔
 *  @param delay     延迟时间
 *  @param fromValue 开始值
 *  @param toValue   结束值
 */
-(void)AnimationFlip:(CGFloat)duration delay:(CGFloat)delay zFromValue:(CGFloat)fromValue zToValue:(CGFloat)toValue;
/**
 *  从中心扩大动画效果
 *
 *  @param duration   时间间隔
 *  @param delay      延迟时间
 *  @param fromFrame  开始Frame
 *  @param completion 完成后执行的Block
 */
-(void)AnimationShowExpandWithImage:(UIImage*)image duration:(CGFloat)duration delay:(CGFloat)delay fromFrame:(CGRect)fromFrame completion:(void (^)(void))completion;

@end
