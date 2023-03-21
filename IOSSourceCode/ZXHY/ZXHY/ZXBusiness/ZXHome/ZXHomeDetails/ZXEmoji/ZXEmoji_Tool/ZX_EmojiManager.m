//
//  ZX_EmojiManager.m
//  ZXHY
//
//  Created by Bern Lin on 2022/2/24.
//

#import "ZX_EmojiManager.h"

#define Regular  @"\\[emoji-[0-9]+\\]"
#define EmojiAttachmentBounds CGRectMake(0, -8, 30, 30);


@implementation ZX_EmojiManager


/**
 给输入框插入自定义表情
 @param emojiAttachment 表情对象
 @param textView 对象文本框
 */

+ (void)zx_insertEmojiToString:(ZXEmojiAttachment *)emojiAttachment textView:(UITextView *)textView{
    
    
    ZXEmojiAttachment *tempEmojiAttachment = [[ZXEmojiAttachment alloc] init];
    tempEmojiAttachment.imageName = emojiAttachment.imageName;
    tempEmojiAttachment.tagName = emojiAttachment.tagName;
    //设置表情大小
    tempEmojiAttachment.bounds = EmojiAttachmentBounds;
    //记录光标位置
    NSInteger location = textView.selectedRange.location;
    //插入表情
    [textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:tempEmojiAttachment] atIndex:textView.selectedRange.location];
    //将光标位置向前移动一个单位
    textView.selectedRange = NSMakeRange(location + 1, 0);
    
}


/**
 表情纯文本 转换 富文本
 @param string  @"[emji-001]"
 @return 带表情的NSAttributedString
 */
+ (NSAttributedString *)zx_emojiWithServerString:(NSString *)string{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    
    //更据正则
    NSRegularExpression *regExpress = nil;
    if(regExpress == nil){
        regExpress = [[NSRegularExpression alloc]initWithPattern:Regular options:0 error:nil];
    }
    
    //将匹配到的字符存入数组
    NSArray *matches = [regExpress matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //收集emoji数据
    NSMutableArray *emojiAttachmentArr = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in matches) {
        
        NSString *subString = [string substringWithRange:result.range];
        
        //去中括号
        NSString *emojiImageStr =  [subString stringByReplacingOccurrencesOfString:@"[" withString:@""];
        emojiImageStr = [emojiImageStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
        
        //建立emoji模型
        ZXEmojiAttachment *emojiAttachment = [[ZXEmojiAttachment alloc]init];
        emojiAttachment.imageName = emojiImageStr;
        emojiAttachment.tagName = subString;
        emojiAttachment.range = result.range;
        emojiAttachment.bounds = EmojiAttachmentBounds;
        [emojiAttachmentArr addObject:emojiAttachment];
    }
    
    emojiAttachmentArr = [NSMutableArray arrayWithArray:[[emojiAttachmentArr reverseObjectEnumerator] allObjects]];
    
    //替换文本
    for (ZXEmojiAttachment *emojiAttachment in emojiAttachmentArr) {
        
        NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:emojiAttachment];
        [attributedString replaceCharactersInRange:emojiAttachment.range withAttributedString:emojiAttributedString];
    }
    
  
    
    return attributedString;
}



/**
 富文本 转换 表情纯文本
 @param attributedStr  @"🤔😴"
 @return 纯文本NSString
 */
+ (NSString *)zx_stringWithEmojiString:(NSAttributedString *)attributedStr {
    
    NSMutableAttributedString *tempAttributeString = [[NSMutableAttributedString alloc]initWithAttributedString:attributedStr];
    
    __block NSUInteger index = 0;
    
    [attributedStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedStr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
       
        //从富文本中遍历出 ZXEmojiAttachment 对象
        if (value && [value isKindOfClass:[ZXEmojiAttachment class]]) {
            
            ZXEmojiAttachment *emojiAttachment = value;
            //替换对象为 [emoji-001]
            [tempAttributeString replaceCharactersInRange:NSMakeRange(range.location + index, range.length) withString:emojiAttachment.tagName];
            //替换后对位置作一下调整
            index += emojiAttachment.tagName.length -1;
        }
        
    }];
    
    return tempAttributeString.string;
}




@end
