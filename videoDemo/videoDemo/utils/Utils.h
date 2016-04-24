//
//  Utils.h
//  AVPlayerDemo
//
//  Created by Yx on 15/9/8.
//  Copyright © 2015年 WuhanBttenMobileTechnologyCo.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utils : NSObject

/**
 *  @brief  检验是否是邮箱账号
 *
 *  @param email 邮箱字符串
 *
 *  @return 返回结果
 */
+(BOOL)isEmail:(NSString*)email;


/**
 *  @author StoneMover, 15-08-27 10:08:20
 *
 *  @brief  提示信息展示
 *
 *  @param message 需要展示的信息
 *  @param view    当前view
 */
+(void)showMessage:(NSString*)message setView:(UIViewController*)view;

/**
 *  @author StoneMover, 15-08-27 10:08:00
 *
 *  @brief  得到状态栏的高度
 *
 *  @return 返回高度
 */
+(int)getStatusbarHeight;

/**
 *  @author StoneMover, 15-08-27 10:08:14
 *
 *  @brief  得到屏幕高度
 *
 *  @return 返回高度
 */
+(int)getScreenHeight;

/**
 *  @author StoneMover, 15-08-27 10:08:32
 *
 *  @brief  得到屏幕宽度
 *
 *  @return 宽度
 */
+(int)getScreenWidth;

/**
 *  @author StoneMover, 15-08-27 10:08:45
 *
 *  @brief  判断是否是手机号码
 *
 *  @param number 传入手机号码
 *
 *  @return 结果
 */
+(BOOL)isMobilePhoneNum:(NSString*)number;
/**
 *  @author StoneMover, 15-09-10 20:09:42
 *
 *  @brief  去除86等国家区号
 *
 *  @param num 传入的电话号码
 *
 *  @return 返回值
 */
+(NSString*)removeCountryNum:(NSString*)num;

/**
 *  @author StoneMover, 15-09-16 10:09:04
 *
 *  @brief  判断是否是空字符串
 */
+(BOOL)isEmpty:(NSString*)str;

/**
 *  @author StoneMover, 15-09-16 10:09:22
 *
 *  @brief  得道label高度
 *
 *  @param label
 *
 *  @return
 */
+(int)getLableHeight:(UILabel*)label;


/**
 *  @author StoneMover, 15-09-16 10:09:42
 *
 *  @brief  字符串拼接
 */
+(NSString*)appendString:(NSString*)str with:(NSString*)mes;

+(NSString*)appendString:(NSString *)str , ...;

+(NSString*)intToString:(int)num;

+(NSString*)doubleToString:(double)num;

+(NSString*)appendString:(NSString*)str withInt:(int)mesInt;

/**
 *  @author StoneMover, 15-09-16 10:09:12
 *
 *  @brief  将字典或者数组转化为JSON串
 */
+(NSData *)toJSONData:(id)theData;

/**
 *  @author StoneMover, 15-09-16 10:09:24
 *
 *  @brief  json字符串转字典
 */
+(NSDictionary*)jsonTiDic:(NSString*)json;


/**
 *  @author StoneMover, 15-09-16 10:09:16
 *
 *  @brief  得到软件版本号
 */
+(NSString*)getAppVersion;

/**
 *  @author StoneMover, 15-09-16 10:09:30
 *
 *  @brief  传入rgb 255 255 255 得到对应的color 对象
 */
+(UIColor*)getRGB:(int)R withG:(int)G withB:(int)B;

/**
 *  @author StoneMover, 15-09-16 10:09:46
 *
 *  @brief  判断是否是iphone4 的屏幕尺寸
 */
+(BOOL)isIPhone4Screen;

/**
 *  @author StoneMover, 15-09-16 10:09:02
 *
 *  @brief  将RGB值转成16进制字符串,例如:255,255,255
 */
+(NSString*)ChangeRGB:(int)R withG:(int)G withB:(int)B;

/**
 *  @author StoneMover, 15-09-16 10:09:19
 *
 *  @brief  判断str 中是否包含某个字符
 */
+(BOOL)isContains:(NSString*)str with:(NSString*)mes;

/**
 *  @author StoneMover, 15-09-16 10:09:31
 *
 *  @brief  从xib中加载view
 */
+(UIView*)getViewFromLib:(NSString*)libName withOwer:(id)owner;

/**
 *  @author StoneMover, 15-09-16 10:09:45
 *
 *  @brief  得到一周中的第几天
 *
 */
+(NSString*)getWeekNum:(NSDate*)date;
/**
 *  @author StoneMover, 15-09-16 10:09:05
 *
 *  @brief  得到一周中的第几天
 */
+(int)getWeekNumInt:(NSDate*)date;

/**
 *  @author StoneMover, 15-09-16 10:09:52
 *
 *  @brief  得到一年中的第几个月
 *
 */
+(NSString*)getMonthNum:(NSDate*)date;
/**
 *  @author StoneMover, 15-09-16 10:09:01
 *
 *  @brief  得到一个月里面的第几天
 */
+(NSString*)getDayofMonthNum:(NSDate*)date;

/**
 *  @author StoneMover, 15-09-16 10:09:18
 *
 *  @brief 得到年份
 */
+(NSString*)getYear:(NSDate*)date;

/**
 *  @author StoneMover, 15-09-16 10:09:37
 *
 *  @brief  得到系统版本号 ios 8.1
 */
+(NSString*)getSysVerstion;

/**
 *  @author StoneMover, 15-09-16 10:09:49
 *
 *  @brief  得到手机的型号,例如iphone4s
 */
+(NSString*)getPhoneModel;

/**
 *  @author StoneMover, 15-09-16 10:09:58
 *
 *  @brief  得到设备号
 */
+(NSString*)getDeviceNum;

/**
 *  @author StoneMover, 15-09-16 10:09:14
 *
 *  @brief  设置应用程序图标上的数字
 */
+(void)setAppIconNotifiNum:(NSString*)num;

/**
 *  @author StoneMover, 15-09-16 10:09:24
 *
 *  @brief  将阿拉伯数字转为中文汉字,目前只能1-7的转换
 */
+(NSString*)aLaBoToHanZi:(NSString*)str;

/**
 *  @author StoneMover, 15-09-16 10:09:38
 *
 *  @brief  将图片变成圆形图片
 */
+(void)imageViewCircle:(UIImageView*)imageView;

/**
 *  @author StoneMover, 15-09-16 10:09:53
 *
 *  @brief  将图片变成圆形图片
 */
+(void)imageViewCircle:(UIImageView*)imageView withBorderColor:(UIColor*)color withBorderWidth:(int)width;

/**
 *  @author StoneMover, 15-09-16 10:09:05
 *
 *  @brief  将空字符串转为 ""
 */
+(NSString*)autoNull:(NSString*)content;

/**
 *  @author StoneMover, 15-09-16 10:09:17
 *
 *  @brief  得到传入时间距离现在的时间显示字符串
 */
+(NSString*)getTimeFromNowStr:(NSString*)dateString;

/**
 *  @author StoneMover, 15-09-16 10:09:27
 *
 *  @brief  传入月和日得到星座
 */
+(NSString *)getAstroWithMonth:(int)m day:(int)d;

/**
 *  @author StoneMover, 15-09-16 10:09:40
 *
 *  @brief  设置view的高度
 */
+(void)setViewHeight:(UIView*)view withHeight:(int)height;
/**
 *  @author StoneMover, 15-09-16 10:09:53
 *
 *  @brief
 *
 *  @param view 设置view的x坐标
 */
+(void)setviewPositonX:(UIView*)view withX:(int)x;

/**
 *  @author StoneMover, 15-09-16 10:09:32
 *
 *  @brief  在view现有坐标上移动move个单位
 */
+(void)viewYAdd:(UIView*)view withAddNum:(int)move;

/**
 *  @author StoneMover, 15-09-16 10:09:56
 *
 *  @brief  设置view的y坐标
 */
+(void)setviewPositonY:(UIView*)view withY:(int)y;

/**
 *  @author StoneMover, 15-09-16 10:09:09
 *
 *  @brief  设置view的宽度
 */
+(void)setViewWidth:(UIView*)view withWidth:(int)width;

/**
 *  @author StoneMover, 15-09-16 10:09:26
 *
 *  @brief  得到当前时间 yyyy-MM-dd HH:mm:ss
 */
+(NSString*)getCurrentTime;

/**
 *  @author StoneMover, 15-09-16 10:09:38
 *
 *  @brief  得到ip地址
 */
+(NSString*)getIpAddress;

/**
 *  @author StoneMover, 15-09-16 10:09:50
 *
 *  @brief  生成范围from到to之间的随机数,可以用来生成随机验证码
 */
+(int)getRandomNumber:(int)from to:(int)to;

/**
 *  @author StoneMover, 15-08-27 11:08:57
 *
 *  @brief  注册apns推送代码
 */
+(void)registerNotification;

/**
 *  @author StoneMover, 15-08-31 18:08:52
 *
 *  @brief  判断是否是同一天
 */
+(BOOL)isSameDay:(int)year withMonth:(int)month withDay:(int)day;
/**
 *  @author StoneMover, 15-09-01 14:09:02
 *
 *  @brief  跳转到浏览器
 *
 *  @param url 需要打开的地址
 */
+(void)toSafari:(NSString*)url;
/**
 *  @author StoneMover, 15-09-05 19:09:32
 *
 *  @brief  计算label的高度
 */
+ (CGSize)boundingRectWithSize:(CGSize)size withStr:(NSString*)str withFont:(UIFont*)font;

/**
 *  @author StoneMover, 15-09-06 17:09:07
 *
 *  @brief  判断是未来的时间
 */
+(BOOL)isFutureTime:(NSString*)year withMonth:(NSString*)month withDay:(NSString*)day;
+(BOOL)isFutureTime:(NSDate*)date;
/**
 *  @author StoneMover, 15-09-07 10:09:20
 *
 *  @brief  判断是否打开推送
 */
+(BOOL)isAllowToPush;

/**
 *  @author StoneMover, 15-09-07 15:09:56
 *
 *  @brief  将内容复制道粘贴板
 */
+(void)copyToPast:(NSString*)str;

/**
 *  @author StoneMover, 15-09-10 17:09:32
 *
 *  @brief  StatusBarProgress 显示隐藏
 */

+(void)showStatusBarProgress;

+(void)hideStatusBarProgress;

/**
 *  @author StoneMover, 15-09-11 16:09:04
 *
 *  @brief  跳转道设置界面
 */
+(void)toSettingView;

/**
 *  @author StoneMover, 15-09-25 10:09:03
 *
 *  @brief  汉字转拼音
 *
 *  @param str 传入字符串
 *
 *  @return 返回拼音
 */
+(NSString*)hanZiToPinyin:(NSString*)str;
/**
 *  @author StoneMover, 15-09-25 10:09:44
 *
 *  @brief  获取拼音的首字符
 */
+(NSString*)hanZiToPinyinFir:(NSString*)str;
@end
