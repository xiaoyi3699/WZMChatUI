//
//  UIView+WZMChat.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WZMChat)

/**
 获取view所在的ViewController
 */
- (UIViewController *)viewController;

/**
 判断view是不是指定视图的子视图
 */
- (BOOL)ll_isDescendantOfView:(UIView *)otherView;

//设置位置(宽和高保持不变)
- (CGFloat)minX;
- (void)setMinX:(CGFloat)minX;

- (CGFloat)maxX;
- (void)setMaxX:(CGFloat)maxX;

- (CGFloat)minY;
- (void)setMinY:(CGFloat)minY;

- (CGFloat)maxY;
- (void)setMaxY:(CGFloat)maxY;

- (CGFloat)LLCenterX;
- (void)setLLCenterX:(CGFloat)LLCenterX;

- (CGFloat)LLCenterY;
- (void)setLLCenterY:(CGFloat)LLCenterY;

- (CGPoint)LLPostion;
- (void)setLLPostion:(CGPoint)LLPostion;

//设置位置(其他顶点保持不变)
- (CGFloat)mutableMinX;
- (void)setMutableMinX:(CGFloat)mutableMinX;

- (CGFloat)mutableMaxX;
- (void)setMutableMaxX:(CGFloat)mutableMaxX;

- (CGFloat)mutableMinY;
- (void)setMutableMinY:(CGFloat)mutableMinY;

- (CGFloat)mutableMaxY;
- (void)setMutableMaxY:(CGFloat)mutableMaxY;

//设置宽和高((位置不变))
- (CGFloat)LLWidth;
- (void)setLLWidth:(CGFloat)LLWidth;

- (CGFloat)LLHeight;
- (void)setLLHeight:(CGFloat)LLHeight;

- (CGSize)LLSize;
- (void)setLLSize:(CGSize)LLSize;

//设置宽和高(中心点不变)
- (CGFloat)center_width;
- (void)setCenter_width:(CGFloat)center_width;

- (CGFloat)center_height;
- (void)setCenter_height:(CGFloat)center_height;

- (CGSize)center_size;
- (void)setCenter_size:(CGSize)center_size;

//设置宽高比例
- (CGFloat)LLScale;
- (void)setScale:(CGFloat)scale x:(CGFloat)x y:(CGFloat)y maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

//设置圆角
- (void)setLLCornerRadius:(CGFloat)LLCornerRadius;
- (CGFloat)LLCornerRadius;

@end

NS_ASSUME_NONNULL_END
