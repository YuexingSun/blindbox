//
//  ZXHomeImageBannerPageControl.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import "ZXHomeImageBannerPageControl.h"

@implementation ZXHomeImageBannerPageControl

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)setNumberOfPages:(NSInteger)numberOfPages{

    [super setNumberOfPages:numberOfPages];

    for (int i = 0; i < [self.subviews count]; i++) {
      UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:i] currPage:i];
       
        if (i == self.currentPage){
            dot.backgroundColor = self.currentPageIndicatorTintColor;
            dot.image = self.currentImage;
            dot.size = self.currentImageSize;
        }else{
            dot.backgroundColor = self.pageIndicatorTintColor;
            dot.image = self.inactiveImage;
            dot.size = self.inactiveImageSize;
        }
    }

}

- (void)setCurrentPage:(NSInteger)page {
      [super setCurrentPage:page];
    
     for (int i = 0; i < [self.subviews count]; i++) {
       UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:i] currPage:i];
        
         if (i == self.currentPage){
             dot.backgroundColor = self.currentPageIndicatorTintColor;
             dot.image = self.currentImage;
             dot.size = self.currentImageSize;
         }else{
             dot.backgroundColor = self.pageIndicatorTintColor;
             dot.image = self.inactiveImage;
             dot.size = self.inactiveImageSize;
         }
     }
}


- (UIImageView *)imageViewForSubview:(UIView *)view currPage:(int)currPage{    UIImageView *dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
     
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
        }else {
            dot = (UIImageView *)view;
        }
    return dot;
}


@end
