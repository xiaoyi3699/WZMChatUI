//
//  WZMEmojisKeyboard.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMEmojisKeyboard.h"
#import "WZMBlankCell.h"
#import "WZMEmojisCell.h"
#import "WZMDeleteCell.h"
#import "WZMEmoticonCell.h"
#import "WZMHorizontalLayout.h"
#import "WZMEmoticonManager.h"
#import "WZChatMacro.h"
#import "UIView+WZMChat.h"

#define key_rows  3
#define key_nums  7
@interface WZMEmojisKeyboard ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation WZMEmojisKeyboard {
    NSArray *_btns;
    NSArray *_emoticons;
    UIButton *_selectedBtn;
    NSInteger _emojisSection;
    UICollectionView *_collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //加载表情
        _emoticons = [WZMEmoticonManager manager].emoticons;
        _emojisSection = _emoticons.count-1;
        
        CGFloat key_itemW = 45;
        CGFloat spcing = (320-key_itemW*key_nums)/(key_nums+1);
        WZMHorizontalLayout *horLayout = [[WZMHorizontalLayout alloc] initWithSpacing:spcing rows:key_rows nums:key_nums];
        
        CGRect rect = self.bounds;
        rect.size.height -= (40+WZMChat_BOTTOM_H);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:horLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[WZMBlankCell class] forCellWithReuseIdentifier:@"blank"];
        [_collectionView registerClass:[WZMEmojisCell class] forCellWithReuseIdentifier:@"emojis"];
        [_collectionView registerClass:[WZMDeleteCell class] forCellWithReuseIdentifier:@"delete"];
        [_collectionView registerClass:[WZMEmoticonCell class] forCellWithReuseIdentifier:@"emoticon"];
        [self addSubview:_collectionView];
        
        UIColor *themeColor = [UIColor colorWithRed:34/255. green:207/255. blue:172/255. alpha:1];
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.maxY, frame.size.width, 40+WZMChat_BOTTOM_H)];
        toolView.backgroundColor = [UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1];
        [self addSubview:toolView];
        
        NSMutableArray *btns = [[NSMutableArray alloc] init];
        NSArray *names = @[@"默认",@"浪小花",@"emojis"];
        for (NSInteger i = 0; i < names.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(i*60, 0, 60, 40);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:[names objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:themeColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:btn];
            [btns addObject:btn];
            if (i == 0) {
                _selectedBtn = btn;
                _selectedBtn.selected = YES;
            }
        }
        _btns = [btns copy];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(frame.size.width-80, 0, 80, 40);
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        sendBtn.backgroundColor = themeColor;
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:sendBtn];
    }
    return self;
}

#define mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _emoticons.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *emoticons = [_emoticons objectAtIndex:section];
    return [self totalCount:emoticons.count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDelete:indexPath.item]) {
        WZMDeleteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"delete" forIndexPath:indexPath];
        return cell;
    }
    else {
        NSArray *emojis = [_emoticons objectAtIndex:indexPath.section];
        NSInteger index = [self trueIndex:indexPath.item];
        if (index < emojis.count) {
            if (indexPath.section == _emojisSection) {
                //emojis表情
                NSString *text = [emojis objectAtIndex:index];
                WZMEmojisCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojis" forIndexPath:indexPath];
                [cell setConfig:text];
                return cell;
            }
            else {
                //图片表情
                NSDictionary *dic = [emojis objectAtIndex:index];
                WZMEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emoticon" forIndexPath:indexPath];
                [cell setConfig:[dic objectForKey:@"png"]];
                return cell;
            }
        }
        else {
            WZMBlankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"blank" forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDelete:indexPath.item]) {
        if ([self.delegate respondsToSelector:@selector(emojisKeyboardDelete)]) {
            [self.delegate emojisKeyboardDelete];
        }
    }
    else {
        NSString *text = [self textWithIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(emojisKeyboardSendText:)]) {
            [self.delegate emojisKeyboardSendText:text];
        }
    }
}

- (NSString *)textWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _emoticons.count) {
        if (indexPath.section == _emojisSection) {
            //emojis表情
            NSArray *emojis = [_emoticons objectAtIndex:indexPath.section];
            NSInteger index = [self trueIndex:indexPath.item];
            if (index < emojis.count) {
                return [emojis objectAtIndex:index];
            }
        }
        else {
            //图片表情
            NSArray *emoticons = [_emoticons objectAtIndex:indexPath.section];
            NSInteger index = [self trueIndex:indexPath.item];
            if (index < emoticons.count) {
                NSDictionary *dic = [emoticons objectAtIndex:index];
                return [dic objectForKey:@"chs"];
            }
        }
    }
    return @"";
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/WZMChat_SCREEN_WIDTH;
    NSInteger section = [self currectSection:index];
    NSInteger page = [self currectPage:index];
    UIButton *btn = [_btns objectAtIndex:section];
    if (btn.isSelected) return;
    [self selectedBtn:btn];
}

- (void)toolBtnClick:(UIButton *)btn {
    if (btn.isSelected) return;
    [self selectedBtn:btn];
    NSInteger index = [self totalPageBeforeSection:btn.tag];
    [_collectionView setContentOffset:CGPointMake(WZMChat_SCREEN_WIDTH*index, 0) animated:NO];
}

- (void)selectedBtn:(UIButton *)btn {
    _selectedBtn.selected = NO;
    _selectedBtn = btn;
    _selectedBtn.selected = YES;
}

- (void)sendBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(emojisKeyboardSend)]) {
        [self.delegate emojisKeyboardSend];
    }
}

//是否是删除键
- (BOOL)isDelete:(NSInteger)index {
    NSInteger c = key_rows*key_nums;
    return ((index+1)%c == 0);
}

//数组中的正确索引
- (NSInteger)trueIndex:(NSInteger)index {
    NSInteger c = key_rows*key_nums;
    //已经加了的删除键个数
    NSInteger count = (index+1)/c;
    return (index-count);
}

//区item总个数
- (NSInteger)totalCount:(NSInteger)count {
    NSInteger c = key_rows*key_nums;
    //一共需要的删除键个数
    NSInteger dc = ceil(count*1.0/(c-1));
    return dc*c;
}

//区总页数
- (NSInteger)totalPage:(NSInteger)count {
    NSInteger c = key_rows*key_nums;
    return ceil(count*1.0/(c-1));
}

//获取当前区数
- (NSInteger)currectSection:(NSInteger)index {
    NSInteger lastPage = 0;
    for (NSInteger i = 0; i < _emoticons.count ; i ++) {
        if (i == _emojisSection) {
            NSArray *emojis = [_emoticons objectAtIndex:i];
            lastPage = [self totalPage:emojis.count]+lastPage;
        }
        else {
            //图片表情
            NSArray *emoticons = [_emoticons objectAtIndex:i];
            lastPage = [self totalPage:emoticons.count]+lastPage;
        }
        if (index < lastPage) {
            return i;
        }
    }
    return 0;
}

//获取在当前区中的页数
- (NSInteger)currectPage:(NSInteger)index {
    NSInteger page = [self currectSection:index];
    NSInteger lastPage = 0;
    for (NSInteger i = 0; i < page ; i ++) {
        if (i == _emojisSection) {
            NSArray *emojis = [_emoticons objectAtIndex:i];
            lastPage = [self totalPage:emojis.count]+lastPage;
        }
        else {
            //图片表情
            NSArray *emoticons = [_emoticons objectAtIndex:i];
            lastPage = [self totalPage:emoticons.count]+lastPage;
        }
    }
    return index-lastPage;
}

//指定区之前有多少页数
- (NSInteger)totalPageBeforeSection:(NSInteger)section {
    NSInteger lastPage = 0;
    for (NSInteger i = 0; i < section ; i ++) {
        if (i == _emojisSection) {
            NSArray *emojis = [_emoticons objectAtIndex:i];
            lastPage = [self totalPage:emojis.count]+lastPage;
        }
        else {
            //图片表情
            NSArray *emoticons = [_emoticons objectAtIndex:i];
            lastPage = [self totalPage:emoticons.count]+lastPage;
        }
    }
    return lastPage;
}

@end
