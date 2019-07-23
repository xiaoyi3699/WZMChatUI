//
//  WZMEmoticonManager.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/5/17.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMEmoticonManager : NSObject

///所有简体表情, 如: [爱你]
@property (nonatomic, strong, readonly) NSArray *chs;
@property (nonatomic, strong, readonly) NSDictionary *chsDic;
///所有繁体表情, 如: [愛你]
@property (nonatomic, strong, readonly) NSArray *cht;
@property (nonatomic, strong, readonly) NSDictionary *chtDic;
///所有表情 <默认, 浪小花, emoji>
@property (nonatomic, strong, readonly) NSArray *emoticons;

+ (instancetype)manager;

///匹配文本中的所有表情
- (NSArray *)matchEmoticons:(NSString *)aString;
///匹配输入框将要删除的表情
- (NSString *)willDeleteEmoticon:(NSString *)aString;
///文本转富文本
- (NSMutableAttributedString *)attributedString:(NSString *)aString;

@end
