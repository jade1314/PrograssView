//
//  PrograssView.m
//  PanGu
//
//  Created by 王玉 on 2017/4/10.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import "PrograssViewTool.h"


@interface PrograssViewTool ()

@property (nonatomic,strong) NSArray * xValueArr;
@end

@implementation PrograssViewTool


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setCurrentModelTop:(CalendarModel *)currentModelTop{
    _currentModelTop = currentModelTop;
    
}
- (void)reloadDateWithModel:(CalendarModel *)model{
    CGFloat pro = 0.0;
    __block NSInteger spaceDay;
    __block NSInteger spaceSection;
    
    NSDate *date = [NSDate date];
    
    NSArray *prograssDateArr = @[model.dateBegin,model.dateMiddleOne,model.dateMiddleTwo];
    
    NSDate *date1 = [DateHelper dateYMDStrTotalDate:model.dateBegin];
    NSDate *date2 = [DateHelper dateYMDStrTotalDate:model.dateMiddleOne];
    NSDate *date3 = [DateHelper dateYMDStrTotalDate:model.dateMiddleTwo];
    NSDate *date4 = [DateHelper dateYMDStrTotalDate:model.dateEnd];
    NSInteger space1 = [self getDaysFrom:date1 To:date2];
    NSInteger space2 = [self getDaysFrom:date2 To:date3];
    NSInteger space3 = [self getDaysFrom:date3 To:date4];
    uWeakSelf
    if ([date timeIntervalSinceDate:date1] < 0) {
        spaceDay = 0;
        spaceSection = 0;
    }
    else if ([date timeIntervalSinceDate:date4] > 0){
        spaceDay = 10000;
        spaceSection = 3;
    }
    else{
        [prograssDateArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDate *midDate = [DateHelper dateYMDStrTotalDate:obj];
            
            if ([date timeIntervalSinceDate:midDate] > 0.0) {
                spaceDay = [weakSelf getDaysFrom:midDate To:date];
                spaceSection = idx;
                *stop = YES;
            }
        }];
    }
    if (spaceSection == 0) {
        pro = ([_xValueArr[1] floatValue] - [_xValueArr[0] floatValue])/space1*(spaceDay) + 3.25 * 2;
    }
    else if (spaceSection == 1){
        pro = ([_xValueArr[2] floatValue] - [_xValueArr[1] floatValue])/space2 * spaceDay + ([_xValueArr[1] floatValue] - [_xValueArr[0] floatValue]) + 3.25 * 2;
    }else if (spaceSection == 2){
        pro = [_xValueArr[2] floatValue]- [_xValueArr[0] floatValue] + 3.25 * 2;
    }else if (spaceSection == 3){
        pro = [_xValueArr[3] floatValue]- [_xValueArr[0] floatValue] + 3.25 * 2;
    }
    pro = pro == 6.5?0:pro;
    _progress.progress = pro/(SCREENWIDTH - 24 - 5);
    
    NSString *zeroStr = model.dateBegin;
    NSString *oneStr = model.dateMiddleOne;
    NSString *twoStr = model.dateMiddleTwo;
    NSString *threeStr = model.dateEnd;
    NSArray *markArr = @[@"起购",@"起息",@"到期",@"到账",[DateHelper dateMDStrTotalString:zeroStr] ,[DateHelper dateMDStrTotalString:oneStr],[DateHelper dateMDStrTotalString:twoStr],[DateHelper dateMDStrTotalString:threeStr]];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [UILabel class]) {
            UILabel *tempLabel = (UILabel *)obj;
            tempLabel.text = markArr[idx];
        }
    }];
}


- (void)createUI{
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.progress.center = CGPointMake(SCREENWIDTH/2, 50);
    
    _progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    _xValueArr = @[@(19.5),@(100),@(SCREENWIDTH - 115),@(SCREENWIDTH - 12 - 7.5)];
    
    NSString *zeroStr = _currentModelTop.dateBegin;
    NSString *oneStr = _currentModelTop.dateMiddleOne;
    NSString *twoStr = _currentModelTop.dateMiddleTwo;
    NSString *threeStr = _currentModelTop.dateEnd;
    NSArray *markArr = @[@[@"起购",@"起息",@"到期",@"到账"],@[[DateHelper dateMDStrTotalString:zeroStr] ,[DateHelper dateMDStrTotalString:oneStr],[DateHelper dateMDStrTotalString:twoStr],[DateHelper dateMDStrTotalString:threeStr]]];
    for (int j = 0; j < markArr.count; j++) {
        for (int i = 0; i < [markArr[j] count]; i ++) {

            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + (SCREENWIDTH-20)/4 * i,15 + 54 *j, (SCREENWIDTH-20)/4, 14)];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:14];
            switch (i) {
                case 0:
                case 1:
                    label.textAlignment = NSTextAlignmentLeft;
                    break;
                case 3:
                case 2:
                    label.textAlignment = NSTextAlignmentRight;
                    break;
                    
                default:
                    break;
            }
            label.text = markArr[j][i];
            [self addSubview:label];
        }
     
    }
    
    [self addSubview:_progress];
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(15, 15);
        btn.layer.cornerRadius = 7.5;
        btn.tag = 123000 + i;
        btn.layer.masksToBounds = YES;
        btn.center = CGPointMake([_xValueArr[i] floatValue], 50);
        [btn setImage:[UIImage imageNamed:@"homepage_prograsspoint"] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    
}

- (UIProgressView *)progress{
    if (!_progress) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 24 - 5, 5)];
        
        _progress.progressTintColor = [UIColor blueColor];
    }
    return _progress;
}

- (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}




@end
