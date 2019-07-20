//
//  WZMUserViewController.m
//  LLChat
//
//  Created by WangZhaomeng on 2018/8/31.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMUserViewController.h"
#import "WZMUserTableViewCell.h"

@interface WZMUserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WZMUserViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"好友";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadUser];
}

- (void)setupUI {
    [self setRightItem];
    [self.view addSubview:self.tableView];
}

- (void)loadUser {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.users = [[WZMChatDBManager DBManager] users];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)setRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = item;
}

//添加一个好友
- (void)rightItemClick {
    NSString *uid = @"00002";
    WZMChatUserModel *lastModel = self.users.lastObject;
    if (lastModel) {
        uid = [NSString stringWithFormat:@"%05ld",(long)(lastModel.uid.integerValue+1)];
    }
    
    WZMChatUserModel *model = [[WZMChatUserModel alloc] init];
    model.uid = uid;
    model.name = [NSString stringWithFormat:@"用户:%@",uid];
    model.avatar = @"http://sqb.wowozhe.com/images/touxiangs/10026820.jpg";
    model.showName = YES;
    //加入列表
    [self.users addObject:model];
    [self.tableView reloadData];
    //加入数据库
    [[WZMChatDBManager DBManager] insertUserModel:model];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.users.count) {
        WZMChatUserModel *model = [self.users objectAtIndex:indexPath.row];
        
        WZMChatViewController *chatVC = [[WZMChatViewController alloc] initWithUser:model];
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZMUserTableViewCell *cell = (WZMUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[WZMUserTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.row < self.users.count) {
        WZMChatUserModel *model = [self.users objectAtIndex:indexPath.row];
        [cell setConfig:model];
    }
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.users.count) {
        WZMChatUserModel *model = [self.users objectAtIndex:indexPath.row];
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self.users removeObject:model];
            [self.tableView reloadData];
            [[WZMChatDBManager DBManager] deleteUserModel:model.uid];
            [WZMChatNotificationManager postSessionNotification];
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
        rect.origin.y = LLCHAT_NAV_TOP_H;
        rect.size.height -= (LLCHAT_NAV_TOP_H+LLCHAT_BAR_BOT_H);
        
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

@end
