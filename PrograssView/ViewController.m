//
//  ViewController.m
//  PrograssView
//
//  Created by 王玉 on 2017/4/17.
//  Copyright © 2017年 JADE. All rights reserved.
//

#import "ViewController.h"
#import "PrograssViewTool.h"
#import "GYZCustomCalendarPickerView.h"
#import "UIView+frame.h"
#import "UIView+Shadow.h"
#import "DateHelper.h"
#import "CalendarModel.h"
typedef  void(^calendarBlock)(UIButton *button);


@interface ViewController ()<GYZCustomCalendarPickerViewDelegate>
@property (nonatomic,assign) NSInteger buttonRes;
@property (nonatomic,strong) PrograssViewTool *prog;
@property (nonatomic,strong) NSMutableArray * dateArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 4; i ++) {

        UIButton *dateField = [self createCalendarBtnWithBackView:self.view idx:i calendar:^(UIButton *button) {
             [button addTarget:self action:@selector(clickCalendarButton:) forControlEvents:UIControlEventTouchUpInside];
        } frame:CGRectMake(SCREENWIDTH/4 * i, SCREENHEIGHT/3, SCREENWIDTH/4, 50)];
        [dateField setTitle:@"点击输入日期" forState:UIControlStateNormal];
        dateField.layer.borderWidth = 2;
        dateField.layer.borderColor = [UIColor blueColor].CGColor;
        dateField.layer.cornerRadius = 5;
        dateField.layer.masksToBounds = YES;
        [self.view addSubview:dateField];
    }
    _prog = [[PrograssViewTool alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT/2, SCREENWIDTH, 100)];
    CalendarModel *model = [[CalendarModel alloc]init];
    model.dateBegin = @"2017-04-10";
    model.dateMiddleOne = @"2017-04-19";
    model.dateMiddleTwo = @"2017-04-25";
    model.dateEnd = @"2017-04-30";
    _prog.currentModelTop = model;
    [self.view addSubview:_prog];
    UIButton *dataBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 64, SCREENWIDTH, 64)];
    dataBtn.backgroundColor = [UIColor yellowColor];
    [dataBtn setTitle:@"更新日期" forState:UIControlStateNormal];
    [dataBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dataBtn];
    _dateArr = @[@"",@"",@"",@""].mutableCopy;
}

- (void)btnClicked:(UIButton *)sender{
    for (int i = 0 ; i < _dateArr.count; i ++) {
        if ([_dateArr[i] length] < 1) {
            NSLog(@"提交的日期不正确");
            return;
        }
    }
    CalendarModel *model = [[CalendarModel alloc]init];
    model.dateBegin = _dateArr[0];
    model.dateMiddleOne = _dateArr[1];
    model.dateMiddleTwo = _dateArr[2];
    model.dateEnd = _dateArr[3];
    [_prog reloadDateWithModel:model];
}

- (UIButton *)createCalendarBtnWithBackView:(UIView *)backView idx:(NSInteger)idx calendar:(calendarBlock)block frame:(CGRect)rect{
    UIButton *calendarBtn = [[UIButton alloc]initWithFrame:rect];
    calendarBtn.tag = 999000 + idx;
    
    CGSize size =[@"2016-04-05" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}];
    //创建起始日期button
    calendarBtn.backgroundColor = [UIColor whiteColor];
    if (idx == 0) [calendarBtn setImage:[UIImage imageNamed:@"rililan"] forState:UIControlStateNormal];
    NSDateFormatter *dataF = [[NSDateFormatter alloc]init];
    dataF.dateFormat = @"YYYY-MM-dd";
    [calendarBtn setTitle:@"选择日期" forState:UIControlStateNormal];
    calendarBtn.layer.cornerRadius = 3;
    calendarBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [calendarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [calendarBtn setImageEdgeInsets:UIEdgeInsetsMake((40-18)/2, 10, (40-18)/2, 18 )];
    [calendarBtn setTitleEdgeInsets:UIEdgeInsetsMake((40-size.height)/2, 10, (40-size.height)/2, 0)];
    
    [backView addSubview:calendarBtn];
    block(calendarBtn);
    return calendarBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyNewCalendar:(IDJCalendar *)cal{
    UIButton *btnS = (UIButton *)[self.view viewWithTag:_buttonRes];
    
    NSString *result = @"2016-04-05";
    if ([cal isMemberOfClass:[IDJCalendar class]]) {//阳历
        
        NSString *year =[NSString stringWithFormat:@"%@",cal.year];
        NSString *month = [cal.month intValue] > 9 ? cal.month:[NSString stringWithFormat:@"0%@",cal.month];
        NSString *day = [cal.day intValue] > 9 ? cal.day:[NSString stringWithFormat:@"0%@",cal.day];
        result = [NSString stringWithFormat:@"%@-%@-%@",year,month, day];
        
    }
    [btnS setTitle:result forState:UIControlStateNormal];
    [_dateArr replaceObjectAtIndex:_buttonRes - 999000 withObject:result];
    
}

- (void)clickCalendarButton:(UIButton *)sender{
    GYZCustomCalendarPickerView *calenderPickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择日期"];
    calenderPickerView.delegate = self;
    calenderPickerView.calendarType = GregorianCalendar;
    _buttonRes = sender.tag;
    [self.view addSubview:calenderPickerView];
}


@end
