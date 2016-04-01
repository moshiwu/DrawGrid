//
//  TestDraw.m
//  DrawGrid
//
//  Created by xiuyu on 16/3/29.
//  Copyright © 2016年 xiuyu. All rights reserved.
//

#import "TestDraw.h"

@implementation TestDraw

-(instancetype)initWithFrame:(CGRect)frame{

    
    self = [super initWithFrame:frame];
    
    if (self) {
      
    }

    return self;
}


-(void)drawRect:(CGRect)rect{

    
//    [super drawRect:rect];
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    
    
    
    UIBezierPath *path=[[UIBezierPath alloc]init];
    path.lineWidth=1;
    path.lineCapStyle=kCGLineCapRound;
    path.lineJoinStyle=kCGLineCapRound;
    
    [path moveToPoint:CGPointMake(100.0, 0)];
    
    [path addLineToPoint:CGPointMake(200.0, 40.0)];
    [path addLineToPoint:CGPointMake(160, 140)];
    [path addLineToPoint:CGPointMake(40.0, 140)];
    [path addLineToPoint:CGPointMake(0.0, 40.0)];
    [path closePath];//第五条线通过调用closePath方法得到的
    
    [path fill];
    [path stroke];//Draws line 根据坐标点连线
    
}

@end
