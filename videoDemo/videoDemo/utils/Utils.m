
//  Utils.m
//  AVPlayerDemo
//
//  Created by Yx on 15/9/8.
//  Copyright © 2015年 WuhanBttenMobileTechnologyCo.,Ltd. All rights reserved.
//

#import "Utils.h"
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "NSDate+SMDate.h"

//系统判断
#define IS_IOS_VERSION_7 (([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)? (YES):(NO))
#define IS_IOS_VERSION_8 (([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)? (YES):(NO))
#define IS_IOS_VERSION_9 (([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)? (YES):(NO))
#define ViewFrameOriginX(vi) vi.frame.origin.x
#define ViewFrameOriginY(vi) vi.frame.origin.y
#define ViewFrameSizeW(vi) vi.frame.size.width
#define ViewFrameSizeH(vi) vi.frame.size.height

@implementation Utils

//弹出提示内容
+(void)showMessage:(NSString*)message setView:(UIViewController*)view{
    
}
//得到statusBar的高度
+(int)getStatusbarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}
//得到屏幕高度
+(int)getScreenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}
//得到屏幕宽度
+(int)getScreenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

//判断是手机号格式是否正确
+(BOOL)isMobilePhoneNum:(NSString*)number{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    
    if (number.length<3) {
        return NO;
    }
    
    if ([number hasPrefix:@"86"]) {
        number=[number substringFromIndex:2];
    }
    
    if ([number hasPrefix:@"181"]||[number hasPrefix:@"140"]) {
        if (number.length==11) {
            return YES;
        }
    }
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";//总况
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",MOBILE];
    bool b=[test evaluateWithObject:number];
    return b;
    
}

+(NSString*)removeCountryNum:(NSString*)num{
    if ([num hasPrefix:@"86"]) {
        return [num substringFromIndex:2];
    }
    
    return num;
}

//判断是否是邮箱

+(BOOL)isEmail:(NSString*)email{
    
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isEmpty:(NSString*)str{
    
    if (![str isKindOfClass:NSString.class]) {
        return YES;
    }
    
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    if ([str isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
    
}

+(int)getLableHeight:(UILabel*)label{
    NSDictionary * attr=@{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGRect size = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attr context:nil];
    return size.size.height;
}

+(NSString*)appendString:(NSString*)str with:(NSString*)mes{
    
    if ([Utils isEmpty:mes]) {
        return str;
    }
    
    return [str stringByAppendingString:mes];
}

+(NSString*)appendString:(NSString*)str withInt:(int)mesInt{
    NSString*m=[NSString stringWithFormat:@"%d",mesInt];
    return [str stringByAppendingString:m];
}



+(NSString*)appendString:(NSString *)str ,...{
    NSString*result=str;
    NSString*ns;
    va_list arg_list;
    va_start(arg_list, str);
    while ((ns = va_arg(arg_list, NSString*))) {
        result=[result stringByAppendingString:ns];
    }
    va_end(arg_list);
    return result;
}



// 将字典或者数组转化为JSON串
+(NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
//    NSString * json=[NSString str]
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+(NSString*)intToString:(int)num{
    return [NSString stringWithFormat:@"%d",num];
}

+(NSString*)doubleToString:(double)num{
    return [NSString stringWithFormat:@"%f",num];
}



+(NSString*)getAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(UIColor*)getRGB:(int)R withG:(int)G withB:(int)B{
    float r=((float)R)/255.0;
    float g=((float)G)/255.0;
    float b=((float)B)/255.0;
    
    return [[UIColor alloc]initWithRed:r green:g blue:b alpha:1.0];
}

+(BOOL)isIPhone4Screen{
    if ([Utils getScreenHeight]==480) {
        return YES;
    }
    return NO;
}

+(NSString*)ChangeRGB:(int)R withG:(int)G withB:(int)B{
    int re=R << 16 | G << 8 | B;
    NSString*str=[NSString stringWithFormat:@"0x%06x",re];
    NSLog(@"%@",str);
    return str;
}

+(BOOL)isContains:(NSString*)str with:(NSString*)mes{
    if([str rangeOfString:mes].location !=NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

+(UIView*)getViewFromLib:(NSString*)libName withOwer:(id)owner{
    return [[[NSBundle mainBundle] loadNibNamed:libName owner:owner options:nil] lastObject];
}


+(NSDateComponents*)getNSDateComponents:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

+(NSString*)getWeekNum:(NSDate*)date{
    NSString * str=@"";
    NSDateComponents *comps=[self getNSDateComponents:date];
    int week = (int)[comps weekday];
    if (week==1) {
        str=@"日";
        return str;
    }
    
    week--;
    
    if (week==1) {
        str=@"一";
    }else if(week==2){
        str=@"二";
    }else if (week==3){
        str=@"三";
    }else if (week==4){
        str=@"四";
    }else if (week==5){
        str=@"五";
    }else if (week==6){
        str=@"六";
    }
    
    //    int month = (int)[comps month];
    //    int day = (int)[comps day];
    //    int hour = (int)[comps hour];
    //    int min = (int)[comps minute];
    //    int sec = (int)[comps second];
    return str;
}

+(int)getWeekNumInt:(NSDate*)date{
    NSString * str=@"";
    NSDateComponents *comps=[self getNSDateComponents:date];
    int week = (int)[comps weekday];
    if (week==1) {
        str=@"日";
        return 7;
    }
    week--;
    return week;
}

//得到一年中的第几个月
+(NSString*)getMonthNum:(NSDate*)date{
    NSString * str=@"";
    NSDateComponents *comps=[self getNSDateComponents:date];
    int month = (int)[comps month];
    str=[NSString stringWithFormat:@"%d",month];
    return str;
}
//得到一个月里面的第几天
+(NSString*)getDayofMonthNum:(NSDate*)date{
    NSString * str=@"";
    NSDateComponents *comps=[self getNSDateComponents:date];
    int day = (int)[comps day];
    str=[NSString stringWithFormat:@"%d",day];
    return str;
}

+(NSString*)getYear:(NSDate*)date{
    NSString * str=@"";
    NSDateComponents *comps=[self getNSDateComponents:date];
    int year = (int)[comps year];
    str=[NSString stringWithFormat:@"%d",year];
    return str;
}

+(NSString*)getSysVerstion{
    return [[UIDevice currentDevice] systemVersion];
}


+(NSString*)getPhoneModel{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    if ([deviceString isEqualToString:@"iPhone7,2"])       return @"iphone 6";
    return deviceString;
}

+(NSString*)getDeviceNum{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}

+(void)setAppIconNotifiNum:(NSString*)num{
    if (IS_IOS_VERSION_8) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        UIApplication *app = [UIApplication sharedApplication];
        // 应用程序右上角数字
        app.applicationIconBadgeNumber =num.intValue;
    }else{
        UIApplication *app = [UIApplication sharedApplication];
        // 应用程序右上角数字
        app.applicationIconBadgeNumber =num.intValue;
    }
    
    
}

+(NSString*)aLaBoToHanZi:(NSString*)str{
    if ([str isEqualToString:@"0"]) {
        str=@"零";
    }else if ([str isEqualToString:@"1"]){
        str=@"一";
    }else if ([str isEqualToString:@"2"]){
        str=@"二";
    }else if ([str isEqualToString:@"3"]){
        str=@"三";
    }else if ([str isEqualToString:@"4"]){
        str=@"四";
    }else if ([str isEqualToString:@"5"]){
        str=@"五";
    }else if ([str isEqualToString:@"6"]){
        str=@"六";
    }else if ([str isEqualToString:@"7"]){
        str=@"七";
    }
    
    return str;
}

+(NSDictionary*)jsonTiDic:(NSString*)json{
    if (json == nil) {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(void)imageViewCircle:(UIImageView*)imageView{
    [self imageViewCircle:imageView withBorderColor:[UIColor lightGrayColor] withBorderWidth:1];
}

+(void)imageViewCircle:(UIImageView*)imageView withBorderColor:(UIColor*)color withBorderWidth:(int)width{
    imageView.clipsToBounds=YES;
    imageView.layer.borderColor=color.CGColor;
    imageView.layer.borderWidth=width;
    imageView.layer.cornerRadius=ViewFrameSizeW(imageView)/2;
}

+(NSString*)autoNull:(NSString*)content{
    if ([Utils isEmpty:content]) {
        return @"";
    }
    
    return content;
}

+(NSString*)getTimeFromNowStr:(NSString*)dateString{
    
    //国际化版本不需要可以去掉
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *d=[date dateFromString:dateString];
//    NSTimeInterval late=[d timeIntervalSince1970]*1;
//    NSDate* dat = [NSDate date];
//    NSTimeInterval now=[dat timeIntervalSince1970]*1;
//    NSTimeInterval cha=now-late;
//    int second=cha;
//    int minute=second/60;
//    int hour=minute/60;
//    int day=hour/24;
//    int mounth=day/30;
//    int year=mounth/12;
//    
//    
//    
//    if (day!=0) {
//        
//        if (day>1) {
//            return [Utils appendString:[NSString stringWithFormat:@"%d",day] with:[[LanguageHelp share]loadStr:@"dayAgos"]];
//        }else{
//            return [Utils appendString:[NSString stringWithFormat:@"%d",day] with:[[LanguageHelp share]loadStr:@"dayAgo"]];
//        }
//        
//        
//    }
//    if (hour!=0) {
//        if (hour>1) {
//            return [Utils appendString:[NSString stringWithFormat:@"%d",hour] with:[[LanguageHelp share]loadStr:@"hourAgos"]];
//        }else{
//            return [Utils appendString:[NSString stringWithFormat:@"%d",hour] with:[[LanguageHelp share]loadStr:@"hourAgo"]];
//        }
//    }
//    if (minute!=0) {
//        if (minute>1) {
//            return [Utils appendString:[NSString stringWithFormat:@"%d",minute] with:[[LanguageHelp share]loadStr:@"minuteAgos"]];
//        }else{
//            return [Utils appendString:[NSString stringWithFormat:@"%d",minute] with:[[LanguageHelp share]loadStr:@"minuteAgo"]];
//        }
//    }
//    return [[LanguageHelp share]loadStr:@"now"];

    
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:dateString];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    int second=cha;
    int minute=second/60;
    int hour=minute/60;
    int day=hour/24;
    if (day!=0) {
        return [Utils appendString:[NSString stringWithFormat:@"%d",day] with:@"天前"];
    }
    if (hour!=0) {
        return [Utils appendString:[NSString stringWithFormat:@"%d",hour] with:@"小时前"];
    }
    if (minute!=0) {
        return [Utils appendString:[NSString stringWithFormat:@"%d",minute] with:@"分钟前"];
    }
    return @"刚刚";
}



+(NSString *)getAstroWithMonth:(int)m day:(int)d{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
//    if ([result isEqualToString:@"魔羯"]) {
//        result=[[LanguageHelp share]loadStr:@"moXie"];
//    }else if ([result isEqualToString:@"水瓶"]){
//        result=[[LanguageHelp share]loadStr:@"shuiPing"];
//    }else if ([result isEqualToString:@"双鱼"]){
//        result=[[LanguageHelp share]loadStr:@"shuangYu"];
//    }else if ([result isEqualToString:@"白羊"]){
//        result=[[LanguageHelp share]loadStr:@"baiYang"];
//    }else if ([result isEqualToString:@"金牛"]){
//        result=[[LanguageHelp share]loadStr:@"jinNiu"];
//    }else if ([result isEqualToString:@"双子"]){
//        result=[[LanguageHelp share]loadStr:@"shuangZi"];
//    }else if ([result isEqualToString:@"巨蟹"]){
//        result=[[LanguageHelp share]loadStr:@"juXie"];
//    }else if ([result isEqualToString:@"狮子"]){
//        result=[[LanguageHelp share]loadStr:@"shiZi"];
//    }else if ([result isEqualToString:@"处女"]){
//        result=[[LanguageHelp share]loadStr:@"chuNv"];
//    }else if ([result isEqualToString:@"天秤"]){
//        result=[[LanguageHelp share]loadStr:@"tianPing"];
//    }else if ([result isEqualToString:@"天蝎"]){
//        result=[[LanguageHelp share]loadStr:@"tianXie"];
//    }else if ([result isEqualToString:@"射手"]){
//        result=[[LanguageHelp share]loadStr:@"sheShou"];
//    }
    
    return result;
}

+(void)setViewHeight:(UIView*)view withHeight:(int)height{
    view.frame=CGRectMake(ViewFrameOriginX(view), ViewFrameOriginY(view), ViewFrameSizeW(view),height);
}

+(void)setviewPositonX:(UIView*)view withX:(int)x{
    view.frame=CGRectMake(x, ViewFrameOriginY(view), ViewFrameSizeW(view),ViewFrameSizeH(view));
}

+(void)setViewWidth:(UIView*)view withWidth:(int)width{
    view.frame=CGRectMake(ViewFrameOriginX(view), ViewFrameOriginY(view), width,ViewFrameSizeH(view));
}

+(void)viewYAdd:(UIView*)view withAddNum:(int)move{
    view.frame=CGRectMake(ViewFrameOriginX(view), ViewFrameOriginY(view)+move, ViewFrameSizeW(view),ViewFrameSizeH(view));
}

+(void)setviewPositonY:(UIView*)view withY:(int)y{
    view.frame=CGRectMake(ViewFrameOriginX(view), y, ViewFrameSizeW(view),ViewFrameSizeH(view));
}

+(NSString*)getCurrentTime{
    NSDateFormatter * formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateTime=[formate stringFromDate:[NSDate date]];
    
    return dateTime;
}

//获取内网ip地址
+(NSString*)getIpAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}


+(void)registerNotification{
    
    NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
    NSString* const NotificationActionOneIdent = @"ACTION_ONE";
    NSString* const NotificationActionTwoIdent = @"ACTION_TWO";
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

+(BOOL)isSameDay:(int)year withMonth:(int)month withDay:(int)day{
    NSDate * date=[NSDate date];
    
    return year==date.year&&month==date.month&&day==date.day;
}

+(void)toSafari:(NSString*)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (CGSize)boundingRectWithSize:(CGSize)size withStr:(NSString*)str withFont:(UIFont*)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [str boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}


+(BOOL)isFutureTime:(NSString*)year withMonth:(NSString*)month withDay:(NSString*)day{
    NSDate * dateNow=[NSDate date];
    if (year.intValue<dateNow.year) {
        return NO;
    }
    
    if (year.intValue>dateNow.year) {
        return YES;
    }
    
    if (month.intValue>dateNow.month) {
        return YES;
    }
    
    if (month.intValue<dateNow.month) {
        return NO;
    }
    
    if (day.intValue>dateNow.day) {
        return YES;
    }
    
    
    
    return NO;
}

+(BOOL)isFutureTime:(NSDate*)date{
    return [self isFutureTime:[self intToString:date.year] withMonth:[self intToString:date.month] withDay:[self intToString:date.day]];
}

+(BOOL)isAllowToPush{
    
    if (IS_IOS_VERSION_8) {
        UIUserNotificationType type=[[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if (type==UIUserNotificationTypeNone) {
            return NO;
        }else{
            return YES;
        }
    }
    UIRemoteNotificationType type=[[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    if (type==UIRemoteNotificationTypeNone) {
        return NO;
    }
    return YES;
}

+(void)copyToPast:(NSString*)str{
    [[UIPasteboard generalPasteboard] setPersistent:YES];
    [[UIPasteboard generalPasteboard] setValue:str forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
}



+(void)showStatusBarProgress{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+(void)hideStatusBarProgress{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

+(void)toSettingView{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+(NSString*)hanZiToPinyin:(NSString*)str{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
    if ([str length]) {
        
        //得到拼音带音节
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
//            NSLog(@"pinyin: %@", ms);
        }
        //得到拼音
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
//            NSLog(@"pinyin: %@", ms);
        }
    }
    
    
    NSString * result=[NSString stringWithFormat:@"%@",ms];
    
    return result;
}

+(NSString*)hanZiToPinyinFir:(NSString*)str{
    NSString * result=[self hanZiToPinyin:str];
    
    if ([self isEmpty:result]) {
        return @"";
    }
    
    return [result substringToIndex:1];
}


@end
