//
//  UIView+WZMChat.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UIView+WZMChat.h"

@implementation UIView (WZMChat)

- (UIViewController *)chat_viewController{
    UIResponder *next = [self nextResponder];
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next);
    return nil;
}

//设置位置(宽和高保持不变)
- (CGFloat)chat_minX {
    return CGRectGetMinX(self.frame);
}

- (void)setChat_minX:(CGFloat)chat_minX {
    CGRect rect = self.frame;
    rect.origin.x = chat_minX;
    self.frame = rect;
}

- (CGFloat)chat_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setChat_maxX:(CGFloat)chat_maxX {
    CGRect rect = self.frame;
    rect.origin.x = chat_maxX-CGRectGetWidth(rect);
    self.frame = rect;
}

- (CGFloat)chat_minY {
    return CGRectGetMinY(self.frame);
}

- (void)setChat_minY:(CGFloat)chat_minY {
    CGRect rect = self.frame;
    rect.origin.y = chat_minY;
    self.frame = rect;
}

- (CGFloat)chat_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setChat_maxY:(CGFloat)chat_maxY {
    CGRect rect = self.frame;
    rect.origin.y = chat_maxY-CGRectGetHeight(rect);
    self.frame = rect;
}

- (CGFloat)chat_centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setChat_centerX:(CGFloat)chat_centerX {
    self.center = CGPointMake(chat_centerX, CGRectGetMidY(self.frame));
}

- (CGFloat)chat_centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setChat_centerY:(CGFloat)chat_centerY {
    self.center = CGPointMake(CGRectGetMidX(self.frame), chat_centerY);
}

- (CGPoint)chat_postion {
    return CGPointMake(self.chat_minX, self.chat_minY);
}

- (void)setChat_postion:(CGPoint)chat_postion {
    CGRect rect = self.frame;
    rect.origin.x = chat_postion.x;
    rect.origin.y = chat_postion.y;
    self.frame = rect;
}

//设置宽和高(位置不变)
- (CGFloat)chat_width {
    return CGRectGetWidth(self.frame);
}

- (void)setChat_width:(CGFloat)chat_width {
    CGRect rect = self.frame;
    rect.size.width = chat_width;
    self.frame = rect;
}

- (CGFloat)chat_height {
    return CGRectGetHeight(self.frame);
}

- (void)setChat_height:(CGFloat)chat_height {
    CGRect rect = self.frame;
    rect.size.height = chat_height;
    self.frame = rect;
}

- (CGSize)chat_size {
    return CGSizeMake(self.chat_width, self.chat_height);
}

- (void)setChat_size:(CGSize)chat_size {
    CGRect rect = self.frame;
    rect.size.width = chat_size.width;
    rect.size.height = chat_size.height;
    self.frame = rect;
}

//设置宽和高(中心点不变)
- (CGFloat)chat_center_width {
    return CGRectGetWidth(self.frame);
}

- (void)setChat_center_width:(CGFloat)chat_center_width {
    CGRect rect = self.frame;
    CGFloat dx = (chat_center_width-CGRectGetWidth(rect))/2.0;
    rect.origin.x -= dx;
    rect.size.width = chat_center_width;
    self.frame = rect;
}

- (CGFloat)chat_center_height {
    return CGRectGetHeight(self.frame);
}

- (void)setChat_center_height:(CGFloat)chat_center_height {
    CGRect rect = self.frame;
    CGFloat dy = (chat_center_height-CGRectGetHeight(rect))/2.0;
    rect.origin.y -= dy;
    rect.size.height = chat_center_height;
    self.frame = rect;
}

- (CGSize)chat_center_size {
    return CGSizeMake(self.chat_width, self.chat_height);
}

- (void)setChat_center_size:(CGSize)chat_center_size {
    CGRect rect = self.frame;
    CGFloat dx = (chat_center_size.width-CGRectGetWidth(rect))/2.0;
    CGFloat dy = (chat_center_size.height-CGRectGetHeight(rect))/2.0;
    rect.origin.x -= dx;
    rect.origin.y -= dy;
    rect.size.width = chat_center_size.width;
    rect.size.height = chat_center_size.height;
    self.frame = rect;
}

- (CGFloat)chat_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setChat_cornerRadius:(CGFloat)chat_cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = chat_cornerRadius;
}

- (CGFloat)chat_borderWidth {
    return self.layer.borderWidth;
}

- (void)setChat_borderWidth:(CGFloat)chat_borderWidth {
    self.layer.borderWidth = chat_borderWidth;
}

- (UIColor *)chat_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setChat_borderColor:(UIColor *)chat_borderColor {
    self.layer.borderColor = [chat_borderColor CGColor];
}

@end
