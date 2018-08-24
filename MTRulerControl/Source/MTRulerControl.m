//
//  MTRulerControl.m
//  MTRulerControl
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MTRulerControl.h"

@interface MTRulerControl() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; // 主要的滚动试图 展示刻度
@property (nonatomic, strong) UIView *indicator; // 指示器 紫色的那个
@property (nonatomic, strong) UILabel *indicatorLabel;

@property (nonatomic, copy) NSString *min;
@property (nonatomic, copy) NSString *max;

@property (nonatomic, assign) CGFloat minNumber; // 最小值
@property (nonatomic, assign) CGFloat maxNumber; // 最大值
@property (nonatomic, assign) CGFloat eachNumber;


@end

@implementation MTRulerControl


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame min:(NSString *)minNumber max:(NSString *)maxNumber {
    self.min = minNumber;
    self.max = maxNumber;
    
    [self referNumber];
    
    return [self initWithFrame:frame];
}

- (void)configUI {
    // 滚动试图
    [self addSubview:self.scrollView];
    // 指示器
    [self addSubview:self.indicator];
    
    
    [self drawRuler];
}

#pragma mark - lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, 100 * 10 + 100);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)indicator {
    if (!_indicator) {
        _indicator = [[UIView alloc] initWithFrame:(CGRect){0, (self.bounds.size.height - 30) / 2.0, 200, 30}];
        
        // 指示针
        UIView *line = [[UIView alloc] initWithFrame:(CGRect){0, (_indicator.frame.size.height - 1) / 2.0, 50, 1}];
        line.backgroundColor = [UIColor purpleColor];
        [_indicator addSubview:line];
        
        // 指示值
        [_indicator addSubview:self.indicatorLabel];
        _indicatorLabel.frame = CGRectMake(50, (_indicator.frame.size.height - 26) / 2.0, 70, 26);
    }
    return _indicator;
}

- (UILabel *)indicatorLabel {
    if (!_indicatorLabel) {
        _indicatorLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, 50, 26}];
        _indicatorLabel.text = @"1/500";
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.textColor = [UIColor whiteColor];
        _indicatorLabel.backgroundColor = [UIColor purpleColor];
        _indicatorLabel.layer.cornerRadius = 13;
        _indicatorLabel.layer.masksToBounds = YES;
        _indicatorLabel.font = [UIFont systemFontOfSize:14];
    }
    return _indicatorLabel;
}


#pragma mark - 绘制标尺

- (void)drawRuler {
    /// 这里的数值应该是外面配置的，为了开发阶段方便暂时写在这里
    CGFloat longHeight = 2; // 长刻度的高度
    CGFloat shortHeight = 1; // 短刻度的高度
    CGFloat topPadding = 10; // 头尾个间距 10
    CGFloat eachLength = 100; // 每两个长刻度的间距
    
    for (NSInteger i = 0; i < 10; i++) {
        // 绘制长刻度
        CAShapeLayer *longLayer = [self drawLayer:CGRectMake(0, topPadding + i * eachLength, 25, longHeight)];
        [self.scrollView.layer addSublayer:longLayer];
        
        // 绘制刻度值
        CATextLayer *textLayer = [self drawTextLayer:CGRectMake(35, topPadding + i * eachLength - 5.5, 100, 14)];
        if (i == 0) {
            textLayer.string = self.min;
        } else if (i == 9) {
            textLayer.string = self.max;
        }
        else {
            CGFloat number = self.minNumber + self.eachNumber * i;
            textLayer.string = [self mapFloatToString:number];
        }
        [self.scrollView.layer addSublayer:textLayer];

        if (i != (10 - 1)) {
            // 绘制短刻度
            for (NSInteger j = 1; j < 10; j++) {
                CAShapeLayer *layer = [self drawLayer:CGRectMake(0, topPadding + i * eachLength + eachLength / 10.0 * j, 15, shortHeight)];
                [self.scrollView.layer addSublayer:layer];
            }
        }
    }
    
    
    // 当前指针的值, 没个间隔10
    NSInteger index = (self.bounds.size.height / 2.0 - 10) / 10;
    NSLog(@"%ld", index);
    CGFloat number = self.minNumber + self.eachNumber / 10.0 * index;
    self.indicatorLabel.text = [self mapFloatToString:number];
}

- (CATextLayer *)drawTextLayer:(CGRect)rect {
    CATextLayer *layerText = [[CATextLayer alloc] init];
    layerText.contentsScale = [UIScreen mainScreen].scale;
    layerText.foregroundColor = [UIColor purpleColor].CGColor;
    layerText.frame = rect;
    
    //set layer font
    UIFont *font = [UIFont systemFontOfSize:14];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    layerText.font = fontRef;
    layerText.fontSize = font.pointSize;
    CGFontRelease(fontRef);

    return layerText;
}

- (CAShapeLayer *)drawLayer:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor redColor].CGColor;
    layer.path = path.CGPath;
    return layer;
}


#pragma mark - 解析数据 1/24000 与 小数之间的关系


/**
 解析最大最小值
 算出 每两个大的区间 间隔eachNumber
 */
- (void)referNumber {
    CGFloat minNumber = self.min.floatValue;
    CGFloat maxNumber = self.max.floatValue;

    if ([self.min containsString:@"/"]) {
        CGFloat molecule = [self.min componentsSeparatedByString:@"/"].firstObject.floatValue; // 分子
        CGFloat denominator = [self.min componentsSeparatedByString:@"/"].lastObject.floatValue; // 分母
        minNumber = molecule / denominator;
    }
    if ([self.max containsString:@"/"]) {
        CGFloat molecule = [self.max componentsSeparatedByString:@"/"].firstObject.floatValue; // 分子
        CGFloat denominator = [self.max componentsSeparatedByString:@"/"].lastObject.floatValue; // 分母
        maxNumber = molecule / denominator;
    }
    
    self.minNumber = minNumber;
    self.maxNumber = maxNumber;
    self.eachNumber = (maxNumber - minNumber ) / 10;
}


/**
 将0.333 转成 1/3
 */
- (NSString *)mapFloatToString:(CGFloat)number {
    NSString *string = [NSString stringWithFormat:@"%f", number];
    if ([[string componentsSeparatedByString:@"."].firstObject isEqualToString:@"0"]) {
        NSString *second = [string componentsSeparatedByString:@"."].lastObject;
        CGFloat denominator = pow(10, second.length); // 10 的 n 次方
        CGFloat molecule = number * denominator;
        NSInteger temp = ceil(denominator / molecule); // 向上取整
        return [NSString stringWithFormat:@"1/%ld", temp];
    }
    return [string componentsSeparatedByString:@"."].firstObject;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 当前指针的值, 没个间隔10
    NSInteger index = (self.bounds.size.height / 2.0 - 10 + scrollView.contentOffset.y) / 10;
    NSLog(@"%ld", index);
    CGFloat number = self.minNumber + self.eachNumber / 10.0 * index;
    self.indicatorLabel.text = [self mapFloatToString:number];
    
}

@end
