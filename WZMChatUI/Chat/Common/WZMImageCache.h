//
//  WZMImageCache.h
//  LLFoundation
//
//  Created by zhaomengWang on 17/3/14.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMImageCache : NSObject

+ (instancetype)imageCache;

///加载网络图片(同步)
- (UIImage *)getImageWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch;
///加载网络图片(异步)
- (void)getImageWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch placeholder:(UIImage *)pla completion:(void(^)(UIImage *image))completion;
///存图片
- (NSString *)storeImage:(UIImage *)image forKey:(NSString *)key;
///取图片
- (UIImage *)imageForKey:(NSString *)key;

///加载网络数据(同步)
- (NSData *)getDataWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch;
///加载网络数据(异步)
- (void)getDataWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch completion:(void(^)(NSData *data))completion;
///存数据
- (NSString *)storeData:(NSData *)data forKey:(NSString *)key;
///取数据
- (NSData *)dataForKey:(NSString *)key;

///文件路径
- (NSString *)filePathForKey:(NSString *)key;
///清理内存
- (void)clearMemory;
///清理所有数据
- (void)clearImageCacheCompletion:(void(^)(void))completion;

@end
