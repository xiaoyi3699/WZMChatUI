//
//  NSMutableAttributedString+AddPart.m
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSAttributedString+WZMChat.h"

@implementation NSAttributedString (WZMChat)

@end

@implementation NSMutableAttributedString (WZMChat)

- (void)ll_setImage:(UIImage *)image rect:(CGRect)rect range:(NSRange)range{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = rect;
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [self replaceCharactersInRange:range withAttributedString:attStr];
}

- (void)ll_insertImage:(UIImage *)image rect:(CGRect)rect index:(NSInteger)index{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = rect;
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [self insertAttributedString:attStr atIndex:index];
}

- (void)ll_addParagraphStyle:(NSParagraphStyle *)style{
    [self addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, 0)];
}

- (void)ll_addLink:(NSString *)link range:(NSRange)range{
    NSURL *url = [NSURL URLWithString:link];
    [self addAttributes:@{NSLinkAttributeName:url} range:range];
}

- (void)ll_addForegroundColor:(UIColor *)color range:(NSRange)range{
    [self addAttributes:@{NSForegroundColorAttributeName:color} range:range];
}

- (void)ll_addFont:(UIFont *)font range:(NSRange)range{
    [self addAttributes:@{NSFontAttributeName:font} range:range];
}

- (void)ll_addSingleDeletelineColor:(UIColor *)color range:(NSRange)range{
    [self addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                          NSStrikethroughColorAttributeName:color}
                  range:range];
}

- (void)ll_addSingleUnderlineColor:(UIColor *)color range:(NSRange)range{
    NSUnderlineStyle style = NSUnderlineStyleSingle | NSUnderlinePatternDot;
    [self addAttributes:@{NSUnderlineStyleAttributeName:@(style)} range:range];
    [self addAttributes:@{NSUnderlineColorAttributeName:color} range:range];
}

- (void)ll_addDoubleUnderlineColor:(UIColor *)color range:(NSRange)range{
    NSUnderlineStyle style = NSUnderlineStyleSingle;
    //虚线
    //style = NSUnderlineStyleSingle | NSUnderlinePatternDot;
    [self addAttributes:@{NSUnderlineStyleAttributeName:@(style)} range:range];
    [self addAttributes:@{NSUnderlineColorAttributeName:color} range:range];
}

- (void)ll_addStrokeWidth:(CGFloat)width range:(NSRange)range{
    [self addAttribute:NSStrokeWidthAttributeName value:@(width) range:range];
}

- (void)ll_addTextEffectWithRange:(NSRange)range{
    [self addAttributes:@{NSTextEffectAttributeName: NSTextEffectLetterpressStyle} range:range];
}

@end
