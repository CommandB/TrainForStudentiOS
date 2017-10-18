//
//  QuestionCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/12.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class QuestionCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var cellTotal = 0
    var parentView : ExamViewController?
    var jsonDataSource = JSON.init("{}")
    var myCollection : UICollectionView?
    let questionFont = UIFont.systemFont(ofSize: 15)
    let boundary = CGFloat(9)
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cellTotal
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cellName = "c1"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
//        let json = jsonDataSource[indexPath.item]
//        
//        let lbl = (cell.viewWithTag(10001) as? UILabel)!
//        let title = json["title"].stringValue
//        lbl.text = title
//        lbl.numberOfLines = title.getLineNumberForWidth(width: lbl.frame.width - 15, cFont: (lbl.font)!)
//        lbl.frame.size = CGSize(width: lbl.frame.size.width, height: getHeightForLabel(lbl: lbl))
        
        return cell
        
    }
    
    
    ///根据lbl的lineNumbner计算lbl的高度
    func getHeightForLabel(lbl : UILabel) -> CGFloat{
        
        return CGFloat(lbl.numberOfLines * 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let labelWidth = UIScreen.width - 40
        let json = jsonDataSource[indexPath.item]
        let title = json["title"].stringValue
        var lineHeight = title.getHeight(font:questionFont)
        let lineNumber = title.getLineNumberForWidth(width: labelWidth, cFont: questionFont)
        lineHeight.multiply(by: CGFloat(lineNumber))
        lineHeight.add(CGFloat(20))
        return CGSize(width: UIScreen.width, height: lineHeight)
        
        
    }
    
    //cell被选中
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    func getAnwserJson(json : JSON) -> Dictionary<String,String>{
        var result = [String:String]()
        result["questionsid"] = json["questionsid"].stringValue
        result["score"] = json["score"].stringValue
        result["answervalue"] = json["answervalue"].stringValue
        
        return result
        
    }
    


}
