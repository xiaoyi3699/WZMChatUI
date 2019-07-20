//
//  NSMutableAttributedString+AddPart.h
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define COLOR_NAME(_color_)   NSForegroundColorAttributeName:_color_
#define FONT_NAME(_font_)     NSFontAttributeName:_font_
#define STYLE_NAME(_style_)   NSParagraphStyleAttributeName:_style_

@interface NSAttributedString (WZMChat)

@end


@interface NSMutableAttributedString (WZMChat)

/**
 给富文本添加图片
 */
- (void)ll_setImage:(UIImage *)image rect:(CGRect)rect range:(NSRange)range;

/**
 给富文本添加图片
 */
- (void)ll_insertImage:(UIImage *)image rect:(CGRect)rect index:(NSInteger)index;

/**
 给富文本添加段落样式
 */
- (void)ll_addParagraphStyle:(NSParagraphStyle *)style;

/**
 给富文本添加链接
 */
- (void)ll_addLink:(NSString *)link range:(NSRange)range;

/**
 给富文本添加文字颜色
 */
- (void)ll_addForegroundColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加字体
 */
- (void)ll_addFont:(UIFont *)font range:(NSRange)range;

/**
 给富文本添加删除线
 */
- (void)ll_addSingleDeletelineColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加单下划线
 */
- (void)ll_addSingleUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加双下划线
 */
- (void)ll_addDoubleUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加空心字
 */
- (void)ll_addStrokeWidth:(CGFloat)width range:(NSRange)range;

/**
 凸版印刷效果
 */
- (void)ll_addTextEffectWithRange:(NSRange)range;

@end
