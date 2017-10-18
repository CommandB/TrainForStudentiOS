//
//  File.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/5.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit


class CircleDataView: UIView {
    
    var fontSize:CGFloat = 13
    // default = 4
    var lineSize:CGFloat = 4
    var process:CGFloat = 0
    var label1Text = ""
    var label2Text = ""
    @IBInspectable var  progress:CGFloat{
        get{
            return process
        }
        set(newval) {
            let val = newval * 6.285
//            let val = newval * 360
            self.process = val
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // println("开始画画.........")
        
        
        //获取画图上下文
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        
        
        //移动坐标
        let x = frame.size.width/2
        let y = frame.size.height/2
        
        let center = CGPoint.init(x: x, y: y)
        
        
        
        // println("\(process)...............")
        
        let width = CGFloat.init(18)
        let height = CGFloat.init(18)
        let textX = frame.size.width/4
        let textY = frame.size.height/2 - height/2
        
        let label = UILabel()
        label.frame = CGRect.init(x: textX, y: textY, width: width , height: height)
        label.text = label1Text
        label.textColor = UIColor.red
        label.textAlignment = .center
        //label.backgroundColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(label)
        
        let label2 = UILabel()
        label2.frame = CGRect.init(x: textX+width-2, y: textY, width: width+5 , height: height)
        label2.text = label2Text
        label2.textColor = UIColor.darkText
        //label2.backgroundColor = UIColor.green
        label2.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(label2)
        
        
        //灰色圆圈
        var radius = frame.size.width/2 - 5
        context.setLineWidth(0)
        context.setStrokeColor(UIColor.gray.cgColor)
        
        context.addArc(center: center, radius: radius-4, startAngle: 0, endAngle: 360, clockwise: false)
        context.drawPath(using: .stroke)
        
        //背景圆
//        context.setLineWidth(lineSize)
//        context.setStrokeColor(UIColor(hex:"407BD8").cgColor)
//        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: 360, clockwise: false)
//        context.drawPath(using: .stroke)
        
        //进度条圆
//        context.setStrokeColor(UIColor.red.cgColor)
//        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: process, clockwise: false)
//        context.drawPath(using: .stroke)
        
        radius = frame.size.width / 4
//        lineSize = frame.size.width / 2
        lineSize = radius * 2
        //背景圆
        context.setLineWidth(lineSize)
        context.setStrokeColor(UIColor(hex:"407BD8").cgColor)
        context.setFillColor(UIColor(hex:"407BD8").cgColor)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: 360, clockwise: false)
        context.drawPath(using: .stroke)
        
        //进度条圆
        context.setStrokeColor(UIColor(hex: "74C0E0").cgColor)
        context.setFillColor(UIColor(hex: "74C0E0").cgColor)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: process, clockwise: false)
        context.drawPath(using: .stroke)
        
        
        // println("结束画画........")
    }
    
}
