//
//  RadioCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/15.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RadioCollectionView : PeiwuCollectionView{

    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cell = UICollectionViewCell.init()
        let a = jsonDataSource["answers"].arrayValue
        var data = JSON.init("")
        if 0 == indexPath.item{
            let cellName = "c1"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
            //获取数据
            data = jsonDataSource
            let qid = data["questionsid"].stringValue
            //渲染问题
            let lbl = (cell.viewWithTag(10001) as? UILabel)!
            var title = data["indexname"].stringValue + " " + data["title"].stringValue
            lbl.text = title
            
            lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - boundary, cFont: (lbl.font)!)
            lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
            
            if qid == selectedQuestionId{
                lbl.textColor = UIColor.init(hex: "68adf6")
            }
            //获取题目对应被选的答案
            let inputanswer = parentView?.anwserDic[qid]?["inputanswer"]
            if inputanswer != nil{
                //在题目结尾展示答案
                title.insert(Character.init(inputanswer!), at: title.index(before: title.endIndex))
                lbl.text = title
            }
            //被选中则需要把题目对应被选中的答案也带出来
            selectedDic[qid] = parentView?.anwserDic[qid]?["inputanswer"]

        }else{
            let cellName = "c2"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
            cell.tag = 0
            //获取数据
            data = a[indexPath.item - 1]
            let questionId = jsonDataSource["questionsid"].stringValue
            var anwserDic = parentView?.anwserDic[questionId]
            //渲染选项
            let btn = (cell.viewWithTag(10001) as? UIButton)!
            btn.layer.cornerRadius = btn.frame.width / 2
            btn.setTitle(data["selecttab"].stringValue, for: .normal)
            //关闭按钮动画
//            btn.adjustsImageWhenDisabled = false
//            btn.adjustsImageWhenHighlighted = false
//            btn.showsTouchWhenHighlighted = false
//            btn.reversesTitleShadowWhenHighlighted = false
            let lbl = (cell.viewWithTag(10002) as? UILabel)!
            let title = data["answervalue"].stringValue
            lbl.text = title
            lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - boundary, cFont: (lbl.font)!)
            var y = lbl.frame.origin.y
            if lbl.numberOfLines >= 2{
               y = btn.frame.origin.y
            }
            lbl.frame.origin = CGPoint(x: lbl.frame.origin.x, y: y)
            lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
            
            if anwserDic != nil{
                if btn.currentTitle == anwserDic!["inputanswer"]{
                    btn.setTitleColor(UIColor.white, for: .normal)
                    btn.backgroundColor = UIColor.init(hex: "ffc84c")
                }else{
                    btn.setTitleColor(UIColor.init(hex: "5ea3f3"), for: .normal)
                    btn.backgroundColor = UIColor.init(hex: "f5f8fb")
                }
            }else{
                btn.setTitleColor(UIColor.init(hex: "5ea3f3"), for: .normal)
                btn.backgroundColor = UIColor.init(hex: "f5f8fb")
            }
            
        }
        
        print("cell.tag=\(cell.tag)")
        return cell
        
    }
    
    //计算cell大小
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var labelWidth = UIScreen.width - 40 - boundary
        let a = jsonDataSource["answers"].arrayValue
        var lineHeight = CGFloat()
        var data = JSON.init("")
        var text = ""
        let index = indexPath.item
        var minHeight = CGFloat(40)
        
        //判断是题目还是答案
        if 0 == index{
            data = jsonDataSource
            text = data["indexname"].stringValue + " " + data["title"].stringValue
        }else{
            labelWidth = UIScreen.width - 40 - 35 - 8 - boundary
            data = a[index - 1]
            text = data["answervalue"].stringValue
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
    
    //cell被选中
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let questionId = jsonDataSource["questionsid"].stringValue
        var anwserDic = parentView?.anwserDic[questionId]
        if anwserDic == nil{
            anwserDic = getAnwserJson(json: jsonDataSource)
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        let btn = cell?.viewWithTag(10001) as! UIButton
        if cell?.tag == 0 {
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = UIColor.init(hex: "ffc84c")
            anwserDic?["inputanswer"] = btn.currentTitle
            cell?.tag = 1
        }else{
            btn.setTitleColor(UIColor.init(hex: "5ea3f3"), for: .normal)
            btn.backgroundColor = UIColor.init(hex: "f5f8fb")
            anwserDic?["inputanswer"] = ""
            cell?.tag = 0
        }
        parentView?.anwserDic[questionId] = anwserDic
        parentView?.questionCollection.reloadData()
        
    }
    
    
}
