//
//  KMoJiLineCell2.m
//  KMoJiLineChart
//
//  Created by tenghu on 2017/11/8.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "KMoJiLineCell2.h"
#import "UIColor+Extension.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define RGB(r,g,b)[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define BOTTOMCOLOR [UIColor colorWithHexString:@"ffffff" alpha:0.04]
#define WORDBRIGHT [UIColor colorWithHexString:@"bfbdbd" alpha:1]

@interface KMoJiLineCell2 ()
{
    NSMutableArray *_colorArr;
    NSMutableArray *_textColor;
}
@property (nonatomic ,strong)UIView *backView;

@property (nonatomic ,strong)UILabel *backLab;

@end


@implementation KMoJiLineCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _colorArr = [[NSMutableArray alloc] init];
        _textColor  = [[NSMutableArray alloc] init];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
        [self.contentView addSubview:_backView];
        
        _backLab = [[UILabel alloc] init];
        _backLab.textColor = RGB(247, 130, 10);
        _backLab.textAlignment = NSTextAlignmentCenter;
        _backLab.font = [UIFont systemFontOfSize:9];
        //        _backLab.backgroundColor = [UIColor redColor];
        [_backView addSubview:_backLab];
        
        
    }
    return self;
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    CGRect frame = _backView.frame;
    frame.size.width = dataArr.count *25+20;
    _backView.frame = frame;
    
    [_colorArr removeAllObjects];
    
    for (UIView *view in _backView.subviews) {
        if (view.tag > 199) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < dataArr.count; i ++) {
        NSString *string = dataArr[i];
        UIView *view1 = [[UIView alloc] init];
        if (string.integerValue > 0 && string.integerValue < 6) {
            view1.frame = CGRectMake(1+i*25, 20, 23, 8);
            view1.backgroundColor =RGB(86, 64, 5);
            [_colorArr addObject:RGB(86, 64, 5)];
        }else if (string.integerValue > 10){
            view1.frame = CGRectMake(1+i*25, 10, 23, 18);
            view1.backgroundColor = RGB(102, 36, 4);
            [_colorArr addObject:RGB(102, 36, 4)];
        }else{
            view1.frame = CGRectMake(1+i*25, 15, 23, 13);
            view1.backgroundColor = RGB(107, 58, 3);
            [_colorArr addObject:RGB(107, 58, 3)];
        }
        view1.tag = 200 + i;
        [_backView addSubview:view1];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view1.bounds;
        maskLayer.path = maskPath.CGPath;
        view1.layer.mask = maskLayer;
        
        
        
    }
    
}

-(void)setLevelArr:(NSArray *)LevelArr{
    
    _LevelArr = LevelArr;
    
    for (UIView *view in _backView.subviews) {
        if (view.tag > 299) {
            [view removeFromSuperview];
        }
    }
    
    
    NSInteger aa = 1;
    NSInteger ii = 0;
    for (int i = 0; i < LevelArr.count; i ++) {
        
        NSString *string = LevelArr[i];
        if (i+1 < LevelArr.count) {
            NSString *string1 = LevelArr[i+1];
            if (string.integerValue == string1.integerValue) {
                aa += 1;
            }else{
                
                UIView *view1 = [[UIView alloc] init];
                view1.frame = CGRectMake(1+ii*25, 32, aa*25-1, 18);
                view1.backgroundColor = BOTTOMCOLOR;
                view1.tag = 300+i;
                [_backView addSubview:view1];
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = view1.bounds;
                maskLayer.path = maskPath.CGPath;
                view1.layer.mask = maskLayer;
                UILabel *lab = [[UILabel alloc] init];
                lab.frame = CGRectMake(0, 0, aa*25, 18);
                lab.text = [NSString stringWithFormat:@"%@级",string];
                lab.textColor = WORDBRIGHT;
                lab.textAlignment = NSTextAlignmentCenter;
                lab.font = [UIFont systemFontOfSize:10];
                [view1 addSubview:lab];
                
                ii = i+1;
                aa = 1;
            }
        }else{
            
            UIView *view1 = [[UIView alloc] init];
            view1.frame = CGRectMake(1+ii*25, 32, aa*25-1, 18);
            view1.backgroundColor = BOTTOMCOLOR;
            view1.tag = 300+i;
            [_backView addSubview:view1];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = view1.bounds;
            maskLayer.path = maskPath.CGPath;
            view1.layer.mask = maskLayer;
            UILabel *lab = [[UILabel alloc] init];
            lab.frame = CGRectMake(0, 0, aa*25, 18);
            lab.text = [NSString stringWithFormat:@"%@级",string];
            lab.textColor = WORDBRIGHT;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:10];
            [view1 addSubview:lab];
            
            ii = i+1;
            aa = 1;
            
        }
    }
    
    
}
-(void)setDateArr:(NSArray *)dateArr{
    
    _dateArr = dateArr;
    [_textColor removeAllObjects];
    
    for (UIView *view in _backView.subviews) {
        if (view.tag > 399) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < dateArr.count; i ++) {
        NSString *string = dateArr[i];
        NSArray *arr = [string componentsSeparatedByString:@"."];
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = arr.lastObject;
        lab.tag = 400+i;
        if ([str containsString:@"0"]) {
            if ([[str substringFromIndex:1] integerValue] == 0) {
                lab.text = str;
            }else{
                lab.text = [str substringFromIndex:1];
            }
        }else{
            lab.text = str;
        }
        
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:10];
        
        if ([self iscalculateWeek:string] == YES) {
            lab.textColor = [UIColor redColor];
            [_textColor addObject:[UIColor redColor]];
        }else{
            lab.textColor = WORDBRIGHT;
            [_textColor addObject:WORDBRIGHT];
        }
        lab.frame = CGRectMake(1+i*25, 50, 23, 18);
        [_backView addSubview:lab];
    }
    
}

-(void)setMm:(NSInteger)mm{
    _mm = mm;
    
    
    NSString *str = _dataArr[mm];
    _backLab.text = str;
    
    for (int i = 0; i < _dataArr.count; i ++) {
        
        UIView *view1 = (UIView *)[_backView viewWithTag:i+200];
        view1.backgroundColor = _colorArr[i];
        
        UILabel *label = (UILabel *)[_backView viewWithTag:i+400];
        label.textColor  = _textColor[i];
        
    }
    
    UIView *hightView = (UIView *)[self.contentView viewWithTag:mm+200];
    hightView.backgroundColor = RGB(247, 130, 10);
    
    UILabel *label = (UILabel *)[self.contentView viewWithTag:mm+400];
    label.textColor = RGB(247, 130, 10);
    
}


-(void)setRr:(CGFloat)rr{
    _rr = rr;
    
    NSInteger mm = rr /25;
    
    
    CGFloat yy = 0.0 ;
    if (mm+1 < _dataArr.count) {
        NSString *str = _dataArr[mm+1];
        if (str.integerValue > 0 && str.integerValue < 6) {
            yy = 10;
        }else if (str.integerValue > 10){
            yy = 0;
        }else{
            yy = 5;
        }
        
    }
    
    
    if (rr > (_dataArr.count-1)*25) {
        _backLab.frame = CGRectMake((_dataArr.count-1)*25, yy, 25, 10);
    }else{
        _backLab.frame = CGRectMake(rr, yy, 25, 10);
    }
    
    
}

- (BOOL)iscalculateWeek:(NSString *)string{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy.MM.dd"];
    NSDate *startD =[date dateFromString:string];
    NSString *str = [self calculateWeek:startD];
    if ([str isEqualToString:@"周日"] || [str isEqualToString:@"周六"] ) {
        return YES;
    }else{
        return NO;
    }
    
}
- (NSString *)calculateWeek:(NSDate *)date{
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:date] weekday];
    //    NSLog(@"week : %zd",week);
    switch (week) {
        case 1:
        {
            return @"周日";
        }
        case 2:
        {
            return @"周一";
        }
        case 3:
        {
            return @"周二";
        }
        case 4:
        {
            return @"周三";
        }
        case 5:
        {
            return @"周四";
        }
        case 6:
        {
            return @"周五";
        }
        case 7:
        {
            return @"周六";
        }
    }
    
    return @"";
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
