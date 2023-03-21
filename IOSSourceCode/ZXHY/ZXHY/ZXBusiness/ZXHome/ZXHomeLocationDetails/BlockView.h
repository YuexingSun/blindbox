//
//  BlockView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^TestBlock) (void);


@interface BlockView : NSObject

//Block
@property (nonatomic, strong) TestBlock  timeBlock;



@end

NS_ASSUME_NONNULL_END
