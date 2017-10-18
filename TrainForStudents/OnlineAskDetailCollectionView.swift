//
//  OnlineAskDetailCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/4.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class OnlineAskDetailCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentView = UIViewController()
    
    var jsonDataSource = [JSON]()
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return jsonDataSource.count
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        
        let btn = cell.viewWithTag(10001) as! UIButton
        btn.setTitle(json["creater"].stringValue, for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
        
        var lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = json["createtime"].stringValue
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = json["answercontent"].stringValue
        //通过文本设置label的行数
        lbl.numberOfLines = (lbl.text?.getLineNumberForWidth(width: lbl.frame.width - 5))!
        //通过行数设置label的高度
        lbl.frame.size = CGSize(width: lbl.frame.width, height: (lbl.text?.getHeight(font: lbl.font))!)
        
        return cell
    }
    
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let json = jsonDataSource[indexPath.item]
        let str = json["anwsercontent"].stringValue
        //40是lebel左右两边的间距
        let lblWidth = UIScreen.width - 40
        //通过文本计算cell的高度
        let lineNumber = str.getLineNumberForWidth(width: lblWidth - 5)
        //70是lebel上下间距的总和
        let height = 70 + UILabel.getDefaultLineHeight().multiplied(by: CGFloat(lineNumber))
        
        return CGSize(width: UIScreen.width , height: height )
        
    }
    
    
    
}
