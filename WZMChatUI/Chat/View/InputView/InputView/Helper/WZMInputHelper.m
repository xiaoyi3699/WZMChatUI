//
//  WZMInputHelper.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMInputHelper.h"

@interface WZMInputHelper ()

@property (nonatomic, strong) NSString *lxhPath;
@property (nonatomic, strong) NSString *otherPath;
@property (nonatomic, strong) NSString *defaultPath;
@property (nonatomic, strong) NSMutableDictionary *otherCache;
@property (nonatomic, strong) NSMutableDictionary *emoticonCache;

@end

@implementation WZMInputHelper {
    NSInteger _iPad;
    NSInteger _iPhone;
    NSInteger _iPhoneX;
    
    CGFloat _statusH;
    CGFloat _navBarH;
    CGFloat _tabBarH;
    
    CGFloat _screenH;
    CGFloat _screenW;
    CGFloat _screenScale;
    CGRect _screenBounds;
    
    CGFloat _iPhoneXBottomH;
}

+ (instancetype)helper {
    static WZMInputHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WZMInputHelper alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _iPad = -1;
        _iPhone  = -1;
        _iPhoneX = -1;
        [self reset];
        self.otherCache = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.emoticonCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)reset {
    _statusH = -1;
    _navBarH = -1;
    _tabBarH = -1;
    _screenW = -1;
    _screenH = -1;
    _screenScale = -1;
    _screenBounds = CGRectNull;
    _iPhoneXBottomH = -1;
}

///是否是iPad
- (BOOL)iPad {
    if (_iPad == -1) {
        _iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    }
    return (_iPad == 1);
}

///是否是iPhone
- (BOOL)iPhone {
    if (_iPhone == -1) {
        _iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    }
    return (_iPhone == 1);
}

///是否是iPhoneX
- (BOOL)iPhoneX {
    if (_iPhoneX == -1) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _iPhoneX = ([self iPhone] && (window.safeAreaInsets.bottom > 0.0));
        }
        else {
            _iPhoneX = 0;
        }
    }
    return (_iPhoneX == 1);
}

///状态栏高
- (CGFloat)statusH {
    if (_statusH == -1) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _statusH = window.safeAreaInsets.top;
        }
        else {
            _statusH = 20.0;
        }
    }
    return _statusH;
}

///导航高
- (CGFloat)navBarH {
    if (_navBarH == -1) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _navBarH = window.safeAreaInsets.top + 44.0;
        }
        else {
            _navBarH = 44.0;
        }
    }
    return _navBarH;
}

///taBar高
- (CGFloat)tabBarH {
    if (_tabBarH == -1) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _tabBarH = window.safeAreaInsets.bottom + 49.0;
        }
        else {
            _tabBarH = 49.0;
        }
    }
    return _tabBarH;
}

///屏幕宽
- (CGFloat)screenW {
    if (_screenW == -1) {
        _screenW = [UIScreen mainScreen].bounds.size.width;
    }
    return _screenW;
}

///屏幕高
- (CGFloat)screenH {
    if (_screenH == -1) {
        _screenH = [UIScreen mainScreen].bounds.size.height;
    }
    return _screenH;
}

///屏幕scale
- (CGFloat)screenScale {
    if (_screenScale == -1) {
        _screenScale = [UIScreen mainScreen].scale;
    }
    return _screenScale;
}

///屏幕bounds
- (CGRect)screenBounds {
    if (CGRectIsNull(_screenBounds)) {
        _screenBounds = [UIScreen mainScreen].bounds;
    }
    return _screenBounds;
}

///iPhoneX底部高度
- (CGFloat)iPhoneXBottomH {
    if (_iPhoneXBottomH == -1) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _iPhoneXBottomH = window.safeAreaInsets.bottom;
        }
        else {
            _iPhoneXBottomH = 0.0;
        }
    }
    return _iPhoneXBottomH;
}

+ (UIImage *)otherImageNamed:(NSString *)name {
    if (name.length == 0) return nil;
    if (name.pathExtension == nil) {
        name = [name stringByAppendingString:@".png"];
    }
    WZMInputHelper *helper = [WZMInputHelper helper];
    UIImage *image = [helper.otherCache objectForKey:name];
    if (image == nil) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",helper.otherPath,name];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        [helper.otherCache setObject:image forKey:name];
    }
    return image;
}

+ (UIImage *)emoticonImageNamed:(NSString *)name {
    if (name.length == 0) return nil;
    if (name.pathExtension == nil) {
        name = [name stringByAppendingString:@".png"];
    }
    WZMInputHelper *helper = [WZMInputHelper helper];
    UIImage *image = [helper.emoticonCache objectForKey:name];
    if (image == nil) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",helper.lxhPath,name];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image == nil) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",helper.defaultPath,name];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        [helper.emoticonCache setObject:image forKey:name];
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
