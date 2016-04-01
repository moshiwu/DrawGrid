//
//  ViewController.m
//  DrawGrid
//
//  Created by xiuyu on 16/3/28.
//  Copyright © 2016年 xiuyu. All rights reserved.
//

#import "ViewController.h"
#import "QWGraphView.h"

#import "TestDraw.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

//    TestDraw *test=[[TestDraw alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:test];

	QWGraphView *grid = [[QWGraphView alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 300)];
    grid.backgroundColor = [UIColor colorWithRed:0.826 green:0.596 blue:1.000 alpha:1.000];
	grid.direction = GraphDirectionVertical;
	[self.view addSubview:grid];

	grid.valueX = @[@0, @10, @20, @30, @40, @50];
	grid.valueY = @[@0, @50, @20, @90, @140, @0];
    grid.showSmooth = true;
    grid.fillColors = @[[UIColor cyanColor], [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.8], [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.6], [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.3], [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.05]];
    
//	grid.backgroundColor = [UIColor greenColor];
    
    CGPoint p = [grid.originPoints[0] CGPointValue];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
