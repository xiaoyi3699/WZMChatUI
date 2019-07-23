//
//  WZMChatMessageModel.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/3.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMChatMessageModel.h"
#import "WZMChatHelper.h"
#import "WZChatMacro.h"
#import "WZMEmoticonManager.h"

@implementation WZMChatMessageModel {
    NSAttributedString *_attStr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modelH = -1;
        self.modelW = -1;
        self.mid = [NSString stringWithFormat:@"%@",@([WZMChatHelper nowTimestamp])];
    }
    return self;
}

#pragma mark - 消息的自定义处理
///缓存model尺寸
- (void)cacheModelSize {
    if (self.modelH == -1 || self.modelW == -1) {
        if (self.msgType == WZMMessageTypeSystem) {
            self.modelH = 20;
            self.modelW = CHAT_SCREEN_WIDTH;
        }
        else if (self.msgType == WZMMessageTypeText) {
            CGSize size = [[self attributedString] boundingRectWithSize:CGSizeMake((CHAT_SCREEN_WIDTH-127), CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                context:nil].size;
            self.modelH = MAX(ceil(size.height), 30);
            self.modelW = MAX(ceil(size.width), 30);
        }
        else if (self.msgType == WZMMessageTypeImage) {
            [self handleImageSize];
            self.modelH = self.imgH;
            self.modelW = self.imgW;
        }
        else if (self.msgType == WZMMessageTypeVoice) {
            CGFloat minW = 60;
            CGFloat dw = 5.2;
            if (CHAT_SCREEN_WIDTH > 375) {
                minW = 70;
                dw = 5.6;
            }
            if (self.duration < 6) {
                self.modelW = minW+self.duration*dw;
            }
            else if (self.duration < 11) {
                self.modelW = minW+dw*5+(self.duration-5)*(dw-2);
            }
            else if (self.duration < 21) {
                self.modelW = minW+dw*5+(dw-2)*5+(self.duration-10)*(dw-3);
            }
            else  if (self.duration < 61) {
                self.modelW = minW+dw*5+(dw-2)*5+(dw-3)*10+(self.duration-20)*(dw-4);
            }
            else {
                self.modelW = minW+dw*5+(dw-2)*5+(dw-3)*10+40*(dw-4);
            }
            self.modelH = 30;
        }
        else if (self.msgType == WZMMessageTypeVideo) {
            [self handleImageSize];
            self.modelH = self.imgH;
            self.modelW = self.imgW;
        }
    }
}

//富文本
- (NSAttributedString *)attributedString {
    if (_attStr == nil) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 2;
        NSDictionary *a = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:[style copy]};
        NSMutableAttributedString *att = [[WZMEmoticonManager manager] attributedString:self.message];
        [att addAttributes:a range:NSMakeRange(0, att.length)];
        _attStr = [att copy];
    }
    return _attStr;
}

//缓存图片尺寸
- (void)handleImageSize {
    CGFloat maxW = ceil(CHAT_SCREEN_WIDTH*0.32)*1.0;
    CGFloat maxH = ceil(CHAT_SCREEN_WIDTH*0.32)*1.0;
    CGFloat imgScale = self.imgW*1.0/self.imgH;
    CGFloat viewScale = maxW*1.0/maxH;
    
    CGFloat w, h;
    if (imgScale > viewScale) {
        w = maxW;
        h = self.imgH*maxW*1.0/self.imgW;
    }
    else if (imgScale < viewScale) {
        h = maxH;
        w = self.imgW*maxH*1.0/self.imgH;
    }
    else {
        w = maxW;
        h = maxH;
    }
    self.imgW = ceil(w);
    self.imgH = ceil(h)+ceil(17.0/self.imgW*h-10);
    
    if (imgScale != viewScale) {
        if (self.imgW > maxW) {
            h = self.imgH*maxW*1.0/self.imgW;
            self.imgW = maxW;
        }
        if (self.imgH > maxH) {
            w = self.imgW*maxH*1.0/self.imgH;
            h = maxH;
        }
        self.imgW = ceil(w);
        self.imgH = ceil(h);
    }
}

@end
