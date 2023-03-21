//
//  UIAlertView+WGExtension.h
//  WGExtension
//
//  Created by Arclin on 16/8/26.
//  Copyright © 2016年 Wegeet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WGAlertWithBtnBlock)(NSInteger index);
typedef void (^WGActionWithBtnBlock)(NSInteger index);
typedef void (^WGAlertWithTextBlock)(NSInteger index,NSString *text);

@interface UIAlertController (WGExtension)<UIAlertViewDelegate>

/**
 标题+信息+确认按钮
 
 @param title 标题
 @param message 显示信息
 */
+ (UIAlertController *)wg_alertWithOKButtonWithTitle:(NSString *)title message:(NSString *)message;
+ (UIAlertController *)wg_alertWithOKButtonWithTitle:(NSString *)title message:(NSString *)message clickBlock:(WGAlertWithBtnBlock)block;

/**
 标题+信息+确认按钮+回调
 
 @param title 标题
 @param message 显示信息
 */
+ (UIAlertController *)wg_alertWithOKButtonWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle handle:(void(^)(UIAlertAction *action))handleBlock;

/** 标题+信息+确认+取消按钮 */
+ (UIAlertController *)wg_alertWithOKCancelBtnWithTitle:(NSString *)title message:(NSString *)message clickBtnAtIndex:(WGAlertWithBtnBlock)block;

/** 标题+信息+确认+取消按钮+取消block */
+ (UIAlertController *)wg_alertWithOKCancelBtnWithTitle:(NSString *)title message:(NSString *)message clickBtnAtIndex:(WGAlertWithBtnBlock)block cancel:(void(^)(void))cancelBlock;

+ (UIAlertController *)wg_alertWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray *)titles clickBtnAtIndex:(WGActionWithBtnBlock)block cancel:(void(^)(void))cancelBlock;

/** 标题+信息+确认+取消+文本框 */
+ (void)wg_alertWithtPlainText:(NSString *)title isSecure:(BOOL)isSecure message:(NSString *)message placeholder:(NSString *)placehoder keyBoardType:(UIKeyboardType)keyBoardType clickBtnAtIndex:(WGAlertWithTextBlock)block;
+ (void)wg_alertWithtPlainText:(NSString *)title message:(NSString *)message configureTextField:(void(^)(UITextField* textField))configureTextField clickBtnAtIndex:(WGAlertWithTextBlock)block;

/** 标题+信息+按钮A+...+按钮N */
+ (UIAlertController *)wg_alertWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray *)titles clickBtnAtIndex:(WGActionWithBtnBlock)block;

/** 列表：标题+信息+按钮A+...+按钮N */
//+ (UIAlertController *)wg_actionSheetWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray *)titles clickBtnAtIndex:(WGActionWithBtnBlock)block;
+ (UIAlertController *)wg_ipad_actionSheetWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray *)titles sourceView:(UIView *)sourceView  clickBtnAtIndex:(WGActionWithBtnBlock)block;


@end
