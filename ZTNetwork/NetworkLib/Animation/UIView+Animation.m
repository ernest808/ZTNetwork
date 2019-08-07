//
//  UIView+Animation.m
//  SeqTool
//
//  Created by user on 14-11-10.
//
//

#import "UIView+Animation.h"
#import "UIView+Custom.h"
#import <objc/runtime.h>

@interface UIView (Animation_Private)

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(UIViewAnimationBlock)block forKey:(void *)blockKey;

@end

@implementation UIView (Animation)

static char kAnimationDidStopBlockKey;

#pragma mark -
#pragma mark Set blocks

- (void)runBlockForKey:(void *)blockKey {
    UIViewAnimationBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block();
}

- (void)setBlock:(UIViewAnimationBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self runBlockForKey:&kAnimationDidStopBlockKey];
}

-(void)AnimationPopOut:(CGFloat)duration outvalue:(CGFloat)outvalue completion:(void (^)(void))completion
{
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.removedOnCompletion = NO;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:outvalue],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    fadeOut.duration = duration * .6f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeOut.beginTime = duration * .3f;
    fadeOut.fillMode = kCAFillModeBoth;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBoth;
    
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setValue:self forKey:@"kFTAnimationTargetViewKey"];
    
    group.delegate = self;
    
    [self setBlock:completion forKey:&kAnimationDidStopBlockKey];
    
    [self.layer addAnimation:group forKey:@"kFTAnimationPopOut"];
}

-(void)RemoveAnimationPopOut
{
    [self.layer removeAnimationForKey:@"kFTAnimationPopOut"];
}

-(void)AnimationUpAndDownAnimation:(float)interval delay:(float)delay completion:(void (^)(void))completion
{
    [self setAlpha:1.0f];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y-10)];
    animation.autoreverses = YES;
    animation.duration = interval;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    
    animation.delegate = self;
    
    [self setBlock:completion forKey:&kAnimationDidStopBlockKey];
    
    [self.layer addAnimation:animation forKey:@"UpAndDownAnimation"];
}

-(void)RemoveAnimationUpAndDown
{
    [self.layer removeAnimationForKey:@"UpAndDownAnimation"];
}

-(void)AnimationHeartbeatAnimation:(float)duration scale:(float)scale completion:(void (^)(void))completion
{
    [self AnimationHeartbeatAnimation:duration repeatCount:HUGE_VALF scale:scale completion:completion];
}

-(void)AnimationHeartbeatAnimation:(float)duration repeatCount:(float)repeatCount scale:(float)scale completion:(void (^)(void))completion
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = repeatCount;
    
    animation.delegate = self;
    
    [self setBlock:completion forKey:&kAnimationDidStopBlockKey];
    
    [self.layer addAnimation:animation forKey:@"AnimationHeart"];
}

-(void)RemoveAnimationHeartbeat
{
    [self.layer removeAnimationForKey:@"AnimationHeart"];
}

-(void)AnimationPopInOut:(CGFloat)duration type:(NSString*)type completion:(void (^)(void))completion
{
    [self setAlpha:1.0f];
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.removedOnCompletion = NO;
    if ([type isEqualToString:@"Out"]) {
        scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                        [NSNumber numberWithFloat:1.1f],
                        [NSNumber numberWithFloat:.9f],
                        nil];
    }else{
        scale.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:1.2f],
                        [NSNumber numberWithFloat:.9f],
                        [NSNumber numberWithFloat:1.f],
                        nil];
    }
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    if ([type isEqualToString:@"Out"]) {
        fadeOut.duration = duration * .4f;
        fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
        fadeOut.toValue = [NSNumber numberWithFloat:0.f];
        fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        fadeOut.beginTime = duration * .6f;
        fadeOut.fillMode = kCAFillModeBoth;
    }else{
        fadeOut.fromValue = [NSNumber numberWithFloat:0.f];
        fadeOut.toValue = [NSNumber numberWithFloat:1.f];
        fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        fadeOut.fillMode = kCAFillModeForwards;
    }
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    if([type isEqualToString:@"Out"]) {
        group.fillMode = kCAFillModeBoth;
    }
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setValue:self forKey:@"kFTAnimationTargetViewKey"];
    
    group.delegate = self;
    
    [self setBlock:completion forKey:&kAnimationDidStopBlockKey];
    
    [self.layer addAnimation:group forKey:@"kFTAnimationPopOut"];
}

-(void)AnimationChangeImage:(UIImage*)image duration:(CGFloat)duration completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)self;
        if (imageView.image) {
            UIImageView *tempView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
            [tempView setImage:imageView.image];
            [imageView setImage:Nil];
            [imageView addSubview:tempView];
            
            UIImageView *tempView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [tempView1 setImage:image];
            [imageView addSubview:tempView1];
            [tempView1 setAlpha:0.0f];
            
            [UIView animateWithDuration:duration
                             animations:^{
                                 [tempView setAlpha:0];
                                 [tempView1 setAlpha:1.0f];
                                 [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, image.size.width, image.size.height)];
                             }
                             completion:^(BOOL finished) {
                                 [tempView removeFromSuperview];
                                 [tempView1 removeFromSuperview];
                                 [imageView setImage:image];
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }else{
            [imageView setImage:image];
        }
    }
}

-(void)AnimationFlip:(UIViewAnimationTransition)flipTransition duration:(float)duration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationTransition:flipTransition forView:self cache:YES];
    
    [UIView commitAnimations];
}

-(void)AnimationChangeFrame:(CGRect)oldFrame newFrame:(CGRect)newFrame duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion
{
    [self setFrame:oldFrame];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self setFrame:newFrame];
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

-(void)AnimationRotation:(CGFloat)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue completion:(void (^)(void))completion
{
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:M_PI * fromValue]];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * toValue]];
    [spin setDuration:duration];
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //添加动画
    [[self layer] addAnimation:spin forKey:nil];
    self.transform = CGAffineTransformMakeRotation(M_PI * toValue);
}

-(void)AnimationRising:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion
{
    [self setAlpha:0.0f];
    self.centerY += 25;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self setAlpha:1.0f];
        self.centerY -= 25;
    } completion:^(BOOL finished){
        if (completion) {
            completion();
        }
    }];
}

-(void)AnimationShine:(float)repeatCount duration:(CFTimeInterval)duration delay:(CGFloat)delay maskWidth:(CGFloat)maskWidth {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *shineLayer = [CALayer layer];
    
    CIImage *coreImage = [CIImage imageWithCGImage:viewImage.CGImage];
    CIImage *output = [CIFilter filterWithName:@"CIColorControls"
                                 keysAndValues:kCIInputImageKey, coreImage,
                       @"inputBrightness", @1.0f,
                       nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:output fromRect:output.extent];
    UIImage *shineImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    shineLayer.contents = (id) shineImage.CGImage;
    shineLayer.frame = CGRectMake(0, 0, width, height);
    
    CALayer *mask = [CALayer layer];
    mask.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat maskHeight = floorf(viewImage.size.height);
    
    UIGraphicsBeginImageContext(CGSizeMake(maskWidth, maskHeight));
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    id clearColor = (__bridge id) [UIColor clearColor].CGColor;
    id blackColor = (__bridge id) [UIColor blackColor].CGColor;
    CGFloat locations[] = { 0.0f, 0.5f, 1.0f };
    NSArray *colors = @[ clearColor, blackColor, clearColor ];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef)colors,
                                                        locations);
    CGFloat midY = floorf(maskHeight/2);
    CGPoint startPoint = CGPointMake(0, midY);
    CGPoint endPoint = CGPointMake(floorf(maskWidth/2), midY);
    
    CGContextDrawLinearGradient(context1, gradient, startPoint, endPoint, 0);
    CFRelease(gradient);
    CFRelease(colorSpace);
    
    UIImage *maskImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mask.contents = (id) maskImage.CGImage;
    mask.contentsGravity = kCAGravityCenter;
    mask.frame = CGRectMake(-width, 0, width * 1.25, height);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    anim.byValue = @(width * 2);
    anim.repeatCount = repeatCount;
    anim.duration = duration;
    anim.beginTime = delay;
    anim.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addSublayer:shineLayer];
    shineLayer.mask = mask;
    
    [mask addAnimation:anim forKey:@"AnimationShine"];
}

-(void)AnimationShineLeft:(float)repeatCount duration:(CFTimeInterval)duration delay:(CGFloat)delay maskWidth:(CGFloat)maskWidth {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *shineLayer = [CALayer layer];
    
    CIImage *coreImage = [CIImage imageWithCGImage:viewImage.CGImage];
    CIImage *output = [CIFilter filterWithName:@"CIColorControls"
                                 keysAndValues:kCIInputImageKey, coreImage,
                       @"inputBrightness", @1.0f,
                       nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:output fromRect:output.extent];
    UIImage *shineImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    shineLayer.contents = (id) shineImage.CGImage;
    shineLayer.frame = CGRectMake(0, 0, width, height);
    
    CALayer *mask = [CALayer layer];
    mask.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat maskHeight = floorf(viewImage.size.height);
    
    UIGraphicsBeginImageContext(CGSizeMake(maskWidth, maskHeight));
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    id clearColor = (__bridge id) [UIColor clearColor].CGColor;
    id blackColor = (__bridge id) [UIColor blackColor].CGColor;
    CGFloat locations[] = { 0.0f, 0.5f, 1.0f };
    NSArray *colors = @[ clearColor, blackColor, clearColor ];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef)colors,
                                                        locations);
    CGFloat midY = floorf(maskHeight/2);
    CGPoint startPoint = CGPointMake(0, midY);
    CGPoint endPoint = CGPointMake(floorf(maskWidth/2), midY);
    
    CGContextDrawLinearGradient(context1, gradient, startPoint, endPoint, 0);
    CFRelease(gradient);
    CFRelease(colorSpace);
    
    UIImage *maskImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mask.contents = (id) maskImage.CGImage;
    mask.contentsGravity = kCAGravityCenter;
    mask.frame = CGRectMake(-width, 0, width * 1.25, height);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.x"];
//    anim.byValue = @(width * 2);
    anim.fromValue = @(width * 2);
    anim.toValue = 0;
    anim.repeatCount = repeatCount;
    anim.duration = duration;
    anim.beginTime = delay;
    anim.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.layer addSublayer:shineLayer];
    shineLayer.mask = mask;
    
    [mask addAnimation:anim forKey:@"AnimationShine"];
}

-(void)AnimationShineXY:(float)repeatCount duration:(CFTimeInterval)duration delay:(CGFloat)delay maskWidth:(CGFloat)maskWidth {
    
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    gradientLayer.backgroundColor   = [[UIColor blackColor] CGColor];
    gradientLayer.startPoint        = CGPointMake(-0.45f, -2.);
    gradientLayer.endPoint          = CGPointMake(0., 1.);
    gradientLayer.colors            = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor],(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.layer addSublayer:gradientLayer];
    
    CALayer *mask              = [CALayer layer];
    mask.backgroundColor      = [[UIColor clearColor] CGColor];
    mask.contentsScale        = [[UIScreen mainScreen] scale];
    mask.rasterizationScale   = [[UIScreen mainScreen] scale];
    mask.bounds               = self.bounds;
    mask.anchorPoint          = CGPointZero;
    
    /* set initial values for the textLayer because they may have been loaded from a nib */
    
    gradientLayer.mask = mask;
    
    CABasicAnimation *startPointAnimation = [CABasicAnimation animationWithKeyPath:@"startPoint"];
    startPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 0)];
    startPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *endPointAnimation = [CABasicAnimation animationWithKeyPath:@"endPoint"];
    endPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1+0.45f, 0)];
    endPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:startPointAnimation, endPointAnimation, nil];
    group.duration = duration;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.repeatCount = FLT_MAX;
    
    [gradientLayer addAnimation:group forKey:@"AnimationShine"];
}

-(void)AnimationShineY:(float)repeatCount duration:(CFTimeInterval)duration delay:(CGFloat)delay maskHeight:(CGFloat)maskHeight {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *shineLayer = [CALayer layer];
    
    CIImage *coreImage = [CIImage imageWithCGImage:viewImage.CGImage];
    CIImage *output = [CIFilter filterWithName:@"CIColorControls"
                                 keysAndValues:kCIInputImageKey, coreImage,
                       @"inputBrightness", @1.0f,
                       nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:output fromRect:output.extent];
    UIImage *shineImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    shineLayer.contents = (id) shineImage.CGImage;
    shineLayer.frame = CGRectMake(0, 0, width, height);
    
    CALayer *mask = [CALayer layer];
    mask.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat maskWidth = floorf(viewImage.size.width);
    
    UIGraphicsBeginImageContext(CGSizeMake(maskWidth, maskHeight));
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    id clearColor = (__bridge id) [UIColor clearColor].CGColor;
    id blackColor = (__bridge id) [UIColor blackColor].CGColor;
    CGFloat locations[] = { 0.0f, 0.5f, 1.0f };
    NSArray *colors = @[ clearColor, blackColor, clearColor ];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef)colors,
                                                        locations);
    CGFloat midX = floorf(maskWidth/2);
    CGPoint startPoint = CGPointMake(midX, 0);
    CGPoint endPoint = CGPointMake(midX, floorf(maskHeight/2));
    
    CGContextDrawLinearGradient(context1, gradient, startPoint, endPoint, 0);
    CFRelease(gradient);
    CFRelease(colorSpace);
    
    UIImage *maskImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mask.contents = (id) maskImage.CGImage;
    mask.contentsGravity = kCAGravityCenter;
    mask.frame = CGRectMake(0, -height, width, height * 1.25);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
    anim.byValue = @(height * 2);
    anim.repeatCount = repeatCount;
    anim.duration = duration;
    anim.beginTime = delay;
    anim.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addSublayer:shineLayer];
    shineLayer.mask = mask;
    
    [mask addAnimation:anim forKey:@"AnimationShine"];
}

-(void)RemoveAnimationShine
{
    [self.layer removeAnimationForKey:@"AnimationShine"];
}

-(void)AnimationShowToRight:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
        [imgView setAlpha:0.0f];
        [imgView setClipsToBounds:YES];
        UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
        [tempView setAutoresizesSubviews:NO];
        [imgView addSubview:tempView];
        [imgView setWidth:0.0f];
        [imgView setImage:Nil];
        
        [UIView animateWithDuration:tempView.width/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [imgView setAlpha:1.0f];
            [imgView setWidth:tempView.width];
        } completion:^(BOOL finished){
            [imgView setImage:tempView.image];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }else if ([self isKindOfClass:[UIButton class]]){
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.frame];
        UIButton *btnView= (UIButton*)self;
        [btnView setAlpha:0.0f];
        [btnView setClipsToBounds:YES];
        UIImageView *tempView = [[UIImageView alloc]initWithImage:[(UIButton*)self imageForState:UIControlStateNormal]];
        [tempView setAutoresizesSubviews:NO];
        tempView.centerY = btnView.height/2;
        [btnView addSubview:tempView];
        [btnView setWidth:0.0f];
        [btnView setImage:Nil forState:UIControlStateNormal];
        
        [UIView animateWithDuration:tempView.width/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [btnView setAlpha:1.0f];
            [btnView setWidth:tempView.width];
        } completion:^(BOOL finished){
            [btnView setImage:tempView.image forState:UIControlStateNormal];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationShowToRightNoAlpha:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
        [imgView setAlpha:1.0f];
        [imgView setClipsToBounds:YES];
        UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
        [tempView setAutoresizesSubviews:NO];
        [imgView addSubview:tempView];
        [imgView setWidth:0.0f];
        [imgView setImage:Nil];
        
        [UIView animateWithDuration:tempView.width/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [imgView setWidth:tempView.width];
        } completion:^(BOOL finished){
            [imgView setImage:tempView.image];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationShowToBottom:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
        [imgView setAlpha:0.0f];
        [imgView setClipsToBounds:YES];
        UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
        [imgView addSubview:tempView];
        [imgView setHeight:0.0f];
        [imgView setImage:Nil];
        
        [UIView animateWithDuration:tempView.height/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [imgView setAlpha:1.0f];
            [imgView setHeight:tempView.height];
        } completion:^(BOOL finished){
            [imgView setImage:tempView.image];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }else{
        CGFloat tempHeight = self.height;
        [UIView animateWithDuration:tempHeight/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [self setAlpha:1.0f];
            [self setHeight:tempHeight];
        } completion:^(BOOL finished){
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationShowToTop:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
        CGFloat tempTop = imgView.top;
        [imgView setAlpha:0.0f];
        [imgView setClipsToBounds:YES];
        [imgView setFrame:CGRectMake(imgView.left, imgView.bottom, imgView.width, 0)];
        imgView.clipsToBounds = YES;
        
        UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
        [tempView setTop:-tempView.height];
        [imgView addSubview:tempView];
        
        [imgView setImage:Nil];
        
        [UIView animateWithDuration:tempView.height/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [imgView setAlpha:1.0f];
            [tempView setTop:0];
            [imgView setFrame:CGRectMake(imgView.left, tempTop, imgView.width, tempView.height)];
        } completion:^(BOOL finished){
            [imgView setImage:tempView.image];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }else if ([self isKindOfClass:[UIButton class]]){
        UIButton *btnView= (UIButton*)self;
        CGFloat tempTop = btnView.top;
        [btnView setAlpha:0.0f];
        [btnView setFrame:CGRectMake(btnView.left, btnView.bottom, btnView.width, 0)];
        [btnView setClipsToBounds:YES];
        
        UIImageView *tempView = [[UIImageView alloc]initWithImage:[(UIButton*)self imageForState:UIControlStateNormal]];
        [tempView setAutoresizesSubviews:NO];
//        tempView.centerX = btnView.width/2;
        [tempView setTop:-tempView.height];
        [btnView addSubview:tempView];
        
        [btnView setImage:Nil forState:UIControlStateNormal];
        
        [UIView animateWithDuration:tempView.height/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [btnView setAlpha:1.0f];
            [tempView setTop:0];
            [btnView setFrame:CGRectMake(btnView.left, tempTop, btnView.width, tempView.height)];
        } completion:^(BOOL finished){
            [btnView setImage:tempView.image forState:UIControlStateNormal];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationShowToLeft:(CGFloat)speed delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
        CGFloat tempLeft = imgView.left;
        [imgView setAlpha:0.0f];
        [imgView setClipsToBounds:YES];
        [imgView setFrame:CGRectMake(imgView.right, imgView.top, 0, imgView.height)];
        imgView.clipsToBounds = YES;
        
        UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
        [tempView setLeft:-tempView.width];
        [imgView addSubview:tempView];
        
        [imgView setImage:Nil];
        
        [UIView animateWithDuration:tempView.width/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [imgView setAlpha:1.0f];
            [tempView setLeft:0];
            [imgView setFrame:CGRectMake(tempLeft, imgView.top, tempView.width, imgView.height)];
        } completion:^(BOOL finished){
            [imgView setImage:tempView.image];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }else if ([self isKindOfClass:[UIButton class]]){
        UIButton *btnView= (UIButton*)self;
        CGFloat tempLeft = btnView.left;
        [btnView setAlpha:0.0f];
        [btnView setFrame:CGRectMake(btnView.right, btnView.top, 0, btnView.height)];
        [btnView setClipsToBounds:YES];
        
        UIImageView *tempView = [[UIImageView alloc]initWithImage:[(UIButton*)self imageForState:UIControlStateNormal]];
        [tempView setAutoresizesSubviews:NO];
        //        tempView.centerX = btnView.width/2;
        [tempView setLeft:-tempView.width];
        [btnView addSubview:tempView];
        
        [btnView setImage:Nil forState:UIControlStateNormal];
        
        [UIView animateWithDuration:tempView.width/(speed*200) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [btnView setAlpha:1.0f];
            [tempView setLeft:0];
            [btnView setFrame:CGRectMake(tempLeft, btnView.top, tempView.width, btnView.height)];
        } completion:^(BOOL finished){
            [btnView setImage:tempView.image forState:UIControlStateNormal];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationShowToRightTop:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
        [imgView setAlpha:0.0f];
        [imgView setClipsToBounds:YES];
        [imgView setFrame:CGRectMake(imgView.left, imgView.bottom, 0, 0)];
        
        UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
//        [tempView setLeft:-imgView.width];
        [tempView setTop:-imgView.height];
        [imgView addSubview:tempView];
        
        [imgView setImage:Nil];
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [imgView setAlpha:1.0f];
            [imgView setFrame:CGRectMake(imgView.left, imgView.top - tempView.height, tempView.width, tempView.height)];
        } completion:^(BOOL finished){
            [imgView setImage:tempView.image];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationShowToLeftTop:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
    [imgView setAlpha:0.0f];
    [imgView setClipsToBounds:YES];
    [imgView setFrame:CGRectMake(imgView.right, imgView.bottom, 0, 0)];
    
    UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
    [tempView setLeft:-imgView.width];
    [tempView setTop:-imgView.height];
    [imgView addSubview:tempView];
    
    [imgView setImage:Nil];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [imgView setAlpha:1.0f];
        [imgView setFrame:CGRectMake(imgView.left - tempView.width, imgView.top - tempView.height, tempView.width, tempView.height)];
    } completion:^(BOOL finished){
        [imgView setImage:tempView.image];
        [tempView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    }
}

-(void)AnimationShowToLeftBottom:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
    [imgView setAlpha:0.0f];
    [imgView setClipsToBounds:YES];
    [imgView setFrame:CGRectMake(imgView.right, imgView.top, 0, 0)];
    
    UIImageView *tempView = [[UIImageView alloc]initWithImage:imgView.image];
    [tempView setLeft:-imgView.width];
    [imgView addSubview:tempView];
    
    [imgView setImage:Nil];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [imgView setAlpha:1.0f];
        [imgView setFrame:CGRectMake(imgView.left - tempView.width, imgView.top, tempView.width, tempView.height)];
    } completion:^(BOOL finished){
        [imgView setImage:tempView.image];
        [tempView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    }
}

-(void)AnimationShowExpand:(CGFloat)duration delay:(CGFloat)delay fromFrame:(CGRect)fromFrame completion:(void (^)(void))completion
{
    [self setClipsToBounds:YES];
    
    CGRect tempFrame = self.frame;
    [self setFrame:fromFrame];
    [self setAlpha:0.0f];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self setAlpha:1.0f];
        self.layer.cornerRadius = tempFrame.size.height/2;
        [self setFrame:tempFrame];
        self.center = CGPointMake(tempFrame.origin.x+tempFrame.size.width/2, tempFrame.origin.y+tempFrame.size.height/2);
    } completion:^(BOOL finished){
        self.layer.cornerRadius = 0;
        if (completion) {
            completion();
        }
    }];
}

-(void)AnimationShowShrink:(CGFloat)duration delay:(CGFloat)delay toFrame:(CGRect)toFrame completion:(void (^)(void))completion
{
    [self setClipsToBounds:YES];
    
    CGRect tempFrame = self.frame;
    [self setAlpha:0.0f];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self setAlpha:1.0f];
        self.layer.cornerRadius = tempFrame.size.height/2;
        [self setFrame:toFrame];
        self.center = CGPointMake(tempFrame.origin.x+tempFrame.size.width/2, tempFrame.origin.y+tempFrame.size.height/2);
    } completion:^(BOOL finished){
        self.layer.cornerRadius = 0;
        [self setFrame:tempFrame];
        if (completion) {
            completion();
        }
    }];
}

-(void)AnimationShowExpandWithImage:(UIImage*)image duration:(CGFloat)duration delay:(CGFloat)delay fromFrame:(CGRect)fromFrame completion:(void (^)(void))completion
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView*)self;
        [imgView setClipsToBounds:YES];
        
        UIImageView *tempView = [[UIImageView alloc]initWithImage:image];
        [tempView setFrame:fromFrame];
        [tempView setAlpha:0.0f];
        tempView.layer.cornerRadius = imgView.height/2;
        [imgView addSubview:tempView];
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            [tempView setAlpha:1.0f];
            tempView.layer.cornerRadius = imgView.height/2;
            [tempView setFrame:imgView.frame];
        } completion:^(BOOL finished){
            [imgView setImage:tempView.image];
            [tempView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationFade:(CGFloat)duration delay:(CGFloat)delay FadeIn:(BOOL)FadeIn completion:(void (^)(void))completion
{
    if (FadeIn) {
        [self setAlpha:0.0f];
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^(void){
            [self setAlpha:1.0f];
        }completion:^(BOOL finished){
            if (completion) {
                completion();
            }
        }];
    }else{
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^(void){
            [self setAlpha:0.0f];
        }completion:^(BOOL finished){
            if (completion) {
                completion();
            }
        }];
    }
}

-(void)AnimationRipple:(UIView*)newView duration:(CGFloat)duration
{
    [self removeAllSubviews];
    [self addSubview:newView];
    CATransition *animationMainView = [CATransition animation];
    animationMainView.delegate = self;
    animationMainView.duration = duration;
    animationMainView.timingFunction = UIViewAnimationCurveEaseInOut;
    animationMainView.fillMode = kCAFillModeForwards;
    animationMainView.type = @"rippleEffect";
    self.opaque = NO;
    [self.layer addAnimation:animationMainView forKey:@"rippleAnimation"];
}

-(void)AnimationFlipFromLeft:(CGFloat)duration
{
    CATransition *t = [CATransition animation];
    t.type = @"flip";
    t.subtype = @"fromRight";
    t.duration = duration;
    t.delegate = self;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:t forKey:@"Transition"];
}

-(void)AnimationFlipFromRight:(CGFloat)duration
{
    CATransition *t = [CATransition animation];
    t.type = @"flip";
    t.subtype = @"fromLeft";
    t.duration = duration;
    t.delegate = self;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:t forKey:@"Transition"];
}

-(void)AnimationFlip:(CGFloat)duration delay:(CGFloat)delay zFromValue:(CGFloat)fromValue zToValue:(CGFloat)toValue
{
    CGPoint anchorPoint = CGPointZero;
    CGPoint superviewCenter = self.superview.center;
    //   superviewCenter是view的superview 的 center 在view.superview.superview中的坐标。
    CGPoint viewPoint = [self convertPoint:superviewCenter fromView:self.superview.superview];
    //   转换坐标，得到superviewCenter 在 view中的坐标
    anchorPoint.x = (viewPoint.x) / self.bounds.size.width;
    anchorPoint.y = (viewPoint.y) / self.bounds.size.height;
    
    [self setAnchorPoint:anchorPoint forView:self];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)AnimationLeftAndRight:(CGFloat)interval delay:(float)delay completion:(void (^)(void))completion
{
    [self setAlpha:1.0f];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x-10, self.center.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x+10, self.center.y)];
    animation.autoreverses = YES;
    animation.beginTime = delay;
    animation.duration = interval;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    
    animation.delegate = self;
    
    [self setBlock:completion forKey:&kAnimationDidStopBlockKey];
    
    [self.layer addAnimation:animation forKey:@"UpAndDownAnimation"];
}

-(void)AnimationAutoRotation:(CGFloat)repeatCount duration:(CGFloat)duration delay:(float)delay directionType:(DirectionType)directionType completion:(void (^)(void))completion
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (directionType==DirectionTypeLeft) {
        rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 0.0 ];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    }else if (directionType==DirectionTypeRight){
        rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.0 ];
    }
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = NO;
    rotationAnimation.beginTime = delay;
    rotationAnimation.repeatCount = repeatCount;
    
    [self setBlock:completion forKey:&kAnimationDidStopBlockKey];
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)RemoveAnimationAutoRotation
{
    [self.layer removeAnimationForKey:@"rotationAnimation"];
}

/**
 *  正方体旋转
 *
 *  @param duration 时间间隔
 *  @param subtype  kCATransitionFromRight,kCATransitionFromLeft,kCATransitionFromTop,kCATransitionFromBottom
 *  @param delay    延迟时间
 */
-(void)AnimationCube:(CFTimeInterval)duration subtype:(NSString*)subtype delay:(CFTimeInterval)delay
{
    __block UIView* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        bself.alpha = 1.0f;
        CATransition *animation = [CATransition animation];
        animation.duration = duration;
        animation.type = @"cube";
        animation.subtype = subtype;
        [bself.layer addAnimation:animation forKey:@"animation"];
    });
    
    
}

@end
