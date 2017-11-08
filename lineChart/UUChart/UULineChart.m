//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUChartLabel.h"
#import "UIBezierPath+Points.h"

@implementation UULineChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

- (void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    max = max<5 ? 5:max;
    _yValueMin = 0;
    _yValueMax = (int)max;
    
    if (_chooseRange.max != _chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

}

- (void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }

    
    _xLabels = xLabels;
    
    
    CGFloat num = 0;
  if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {

        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height-5 , _xLabelWidth, 0.1)];
        [_chartLabelsForX addObject:label];
    }
    
}

- (void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setshowHorizonLine:(NSMutableArray *)showHorizonLine
{
    _showHorizonLine = showHorizonLine;
}
-(void)setLinecolors:(UIColor *)Linecolors{
    _Linecolors = Linecolors;
}

- (void)strokeChart
{
    
    _pointArr = [[NSMutableArray alloc] init];
    _pointArr1 = [[NSMutableArray alloc] init];
    _pointArr2 = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSMutableArray *max_i = [[NSMutableArray alloc] init];
        NSMutableArray *min_i = [[NSMutableArray alloc] init];
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
            }
            if (min>=num){
                min = num;
            }
        }
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max == num){
                [max_i addObject:[NSString stringWithFormat:@"%d",j]];
            }
            if (min == num){
                [min_i addObject:[NSString stringWithFormat:@"%d",j]];
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 1.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*2;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
       
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.showMaxMinArray) {
            if ([self.showMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = ([max_i containsObject:@"0"] )?NO:YES;  //显示最大最小
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        
        //在第一个点上添加移动的lable 
        [self addFirstNumLab:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight*2-5) index:i value:firstValue];
        
        
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight*2-5)
                 index:i  isShow:isShowMaxAndMinPoint value:firstValue];
        
//        CGPoint PrePonit;
//        PrePonit = CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight*2-5);
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight*2-5)];
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight*2-5);
//                [progressline addCurveToPoint:point controlPoint1:CGPointMake((PrePonit.x+point.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+point.x)/2, point.y)]; //三次曲线
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.showMaxMinArray) {
                    if ([self.showMaxMinArray[i] intValue]>0) {
                        NSString *str = [NSString stringWithFormat:@"%ld",(long)index];
                        isShowMaxAndMinPoint = ([max_i containsObject:str] )?NO:YES; //显示最大最小
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
//                PrePonit = point;
                [progressline moveToPoint:point];
                [self addPoint:point index:i   isShow:isShowMaxAndMinPoint  value:[valueString floatValue]];
            }
            index += 1;
        }
       
        _chartLine.path = progressline.CGPath;
        
        
        if (i == 0) {
             NSArray *ar = [progressline points];
          //字典去重，nsset去重，，数组去重
            for (unsigned i = 0; i < [ar count]; i++){
                if ([_pointArr containsObject:[ar objectAtIndex:i]] == NO){
                    [_pointArr addObject:[ar objectAtIndex:i]];
                }
                
            }
            
        }else if (i == 1){
            NSArray *ar = [progressline points];
            //字典去重，nsset去重，，数组去重
            for (unsigned i = 0; i < [ar count]; i++){
                if ([_pointArr1 containsObject:[ar objectAtIndex:i]] == NO){
                    [_pointArr1 addObject:[ar objectAtIndex:i]];
                }
                
            }

        }else{
            NSArray *ar = [progressline points];
            //字典去重，nsset去重，，数组去重
            for (unsigned i = 0; i < [ar count]; i++){
                if ([_pointArr2 containsObject:[ar objectAtIndex:i]] == NO){
                    [_pointArr2 addObject:[ar objectAtIndex:i]];
                }
                
            }

            
        }
        
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = _Linecolors.CGColor;
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.01;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(6, 6, 6, 6)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:[UUColor green].CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:[UUColor green];

        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(point.x-UULabelHeight/2.0, point.y-15, UULabelHeight, UULabelHeight);
        imageView.image = [UIImage imageNamed:@"huangguan2"];
        [self addSubview:imageView];
    }
    
    [self addSubview:view];
}

- (void)addFirstNumLab:(CGPoint)point index:(NSInteger)index value:(CGFloat)value{
    if (index == 0) {
        _NumLab = [[UILabel alloc]initWithFrame:CGRectMake(point.x-50/2.0, point.y-15, 50, UULabelHeight)];
        _NumLab.font = [UIFont systemFontOfSize:9.0];
        _NumLab.backgroundColor = [UIColor clearColor];
        _NumLab.textAlignment = NSTextAlignmentCenter;
        _NumLab.textColor = _colors[index];
        _NumLab.text = [NSString stringWithFormat:@"%d",(int)value];
//        _NumLab.backgroundColor = [UIColor redColor];
        [self addSubview:_NumLab];

    }else if (index == 1){
        _NumLab1 = [[UILabel alloc]initWithFrame:CGRectMake(point.x-50/2.0, point.y-15, 50, UULabelHeight)];
        _NumLab1.font = [UIFont systemFontOfSize:9.0];
        _NumLab1.backgroundColor = [UIColor clearColor];
        _NumLab1.textAlignment = NSTextAlignmentCenter;
        _NumLab1.textColor = _colors[index];
        _NumLab1.text = [NSString stringWithFormat:@"%d",(int)value];
        [self addSubview:_NumLab1];
    
    }else{
        _NumLab2 = [[UILabel alloc]initWithFrame:CGRectMake(point.x-50/2.0, point.y-15, 50, UULabelHeight)];
        _NumLab2.font = [UIFont systemFontOfSize:9.0];
        _NumLab2.backgroundColor = [UIColor clearColor];
        _NumLab2.textAlignment = NSTextAlignmentCenter;
        _NumLab2.textColor = _colors[index];
        _NumLab2.text = [NSString stringWithFormat:@"%d",(int)value];
        [self addSubview:_NumLab2];

    }
    
}


- (BOOL)judgeDivisibleWithFirstNumber:(CGFloat)firstNumber andSecondNumber:(CGFloat)secondNumber
{
    // 默认记录为整除
    BOOL isDivisible = YES;
    
    if (secondNumber == 0) {
        return NO;
    }
    
    CGFloat result = firstNumber / secondNumber;
    
    // NSString * resultStr = @"10062.0038";
    NSString * resultStr = [NSString stringWithFormat:@"%f", result];
    NSRange range = [resultStr rangeOfString:@"."];
    
    NSString * subStr = [resultStr substringFromIndex:range.location + 1];
    
    for (NSInteger index = 0; index < subStr.length; index ++) {
        unichar ch = [subStr characterAtIndex:index];
        
        // 后面的字符中只要有一个不为0，就可判定不能整除，跳出循环
        if ('0' != ch) {
           
            isDivisible = NO;
            break;
        }
       
    }
    return isDivisible;
}


#pragma mark - 动起来
-(void)setKk:(CGFloat)kk{
    
    _kk = kk;
    NSArray *childAry = _yValues[0];
    NSInteger xx = (childAry.count -1)  * 25.0 * kk / (childAry.count * 25.0 - [UIScreen mainScreen].bounds.size.width +50.0);
    
    NSInteger sum = 0;
    CGPoint startPoint  , endPoint;
    
    NSInteger index = 0;
    for(int i=0; i<childAry.count; i++){
        sum += 25.0;
        if(xx < sum) {
            startPoint = [_pointArr[i] CGPointValue];
            index = i;
            break;
        }
    }

    NSString *sumnum = [childAry objectAtIndex:index];
    _NumLab.text = sumnum;
    
    NSInteger yy = 0.0;
    if(index+1 >= childAry.count || startPoint.x == 0){
        endPoint = [_pointArr[childAry.count -1] CGPointValue];
        yy = endPoint.y;
    }else{
        endPoint = [_pointArr[index+1] CGPointValue];
    }
   
    yy = (int)(startPoint.y + (xx - index*25)*1.0/25.0 * (endPoint.y - startPoint.y));
    
    CGRect frame = _NumLab.frame;
    frame.origin.x = xx-50/2.0 +12.5;
    frame.origin.y = yy-13;
    _NumLab.frame = frame;

    // 第二组
    NSArray *childAry2 = _yValues[1];
    NSInteger xx2 = (childAry2.count -1)  * 25.0 * kk / (childAry2.count * 25.0 - [UIScreen mainScreen].bounds.size.width +50.0);
    
    NSInteger sum2 = 0;
    CGPoint startPoint2  , endPoint2;
    
    NSInteger index2 = 0;
    for(int i=0; i<childAry2.count; i++){
        sum2 += 25.0;
        if(xx2 < sum2) {
            startPoint2 = [_pointArr1[i] CGPointValue];
            index2 = i;
            break;
        }
    }
    
    NSString *sumnum2 = [childAry2 objectAtIndex:index2];
    _NumLab1.text = sumnum2;
    
    NSInteger yy2 = 0.0;
    if(index2+1 >= childAry2.count || startPoint2.x == 0){
        endPoint2 = [_pointArr1[childAry2.count -1] CGPointValue];
        yy2 = endPoint2.y;
    }else{
        endPoint2 = [_pointArr1[index2+1] CGPointValue];
    }
    
    yy2 = (int)(startPoint2.y + (xx2 - index2*25)*1.0/25.0 * (endPoint2.y - startPoint2.y));
    
    CGRect frame2 = _NumLab1.frame;
    frame2.origin.x = xx2-50/2.0 +12.5;
    frame2.origin.y = yy2-13;
    _NumLab1.frame = frame2;

    // 第三组
    NSArray *childAry3 = _yValues[2];
    NSInteger xx3 = (childAry3.count -1)  * 25.0 * kk / (childAry3.count * 25.0 - [UIScreen mainScreen].bounds.size.width +50.0);
    
    NSInteger sum3 = 0;
    CGPoint startPoint3  , endPoint3;
    
    NSInteger index3 = 0;
    for(int i=0; i<childAry3.count; i++){
        sum3 += 25.0;
        if(xx3 < sum3) {
            startPoint3 = [_pointArr2[i] CGPointValue];
            index3 = i;
            break;
        }
    }
    
    NSString *sumnum3 = [childAry3 objectAtIndex:index3];
    _NumLab2.text = sumnum3;
    
    NSInteger yy3 = 0.0;
    if(index3+1 >= childAry3.count || startPoint3.x == 0){
        endPoint3 = [_pointArr2[childAry3.count -1] CGPointValue];
        yy3 = endPoint3.y;
    }else{
        endPoint3 = [_pointArr2[index3+1] CGPointValue];
    }
    
    yy3 = (int)(startPoint3.y + (xx3 - index3*25)*1.0/25.0 * (endPoint3.y - startPoint3.y));
    
    CGRect frame3 = _NumLab2.frame;
    frame3.origin.x = xx3-50/2.0 +12.5;
    frame3.origin.y = yy3-13;
    _NumLab2.frame = frame3;

  
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
