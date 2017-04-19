

#import "DateHelper.h"


#define NSSTRING_FROM_INT(aIntNumber) [NSString stringWithFormat:@"%d",aIntNumber]
#define INT_FROM_NSSTRING(aNSString)  [aNSString intValue]

#define YEAR_RANGE NSMakeRange(0, 4)
#define MONTH_RANGE NSMakeRange(5, 2)
#define DAY_RANGE NSMakeRange(8, 2)
#define HOUR_RANGE NSMakeRange(11, 2)
#define MINITE_RANGE NSMakeRange(14, 2)
#define YEAR_MONTH_DAY_RANGE NSMakeRange(0, 10)
#define HOUR_MINITE_RANGE NSMakeRange(11, 5)

@implementation DateHelper

/**
 * 根据类型返回日期
 */
+(NSString *) getNowTimeWithType:(DateHelperTimeTextType) type
{
    NSString * dataString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (type)
    {
        case DateHelperTimeTextTypeCut:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeColon:
            [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeNone:
            [dateFormatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
            break;
        default:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
    }
    
    dataString = [dateFormatter stringFromDate:[NSDate date]];
    
    //[dateFormatter release];
    
    return dataString;
}

//获取当前年月日字符串
+(NSString *) yearMonthDayString
{
    NSString * nowTime = [DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut];
    NSString * YMD = [nowTime substringWithRange:YEAR_MONTH_DAY_RANGE];
    return YMD;
}

//获取当前年月日数组
+(NSArray *) yearMonthDayArray
{
    NSString * YMD = [DateHelper yearMonthDayString];
    NSArray * tempArray = [YMD componentsSeparatedByString:@"-"];
    return tempArray;
}
//获取当前年份
+(NSString *) year
{
    return [[DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut] substringWithRange:YEAR_RANGE];
}
//获取当前月份
+(NSString *) month
{
    return [[DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut] substringWithRange:MONTH_RANGE];
}
//获取当月几号
+(NSString *) day
{
    return [[DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut] substringWithRange:DAY_RANGE];
}

//获取当前小时与分钟字符串
+(NSString *) hourMinitesString
{
    return [[DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut] substringWithRange:HOUR_MINITE_RANGE];
}

//获取当前小时与分钟数组
+(NSArray *) hourMinitesArray
{
    NSString * HM = [DateHelper hourMinitesString];
    NSArray * tempArray = [HM componentsSeparatedByString:@":"];
    return tempArray;;
}

//获取当前小时
+(NSString *) hour
{
    return [[DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut] substringWithRange:HOUR_RANGE];
}

//获取当前分钟
+(NSString *) minite
{
    return [[DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut] substringWithRange:MINITE_RANGE];
}

//计算流逝的时间 参数为一个标准格式的时间字符串
+(NSString *) calulatePassTime:(NSString *) timeText
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * d= [date dateFromString:timeText];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        
        return [NSString stringWithFormat:@"%@天前",timeString];
        
    }
    
    return timeString;
    
    
}
+(NSString *) calulatePassTimeTZGG:(NSString *) timeText
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init ];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d= [date dateFromString:timeText];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString= @"";
    NSTimeInterval cha=now-late;
    if (cha/86400<1)
    {
        [date setDateFormat:@"HH:mm"];
        timeString = [date stringFromDate:d];
    }else{
        [date setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeString = [date stringFromDate:d];
    }
    return timeString;
}

/***************/

//获取当前时间 yyyy-MM-dd HH:mm:ss
+ (NSString *)currentTime {
    NSDate *cuttentDate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *currentDateStr=[dateformatter stringFromDate:cuttentDate];
    return currentDateStr;
}
//yyyyMMdd 转 yyyy.MM.dd
+ (NSString *)dateStrDotWithString:(NSString *)dateString {
    NSString *orderDateString;
    if (![dateString isKindOfClass:[NSString class]] || [dateString isEqualToString:@""]) {
        orderDateString = @"--";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat =@"yyyyMMdd";
        NSDate *orderDate = [dateFormatter dateFromString:dateString];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
        orderDateString = [dateFormatter stringFromDate:orderDate];
    }
    return orderDateString;
}

//yyyyMMdd 转 yyyy-MM-dd
+ (NSString *)dateStrDashWithString:(NSString *)dateString {
    NSString *orderDateString;
    if (![dateString isKindOfClass:[NSString class]] || [dateString isEqualToString:@""]) {
        orderDateString = @"--";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat =@"yyyyMMdd";
        NSDate *orderDate = [dateFormatter dateFromString:dateString];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        orderDateString = [dateFormatter stringFromDate:orderDate];
    }
    return orderDateString;
}

//yyyyMMdd 转MM.dd
+ (NSString *)dateMDStrDashWithString:(NSString *)dateString {
    NSString *orderDateString;
    if (![dateString isKindOfClass:[NSString class]] || [dateString isEqualToString:@""]) {
        orderDateString = @"--";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat =@"yyyyMMdd";
        NSDate *orderDate = [dateFormatter dateFromString:dateString];
        dateFormatter.dateFormat = @"MM.dd";
        orderDateString = [dateFormatter stringFromDate:orderDate];
    }
    return orderDateString;
}
//yyyyMMdd 转 yyyy/MM/dd
+ (NSString *)dateStrObliqueLineWithString:(NSString *)dateString {
    NSString *orderDateString;
    if (![dateString isKindOfClass:[NSString class]] || [dateString isEqualToString:@""]) {
        orderDateString = @"--";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat =@"yyyyMMdd";
        NSDate *orderDate = [dateFormatter dateFromString:dateString];
        dateFormatter.dateFormat = @"yyyy/MM/dd";
        orderDateString = [dateFormatter stringFromDate:orderDate];
    }
    return orderDateString;
}

//HHmmss 转 HH:mm:ss
//+ (NSString *)timeStrColonWithString:(NSString *)timeString {
//    NSString *orderTimeString;
//    if (![timeString isKindOfClass:[NSString class]] || [timeString isEqualToString:@""] || [timeString isEqualToString:@"0"]) {
//        orderTimeString = @"--";
//    } else {
//        NSMutableString *str = [timeString mutableCopy];
//        if ([timeString length] != 6) {
//            [str insertString:@"0" atIndex:0];
//        }
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        dateFormatter.dateFormat = @"HHmmss";
//        NSDate *orderTime = [dateFormatter dateFromString:str];
//        dateFormatter.dateFormat = @"HH:mm:ss";
//        orderTimeString = [dateFormatter stringFromDate:orderTime];
//    }
//    return orderTimeString;
//    
//}


//HHmmss 转 HH:mm:ss
+ (NSString *)timeStrColonWithString:(NSString *)timeString {
    NSString *orderTimeString;
    if (![timeString isKindOfClass:[NSString class]] || [timeString isEqualToString:@""]) {
        orderTimeString = @"--";
    } else {
        NSMutableString *str = [timeString mutableCopy];
        if ([timeString length] != 6) {
            
            for (NSInteger i = 0; i < 6-timeString.length; i ++ ) {
                [str insertString:@"0" atIndex:0];
            }
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"HHmmss";
        NSDate *orderTime = [dateFormatter dateFromString:str];
        dateFormatter.dateFormat = @"HH:mm:ss";
        orderTimeString = [dateFormatter stringFromDate:orderTime];
    }
    return orderTimeString;
    
}



//yyyy-MM-dd 转 MM.dd
+ (NSString *)dateMDStrDashWithMinusString:(NSString *)dateString {
    NSString *orderDateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *dateStr = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"MM.dd";
    orderDateString = [dateFormatter stringFromDate:dateStr];
    return orderDateString;
}

//yyyyMMdd 转 MM-dd
+ (NSString *)dateMDStrHengDashWithMinusString:(NSString *)dateString {
    NSString *orderDateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *dateStr = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"MM-dd";
    orderDateString = [dateFormatter stringFromDate:dateStr];
    return orderDateString;
}

+ (NSDate *)timeString:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:timeString];
}

//yyyy-MM-dd,yyyy.MM.dd yyyyMMdd转 MMdd
+ (NSString *)dateMDStrTotalString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (dateString.length < 5) {
        return @"00-00";
    }
    if (dateString.length > 11){
        dateString = [dateString substringToIndex:8];
        dateFormatter.dateFormat = @"yyyyMMdd";
    }else if (!([dateString rangeOfString:@"-"].location == NSNotFound)) {
       dateFormatter.dateFormat = @"yyyy-MM-dd";
    }else if (!([dateString rangeOfString:@"."].location == NSNotFound)){
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    NSString *orderDateString;
    NSDate *dateStr = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"MM-dd";
    orderDateString = [dateFormatter stringFromDate:dateStr];
    return orderDateString;
}
//yyyy-MM-dd,yyyy.MM.dd yyyyMMdd转date
+ (NSDate *)dateYMDStrTotalDate:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (dateString.length > 11){
        dateString = [dateString substringToIndex:8];
        dateFormatter.dateFormat = @"yyyyMMdd";
    }else
    if ([dateString rangeOfString:@"-"].location) {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }else if ([dateString rangeOfString:@"."].location){
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }else{
        dateFormatter.dateFormat = @"yyyyMMdd";
    }
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

@end
