//
//  WishDetailConllectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/29.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WishDetailCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentVC = UIViewController()
    var jsonDataSource = JSON.init("")
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if jsonDataSource["state"].intValue < 2{
            return 1
        }else{
            return 2
        }
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = UICollectionViewCell()
        if indexPath.item == 0{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
            
            var lbl = cell.viewWithTag(10001) as! UILabel
            lbl.text = jsonDataSource["typename"].stringValue
            lbl = cell.viewWithTag(10002) as! UILabel
            lbl.text = jsonDataSource["stateshow"].stringValue
            lbl = cell.viewWithTag(20001) as! UILabel
            lbl.text = jsonDataSource["manageroleshow"].stringValue
            lbl = cell.viewWithTag(30001) as! UILabel
            lbl.text = jsonDataSource["createtimeshow"].stringValue
            lbl = cell.viewWithTag(40001) as! UILabel
            lbl.text = jsonDataSource["wishcontent"].stringValue
            let str = jsonDataSource["wishcontent"].stringValue
            //计算多行label的高度
            lbl.numberOfLines = str.getLineNumberForWidth(width: lbl.frame.width - 5)
            lbl.frame.size = CGSize.init(width: lbl.frame.width, height: UILabel.getDefaultLineHeight().multiplied(by: CGFloat(lbl.numberOfLines)))
            
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c2", for: indexPath)
            
            var lbl = cell.viewWithTag(10001) as? UILabel
            lbl?.text = jsonDataSource["tasktitle"].stringValue
            lbl = cell.viewWithTag(20001) as? UILabel
            lbl?.text = jsonDataSource["taskstarttimeshow"].stringValue
            lbl = cell.viewWithTag(30001) as? UILabel
            lbl?.text = jsonDataSource["taskendtimeshow"].stringValue
            lbl = cell.viewWithTag(40001) as? UILabel
            lbl?.text = jsonDataSource["taskaddress"].stringValue
        }
        
        
        return cell
        
    }
    
    
    //计算大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let str = jsonDataSource["wishcontent"].stringValue
            
            //计算多行label的高度
            let lineNumber = str.getLineNumberForWidth(width: UIScreen.width - 86 - 13 - 5)
            let lblHeight = UILabel.getDefaultLineHeight().multiplied(by: CGFloat(lineNumber))
            return CGSize.init(width: UIScreen.width, height: 140 + lblHeight - 20)
        }else{
            return CGSize.init(width: UIScreen.width, height: 140)
        }
    }
    
    
}
