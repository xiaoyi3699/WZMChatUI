//
//  NSMutableAttributedString+AddPart.h
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (WZMChat)

@end

@interface NSMutableAttributedString (WZMChat)

/**
 给富文本添加图片
 */
- (void)wzm_setImage:(UIImage *)image rect:(CGRect)rect range:(NSRange)range;

@end
