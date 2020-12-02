//
//  WZMInputHelper.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMInputHelper : NSObject

+ (instancetype)helper;

///还原, 如屏幕旋转时
- (void)reset;
///是否是iPad
- (BOOL)iPad;
///是否是iPhone
- (BOOL)iPhone;
///是否是iPhoneX
- (BOOL)iPhoneX;
///导航高
- (CGFloat)navBarH;
///状态栏高
- (CGFloat)statusH;
///taBar高
- (CGFloat)tabBarH;
///屏幕宽
- (CGFloat)screenW;
///屏幕高
- (CGFloat)screenH;
///屏幕scale
- (CGFloat)screenScale;
///屏幕bounds
- (CGRect)screenBounds;
///iPhoneX底部高度
- (CGFloat)iPhoneXBottomH;

///图片
+ (UIImage *)otherImageNamed:(NSString *)name;
+ (UIImage *)emoticonImageNamed:(NSString *)name;

@end
