//
//  WZMSessionViewController.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/8/31.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMSessionViewController.h"
#import "WZMSessionTableViewCell.h"

@interface WZMSessionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sessions;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, getter=isRefreshSession) BOOL refreshSession;

@end

@implementation WZMSessionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"会话";
        self.refreshSession = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadSession];
    [self setRightItem];
    
    [WZMChatNotificationManager observerSessionNotification:self sel:@selector(receiveSessionNotification)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isRefreshSession) {
        self.refreshSession = NO;
        [self loadSession];
    }
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
}

- (void)loadSession {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.sessions = [[WZMChatDBManager DBManager] sessions];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

//收到刷新session的通知
- (void)receiveSessionNotification {
    self.refreshSession = YES;
}

#pragma mark - 模拟消息免打扰、显示未读未读消息数等
- (void)setRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"更改样式" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightItemClick {
    static NSInteger type = 1;
    if (type == 4) {
        type = 0;
    }
    for (WZMChatSessionModel *session in self.sessions) {
        if (type == 0) {
            session.unreadNum = @"0";
            session.silence = NO;
        }
        else if (type == 1) {
            session.unreadNum = @"18";
            session.silence = NO;
        }
        else if (type == 2) {
            session.unreadNum = @"18";
            session.silence = YES;
        }
        else if (type == 3) {
            session.unreadNum = @"100";
            session.silence = NO;
        }
    }
    [self.tableView reloadData];
    type ++;
}
#pragma mark -

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.sessions.count) {
        WZMChatSessionModel *session = [self.sessions objectAtIndex:indexPath.row];
        
        WZMChatViewController *chatVC = [[WZMChatViewController alloc] initWithSession:session];
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZMSessionTableViewCell *cell = (WZMSessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[WZMSessionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.row < self.sessions.count) {
        WZMChatSessionModel *session = [self.sessions objectAtIndex:indexPath.row];
        [cell setConfig:session];
    }
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.sessions.count) {
        WZMChatSessionModel *session = [self.sessions objectAtIndex:indexPath.row];
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self.sessions removeObject:session];
            [self.tableView reloadData];
            [[WZMChatDBManager DBManager] deleteSessionModel:session.sid];
            //删除聊天记录
            if (session.isSilence) {
                [[WZMChatDBManager DBManager] deleteMessageWithGid:session.sid];
            }
            else {
                [[WZMChatDBManager DBManager] deleteMessageWithUid:session.sid];
            }
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction];
    }
    return nil;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect rect = self.view.bounds;
        rect.origin.y = WZMChat_NAV_TOP_H;
        rect.size.height -= (WZMChat_NAV_TOP_H+WZMChat_BAR_BOT_H);
        
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
    }
    return _tableView;
}

- (void)dealloc {
    [WZMChatNotificationManager removeObserver:self];
}

@end
