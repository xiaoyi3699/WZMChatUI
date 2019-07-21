**一、效果图**

![效果图](https://github.com/wangzhaomeng/WZMChatUI/blob/master/WZMChatUI/GitImage/preview.png?raw=true)

**二、集成方式**

**直接导入：`#import "WZMChat.h"`**

**文件夹结构如下图:**

![文件夹结构](https://github.com/wangzhaomeng/WZMChatUI/blob/master/WZMChatUI/GitImage/setting.png?raw=true)

**三、数据库设计简单描述**

从类型上，可分为3个表：

`用户表(user)、会话表(session)、消息表(message)`；

从实际需求上，再进一步细分：

`用户表需要两个：用户(user)和群(group)；`

`而为了消息的优化处理，每一个私聊或群聊，都可以新建一个消息表(message)`。

```
处理逻辑如下：
1、添加好友 - 发起聊天；
2、查询对应的消息表(message)是否存在，不存在则创建；
3、向该消息表(message)插入私聊消息；
4、从会话表(session)查询对应的会话，不存在则插入，存在则更新；
5、刷新相关页面。
```


**四、表情键盘的处理**

1、自定义layout，实现表情键盘的横向布局；

2、键盘弹出的时机与UITableView的偏移处理；

3、表情字符删除时的匹配处理，以及输入框光标的变化；

4、普通文本转换为表情富文本时的字符偏移，以及正则匹配效率的处理。


**五、消息列表滑动优化**

1、使用model类存储行高、行宽，避免重复计算；

2、视频、图片等消息使用缩略图，减少系统开销；

3、其他常规的优化处理。


