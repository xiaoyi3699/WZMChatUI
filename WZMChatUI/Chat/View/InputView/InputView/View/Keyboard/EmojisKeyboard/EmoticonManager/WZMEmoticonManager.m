//
//  WZMEmoticonManager.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/5/17.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMEmoticonManager.h"
#import "WZMInputHelper.h"
#import "WZMInputBase64.h"

@interface WZMEmoticonManager ()

///所有简体表情, 如: [爱你]
@property (nonatomic, strong) NSArray *chs;
@property (nonatomic, strong) NSDictionary *chsDic;
///所有繁体表情, 如: [愛你]
@property (nonatomic, strong) NSArray *cht;
@property (nonatomic, strong) NSDictionary *chtDic;
///所有表情 <默认, 浪小花, emoji>
@property (nonatomic, strong) NSArray *emoticons;

@end

@implementation WZMEmoticonManager

+ (instancetype)manager {
    static WZMEmoticonManager *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[WZMEmoticonManager alloc] init];
    });
    return m;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadEmoticons];
    }
    return self;
}

- (void)loadEmoticons {
    NSMutableArray *emoticons = [[NSMutableArray alloc] initWithCapacity:0];
    //默认表情
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"WZMEmoticon1" ofType:@"plist"];
    NSArray *array1 = [[NSArray alloc] initWithContentsOfFile:path1];
    [emoticons addObject:array1];
    
    //浪小花
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"WZMEmoticon2" ofType:@"plist"];
    NSArray *array2 = [[NSArray alloc] initWithContentsOfFile:path2];
    [emoticons addObject:array2];
    //emojis
    NSString *emojisPath = [[NSBundle mainBundle] pathForResource:@"WZMEmojis" ofType:@"plist"];
    NSDictionary *emojisDic = [NSDictionary dictionaryWithContentsOfFile:emojisPath];
    NSArray *emojis = [emojisDic objectForKey:@"Default"];
    [emoticons addObject:emojis];
    self.emoticons = [emoticons copy];
    
    NSMutableArray *chs = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *cht = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *chsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *chtDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSDictionary *dic in array1) {
        NSString *ch1 = [dic objectForKey:@"chs"];
        NSString *ch2 = [dic objectForKey:@"cht"];
        NSString *png = [dic objectForKey:@"png"];
        
        [chs addObject:ch1];
        [cht addObject:ch2];
        
        NSString *key1 = [ch1 input_base64EncodedString];
        NSString *key2 = [ch2 input_base64EncodedString];
        [chsDic setObject:png forKey:key1];
        [chtDic setObject:png forKey:key2];
    }
    for (NSDictionary *dic in array2) {
        NSString *ch1 = [dic objectForKey:@"chs"];
        NSString *ch2 = [dic objectForKey:@"cht"];
        NSString *png = [dic objectForKey:@"png"];
        
        [chs addObject:ch1];
        [cht addObject:ch2];
        
        NSString *key1 = [ch1 input_base64EncodedString];
        NSString *key2 = [ch2 input_base64EncodedString];
        [chsDic setObject:png forKey:key1];
        [chtDic setObject:png forKey:key2];
    }
    self.chs = [chs copy]; self.chsDic = [chsDic copy];
    self.cht = [cht copy]; self.chtDic = [chtDic copy];
}

///匹配文本中的所有表情
- (NSArray *)matchEmoticons:(NSString *)aString {
    NSMutableArray *emoticons = [[NSMutableArray alloc] initWithCapacity:0];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]"
                                  options:0
                                  error:&error];
    if (!error) {
        NSArray *matchs = [regex matchesInString:aString
                                         options:0
                                           range:NSMakeRange(0, [aString length])];
        for (NSTextCheckingResult *match in matchs) {
            NSString *result = [aString substringWithRange:match.range];
            NSDictionary *dic = @{@"emoticon":result, @"range":NSStringFromRange(match.range)};
            [emoticons addObject:dic];
        }
    }
    return [emoticons copy];
}

///匹配输入框将要删除的表情
- (NSString *)willDeleteEmoticon:(NSString *)aString {
    if ([aString hasSuffix:@"]"]) {
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]"
                                      options:0
                                      error:&error];
        if (!error) {
            NSArray *matchs = [regex matchesInString:aString
                                             options:0
                                               range:NSMakeRange(0, [aString length])];
            NSTextCheckingResult *match = matchs.lastObject;
            if (match) {
                if (match.range.location+match.range.length == aString.length) {
                    NSString *result = [aString substringWithRange:match.range];
                    return result;
                }
            }
        }
    }
    return nil;
}

///富文本
- (NSMutableAttributedString *)attributedString:(NSString *)aString {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:aString];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]"
                                  options:0
                                  error:&error];
    if (!error) {
        NSArray *matchs = [regex matchesInString:aString
                                         options:0
                                           range:NSMakeRange(0, [aString length])];
        NSUInteger offset = 0;
        for (NSTextCheckingResult *match in matchs) {
            NSUInteger newLocation = match.range.location+offset;
            NSString *result = [aString substringWithRange:match.range];
            NSString *imageName = [self.chsDic objectForKey:[result input_base64EncodedString]];
            UIImage *image = [WZMInputHelper emoticonImageNamed:imageName];
            if (image) {
                [self setAttributedString:attStr image:image rect:CGRectMake(0, -4, 20, 20) range:NSMakeRange(newLocation, match.range.length)];
                offset += (1-match.range.length);
            }
        }
    }
    return attStr;
}

//private
- (void)setAttributedString:(NSMutableAttributedString *)attributedString image:(UIImage *)image rect:(CGRect)rect range:(NSRange)range{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = rect;
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [attributedString replaceCharactersInRange:range withAttributedString:attStr];
}

@end
