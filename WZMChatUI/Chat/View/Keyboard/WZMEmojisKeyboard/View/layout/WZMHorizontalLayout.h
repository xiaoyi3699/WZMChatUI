//
//  LLCustomLayout.h
//  WZMEmoticonsKeyboard
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 Wang. All rights reserved.
//  横向、分页UICollectionViewLayout

#import <UIKit/UIKit.h>

@interface WZMHorizontalLayout : UICollectionViewLayout

@property (nonatomic, assign, readonly) CGSize WZMItemSize;//获取当前设置下的itemSize

/**
 *  初始化
 *
 *  @param spacing 每个item之间的距离
 *  @param rows    每页显示的item行数
 *  @param nums    每行显示的item个数
 *
 *  @return layout
 */
- (id)initWithSpacing:(CGFloat)spacing rows:(NSInteger)rows nums:(NSInteger)nums;

@end
