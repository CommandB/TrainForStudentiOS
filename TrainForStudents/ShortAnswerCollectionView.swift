//
//  RecordsCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/15.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ShortAnswerCollectionView : QuestionCollectionView ,UITextViewDelegate{
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cell = UICollectionViewCell.init()
        var data = jsonDataSource
        if 0 == indexPath.item{
            let cellName = "c1"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
            //渲染问题
            let lbl = (cell.viewWithTag(10001) as? UILabel)!
            let title = data["indexname"].stringValue + " " + data["title"].stringValue
            lbl.text = title
            lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - boundary, cFont: (lbl.font)!)
            lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
        }else{
            let cellName = "c3"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
            let lbl = (cell.viewWithTag(10001) as? UILabel)!
            lbl.text = "请填写答案:"
            
            
            let answerDic = parentView?.anwserDic[jsonDataSource["questionsid"].stringValue]
            let textView = cell.viewWithTag(20001) as! UITextView
            textView.delegate = self
            textView.text = ""
            if answerDic != nil {
                textView.text = answerDic?["inputanswer"]
            }
            
            
        }
        
        
        return cell
        
    }
    
    //计算cell大小
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let labelWidth = UIScreen.width - 40 - boundary
        var lineHeight = CGFloat()
        var data = jsonDataSource
        var text = ""
        let index = indexPath.item
        let minHeight = CGFloat(40)
        
        //判断是题目还是答案
        if index == 0{
            data = jsonDataSource
            text = data["indexname"].stringValue + " " + data["title"].stringValue
            let lineNumber = text.getLineNumberForWidth(width: labelWidth, cFont: questionFont)
            lineHeight = text.getHeight(font:questionFont)
            lineHeight.multiply(by: CGFloat(lineNumber))
        }else{
            lineHeight = 140
        }
        
        
        if lineHeight < minHeight {
            lineHeight = minHeight
        }
        
        
        return CGSize(width: UIScreen.width, height: lineHeight)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let selectedQuestionId = jsonDataSource["questionsid"].stringValue
        parentView?.anwserDic[selectedQuestionId] = getAnwserJson(json: jsonDataSource)
        parentView?.anwserDic[selectedQuestionId]?["inputanswer"] = textView.text
        
    }
    
}
