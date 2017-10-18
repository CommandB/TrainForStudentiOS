//
//  DateUtil.swift
//  SRM
//
//  Created by 黄玮晟 on 16/7/14.
//  Copyright © 2016年 黄玮晟. All rights reserved.
//

import Foundation
import SwiftDate

class DateUtil{

    static let dayToSecond=86400
    static let hourToSecond=3600
    static let minuteToSecond=60
    //默认日期格式化参数
    static let datePattern="yyyy-MM-dd"
    static let dateTimePattern="yyyy-MM-dd HH:mm:ss"
    static let dateTimeSecondPattern="yyyy-MM-dd HH:mm:ss.s"
    
    ///自定义pattern
    static func formatString(_ dateStr:String,pattern:String) ->Date{
        do{
            return try dateStr.date(format: DateFormat.custom(pattern)).absoluteDate
        }catch{
            print("格式化日期异常...")
        }
        return Date()
    }
    
    ///格式化符合yyyy-MM-dd格式的字符串
    static func stringToDate(_ dateStr:String) -> Date{
        do{
            return try dateStr.date(format: DateFormat.custom(datePattern)).absoluteDate
        }catch{
            print("格式化日期异常...")
        }
        return Date()
    }
    
    ///格式化符合yyyy-MM-dd HH:mm:ss格式的字符串
    static func stringToDateTime(_ dateTimeStr:String) -> Date{
        do{
            return try dateTimeStr.date(format: DateFormat.custom(dateTimePattern)).absoluteDate
        }catch{
            print("格式化日期异常...")
        }
        return Date()
    }
    
    ///格式化日期 精确到分钟
    static func stringToDateToMinute(_ dateStr : String) -> String{
        return DateUtil.formatDate(DateUtil.stringToDateTime(dateStr), pattern: "yyyy-MM-dd HH:mm")
    }
    
    
    static func formatDate(_ date:Date,pattern:String) -> String {
        return date.string(format: DateFormat.custom(pattern))
//        return date.toString(format: DateFormatter.custom(pattern))
    }
    
    static func dateToString(_ date:Date) -> String {
        return date.string(format: DateFormat.custom(datePattern))
//        return date.toString(format: DateFormatter.custom(datePattern))
    }
    
    static func dateTimeToString(_ date:Date) -> String{
        return date.string(format: DateFormat.custom(dateTimePattern))
    }
    
    ///获取字符串格式的当前日期
    static func getCurrentDate() -> String{
        return dateToString(Date())
    }
    
    ///获取字符串格式的当前日期时间
    static func getCurrentDateTime() -> String{
        return dateTimeToString(Date())
    }

    ///计算两个日前相隔的"日,时,分"
    static func intervalDate(_ from:String ,to:String , pattern:String ) ->(day:Int,hour:Int,minute:Int) {

        //返回值
        var result=(day:0,hour:0,minute:0);
        //把参数赋值给成员变量
        
        var fromDate = formatString(from, pattern: pattern)
        let toDate = formatString(to, pattern: pattern)
        //初始化calendar
        let calendar=Calendar(identifier:Calendar.Identifier.gregorian)

        //计算相隔天数
        let intervalDay=(calendar as NSCalendar?)?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options(rawValue:0))
        //把天数增加 以便计算小时
        fromDate=fromDate+(intervalDay?.day?.day)!


        //计算除天数外的小时数数
        let intervalHour=(calendar as NSCalendar?)?.components(NSCalendar.Unit.hour, from: fromDate, to: toDate, options: NSCalendar.Options(rawValue:0))
        //把分钟数增加 以便计算分钟数
        fromDate=fromDate+(intervalHour?.hour?.hour)!


        //计算出天数外的分钟数
        let intervalMinute=(calendar as NSCalendar?)?.components(NSCalendar.Unit.minute, from: fromDate, to: toDate, options: NSCalendar.Options(rawValue:0))

        result=(day:(intervalDay?.day)!,hour:(intervalHour?.hour)!,minute:(intervalMinute?.minute)!);

        return result

    }

}
