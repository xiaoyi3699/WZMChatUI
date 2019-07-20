//
//  LLCustomLayout.m
//  LLEmoticonsKeyboard
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 Wang. All rights reserved.
//

#import "LLHorizontalLayout.h"

@interface LLHorizontalLayout (){
    NSMutableArray *_attributesArray;
    CGFloat _contentSizeWidth;
    CGFloat _keyboardW;
}
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) NSInteger nums;
@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger items;
@end

@implementation LLHorizontalLayout

- (id)initWithSpacing:(CGFloat)spacing rows:(NSInteger)rows nums:(NSInteger)nums {
    self = [super init];
    if (self) {
        _spacing = spacing;
        _rows = rows;
        _nums = nums;
        _items = nums*rows;
        _keyboardW = [UIScreen mainScreen].bounds.size.width;
        CGFloat itemWidth = (_keyboardW-(_nums+1)*_spacing)/_nums;
        CGFloat itemHeight = itemWidth*0.9;
        _LLItemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return self;
}

- (void)prepareLayout{
    _contentSizeWidth = 0.0;
    _attributesArray = [[NSMutableArray alloc] initWithCapacity:0];
    CGFloat itemWidth = _LLItemSize.width;
    CGFloat itemHeight = _LLItemSize.height;
    
    NSInteger sections = self.collectionView.numberOfSections;
    for (NSInteger section = 0; section < sections; section ++){
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < items; item ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGRect frame = CGRectZero;
            frame.origin.x = _spacing+item%_nums*(_spacing+itemWidth)+(item/_items)*_keyboardW+_contentSizeWidth;
            frame.origin.y = _spacing+item/_nums%_rows*(_spacing+itemHeight);
            frame.size.width = itemWidth;
            frame.size.height = itemHeight;
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = frame;
            [_attributesArray addObject:attributes];
        }
        _contentSizeWidth = _contentSizeWidth + ((items+_items-1)/_items)*_keyboardW;
    }
}

- (CGSize)collectionViewContentSize{
    CGSize size = CGSizeZero;
    size.height = self.collectionView.frame.size.height;
    size.width = _contentSizeWidth;
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < _attributesArray.count; i ++) {
        UICollectionViewLayoutAttributes *attributes = _attributesArray[i];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [resultArray addObject:attributes];
        }
    }
    return resultArray;
}

@end
