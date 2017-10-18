//
//  StringExtension.swift
//  easyStore
//
//  Created by 黄玮晟 on 2017/3/28.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    
//    func substring(from: Int) -> String {
//        return self.substring(from: self.startIndex.advancedBy(from))
//    }
    
    
    ///string转sha1
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    
    
    
//    func substring(s: Int, _ e: Int?) -> String {
//        let start = s >= 0 ? self.startIndex : self.endIndex
//        let startIndex = start.advancedBy(s)
//        
//        var end: String.Index
//        var endIndex: String.Index
//        if(e == nil){
//            end = self.endIndex
//            endIndex = self.endIndex
//        } else {
//            end = e >= 0 ? self.startIndex : self.endIndex
//            endIndex = end.advancedBy(e!)
//        }
//        
//        let range = Range<String.Index>(startIndex..<endIndex)
//        return self.substringWithRange(range)
//        
//    }
    
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func getWidth(font : UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) -> CGFloat{
        return getSize(font: font).width
    }
    
    func getHeight(font : UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) -> CGFloat{
        return getSize(font: font).height
    }
    
    func getSize(font : UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) -> CGSize{
        
        
        let content = NSString(data: data(using: .utf8)!, encoding: String.Encoding.utf8.rawValue)
        let attr = [NSFontAttributeName:font]
        let size = CGSize(width: 99999, height: 99999)
        let rect = content?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attr, context: nil)
        
        return (rect?.size)!
    }
    
    ///根据字体大小以及设置的宽度计算字符串需要几行来显示
    func getLineNumberForWidth(width : CGFloat, cFont : UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) -> Int{
        
        var lineNumber = 0
        
        //获取字符串在一行时占的总宽度
        let contentWidth = getWidth(font: cFont)
        
        //计算需要几行
        let multipleF = contentWidth / width
        let multipleI = Int.init(multipleF)
        //判断是否有余数 需要加一行
        if multipleF > CGFloat.init(multipleI) {
            lineNumber = multipleI
            lineNumber = lineNumber+1
        }else{
            lineNumber = multipleI
        }
        
        return lineNumber
    }
    
    func getLineNumberForUILabel(_ lbl : UILabel) -> Int{
        return getLineNumberForWidth(width: lbl.frame.width, cFont: lbl.font)
    }
    
}
