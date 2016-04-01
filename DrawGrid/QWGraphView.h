//
//  QWGraphView.h
//  DrawGrid
//
//  Created by 莫锹文 on 16/3/28.
//  Copyright © 2016年 莫锹文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
	CGFloat min;
	CGFloat max;
} QWRange;

NS_INLINE QWRange QWMakeRange(CGFloat min,CGFloat max) {
    QWRange r;
    r.min = min;
    r.max = max;
    return r;
}

typedef enum : NSUInteger
{
	GraphDirectionHorizontal, //从左到右，起始点在左下
	GraphDirectionVertical,   //从上到下，起始点在左上
} GraphDirection;

@interface QWGraphView : UIView

#pragma mark - 坐标点定义

/**
 *  X坐标值（水平方向下）
 */
@property (nonatomic, strong) NSArray *valueX;

/**
 *  X坐标值范围（水平方向下）
 */
@property (nonatomic, assign) QWRange valueRangeX;

/**
 *  Y坐标值（水平方向下）
 */
@property (nonatomic, strong) NSArray *valueY;

/**
 *  Y坐标值范围（水平方向下）
 */
@property (nonatomic, assign) QWRange valueRangeY;

/**
 *  坐标点的实际坐标，提供给外部调用
 */
@property (nonatomic, strong, readonly) NSMutableArray *originPoints;

/**
 *  表格的方向
 */
@property (nonatomic, assign) GraphDirection direction;

#pragma mark - 渐变颜色

/**
 *  填充颜色，多个颜色则为渐变
 */
@property (nonatomic, strong) NSArray *fillColors;

/**
 *  渐变颜色起始范围,(0,0)~(1,1)
 */
@property (nonatomic, assign) CGPoint gradientStartPoint;

/**
 *  渐变颜色结束范围,(0,0)~(1,1)
 */
@property (nonatomic, assign) CGPoint gradientEndPoint;

#pragma mark - 线条

/**
 *  是否圆滑显示线段
 */
@property (nonatomic, assign) BOOL showSmooth;

/**
 *  线段颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  线段宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;

#pragma mark - 关键点

/**
 *  是否显示关键点
 */
@property (nonatomic, assign) BOOL showPoints;

/**
 *  关键点颜色
 */
@property (nonatomic, strong) UIColor *pointColor;

/**
 *  关键点半径
 */
@property (nonatomic, assign) CGFloat pointRadius;

@end
