//
//  MyDrawGrid.m
//  DrawGrid
//
//  Created by 莫锹文 on 16/3/28.
//  Copyright © 2016年 莫锹文. All rights reserved.
//

#import "QWGraphView.h"

@interface QWGraphView ()

//@property (nonatomic, strong) NSMutableArray *originPoints;

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *graphLayer;
@property (nonatomic, strong) CAShapeLayer *pointLayer;

@end

@implementation QWGraphView

- (instancetype)initWithFrame:(CGRect)frame
{
	if ([super initWithFrame:frame])
	{
		self.valueX = [NSArray array];
		self.valueY = [NSArray array];
		self.showPoints = YES;
		self.showSmooth = YES;

		//线段图层
		self.lineLayer = [[CAShapeLayer alloc] init];
		self.lineLayer.fillColor = [UIColor clearColor].CGColor;
		self.lineLayer.strokeColor = [UIColor blueColor].CGColor;
		self.lineLayer.lineJoin = kCALineJoinRound;
		self.lineLayer.lineWidth = 2;
		[self.layer addSublayer:self.lineLayer];

		//渐变颜色图层
		self.gradientLayer = [CAGradientLayer layer];
		self.gradientLayer.frame = self.bounds;
		[self.layer addSublayer:self.gradientLayer];

		//遮罩图层
		self.graphLayer = [[CAShapeLayer alloc] init];
		[self.layer addSublayer:self.graphLayer];

		//关键点图层
		self.pointLayer = [[CAShapeLayer alloc] init];
		self.pointLayer.fillColor = [UIColor redColor].CGColor;
		self.pointLayer.strokeColor = [UIColor redColor].CGColor;
		[self.layer addSublayer:self.pointLayer];

		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)setToPoints
{
	_originPoints = [NSMutableArray array];

	for (int i = 0; i < self.valueX.count; i++)
	{
		CGPoint p;

		switch (self.direction)
		{
			case GraphDirectionVertical:
				p = CGPointMake([self.valueX[i] floatValue], self.frame.size.height - [self.valueY[i] floatValue]);
				break;

			case GraphDirectionHorizontal:
				p = CGPointMake([self.valueY[i] floatValue], [self.valueX[i] floatValue]);
				break;

			default:

				break;
		}

		[self.originPoints addObject:[NSValue valueWithCGPoint:p]];
	}
}

- (void)drawRect:(CGRect)rect
{
	NSLog(@"draw rect");
	[super drawRect:rect];

	if (self.originPoints.count == 0)
	{
		return;
	}

	UIBezierPath *path;

	if (self.showSmooth)
	{
		path = [self smoothedPathWithGranularity:20];
	}
	else
	{
		path = [[UIBezierPath alloc] init];
		[path moveToPoint:[[self.originPoints firstObject] CGPointValue]];

		for (int i = 1; i < self.originPoints.count; i++)
		{
			[path addLineToPoint:[self.originPoints[i] CGPointValue]];
		}
	}

	self.lineLayer.path = path.CGPath;

	if (self.fillColors.count)
	{
		UIBezierPath *fillPath = [path copy];

		CGPoint startPoint = [[self.originPoints firstObject] CGPointValue];
		CGPoint endPoint = [[self.originPoints lastObject] CGPointValue];

		switch (self.direction)
		{
			case GraphDirectionVertical:
			{
				[fillPath addLineToPoint:CGPointMake(endPoint.x, self.frame.size.height)];
				[fillPath addLineToPoint:CGPointMake(startPoint.x, self.frame.size.height)];
			}

			break;

			case GraphDirectionHorizontal:
			{
				[fillPath addLineToPoint:CGPointMake(0, endPoint.y)];
				[fillPath addLineToPoint:CGPointMake(0, 0)];
			}

			default:
				break;
		}
		[fillPath closePath];

		self.graphLayer.path = fillPath.CGPath;
		self.gradientLayer.mask = self.graphLayer;
	}

	if (self.showPoints)
	{
		UIBezierPath *pointPath = [[UIBezierPath alloc] init];

		for (int i = 0; i < self.originPoints.count; i++)
		{
			CGPoint point = [self.originPoints[i] CGPointValue];
			[pointPath moveToPoint:point];
			[pointPath addArcWithCenter:point radius:3 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
		}

		self.pointLayer.path = pointPath.CGPath;
	}
}

- (UIBezierPath *)smoothedPathWithGranularity:(NSInteger)granularity
{
	NSMutableArray *points = [self.originPoints mutableCopy];

	[points insertObject:[points objectAtIndex:0] atIndex:0];
	[points addObject:[points lastObject]];

	UIBezierPath *smoothedPath = [[UIBezierPath alloc] init];

	[smoothedPath moveToPoint:[[points objectAtIndex:0] CGPointValue]];

	for (NSUInteger index = 1; index < points.count - 2; index++)
	{
		CGPoint p0 = [[points objectAtIndex:(index - 1)] CGPointValue];
		CGPoint p1 = [[points objectAtIndex:index] CGPointValue];
		CGPoint p2 = [[points objectAtIndex:index + 1] CGPointValue];
		CGPoint p3 = [[points objectAtIndex:index + 2] CGPointValue];

		for (int i = 1; i < granularity; i++)
		{
			float t = (float)i * (1.0f / (float)granularity);
			float tt = t * t;
			float ttt = tt * t;

			CGPoint pi;
			pi.x = 0.5 * (2 * p1.x + (p2.x - p0.x) * t + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * tt + (3 * p1.x - p0.x - 3 * p2.x + p3.x) * ttt);
			pi.y = 0.5 * (2 * p1.y + (p2.y - p0.y) * t + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * tt + (3 * p1.y - p0.y - 3 * p2.y + p3.y) * ttt);
			[smoothedPath addLineToPoint:pi];
		}

		[smoothedPath addLineToPoint:p2];
	}

	[smoothedPath addLineToPoint:[[points objectAtIndex:points.count - 1] CGPointValue]];

	return smoothedPath;
}

#pragma mark - Setter
- (void)setFillColors:(NSArray *)fillColors
{
	if (fillColors.count)
	{
		NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:fillColors.count];

		for (UIColor *color in fillColors)
		{
			if ([color isKindOfClass:[UIColor class]])
			{
				[colors addObject:(id)[color CGColor]];
			}
			else
			{
				[colors addObject:(id)color];
			}
		}

		_fillColors = colors;

		self.gradientLayer.colors = _fillColors;
	}
	else
	{
		_fillColors = fillColors;
	}

	[self setNeedsDisplay];
}

- (void)setValueX:(NSMutableArray *)valueX
{
	_valueX = valueX;

	if (_valueX != nil && _valueX.count != 0 && _valueX.count == _valueY.count)
	{
		[self setToPoints];
	}
}

- (void)setValueY:(NSArray *)valueY
{
	_valueY = valueY;

	if (_valueY != nil && _valueY.count != 0 && _valueX.count == _valueY.count)
	{
		[self setToPoints];
	}
}

- (void)setShowSmooth:(BOOL)showSmooth
{
	_showSmooth = showSmooth;

	[self setNeedsDisplay];
}

- (void)setShowPoints:(BOOL)showPoints
{
	_showPoints = showPoints;

	[self setNeedsDisplay];
}

- (void)setGradientStartPoint:(CGPoint)gradientStartPoint
{
	_gradientStartPoint = gradientStartPoint;

	self.gradientLayer.startPoint = gradientStartPoint;

	[self setNeedsDisplay];
}

- (void)setGradientEndPoint:(CGPoint)gradientEndPoint
{
	_gradientEndPoint = gradientEndPoint;

	self.gradientLayer.endPoint = gradientEndPoint;

	[self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
	_lineColor = lineColor;

	self.lineLayer.strokeColor = lineColor.CGColor;

	[self setNeedsDisplay];
}

- (void)setPointColor:(UIColor *)pointColor
{
	_pointColor = pointColor;

	self.pointLayer.fillColor = pointColor.CGColor;

	[self setNeedsDisplay];
}

@end
