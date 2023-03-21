//
//  ZXMineFooterCollectionReusableView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/10.
//

#import "ZXMineFooterCollectionReusableView.h"

@interface ZXMineFooterCollectionReusableView ()

@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UIImageView  *imageView;


@end


@implementation ZXMineFooterCollectionReusableView


+ (NSString *)wg_cellIdentifier{
    return @"ZXMineFooterCollectionReusableView";
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
     
        self.backgroundColor = [UIColor clearColor];
        
        
        //
        UIImageView *logo = [UIImageView wg_imageViewWithImageNamed:@"MeNotNotes"];
        [self addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(30);
            make.centerX.mas_equalTo(self);
            make.width.height.offset(95);
        }];
        self.imageView = logo;

        
        UILabel *label = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(204) TextStr:@"还没有发布过笔记" NumberOfLines:1];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logo.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self);
            make.height.offset(20);
            make.width.offset(200);
        }];
        self.label = label;
    }
    
    return self;
}



- (void)zx_isHidden:(BOOL)hidden{
    self.label.hidden = hidden;
    self.imageView.hidden = hidden;
}

@end
