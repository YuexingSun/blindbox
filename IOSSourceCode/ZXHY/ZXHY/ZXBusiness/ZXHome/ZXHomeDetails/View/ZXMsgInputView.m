//
//  ZXMsgInputView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/29.
//

#import "ZXMsgInputView.h"
#import "ZXMsgEmojiView.h"


@interface ZXMsgInputView()
<
UITextFieldDelegate,
UITextViewDelegate,
ZXMsgEmojiViewDelegate
>

//表情
@property (nonatomic, strong) ZXMsgEmojiView *emojiView;

@property (nonatomic, strong)  UIView *topMsgView;
@property (nonatomic, strong)  UIView *bgView;
@property (nonatomic, strong) UITextView *msgInputTextView;
@property (nonatomic, strong) UIButton *msgSendBtn;
@property (nonatomic, strong) UIButton *msgEmojiBtn;
//键盘Y
@property (nonatomic, assign) CGFloat  keyboaryY;

@end

@implementation ZXMsgInputView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
        //监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    
    //消息View
    self.topMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 48.0)];
    self.topMsgView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.topMsgView];
    
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, WGNumScreenWidth() - 95, self.frame.size.height - 10)];
    bgView.layer.cornerRadius = 18;
    bgView.layer.borderWidth = 1.5;
    bgView.layer.borderColor = WGGrayColor(238).CGColor;
    bgView.backgroundColor = UIColor.whiteColor;
    [self.topMsgView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topMsgView.mas_top).offset(5);
        make.bottom.mas_equalTo(self.topMsgView.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-95);
    }];
    self.bgView = bgView;
    
    
    
    [bgView addSubview:self.msgInputTextView];
    [self.msgInputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(bgView);
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-45);
    }];
    
    
    
    [bgView addSubview:self.msgEmojiBtn];
    [self.msgEmojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-6);
        make.right.mas_equalTo(bgView.mas_right).offset(-10);
        make.width.height.offset(25);
    }];
    
    [self.topMsgView addSubview:self.msgSendBtn];
    [self.msgSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topMsgView.mas_bottom).offset(-8);
        make.right.mas_equalTo(self.topMsgView.mas_right).offset(-12);
        make.width.offset(64);
        make.height.offset(36);
    }];
    
    
    
    //表情
    ZXMsgEmojiView *emojiView = [[ZXMsgEmojiView alloc] initWithFrame:CGRectMake(0, WGNumScreenHeight(), WGNumScreenWidth(), 290)];
    emojiView.delegate = self;
    self.emojiView = emojiView;
    
}





#pragma mark - 事件交互
//发送响应
- (void)msgSendBtnClick{
    if (!self.msgInputTextView.text.length){
        [WGUIManager wg_hideHUDWithText:@"消息不能为空"];
        return;
    }
    
    //文本转换
    NSString *serverString = [ZX_EmojiManager zx_stringWithEmojiString:self.msgInputTextView.attributedText];
    NSLog(@"\nserverString----%@",serverString);
    
    //发送代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_sendMsgInputView:MsgText:)]){
        [self.delegate zx_sendMsgInputView:self MsgText:serverString];
    }
    
    [self wg_cleanTextField];
    [self wg_resignFirstResponder];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.top = WGNumScreenHeight();
    }];
    
}

   
//表情键盘响应
- (void)msgEmojiBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    [self.msgInputTextView resignFirstResponder];
    if (sender.selected) {
        self.msgInputTextView.inputView = self.emojiView;
    }
    else {
        self.msgInputTextView.inputView = nil;
    }
    [self.msgInputTextView becomeFirstResponder];
}
    


#pragma mark - notification 监听键盘高度变化
- (void)keyboardFrameDidChange:(NSNotification *)notice {

    NSDictionary * userInfo = notice.userInfo;
    NSValue * endFrameValue = [userInfo wg_safeObjectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = endFrameValue.CGRectValue;
    
    self.keyboaryY = endFrame.origin.y;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (endFrame.origin.y == WGNumScreenHeight()) {
           
            if ([self wg_isEmoji]){
                
            }
//            self.height = self.topMsgView.height + endFrame.size.height;
//            self.top = WGNumScreenHeight();
            
            

        } else {
            
            self.height = self.topMsgView.height + endFrame.size.height;
            self.top = WGNumScreenHeight() - self.height;
            
        }
    }];
    
}


#pragma -- mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 300) {
        textView.text = [textView.text wg_safeSubstringToIndex:300];
    }
    
    //按钮高亮处理
    self.msgSendBtn.alpha = (textView.text.length) ? 1 : 0.5;
    
    //计算文本高度并处理 MsgView
    [self heightForString:textView andWidth:textView.mj_w];
   
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
   
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self msgSendBtnClick];
        return NO;
    }
    return YES;
}



#pragma mark - ZXMsgEmojiViewDelegate(emoji处理)
//删除
- (void)zx_removeEmojiView:(ZXMsgEmojiView *)emojiView{
    
}

//选中Item
- (void)zx_selectEmojiView:(ZXMsgEmojiView *)emojiView SelectItemAtEmojiAttachment:(ZXEmojiAttachment *)attachment{
        
    //插入表情
    [ZX_EmojiManager zx_insertEmojiToString:attachment textView:self.msgInputTextView];
    
    _msgInputTextView.font = kFontMedium(15);
    
    
    //按钮高亮处理
    self.msgSendBtn.alpha = (self.msgInputTextView.text.length) ? 1 : 0.5;
    
    //计算文本高度并处理 MsgView
    [self heightForString:self.msgInputTextView andWidth:self.msgInputTextView.mj_w];
    

}




#pragma mark - 方法

- (void)wg_becomeFirstResponder
{
    [self.msgInputTextView becomeFirstResponder];
}

- (void)wg_resignFirstResponder
{
    self.msgEmojiBtn.selected = NO;
    self.msgInputTextView.inputView = nil;
    [self.msgInputTextView resignFirstResponder];
}

- (BOOL)wg_isEmoji{
    return  self.msgEmojiBtn.selected;
}

- (void)wg_cleanTextField{
    
    self.msgInputTextView.text = @"";
    
    //按钮高亮处理
    self.msgSendBtn.alpha = (self.msgInputTextView.text.length) ? 1 : 0.5;

    //计算文本高度并处理 MsgView
    [self heightForString:self.msgInputTextView andWidth:self.msgInputTextView.mj_w];
    
}

//计算文本高度并处理 MsgView
- (void) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    CGFloat textHeight = sizeToFit.height;
    
    //改变消息topMsgView高度
    CGFloat msgInputTopViewHeight = 48;
    
    if (msgInputTopViewHeight > textHeight + 10){
        self.topMsgView.height = msgInputTopViewHeight;
    }else{
        self.topMsgView.height = textHeight + 10;
    }
    if (self.topMsgView.height > 150) self.topMsgView.height = 150;
    
    //self 高度 和 Y值
    self.height  = ( WGNumScreenHeight() - self.keyboaryY) + self.topMsgView.height;
    self.top = WGNumScreenHeight() - self.height;
    
}






#pragma mark - lazy
- (UITextView *)msgInputTextView{
    if (!_msgInputTextView){
        
    
        _msgInputTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, WGNumScreenWidth() - 95, self.frame.size.height - 10)];
        _msgInputTextView.placeholder = @"讲两句";
        _msgInputTextView.textColor = UIColor.blackColor;
        _msgInputTextView.font = kFontMedium(15);
        _msgInputTextView.delegate = self;
        _msgInputTextView.returnKeyType = UIReturnKeySend;
        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:kFontMedium(15)}];
        _msgInputTextView.attributedText = attributedString;
        
    }
    return  _msgInputTextView;
}

- (UIButton *)msgEmojiBtn
{
    if (!_msgEmojiBtn) {
        _msgEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _msgEmojiBtn.frame = CGRectMake(0,0, 25, 25);
        _msgEmojiBtn.adjustsImageWhenHighlighted = NO;
        [_msgEmojiBtn setBackgroundImage:IMAGENAMED(@"postEmoji") forState:UIControlStateNormal];
        [_msgEmojiBtn setBackgroundImage:IMAGENAMED(@"postKeyboard") forState:UIControlStateSelected];
        [_msgEmojiBtn addTarget:self action:@selector(msgEmojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgEmojiBtn;
}


- (UIButton *)msgSendBtn
{
    if (!_msgSendBtn) {
        _msgSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _msgSendBtn.frame = CGRectMake(0,0, 64, 36);
        _msgSendBtn.layer.cornerRadius = 18;
        _msgSendBtn.layer.masksToBounds = YES;
        _msgSendBtn.alpha = 0.5;
        [_msgSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_msgSendBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_msgSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_msgSendBtn setBackgroundColor:WGRGBColor(248, 110, 151)];
        [_msgSendBtn addTarget:self action:@selector(msgSendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgSendBtn;
}


@end
