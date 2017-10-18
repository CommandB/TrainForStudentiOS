//
//  RecordsAnalysis.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/16.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RecordsAnalysisCollectionView : QuestionCollectionView{
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cell = UICollectionViewCell.init()
        let subQ = jsonDataSource["sub_questions"].arrayValue
        var data = JSON.init("")
        if 0 == indexPath.item{
            let cellName = "c1"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
            //获取数据
            data = jsonDataSource
            //渲染问题
            let lbl = (cell.viewWithTag(10001) as? UILabel)!
            let title = data["indexname"].stringValue + " " + data["title"].stringValue
            lbl.text = title
            lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - boundary, cFont: (lbl.font)!)
            lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
        }else{
            let cellName = "c3"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
            //获取数据
            data = subQ[indexPath.item - 1]
            //渲染子题目
            let lbl = (cell.viewWithTag(10001) as? UILabel)!
            let title = data["indexname"].stringValue + " " + data["titile"].stringValue
            lbl.text = title
            lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - boundary, cFont: (lbl.font)!)
            lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
            let txt = cell.viewWithTag(20001) as! UITextView
            txt.frame.origin = CGPoint(x: txt.frame.origin.x, y: lbl.frame.height.adding(10))
            
        }
        
        
        return cell
        
    }
    
    //计算cell大小
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var labelWidth = UIScreen.width - 40 - boundary
        let subQ = jsonDataSource["sub_questions"].arrayValue
        var lineHeight = CGFloat()
        var data = JSON.init("")
        var text = ""
        let index = indexPath.item
        var minHeight = CGFloat(40)
        
        //判断是题目还是答案
        if index == 0{
            data = jsonDataSource
            text = data["indexname"].stringValue + " " + data["title"].stringValue
        }else{
            labelWidth = UIScreen.width - 40 - 35 - 8 - boundary
            data = subQ[index - 1]
            text = data["indexname"].stringValue + " " + data["title"].stringValue
            minHeight.add(10)  //答案选项的cell需要增加间距
        }
        let lineNumber = text.getLineNumberForWidth(width: labelWidth, cFont: questionFont)
        lineHeight = text.getHeight(font:questionFont)
        lineHeight.multiply(by: CGFloat(lineNumber))
        lineHeight.add(5)
        
        
        if lineHeight < minHeight {
            lineHeight = minHeight
        }
        
        
        return CGSize(width: UIScreen.width, height: lineHeight)
        
    }
    
}
