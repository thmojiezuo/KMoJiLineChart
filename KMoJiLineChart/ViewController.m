//
//  ViewController.m
//  KMoJiLineChart
//
//  Created by tenghu on 2017/11/8.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Extension.h"
#import "KMoJiLineCell.h"
#import "KMoJiLineCell2.h"

#define WORDBRIGHT [UIColor colorWithHexString:@"bfbdbd" alpha:1] 
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WIDTH(view) view.frame.size.width
#define LINECOLOR [UIColor colorWithHexString:@"666666" alpha:0.3]

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger _flagIndex; //折线图方块
    CGFloat _flagrr;
}
@property (nonatomic ,strong)UIScrollView *scroller;
@property (strong, nonatomic)  UITableView *chartTableView;  //折线图
@property (nonatomic , strong)UILabel *TyearLab; // 年份 变化的
@property (nonatomic , strong)NSMutableArray *TyearArr; //时间段内的日期
@property (nonatomic , strong)NSMutableArray *TLevelArr; //等级
@property (nonatomic , strong)NSMutableArray *NewCusArr; //新客

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _flagIndex = 0;
    _flagrr = 0.0;
    
    _TyearArr = [[NSMutableArray alloc] init];
    _TLevelArr = [[NSMutableArray alloc] init];
    _NewCusArr = [[NSMutableArray alloc] init];
    
    
    [self createTopView];
}
#pragma  mark - 创建最上面的折线图
- (void)createTopView{
   
    
    _TyearLab = [[UILabel alloc] init];
    _TyearLab.text = @"2016-06";
    _TyearLab.textColor = WORDBRIGHT;
    _TyearLab.textAlignment = NSTextAlignmentLeft;
    _TyearLab.font = [UIFont systemFontOfSize:10];
    _TyearLab.frame = CGRectMake(5, 140+150+51, 50, 18);
    [self.view addSubview:_TyearLab];
    
    NSArray *arr =  [self dateFromeTime:@"2017.06.25" ToTime:@"2017.07.16"];
    [_TyearArr addObjectsFromArray:arr];
    NSArray *arr1 = @[@"500",@"500",@"1000",@"1000",@"1000",@"1500",@"2000",@"2000",@"1000",@"1000",@"1500",@"500",@"500",@"1000",@"1000",@"1000",@"1500",@"2000",@"2000",@"1000",@"1000",@"1500"];
    for (NSString *string in arr1) {
        
        NSInteger aa =  string.integerValue/1000;
        [_TLevelArr addObject:[NSString stringWithFormat:@"%ld",(long)aa]];
        
    }
    
    for (int i = 1; i < 23; i ++) {
        [_NewCusArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    _scroller= [[UIScrollView alloc]initWithFrame:CGRectMake(50, 140,  SCREEN_WIDTH-50 , 230)];
    _scroller.contentSize = CGSizeMake( 22*25+20, 0);
    
    _scroller.showsHorizontalScrollIndicator = YES;
    _scroller.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    _scroller.delegate = self;
    [self.view addSubview:_scroller];
    
    _chartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 22*25+20<SCREEN_WIDTH-50?SCREEN_WIDTH-50:22*25+20 , 220) style:UITableViewStylePlain];
    _chartTableView.backgroundColor = [UIColor clearColor];
    _chartTableView.delegate = self;
    _chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chartTableView.dataSource = self;
    _chartTableView.scrollEnabled = NO;
    _chartTableView.showsHorizontalScrollIndicator = YES;
    _chartTableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    [_chartTableView registerClass:[KMoJiLineCell class] forCellReuseIdentifier:@"user_id"];
    [_chartTableView registerClass:[KMoJiLineCell2 class] forCellReuseIdentifier:@"user"];
    [_scroller addSubview:_chartTableView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 140+150+18+10, 50+WIDTH(_chartTableView), 0.5)];
    lineView.backgroundColor = LINECOLOR;
    [self.view addSubview:lineView];
        
}
#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        KMoJiLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user_id" forIndexPath:indexPath];
        [cell configUI:indexPath];
        
        return cell;
    }else{
        KMoJiLineCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"user" forIndexPath:indexPath];
        
        cell.dataArr = _NewCusArr;
        cell.LevelArr = _TLevelArr;
        cell.dateArr = _TyearArr;
        cell.mm = _flagIndex;
        cell.rr = _flagrr;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }else{
        return 66;
    }
    
}
//这个函数是求一段时间内的每一天集合
- (NSArray *)dateFromeTime:(NSString *)startTime ToTime:(NSString *)lastTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy.MM.dd"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:lastTime];
    NSTimeInterval nowTime = [startD timeIntervalSince1970]*1;
    NSTimeInterval endTime = [endD timeIntervalSince1970]*1;
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSTimeInterval  dayTime = 24*60*60;
    double mm = (long long)nowTime % (int)dayTime;
    NSTimeInterval time = nowTime - mm;
    
    while (time <= endTime) {
        NSString *showOldDate = [date stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [dates addObject:showOldDate];
        time += dayTime;
    }
    [dates removeObjectAtIndex:0];
    [dates addObject:lastTime];
    
    return dates;
}

#pragma mark -上面的折线图滚动

- (NSInteger)getScrollBarX:(NSInteger)scrollOffset{
    NSInteger x = (_TyearArr.count - 1) * 25.0 * scrollOffset / (_TyearArr.count * 25.0 - SCREEN_WIDTH +50.0);
    
    return x;
}

- (NSInteger) calculateItemIndex:(NSInteger)scrollOffset{
    
    NSInteger x = [self getScrollBarX:scrollOffset];
    
    int sum = -12.5;
    for(int i=0; i<_TyearArr.count; i++){
        sum += 25.0;
        if(x < sum)
            return i;
    }
    return _TyearArr.count - 1;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat aa = scrollView.contentOffset.x;
    if (aa < 0.0  ) {
        aa = 0;
    }else if (aa > (_TyearArr.count * 25.0 - SCREEN_WIDTH +50.0)){
        aa = _TyearArr.count * 25.0 - SCREEN_WIDTH +50.0;
    }
    NSInteger kk = [self calculateItemIndex:aa];
    if (scrollView == _scroller) {
        NSString * str = _TyearArr[kk];
        NSArray *arr = [str componentsSeparatedByString:@"."];
        _TyearLab.text = [NSString stringWithFormat:@"%@-%@",arr[0],arr[1]];
        
        // 以下开始动画效果
        
        CGFloat xx = [self getScrollBarX:aa];
        NSInteger mm = kk;
        
        _flagIndex = mm;
        _flagrr = xx;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        KMoJiLineCell2 *cell2 = [_chartTableView cellForRowAtIndexPath:indexPath];
        cell2.mm = mm;
        cell2.rr = _flagrr;
        
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:0 inSection:0];
        KMoJiLineCell *cell = [_chartTableView cellForRowAtIndexPath:indexPath1];
        cell.kk = aa;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
