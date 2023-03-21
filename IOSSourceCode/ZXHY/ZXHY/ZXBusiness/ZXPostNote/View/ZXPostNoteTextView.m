//
//  ZXPostNoteTextView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/27.
//

#import "ZXPostNoteTextView.h"


@interface ZXPostNoteTextView()
<UITextViewDelegate>

@property (nonatomic, strong) UILabel  *textViewPlaceholderLabel;

@end

@implementation ZXPostNoteTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *textViewPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.mj_w - 20, 25)];
    textViewPlaceholderLabel.font = kFontMedium(16);
    textViewPlaceholderLabel.text = @" 输入正文";
    textViewPlaceholderLabel.textColor = WGGrayColor(153);
    [self addSubview: textViewPlaceholderLabel];
    self.textViewPlaceholderLabel = textViewPlaceholderLabel;
    
    self.delegate = self;
    self.textColor = WGGrayColor(51);
    self.font = kFont(16);
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    

    if (![text isEqualToString:@""])
    {
        self.textViewPlaceholderLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        self.textViewPlaceholderLabel.hidden = NO;
    }
   
    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.text.length == 0){
        self.textViewPlaceholderLabel.hidden = NO;
    }else{
        self.textViewPlaceholderLabel.hidden = YES;
    }
   
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    if (text.length == 0){
        self.textViewPlaceholderLabel.hidden = NO;
    }else{
        self.textViewPlaceholderLabel.hidden = YES;
    }
}



@end
