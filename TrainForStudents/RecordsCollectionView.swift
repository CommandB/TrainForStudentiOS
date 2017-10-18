//
//  ShortAnswerCollection.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/15.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RecordsCollectionView : QuestionCollectionView{
    
    //设置collectionView的分区个数
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let num = jsonDataSource["sub_questions"].arrayValue.count
        return num + 1
    }
    
    //设置每个分区元素的个数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let subQ = jsonDataSource["sub_questions"].arrayValue
        if section == 0{
            return 1
        }else{
            return subQ[section - 1]["answers"].arrayValue.count + 1
        }
        
    }
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cell = UICollectionViewCell.init()
        let subQ = jsonDataSource["sub_questions"].arrayValue
        var data = JSON.init("")
        if 0 == indexPath.section{
            
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
            
            if indexPath.item > 0{    //渲染子题目的答案
                let cellName = "c2"
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
                //获取数据
                let answersJson = subQ[indexPath.section - 1]["answers"].arrayValue
                data = answersJson[indexPath.item - 1]
                //渲染选项
                let btn = (cell.viewWithTag(10001) as? UIButton)!
                btn.layer.cornerRadius = btn.frame.width / 2
                btn.setTitle(data["selecttab"].stringValue, for: .normal)
                let lbl = (cell.viewWithTag(10002) as? UILabel)!
                let title = data["answervalue"].stringValue
                lbl.text = title
                lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - boundary, cFont: (lbl.font)!)
                lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
                
                
            }else{  //渲染子题目
                let cellName = "c1"
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
                //获取数据
                data = subQ[indexPath.section - 1]
                //渲染问题
                let lbl = (cell.viewWithTag(10001) as? UILabel)!
                let title = data["indexname"].stringValue + " " + data["title"].stringValue
                lbl.text = title
                lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - boundary, cFont: (lbl.font)!)
                lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
            }
            
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
        if indexPath.section == 0{
            data = jsonDataSource
            text = data["indexname"].stringValue + " " + data["title"].stringValue
            
        }else{
            
            if index > 0{    //渲染子题目的答案
                labelWidth = UIScreen.width - 40 - 35 - 8 - boundary
                let answersJson = subQ[indexPath.section - 1]["answers"].arrayValue
                data = answersJson[indexPath.item - 1]
                text = data["answervalue"].stringValue
                minHeight.add(10)  //答案选项的cell需要增加间距
                
            }else{
                data = subQ[indexPath.section - 1]
                text = data["indexname"].stringValue + " " + data["title"].stringValue
                
            }
            
            
        }
        var lineNumber = text.getLineNumberForWidth(width: labelWidth, cFont: questionFont)
        if lineNumber > 2 { //多加一行高度 显示的好看一些
            lineNumber += 1
        }
        lineHeight = text.getHeight(font:questionFont)
        lineHeight.multiply(by: CGFloat(lineNumber))
        lineHeight.add(5)
        
        
        if lineHeight < minHeight {
            lineHeight = minHeight
        }
        
        
        return CGSize(width: UIScreen.width, height: lineHeight)
        
    }
    
}
