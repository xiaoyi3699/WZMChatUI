//
//  WZMChatHelper.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMChatHelper.h"
#import "WZMInputBase64.h"
#import "WZMInputHelper.h"
#import "NSDateFormatter+WZMChat.h"

@interface WZMChatHelper ()
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) UIImage *senderBubbleImage;
@property (nonatomic, strong) UIImage *receiverBubbleImage;
@property (nonatomic, strong) NSMutableDictionary *memoryCache;
@end

@implementation WZMChatHelper

+ (instancetype)helper {
    static WZMChatHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WZMChatHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDirectoryAtPath:self.cachePath];
    }
    return self;
}

+ (UIImage *)senderBubble {
    return [WZMChatHelper helper].senderBubbleImage;
}

+ (UIImage *)receiverBubble {
    return [WZMChatHelper helper].receiverBubbleImage;
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

#pragma mark - 图片缓存处理
/**
 获取网络图片(同步)
 */
+ (UIImage *)getImageWithUrl:(NSString *)url {
    UIImage *image = [self getImageFromCacheWithUrl:url];
    if (image == nil) {
        image = [self getImageFromNetworkWithUrl:url];
    }
    return image;
}

+ (UIImage *)getImageFromCacheWithUrl:(NSString *)url {
    //1、从内存存获取
    WZMChatHelper *helper = [WZMChatHelper helper];
    NSString *urlKey = [url input_base64EncodedString];
    UIImage *image = [helper.memoryCache objectForKey:urlKey];
    if (image) {
        return image;
    }
    //2、从本地获取
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
    if ([helper fileExistsAtPath:cachePath]) {
        image = [UIImage imageWithContentsOfFile:cachePath];
        if (image) {
            //存到内存
            [helper.memoryCache setValue:image forKey:urlKey];
            return image;
        }
    }
    return nil;
}

+ (UIImage *)getImageFromNetworkWithUrl:(NSString *)url {
    //3、从网络获取
    WZMChatHelper *helper = [WZMChatHelper helper];
    NSString *urlKey = [url input_base64EncodedString];
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (imageData) {
        UIImage *urlImage = [UIImage imageWithData:imageData];
        if (urlImage) {
            //存到内存
            [helper.memoryCache setValue:urlImage forKey:urlKey];
            //存到本地
            [helper writeFile:imageData toPath:cachePath];
            return urlImage;
        }
    }
    return nil;
}

/**
 获取网络图片(异步)
 */
+ (void)getImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion {
    if (!completion) return;
    [self getImageFromCacheWithUrl:url placeholder:placeholder completion:^(UIImage *image) {
        if (image) {
            completion(image);
        }
        else {
            [self getImageFromNetworkWithUrl:url placeholder:placeholder completion:completion];
        }
    }];
}

+ (void)getImageFromCacheWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion {
    //1、从内存获取
    WZMChatHelper *helper = [WZMChatHelper helper];
    NSString *urlKey = [url input_base64EncodedString];
    UIImage *image = [helper.memoryCache objectForKey:urlKey];
    if (image) {
        completion(image);
        return;
    }
    //2、从本地获取
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
    if ([helper fileExistsAtPath:cachePath]) {
        image = [UIImage imageWithContentsOfFile:cachePath];
        if (image) {
            //存到内存
            [helper.memoryCache setValue:image forKey:urlKey];
            completion(image);
            return;
        }
    }
    completion(nil);
}

+ (void)getImageFromNetworkWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(placeholder);
        //3、从网络获取
        WZMChatHelper *helper = [WZMChatHelper helper];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *urlKey = [url input_base64EncodedString];
            NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (imageData) {
                UIImage *urlImage = [UIImage imageWithData:imageData];
                if (urlImage) {
                    //存到内存
                    [helper.memoryCache setValue:urlImage forKey:urlKey];
                    //存到本地
                    [helper writeFile:imageData toPath:cachePath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(urlImage);
                    });
                }
            }
        });
    });
}

+ (NSString *)storeImage:(UIImage *)image forKey:(NSString *)key {
    if (image == nil || key.length == 0) {
        NSLog(@"键值不能为空");
        return @"";
    }
    WZMChatHelper *helper = [WZMChatHelper helper];
    NSString *tureKey = [key input_base64EncodedString];
    //存到内存
    [helper.memoryCache setValue:image forKey:tureKey];
    //存到本地
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:tureKey];
    if ([helper writeFile:UIImagePNGRepresentation(image) toPath:cachePath]) {
        return cachePath;
    }
    return @"";
}

+ (UIImage *)imageForKey:(NSString *)key {
    WZMChatHelper *helper = [WZMChatHelper helper];
    NSString *tureKey = [key input_base64EncodedString];
    UIImage *image = [helper.memoryCache objectForKey:tureKey];
    if (image == nil) {
        NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:tureKey];
        if ([helper fileExistsAtPath:cachePath]) {
            image = [UIImage imageWithContentsOfFile:cachePath];
            //存到内存
            [helper.memoryCache setValue:image forKey:key];
        }
    }
    return image;
}

+ (void)clearMemory {
    WZMChatHelper *helper = [WZMChatHelper helper];
    [helper.memoryCache removeAllObjects];
}

+ (void)clearImageCacheCompletion:(void(^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        WZMChatHelper *helper = [WZMChatHelper helper];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self clearMemory];
            if ([helper deleteFileAtPath:helper.cachePath error:nil]) {
                [helper createDirectoryAtPath:helper.cachePath];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        });
    });
}

#pragma mark - 文件管理
- (BOOL)fileExistsAtPath:(NSString *)filePath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    NSLog(@"fileExistsAtPath:文件未找到");
    return NO;
}

- (BOOL)createDirectoryAtPath:(NSString *)path{
    BOOL isDirectory;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExists && isDirectory) {
        return YES;
    }
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    if (error) {
        NSLog(@"创建文件夹失败:%@",error);
    }
    return result;
}

- (BOOL)writeFile:(id)file toPath:(NSString *)path{
    BOOL isOK = [file writeToFile:path atomically:YES];
    NSLog(@"文件存储路径为:%@",path);
    return isOK;
}

- (BOOL)deleteFileAtPath:(NSString *)filePath error:(NSError **)error{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
    }
    NSLog(@"deleteFileAtPath:error:路径未找到");
    return YES;
}

#pragma mark - getter
- (NSString *)cachePath {
    if (_cachePath == nil) {
        _cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatCache"];
    }
    return _cachePath;
}

- (NSMutableDictionary *)memoryCache {
    if (_memoryCache == nil) {
        _memoryCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _memoryCache;
}

//聊天气泡
- (UIImage *)senderBubbleImage {
    if (_senderBubbleImage == nil) {
        UIImage *image = [WZMInputHelper otherImageNamed:@"wzm_chat_bj2"];
        CGSize size = image.size;
        _senderBubbleImage = [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height*0.8];
    }
    return _senderBubbleImage;
}

- (UIImage *)receiverBubbleImage {
    if (_receiverBubbleImage == nil) {
        UIImage *image = [WZMInputHelper otherImageNamed:@"wzm_chat_bj1"];
        CGSize size = image.size;
        _receiverBubbleImage = [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height*0.8];
    }
    return _receiverBubbleImage;
}

@end
