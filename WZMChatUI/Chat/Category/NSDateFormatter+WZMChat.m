//
//  NSDateFormatter+WZMChat.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "NSDateFormatter+WZMChat.h"

@implementation NSDateFormatter (WZMChat)

+ (NSMutableDictionary *)formatterCache {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *cache;
    dispatch_once(&onceToken, ^{
        cache = [NSMutableDictionary dictionaryWithCapacity:0];
    });
    return cache;
}

+ (NSDateFormatter *)wzm_defaultDateFormatter {
    NSString *f = @"yyyy-MM-dd HH:mm:ss";
    return [self wzm_dateFormatter:f];
}

+ (NSDateFormatter *)wzm_detailDateFormatter{
    NSString *f = @"yyyy-MM-dd HH:mm:ss.SSS EEEE";
    return [self wzm_dateFormatter:f];
}

+ (NSDateFormatter *)wzm_dateFormatter:(NSString *)f {
    NSDateFormatter *formatter = [[self formatterCache] objectForKey:f];
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:f];
        [[self formatterCache] setObject:formatter forKey:f];
    }
    return formatter;
}

@end
