//
//  KMoJiLineCell.m
//  KMoJiLineChart
//
//  Created by tenghu on 2017/11/8.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "KMoJiLineCell.h"
#import "UUChart.h"
#import "UIColor+Extension.h"

@interface KMoJiLineCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
}
@end

@implementation KMoJiLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configUI:(NSIndexPath *)indexPath
{
    
    self.backgroundColor = [UIColor clearColor];
    
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initWithFrame:CGRectMake(0, 0, 22*25, 150)  dataSource:self ];
    [chartView showInView:self.contentView];
}

-(void)setKk:(CGFloat)kk{
    
    _kk = kk;
    chartView.kk = kk;
    
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    return [self getXTitles:22];
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    NSArray *ary = @[@"1",@"49",@"1",@"-15",@"30",@"42",@"32",@"40",@"42",@"25",@"33",@"1",@"49",@"1",@"15",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
    NSArray *ary1 = @[@"23",@"40",@"1",@"49",@"37",@"45",@"27",@"36",@"16",@"39",@"12",@"25",@"6",@"40",@"49",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
    NSArray *ary4 = @[@"15",@"1",@"49",@"1",@"49",@"20",@"38",@"38",@"45",@"28",@"36",@"26",@"9",@"49",@"34",@"28",@"42",@"32",@"40",@"42",@"25",@"33"];
    
    
    switch (path.row) {
        case 0:
            return @[ary,ary4,ary1];
        case 1:
            return @[ary4];
        default:
            return @[ary1];
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    UIColor *color1 = [UIColor colorWithHexString:@"b4cd5f"];
    UIColor *color2 = [UIColor colorWithHexString:@"d26060"];
    UIColor *color3 = [UIColor colorWithHexString:@"55abb2"];
    if (path.row == 0) {
        return @[color1,color2,color3];
    }else{
        return @[color1];
    }
    
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    if (path.row==0 ) {
        return CGRangeMake(49, -15);
    }
    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
//- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
//{
//    if (path.row == 0) {
//        return CGRangeMake(0, 100);
//    }
//    return CGRangeZero;
//}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return NO;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
