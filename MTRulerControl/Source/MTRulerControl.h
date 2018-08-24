//
//  MTRulerControl.h
//  MTRulerControl
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTRulerControl : UIControl


/**
 构造

 @param frame 试图大小
 @param numberArray 分段数据
 @return MTRulerControl
 */
- (instancetype)initWithFrame:(CGRect)frame numerArray:(NSArray *)numberArray;


/**
 构造函数

 @param frame 位置大小
 @param minNumber 最小值 如1/24000
 @param maxNumber 最大值 如100
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
                          min:(NSString *)minNumber
                          max:(NSString *)maxNumber;


@end
