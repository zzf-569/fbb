//
//  TUIBaseChatViewControllerDelegate.h
//  TUIChat
//
//  Created by lei on 2024/9/28.
//

#import <Foundation/Foundation.h>

@import ImSDK_Plus;

@class TUIBaseChatViewController;
@class TUIBaseMessageController;
@class TUIMessageCellData;
@class TUIMessageCell;

NS_ASSUME_NONNULL_BEGIN

@protocol TUIBaseChatViewControllerDelegate <NSObject>


/// 点击控制器的回调
/// 你可以使用这个回调:重置InputController，解散键盘。
/// @param controller 消息控制器
- (void)didTapInMessageController:(TUIBaseMessageController *)controller;


/// 隐藏后长按菜单键回拨
/// 您可以根据需要自定义实现此委托函数
/// @param controller 消息控制器
- (void)didHideMenuInMessageController:(TUIBaseMessageController *)controller;


/// 回调前隐藏长按菜单键
/// 您可以根据需要自定义实现此委托函数
/// @param controller 消息控制器
/// @param view 控制器所在的视图
- (BOOL)messageController:(TUIBaseMessageController *)controller willShowMenuInCell:(UIView *)view;


/// 接收新消息的回调
/// 你可以使用这个回调来初始化一个基于传入数据的新消息，并执行一个新的消息提醒。
/// @param controller 消息控制器
/// @param message 返回需要显示的新消息单元。
- (nullable TUIMessageCellData *)messageController:(TUIBaseMessageController *)controller onNewMessage:(V2TIMMessage *)message;


/// 显示新消息的回调
/// 你可以使用这个回调来初始化消息气泡基于传入的数据和显示它
/// @param controller 消息控制器
/// @param data 返回需要显示的新消息单元。
- (nullable TUIMessageCell *)messageController:(TUIBaseMessageController *)controller onShowMessageData:(TUIMessageCellData *)data atIndexPath:(NSIndexPath *)indexPath;


/// 将显示单元格的回调
/// @param controller 消息控制器
/// @param cell 要显示的单元格
/// @param cellData 显示的单元格的数据
- (void)messageController:(TUIBaseMessageController *)controller willDisplayCell:(TUIMessageCell *)cell withData:(TUIMessageCellData *)cellData;


/// 回调点击头像在消息单元
/// 可以使用此回调实现:跳转到对应用户的详细信息界面。
/// 1.首先拉出用户信息，如果该用户是当前用户的好友，则初始化相应的好友信息界面并跳转。
/// 2.如果该用户不是当前用户的好友，则初始化用于添加好友的相应接口，并执行跳转。
/// @param controller 消息控制器
/// @param cell 显示的单元格
- (void)messageController:(TUIBaseMessageController *)controller onSelectMessageAvatar:(TUIMessageCell *)cell;


/// 在留言单元长按头像回调
/// @param controller 消息控制器
/// @param cell 显示的单元格
- (void)messageController:(TUIBaseMessageController *)controller onLongSelectMessageAvatar:(TUIMessageCell *)cell;


/// 回调，用于单击消息单元格中的消息内容
/// @param controller 消息控制器
/// @param cell 显示的单元格
- (void)messageController:(TUIBaseMessageController *)controller onSelectMessageContent:(TUIMessageCell *)cell;

/// 长按消息后，弹出菜单栏，点击菜单选项后进行回拨
/// menuType:被点击的菜单类型。0 -多选择，1 -转发。2. 举报
- (void)messageController:(TUIBaseMessageController *)controller onSelectMessageMenu:(NSInteger)menuType withData:(TUIMessageCellData *)data;

/// 即将回复邮件时的回拨(通常是长按邮件内容，然后点击回复按钮触发)
- (void)messageController:(TUIBaseMessageController *)controller onRelyMessage:(TUIMessageCellData *)data;

/// 回调报价信息(长按消息内容，然后点击报价按钮触发)
- (void)messageController:(TUIBaseMessageController *)controller onReferenceMessage:(TUIMessageCellData *)data;

/// 重新编辑消息的回调(通常用于重新调用消息)
- (void)messageController:(TUIBaseMessageController *)controller onReEditMessage:(TUIMessageCellData *)data;

/// 转发文本。
- (void)messageController:(TUIBaseMessageController *)controller onForwardText:(NSString *)text;


@end


NS_ASSUME_NONNULL_END
