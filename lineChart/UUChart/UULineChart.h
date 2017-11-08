//
//  UULineChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUChartConst.h"

@interface UULineChart : UIView

@property (strong, nonatomic) NSArray * xLabels;
@property (strong, nonatomic) NSArray * yLabels;
@property (strong, nonatomic) NSArray * yValues;
@property (strong, nonatomic) NSArray * colors;

@property (strong, nonatomic) NSMutableArray *showHorizonLine;
@property (strong, nonatomic) NSMutableArray *showMaxMinArray;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (strong, nonatomic) UIColor * Linecolors;
// 动起来
@property (strong, nonatomic) UILabel * NumLab;
@property (strong, nonatomic) UILabel * NumLab1;
@property (strong, nonatomic) UILabel * NumLab2;
@property (nonatomic ,strong) NSMutableArray *pointArr;
@property (nonatomic ,strong) NSMutableArray *pointArr1;
@property (nonatomic ,strong) NSMutableArray *pointArr2;

@property (nonatomic ,assign)CGFloat kk;

-(void)strokeChart;

- (NSArray *)chartLabelsForX;

@end
