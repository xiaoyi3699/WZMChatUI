//
//  UIView+WZMChat.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UIView+WZMChat.h"

@implementation UIView (WZMChat)

- (UIViewController *)viewController{
    UIResponder *next = [self nextResponder];
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next);
    return nil;
}

- (BOOL)ll_isDescendantOfView:(UIView *)otherView {
    return [self isDescendantOfView:otherView];
}

#pragma - mark 自定义适配
//设置位置(宽和高保持不变)
- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}

- (void)setMinX:(CGFloat)minX{
    CGRect rect = self.frame;
    rect.origin.x = minX;
    self.frame = rect;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxX:(CGFloat)maxX{
    CGRect rect = self.frame;
    rect.origin.x = maxX-CGRectGetWidth(rect);
    self.frame = rect;
}

- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}

- (void)setMinY:(CGFloat)minY{
    CGRect rect = self.frame;
    rect.origin.y = minY;
    self.frame = rect;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    CGRect rect = self.frame;
    rect.origin.y = maxY-CGRectGetHeight(rect);
    self.frame = rect;
}

- (CGFloat)LLCenterX{
    return CGRectGetMidX(self.frame);
}

- (void)setLLCenterX:(CGFloat)LLCenterX{
    self.center = CGPointMake(LLCenterX, CGRectGetMidY(self.frame));
}

- (CGFloat)LLCenterY{
    return CGRectGetMidY(self.frame);
}

- (void)setLLCenterY:(CGFloat)LLCenterY{
    self.center = CGPointMake(CGRectGetMidX(self.frame), LLCenterY);
}

- (CGPoint)LLPostion{
    return CGPointMake(self.minX, self.minY);
}

- (void)setLLPostion:(CGPoint)LLPostion{
    CGRect rect = self.frame;
    rect.origin.x = LLPostion.x;
    rect.origin.y = LLPostion.y;
    self.frame = rect;
}

//设置位置(其他顶点保持不变)
- (CGFloat)mutableMinX{
    return self.minX;
}

- (void)setMutableMinX:(CGFloat)mutableMinX{
    CGRect rect = self.frame;
    rect.origin.x = mutableMinX;
    rect.size.width = self.maxX-mutableMinX;
    self.frame = rect;
}

- (CGFloat)mutableMaxX{
    return self.maxX;
}

- (void)setMutableMaxX:(CGFloat)mutableMaxX{
    CGRect rect = self.frame;
    rect.size.width = mutableMaxX-self.minX;
    self.frame = rect;
}

- (CGFloat)mutableMinY{
    return self.minY;
}

- (void)setMutableMinY:(CGFloat)mutableMinY{
    CGRect rect = self.frame;
    rect.origin.y = mutableMinY;
    rect.size.height = self.maxY-mutableMinY;
    self.frame = rect;
}

- (CGFloat)mutableMaxY{
    return self.maxY;
}

- (void)setMutableMaxY:(CGFloat)mutableMaxY{
    CGRect rect = self.frame;
    rect.size.height = mutableMaxY-self.minY;
    self.frame = rect;
}

//设置宽和高(位置不变)
- (CGFloat)LLWidth{
    return CGRectGetWidth(self.frame);
}

- (void)setLLWidth:(CGFloat)LLWidth{
    CGRect rect = self.frame;
    rect.size.width = LLWidth;
    self.frame = rect;
}

- (CGFloat)LLHeight{
    return CGRectGetHeight(self.frame);
}

- (void)setLLHeight:(CGFloat)LLHeight{
    CGRect rect = self.frame;
    rect.size.height = LLHeight;
    self.frame = rect;
}

- (CGSize)LLSize{
    return CGSizeMake(self.LLWidth, self.LLHeight);
}

- (void)setLLSize:(CGSize)LLSize{
    CGRect rect = self.frame;
    rect.size.width = LLSize.width;
    rect.size.height = LLSize.height;
    self.frame = rect;
}

//设置宽和高(中心点不变)
- (CGFloat)center_width{
    return CGRectGetWidth(self.frame);
}

- (void)setCenter_width:(CGFloat)center_width{
    CGRect rect = self.frame;
    CGFloat dx = (center_width-CGRectGetWidth(rect))/2.0;
    rect.origin.x -= dx;
    rect.size.width = center_width;
    self.frame = rect;
}

- (CGFloat)center_height{
    return CGRectGetHeight(self.frame);
}

- (void)setCenter_height:(CGFloat)center_height{
    CGRect rect = self.frame;
    CGFloat dy = (center_height-CGRectGetHeight(rect))/2.0;
    rect.origin.y -= dy;
    rect.size.height = center_height;
    self.frame = rect;
}

- (CGSize)center_size{
    return CGSizeMake(self.LLWidth, self.LLHeight);
}

- (void)setCenter_size:(CGSize)center_size{
    CGRect rect = self.frame;
    CGFloat dx = (center_size.width-CGRectGetWidth(rect))/2.0;
    CGFloat dy = (center_size.height-CGRectGetHeight(rect))/2.0;
    rect.origin.x -= dx;
    rect.origin.y -= dy;
    rect.size.width = center_size.width;
    rect.size.height = center_size.height;
    self.frame = rect;
}

//设置宽高比例
- (CGFloat)LLScale{
    if (self.LLHeight != 0) {
        return self.LLWidth/self.LLHeight;
    }
    return -404;
}

- (void)setScale:(CGFloat)scale x:(CGFloat)x y:(CGFloat)y maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight{
    CGFloat width = maxWidth;
    CGFloat height = width/scale;
    if (height > maxHeight) {
        height = maxHeight;
        width = height*scale;
    }
    self.frame = CGRectMake(x, y, width, height);
}

- (void)setLLCornerRadius:(CGFloat)LLCornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = LLCornerRadius;
}

- (CGFloat)LLCornerRadius{
    return self.layer.cornerRadius;
}

@end
