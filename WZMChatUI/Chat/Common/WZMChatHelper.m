//
//  WZMChatHelper.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMChatHelper.h"
#import "NSDateFormatter+WZMChat.h"

@interface WZMChatHelper ()

@property (nonatomic, strong) NSString *lxhPath;
@property (nonatomic, strong) NSString *otherPath;
@property (nonatomic, strong) NSString *defaultPath;
@property (nonatomic, strong) NSMutableDictionary *imageCache;

@end

@implementation WZMChatHelper {
    
    NSInteger _iPhoneX;
    
    CGFloat _navBarH;
    CGFloat _tabBarH;
    
    CGFloat _screenH;
    CGFloat _screenW;
    
    CGFloat _inputH;
    CGFloat _keyboardH;
    CGFloat _inputKeyboardH;
    CGFloat _iPhoneXBottomH;
    
    UIImage *_senderBubbleImage;
    UIImage *_receiverBubbleImage;
}

+ (instancetype)shareInstance {
    static WZMChatHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WZMChatHelper alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _iPhoneX = -1;
        _navBarH = 0;
        _tabBarH = 0;
        _screenW = 0;
        _screenH = 0;
        _inputH = 0;
        _keyboardH = 0;
        _inputKeyboardH = 0;
        _iPhoneXBottomH = 0;
        self.imageCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

///是否是iPhoneX
- (BOOL)iPhoneX {
    if (_iPhoneX == -1) {
        BOOL iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
        _iPhoneX = (iPhone && [UIScreen mainScreen].bounds.size.height>=812);
    }
    return (_iPhoneX == 1);
}

///导航高
- (CGFloat)navBarH {
    if (_navBarH == 0) {
        _navBarH = ([self iPhoneX] ? 88:64);
    }
    return _navBarH;
}

///taBar高
- (CGFloat)tabBarH {
    if (_tabBarH == 0) {
        _tabBarH = ([self iPhoneX] ? 83:49);
    }
    return _tabBarH;
}

///屏幕宽
- (CGFloat)screenW {
    if (_screenW == 0) {
        _screenW = [UIScreen mainScreen].bounds.size.width;
    }
    return _screenW;
}

///屏幕高
- (CGFloat)screenH {
    if (_screenH == 0) {
        _screenH = [UIScreen mainScreen].bounds.size.height;
    }
    return _screenH;
}

///输入框高度
- (CGFloat)inputH {
    if (_inputH == 0) {
        _inputH = 49;
    }
    return _inputH;
}

///键盘高度
- (CGFloat)keyboardH {
    if (_keyboardH == 0) {
        _keyboardH = (200+[self iPhoneXBottomH]);
    }
    return _keyboardH;
}

///输入框和键盘的高度和
- (CGFloat)inputKeyboardH {
    if (_inputKeyboardH == 0) {
        _inputKeyboardH = [self inputH]+[self keyboardH];
    }
    return _inputKeyboardH;
}

///iPhoneX底部高度
- (CGFloat)iPhoneXBottomH {
    if (_iPhoneXBottomH == 0) {
        _iPhoneXBottomH = ([self iPhoneX] ? 34:0);
    }
    return _iPhoneXBottomH;
}

//聊天气泡
- (UIImage *)senderBubbleImage {
    if (_senderBubbleImage == nil) {
        UIImage *image = [WZMChatHelper otherImageNamed:@"wzm_chat_bj2"];
        CGSize size = image.size;
        _senderBubbleImage = [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height*0.8];
    }
    return _senderBubbleImage;
}

- (UIImage *)receiverBubbleImage {
    if (_receiverBubbleImage == nil) {
        UIImage *image = [WZMChatHelper otherImageNamed:@"wzm_chat_bj1"];
        CGSize size = image.size;
        _receiverBubbleImage = [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height*0.8];
    }
    return _receiverBubbleImage;
}

//获取当前时间戳
+ (NSTimeInterval)nowTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    return time;
}

//获取指定时间戳
+ (NSTimeInterval)timestampFromDate:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    return time;
}

//获取指定日期
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp {
    NSInteger scale = 1;
    if (timeStamp.floatValue > 999999999999) {
        scale = 1000;
    }
    NSTimeInterval time = [timeStamp integerValue]/scale;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return date;
}

//时间格式化
+ (NSString *)timeFromTimeStamp:(NSString *)timeStamp {
    NSDate *date = [self dateFromTimeStamp:timeStamp];
    return [self timeFromDate:date];
}

+ (NSString *)timeFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:nowDate];
    // 2.获得指定日期的年月日
    NSDateComponents *sinceCmps = [calendar components:unit fromDate:date];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter chat_dateFormatter:@"HH:mm"];
    NSString *time = [dateFormatter stringFromDate:date];
    if ((sinceCmps.year == nowCmps.year) &&
        (sinceCmps.month == nowCmps.month)) {
        
        if ((sinceCmps.day == nowCmps.day)) {
            //今天
            return [NSString stringWithFormat:@"今天 %@",time];
        }
        if (nowCmps.day - sinceCmps.day == 1) {
            //昨天
            return [NSString stringWithFormat:@"昨天 %@",time];
        }
    }
    return [NSString stringWithFormat:@"%@/%@/%@ %@",@(sinceCmps.year),@(sinceCmps.month),@(sinceCmps.day),time];
}

+ (UIImage *)otherImageNamed:(NSString *)name {
    if (name.length == 0) return nil;
    if (name.pathExtension == nil) {
        name = [name stringByAppendingString:@".png"];
    }
    WZMChatHelper *helper = [WZMChatHelper shareInstance];
    UIImage *image = [helper.imageCache objectForKey:name];
    if (image == nil) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",helper.otherPath,name];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        [helper.imageCache setObject:image forKey:name];
    }
    return image;
}

+ (UIImage *)emoticonImageNamed:(NSString *)name {
    if (name.length == 0) return nil;
    if (name.pathExtension == nil) {
        name = [name stringByAppendingString:@".png"];
    }
    WZMChatHelper *helper = [WZMChatHelper shareInstance];
    NSString *path = [NSString stringWithFormat:@"%@/%@",helper.defaultPath,name];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image == nil) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",helper.lxhPath,name];
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

- (NSString *)lxhPath {
    if (_lxhPath == nil) {
        NSString *emoticon = [[NSBundle mainBundle] pathForResource:@"WZMEmoticon" ofType:@"bundle"];
        _lxhPath = [emoticon stringByAppendingPathComponent:@"emoticon_lxh"];
    }
    return _lxhPath;
}

- (NSString *)otherPath {
    if (_otherPath == nil) {
        NSString *emoticon = [[NSBundle mainBundle] pathForResource:@"WZMEmoticon" ofType:@"bundle"];
        _otherPath = [emoticon stringByAppendingPathComponent:@"emoticon_other"];
    }
    return _otherPath;
}

- (NSString *)defaultPath {
    if (_defaultPath == nil) {
        NSString *emoticon = [[NSBundle mainBundle] pathForResource:@"WZMEmoticon" ofType:@"bundle"];
        _defaultPath = [emoticon stringByAppendingPathComponent:@"emoticon_default"];
    }
    return _defaultPath;
}

@end
