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

- (void)chat_setImage:(UIImage *)image rect:(CGRect)rect range:(NSRange)range{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = rect;
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [self replaceCharactersInRange:range withAttributedString:attStr];
}

@end
