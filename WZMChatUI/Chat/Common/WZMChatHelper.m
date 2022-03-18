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

@implementation WZMChatHelper {
    CGFloat _cacheSize;
}

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
- (UIImage *)getImageWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch {
    NSData *data = [self getDataWithUrl:url isUseCatch:isUseCatch];
    if (data) {
        return [UIImage imageWithData:data];
    }
    return nil;
}

/**
 获取网络图片(异步)
 */
- (UIImage *)getImageWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch completion:(void(^)(UIImage *image))completion {
    NSData *rd = [self getDataWithUrl:url isUseCatch:isUseCatch completion:^(NSData *data) {
        if (data) {
            if (completion) completion([UIImage imageWithData:data]);
        }
        else {
            if (completion) completion(nil);
        }
    }];
    return (rd == nil ? nil : [UIImage imageWithData:rd]);
}

/**
 获取网络数据(同步)
 */
- (NSData *)getDataWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch {
    NSData *data;
    if (isUseCatch) {
        data = [self getDataFromCacheWithUrl:url];
        if (data == nil) {
            data = [self getDataWithUrl:url];
        }
    }
    else {
        data = [self getDataWithUrl:url];
    }
    return data;
}

/**
 获取网络数据(异步)
 */
- (NSData *)getDataWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch completion:(void(^)(NSData *data))completion {
    if (isUseCatch) {
        NSData *cd = [self getDataFromCacheWithUrl:url];
        if (completion) completion(cd);
        if (cd) return cd;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *ud = [self getDataWithUrl:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(ud);
            });
        });
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *ud = [self getDataWithUrl:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(ud);
            });
        });
    }
    return nil;
}

///private method
- (NSData *)getDataFromCacheWithUrl:(NSString *)url {
    //1、从内存获取
    NSString *urlKey = [self wzmEncodeString:url];
    NSData *data = [_memoryCache objectForKey:urlKey];
    if (data) {
        return data;
    }
    //2、从本地获取
    NSString *cachePath = [_cachePath stringByAppendingPathComponent:urlKey];
    if ([self fileExistsAtPath:cachePath]) {
        data = [NSData dataWithContentsOfFile:cachePath];
        if (data) {
            //存到内存
            [self cacheData:data forKey:urlKey];
            return data;
        }
    }
    return nil;
}

- (NSData *)getDataWithUrl:(NSString *)url {
    //3、从网络获取
    NSString *urlKey = [self wzmEncodeString:url];
    NSString *cachePath = [_cachePath stringByAppendingPathComponent:urlKey];
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (urlData) {
        //存到内存
        [self cacheData:urlData forKey:urlKey];
        //存到本地
        [self writeFile:urlData toPath:cachePath];
        return urlData;
    }
    return nil;
}

///other method
- (NSString *)setObj:(id)obj forKey:(NSString *)key {
    if (obj == nil || key == nil) {
        return nil;
    }
    NSData *data;
    if ([obj isKindOfClass:[UIImage class]]) {
        BOOL hasAlpha = [self hasAlphaChannel:(UIImage *)obj];
        if (hasAlpha) {
            data = UIImagePNGRepresentation((UIImage *)obj);
        }
        else {
            data = UIImageJPEGRepresentation((UIImage *)obj, 1.0);
        }
    }
    else if ([obj isKindOfClass:[data class]]) {
        data = (NSData *)obj;
    }
    if (data == nil) return nil;
    NSString *path = [self filePathForKey:key];
    [self deleteFileAtPath:path error:nil];
    if ([data writeToFile:path atomically:YES]) {
        return path;
    }
    return nil;
}

- (NSData *)objForKey:(NSString *)key {
    if (key == nil) return nil;
    NSString *path = [self filePathForKey:key];
    return [NSData dataWithContentsOfFile:path];
}

- (NSString *)filePathForKey:(NSString *)key {
    NSString *tureKey = [self wzmEncodeString:key];
    return [_cachePath stringByAppendingPathComponent:tureKey];
}

- (void)cacheData:(NSData *)data forKey:(NSString *)key {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (data == nil) return;
            if (_cacheSize > self.maxCacheSize*1000*1000) {
                [self clearMemory];
            }
            _cacheSize += data.length;
            [_memoryCache setValue:data forKey:key];
        });
    });
}

- (void)clearMemory {
    _cacheSize = 0.0;
    [_memoryCache removeAllObjects];
}

- (void)clearImageCacheCompletion:(void(^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearMemory];
        if ([self deleteFileAtPath:_cachePath error:nil]) {
            [self createDirectoryAtPath:_cachePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion();
        });
    });
}

- (NSString *)wzmEncodeString:(NSString *)string {
    return [string input_base64EncodedString];
}

- (BOOL)hasAlphaChannel:(UIImage *)image {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
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
