//
//  UIView+WZMChat.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WZMChat)

/**
 获取view所在的ViewController
 */
- (UIViewController *)chat_viewController;

//设置位置(宽和高保持不变)
- (CGFloat)chat_minX;
- (void)setChat_minX:(CGFloat)chat_minX;

- (CGFloat)chat_maxX;
- (void)setChat_maxX:(CGFloat)chat_maxX;

- (CGFloat)chat_minY;
- (void)setChat_minY:(CGFloat)chat_minY;

- (CGFloat)chat_maxY;
- (void)setChat_maxY:(CGFloat)chat_maxY;

- (CGFloat)chat_centerX;
- (void)setChat_centerX:(CGFloat)chat_centerX;

- (CGFloat)chat_centerY;
- (void)setChat_centerY:(CGFloat)chat_centerY;

- (CGPoint)chat_postion;
- (void)setChat_postion:(CGPoint)chat_postion;

//设置宽和高(顶点位置不变)
- (CGFloat)chat_width;
- (void)setChat_width:(CGFloat)chat_width;

- (CGFloat)chat_height;
- (void)setChat_height:(CGFloat)chat_height;

- (CGSize)chat_size;
- (void)setChat_size:(CGSize)chat_size;

//设置宽和高(中心点不变)
- (CGFloat)chat_center_width;
- (void)setChat_center_width:(CGFloat)chat_center_width;

- (CGFloat)chat_center_height;
- (void)setChat_center_height:(CGFloat)chat_center_height;

- (CGSize)chat_center_size;
- (void)setChat_center_size:(CGSize)chat_center_size;

//设置圆角
- (CGFloat)chat_cornerRadius;
- (void)setChat_cornerRadius:(CGFloat)chat_cornerRadius;

- (CGFloat)chat_borderWidth;
- (void)setChat_borderWidth:(CGFloat)chat_borderWidth;

- (UIColor *)chat_borderColor;
- (void)setChat_borderColor:(UIColor *)chat_borderColor;


@end
