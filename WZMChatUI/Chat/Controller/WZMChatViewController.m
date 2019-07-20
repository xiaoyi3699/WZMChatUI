//
//  WZMChatViewController.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMChatViewController.h"
#import "WZMInputView.h"
#import "WZMChatSystemCell.h"
#import "WZMChatTextMessageCell.h"
#import "WZMChatVoiceMessageCell.h"
#import "WZMChatImageMessageCell.h"
#import "WZMChatVideoMessageCell.h"
#import "WZMChatRecordAnimation.h"
#import "WZMChatDBManager.h"
#import "WZMChatUserModel.h"
#import "WZMChatGroupModel.h"
#import "WZMChatHelper.h"
#import "WZMChatMessageManager.h"
#import "WZChatMacro.h"
#import "UIView+WZMChat.h"
#import "WZMChatNotificationManager.h"

@interface WZMChatViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,WZMInputViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WZMInputView *inputView;
@property (nonatomic, strong) NSMutableArray *messageModels;
@property (nonatomic, assign, getter=isEditing) BOOL editing;
@property (nonatomic, assign, getter=isShowName) BOOL showName;
@property (nonatomic, assign, getter=isDeferredSystemGestures) BOOL deferredSystemGestures;
@property (nonatomic, assign) CGFloat recordDuration;
@property (nonatomic, strong) WZMChatUserModel *userModel;
@property (nonatomic, strong) WZMChatGroupModel *groupModel;
@property (nonatomic, strong) WZMChatRecordAnimation *recordAnimation;
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> recognizerDelegate;

@end

@implementation WZMChatViewController

- (instancetype)initWithUser:(WZMChatUserModel *)userModel {
    self = [super init];
    if (self) {
        [self setConfig:userModel];
    }
    return self;
}

- (instancetype)initWithGroup:(WZMChatGroupModel *)groupModel {
    self = [super init];
    if (self) {
        [self setConfig:groupModel];
    }
    return self;
}

- (instancetype)initWithSession:(WZMChatSessionModel *)sessionModel {
    self = [super init];
    if (self) {
        [self setConfig:[[WZMChatDBManager DBManager] selectChatModel:sessionModel]];
    }
    return self;
}

- (void)setConfig:(WZMChatBaseModel *)model {
    self.title = @"消息";
    if ([model isKindOfClass:[WZMChatUserModel class]]) {
        self.userModel = (WZMChatUserModel *)model;
        self.showName = self.userModel.isShowName;
    }
    else {
        self.groupModel = (WZMChatGroupModel *)model;
        self.showName = self.groupModel.isShowName;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI布局
    [self createViews];
    //屏蔽系统底部手势
    self.deferredSystemGestures = YES;
    //加载聊天记录
    [self loadMessage:0];
    //模拟发送消息
    [self setRightItem];
}

- (void)createViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateRecognizerDelegate:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self updateRecognizerDelegate:NO];
}

//从数据库加载聊天记录
- (void)loadMessage:(NSInteger)page {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.userModel) {
            self.messageModels = [[WZMChatDBManager DBManager] messagesWithUser:self.userModel];
        }
        else {
            self.messageModels = [[WZMChatDBManager DBManager] messagesWithGroup:self.groupModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self tableViewScrollToBottom:NO];
        });
    });
}

#pragma mark - 模拟收到消息
- (void)setRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"模拟收到消息" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightItemClick {
    static NSInteger msgType = 1;
    if (msgType == WZMMessageTypeSystem) {
        NSString *timeMessage = [WZMChatHelper timeFromDate:[NSDate date]];
        WZMChatMessageModel *model = [WZMChatMessageManager createSystemMessage:self.userModel
                                                                      message:timeMessage
                                                                     isSender:YES];
        [self receiveMessageModel:model];
    }
    else if (msgType == WZMMessageTypeText) {
        WZMChatMessageModel *model = [WZMChatMessageManager createTextMessage:self.userModel
                                                                    message:@"[微笑]我收到了一条文本消息"
                                                                   isSender:NO];
        [self receiveMessageModel:model];
    }
    else if (msgType == WZMMessageTypeImage) {
        //收到图片
        //原图和缩略图链接
        NSString *original = @"http://www.vasueyun.cn/llgit/WZMChat/2.jpg";
        NSString *thumbnail = @"http://www.vasueyun.cn/llgit/WZMChat/2_t.jpg";
        
        //图片下载的代码就不多写, 这里默认下载完成
        //原图
        UIImage *oriImage = [UIImage imageNamed:@"2.jpg"];
        //缩略图, 消息展示, 优化消息滑动时的卡顿
        UIImage *thumImage = [UIImage imageNamed:@"2_t.jpg"];
        
        //创建图片model
        WZMChatMessageModel *model = [WZMChatMessageManager createImageMessage:self.userModel
                                                                   thumbnail:thumbnail
                                                                    original:original
                                                                   thumImage:thumImage
                                                                    oriImage:oriImage
                                                                    isSender:NO];
        [self receiveMessageModel:model];
    }
    else if (msgType == WZMMessageTypeVoice) {
        //接收到声音
        //声音地址
        NSString *voiceUrl = @"";
        
        //创建录音model
        NSInteger duration = arc4random()%60+1;
        WZMChatMessageModel *model = [WZMChatMessageManager createVoiceMessage:self.userModel
                                                                    duration:duration
                                                                    voiceUrl:voiceUrl
                                                                    isSender:NO];
        [self sendMessageModel:model];
    }
    else if (msgType == WZMMessageTypeVideo) {
        //收到视频
        NSString *videoUrl = @"";
        //封面图链接
        NSString *coverUrl = @"http://www.vasueyun.cn/llgit/WZMChat/1_t.jpg";
        //下载封面图
        UIImage *coverImage = [UIImage imageNamed:@"1_t.jpg"];
        //创建视频model
        WZMChatMessageModel *model = [WZMChatMessageManager createVideoMessage:self.userModel
                                                                    videoUrl:videoUrl
                                                                    coverUrl:coverUrl
                                                                  coverImage:coverImage
                                                                    isSender:NO];
        [self sendMessageModel:model];
    }
    msgType = (msgType+1)%5;
}

#pragma mark - 发送消息
//文本消息
- (void)inputView:(WZMInputView *)inputView sendMessage:(NSString *)message {
    //清空草稿
    [[WZMChatDBManager DBManager] removeDraftWithModel:self.userModel];
    WZMChatMessageModel *model = [WZMChatMessageManager createTextMessage:self.userModel
                                                                message:message
                                                               isSender:YES];
    [self sendMessageModel:model];
}

//其他自定义消息, 如: 图片、视频、位置等等
- (void)inputView:(WZMInputView *)inputView selectedType:(WZMChatMoreType)type {
    if (type == WZMChatMoreTypeImage) {
        //发送图片
        //选择图片的代码就不多写了, 这里假定已经选择了图片
        
        //原图,
        UIImage *oriImage = [UIImage imageNamed:@"1.jpg"];
        
        //缩略图, 消息展示, 优化消息滑动时的卡顿
        //将原图按照一定的算法压缩处理成缩略图, 这里直接使用外部生成的缩略图,
        UIImage *thumImage = [UIImage imageNamed:@"1_t.jpg"];
        
        //将图片上传到服务器, 图片消息只是把图片的链接发送过去, 接收端根据链接展示图片
        //上传图片的代码就不多写, 具体上传方式根据自身服务器api决定, 这里假定图片已经上传到服务器上了, 并且返回了两个链接, 原图和缩略图
        //原图和缩略图链接
        NSString *original = @"http://www.vasueyun.cn/llgit/WZMChat/1.jpg";
        NSString *thumbnail = @"http://www.vasueyun.cn/llgit/WZMChat/1_t.jpg";
        
        //创建图片model
        WZMChatMessageModel *model = [WZMChatMessageManager createImageMessage:self.userModel
                                                                   thumbnail:thumbnail
                                                                    original:original
                                                                   thumImage:thumImage
                                                                    oriImage:oriImage
                                                                    isSender:YES];
        [self sendMessageModel:model];
    }
    else if (type == WZMChatMoreTypeVideo) {
        //发送视频
        //选择视频的代码就不多写了, 这里假定已经选择了视频
        //上传到服务器, 获取视频链接
        NSString *videoUrl = @"";
        
        //封面图
        UIImage *coverImage = [UIImage imageNamed:@"2_t.jpg"];
        
        //将封面图上传到服务器, 获取封面图链接
        NSString *coverUrl = @"http://www.vasueyun.cn/llgit/WZMChat/2_t.jpg";
        
        //创建视频model
        WZMChatMessageModel *model = [WZMChatMessageManager createVideoMessage:self.userModel
                                                                    videoUrl:videoUrl
                                                                    coverUrl:coverUrl
                                                                  coverImage:coverImage
                                                                    isSender:YES];
        [self sendMessageModel:model];
    }
    else if (type == WZMChatMoreTypeLocation) {
        //发送定位 - 未实现
        
    }
    else if (type == WZMChatMoreTypeTransfer) {
        //文件互传 - 未实现
        
    }
}

//文本变化
- (void)inputView:(WZMInputView *)inputView didChangeText:(NSString *)text {
    //保存草稿
    [[WZMChatDBManager DBManager] setDraft:text model:self.userModel];
}

//录音状态变化
- (void)inputView:(WZMInputView *)inputView didChangeRecordType:(WZMChatRecordType)type {
    if (type == WZMChatRecordTypeTouchDown) {
        //手指按下, 开始录音
        //此处录音计时采用的时间差
        //若是需要限制录音时长, 可采用计时器进行计时
        self.recordDuration = [WZMChatHelper nowTimestamp];
        [self.view addSubview:self.recordAnimation];
        self.recordAnimation.volume = 1.0;
    }
    else if (type == WZMChatRecordTypeTouchDragOutside) {
        //手指滑动到外面
        [self.recordAnimation showVoiceCancel];
    }
    else if (type == WZMChatRecordTypeTouchDragInside) {
        //手指滑动到里面
        [self.recordAnimation showVoiceAnimation];
    }
    else if (type == WZMChatRecordTypeTouchCancel) {
        //取消录音
        [self.recordAnimation removeFromSuperview];
    }
    else if (type == WZMChatRecordTypeTouchFinish) {
        //结束录音
        self.recordDuration = ([WZMChatHelper nowTimestamp]-self.recordDuration);
        if (self.recordDuration > 1000) {
            //录音完成
            [self.recordAnimation removeFromSuperview];
            //发送声音
            //录音的代码就不多写了, 这里假定已经录音
            
            //将录音上传到服务器, 获取录音链接
            NSString *voiceUrl = @"";
            
            //创建录音model
            WZMChatMessageModel *model = [WZMChatMessageManager createVoiceMessage:self.userModel
                                                                        duration:(NSInteger)self.recordDuration/1000
                                                                        voiceUrl:voiceUrl
                                                                        isSender:YES];
            [self sendMessageModel:model];
        }
        else {
            [self.recordAnimation showVoiceShort];
            if (self.recordDuration > 200) {
                //录音时间太短
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.recordAnimation removeFromSuperview];
                });
            }
            else {
                [self.recordAnimation removeFromSuperview];
            }
        }
    }
}

//键盘状态变化
- (void)inputView:(WZMInputView *)inputView willChangeFrameWithDuration:(CGFloat)duration isEditing:(BOOL)isEditing {
    self.editing = isEditing;
    
    CGFloat TContentH = self.tableView.contentSize.height;
    CGFloat tableViewH = self.tableView.bounds.size.height;
    CGFloat keyboardH = WZMChat_SCREEN_HEIGHT-self.inputView.minY-WZMChat_INPUT_H;
    
    CGFloat offsetY = 0;
    if (TContentH < tableViewH) {
        offsetY = TContentH+keyboardH-tableViewH;
        if (offsetY < 0) {
            offsetY = 0;
        }
    }
    else {
        offsetY = keyboardH;
    }
    
    CGRect TRect = self.tableView.frame;
    if (offsetY > 0) {
        TRect.origin.y = WZMChat_NAV_TOP_H-offsetY+WZMChat_BOTTOM_H;
        [UIView animateWithDuration:duration animations:^{
            self.tableView.frame = TRect;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageModels.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
    }
    else {
        TRect.origin.y = WZMChat_NAV_TOP_H;
        [UIView animateWithDuration:duration animations:^{
            self.tableView.frame = TRect;
        }];
    }
}

#pragma mark - private method
//发送消息
- (void)sendMessageModel:(WZMChatMessageModel *)model {
    [self addMessageModel:model];
    
    //模拟消息发送中、发送成功、发送失败
    //根据需要可以将消息默认值设置为发送成功, 此处是为了演示效果
    NSInteger i = arc4random()%2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (i == 0) {
            model.sendType = WZMMessageSendTypeFailed;
        }
        else {
            model.sendType = WZMMessageSendTypeSuccess;
        }
        if (self.userModel) {
            [[WZMChatDBManager DBManager] updateMessageModel:model chatWithUser:self.userModel];
        }
        else {
            [[WZMChatDBManager DBManager] updateMessageModel:model chatWithGroup:self.groupModel];
        }
        [self.tableView reloadData];
    });
    
    [WZMChatNotificationManager postSessionNotification];
}

//收到消息
- (void)receiveMessageModel:(WZMChatMessageModel *)model {
    [self addMessageModel:model];
    
    [WZMChatNotificationManager postSessionNotification];
}

//消息存储
- (void)addMessageModel:(WZMChatMessageModel *)model {
    [self.messageModels addObject:model];
    [_tableView reloadData];
    [self tableViewScrollToBottom:YES];
    
    if (self.userModel) {
        [[WZMChatDBManager DBManager] insertMessage:model chatWithUser:self.userModel];
    }
    else {
        [[WZMChatDBManager DBManager] insertMessage:model chatWithGroup:self.groupModel];
    }
}

- (void)tableViewScrollToBottom:(BOOL)animated {
    if (animated) {
        if (self.isEditing) {
            CGFloat TContentH = self.tableView.contentSize.height;
            CGFloat tableViewH = self.tableView.bounds.size.height;
            
            CGFloat keyboardH = WZMChat_SCREEN_HEIGHT-self.inputView.minY-WZMChat_INPUT_H;
            
            CGFloat offsetY = 0;
            if (TContentH < tableViewH) {
                offsetY = TContentH+keyboardH-tableViewH;
                if (offsetY < 0) {
                    offsetY = 0;
                }
            }
            else {
                offsetY = keyboardH;
            }
            
            if (offsetY > WZMChat_BOTTOM_H) {
                CGRect TRect = self.tableView.frame;
                TRect.origin.y = WZMChat_NAV_TOP_H-offsetY+WZMChat_BOTTOM_H;
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView.frame = TRect;
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageModels.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }];
            }
        }
        else {
            CGFloat TContentH = self.tableView.contentSize.height;
            CGFloat tableViewH = self.tableView.bounds.size.height;
            if (TContentH > tableViewH) {
                [UIView animateWithDuration:0.25 animations:^{
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageModels.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }];
            }
        }
    }
    else {
        if (self.messageModels.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageModels.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputView chatResignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.messageModels.count) {
        WZMChatMessageModel *model = [self.messageModels objectAtIndex:indexPath.row];
        [model cacheModelSize];
        if (model.msgType == WZMMessageTypeSystem) {
            return model.modelH;
        }
        if (self.isShowName) {
            return model.modelH+45;
        }
        else {
            return model.modelH+32;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.messageModels.count) {
        
        WZMChatBaseCell *cell;
        WZMChatMessageModel *model = [self.messageModels objectAtIndex:indexPath.row];
        
        if (model.msgType == WZMMessageTypeSystem) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
            if (cell == nil) {
                cell = [[WZMChatSystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemCell"];
            }
            [cell setConfig:model];
        }
        else if (model.msgType == WZMMessageTypeText) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            if (cell == nil) {
                cell = [[WZMChatTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"];
            }
            [cell setConfig:model isShowName:self.isShowName];
        }
        else if (model.msgType == WZMMessageTypeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            if (cell == nil) {
                cell = [[WZMChatImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
            }
            [cell setConfig:model isShowName:self.isShowName];
        }
        else if (model.msgType == WZMMessageTypeVoice) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
            if (cell == nil) {
                cell = [[WZMChatVoiceMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"voiceCell"];
            }
            [cell setConfig:model isShowName:self.isShowName];
        }
        else if (model.msgType == WZMMessageTypeVideo) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
            if (cell == nil) {
                cell = [[WZMChatVideoMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
            }
            [cell setConfig:model isShowName:self.isShowName];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noDataCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"noDataCell"];
    }
    return cell;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect rect = self.view.bounds;
        rect.origin.y = WZMChat_NAV_TOP_H;
        rect.size.height -= (WZMChat_NAV_TOP_H+WZMChat_INPUT_H+WZMChat_BOTTOM_H);
        
        _tableView = [[UITableView alloc] initWithFrame:rect];
        _tableView.delegate = self;
        _tableView.dataSource = self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (WZMInputView *)inputView {
    if (_inputView == nil) {
        _inputView = [[WZMInputView alloc] init];
        _inputView.delegate = self;
        [_inputView setText:[[WZMChatDBManager DBManager] draftWithModel:self.userModel]];
    }
    return _inputView;
}

- (NSMutableArray *)messageModels {
    if (_messageModels == nil) {
        _messageModels = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _messageModels;
}

- (WZMChatRecordAnimation *)recordAnimation {
    if (_recordAnimation == nil) {
        _recordAnimation = [[WZMChatRecordAnimation alloc] init];
    }
    return _recordAnimation;
}

#pragma mark - 录音按钮手势冲突处理
//设置手势代理
- (void)updateRecognizerDelegate:(BOOL)appear {
    if (appear) {
        if (self.recognizerDelegate == nil) {
            self.recognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        }
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.delegate = self.recognizerDelegate;
    }
}

//是否响应触摸事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.navigationController.viewControllers.count <= 1) return NO;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.y > WZMChat_SCREEN_HEIGHT-WZMChat_INPUT_H-WZMChat_BOTTOM_H) {
            return NO;
        }
        if (point.x <= 100) {//设置手势触发区
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGFloat tx = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view].x;
        if (tx < 0) {
            return NO;
        }
    }
    return YES;
}

//是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    //UIScrollView的滑动冲突
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollow = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollow.bounds.size.width >= scrollow.contentSize.width) {
            return NO;
        }
        if (scrollow.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

//屏蔽屏幕底部的系统手势
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    if (self.isDeferredSystemGestures) {
        return  UIRectEdgeBottom;
    }
    return UIRectEdgeNone;
}

- (void)dealloc {
    NSLog(@"释放了==%@",NSStringFromClass([self class]));
}

@end
