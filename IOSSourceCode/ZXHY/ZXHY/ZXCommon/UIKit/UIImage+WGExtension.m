//
//  UIImage+Scacle.m
//  amys
//
//  Created by 杨智晓 on 15/8/22.
//  Copyright (c) 2015年 swin. All rights reserved.
//

#import "UIImage+WGExtension.h"

@implementation UIImage (WGExtension)

#pragma mark - Public Methods

+ (UIImage *)wg_imageNamed:(NSString *)imageNamed {
    return [UIImage imageNamed:imageNamed];
}

- (UIImage *)wg_scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (void)wg_saveImage:(UIImage *)tempImage withName:(NSString *)imageName inDocument:(NSString *)documentName {
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    BOOL isDir = YES;
    NSString *path = [documentsDirectory stringByAppendingPathComponent:documentName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:&isDir]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // Now we get the full path to the file
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (UIImage *)wg_getImageWithName:(NSString *)imageName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPathToFile];
    return image;
}

+ (UIImage *)wg_createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius {
    int w = size.width;
    int h = size.height;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(contextRef);
    addRoundedRectToPath(contextRef, rect, radius, radius);
    CGContextClosePath(contextRef);
    CGContextClip(contextRef);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, w, h), image.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(contextRef);
    UIImage *img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(imageMasked);
    return img;
}

#pragma mark - Private Methods
static void addRoundedRectToPath(CGContextRef contextRef, CGRect rect, float widthOfRadius, float heightOfRadius) {
    float fw, fh;
    if (widthOfRadius == 0 || heightOfRadius == 0)
    {
        CGContextAddRect(contextRef, rect);
        return;
    }
    
    CGContextSaveGState(contextRef);
    CGContextTranslateCTM(contextRef, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(contextRef, widthOfRadius, heightOfRadius);
    fw = CGRectGetWidth(rect) / widthOfRadius;
    fh = CGRectGetHeight(rect) / heightOfRadius;
    
    CGContextMoveToPoint(contextRef, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(contextRef, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(contextRef, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(contextRef, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(contextRef, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(contextRef);
    CGContextRestoreGState(contextRef);
}

//获取一张指定颜色和大小的图片
+ (UIImage *)wg_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//获取一张指定颜色和大小的图片
+ (UIImage *)wg_imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    }
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)wg_imageWithAlpha:(CGFloat)alpha
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    //draw with alpha
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

+ (UIImage *)wg_imageRepresentationWithWebView:(WKWebView *)webView {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize boundsSize = webView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize contentSize = webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    
    CGPoint offset = webView.scrollView.contentOffset;
    
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = webView.scrollView.contentOffset.y;
        [webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    
    [webView.scrollView setContentOffset:offset];
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}

- (UIImage *)wg_fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)wg_image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    CGRect bnds = CGRectZero;
    UIImage* newPic = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = image.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    bnds = rect;
    switch (orientation)
    {
        case UIImageOrientationUp:
            return image;
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;

        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI_2);
            break;
            
        default:
            return image;
    }    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    switch (orientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

/** 交换宽和高 */
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat swap = rect.size.width;
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    return rect;
}

+ (NSData *)wg_scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    if (!image || kb < 1) {
        Byte byte[] ={0,1,};
        return [NSData dataWithBytes:byte length:0];
    }
    kb *= 1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *compressedImageData = UIImageJPEGRepresentation(image, compression);
    while ([compressedImageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        compressedImageData = UIImageJPEGRepresentation(image, compression);
    }
//    WGLog(@"当前大小:%fkb",(float)[compressedImageData length]/1024.0f);
    return compressedImageData;
}

+ (UIImage *)wg_compressedImage:(UIImage *)image toKb:(NSInteger)kb{
    if (!image || kb < 1) {
        return image;
    }
    NSData * imageData = [self wg_scaleImage:image toKb:kb];
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

- (UIImage *)wg_imageWithOrientation:(UIImageOrientation)orientation {
    return [UIImage wg_image:self rotation:orientation];
}

- (NSData *)wg_imageDataToKb:(NSInteger)kb {
    
    return [UIImage wg_scaleImage:self toKb:kb];
}
- (UIImage *)wg_imageToKb:(NSInteger)kb {
    return [UIImage wg_compressedImage:self toKb:kb];
}

- (UIImage *)wg_imageInRect:(CGRect)rect {
    
    ///调整Image的方向
    UIImage *fixedImage = [self wg_fixOrientation];
    CGImageRef imageRef = CGImageCreateWithImageInRect([fixedImage CGImage], rect);
//    WGLog(@"%zd", fixedImage.imageOrientation);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    ///旋转图片
    UIImage* subImage = [UIImage wg_image:image rotation:UIImageOrientationLeft];
//    UIImage * subImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationLeft];
    CGImageRelease(imageRef);
    return subImage;
}

// 查找导航栏下的横线
+ (nullable UIImageView *)wg_seekLineImageViewOn:(nullable UIView *)view{
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) return (UIImageView *)view;
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self wg_seekLineImageViewOn:subview];
        if (imageView) return imageView;
    }
    return nil;
}

@end
