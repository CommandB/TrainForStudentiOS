//
//  HistoryExamCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HistoryExamCollectionView : MyBaseCollectionView{
    
    var parentVC = UIViewController()
    
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        let cellName = "c1"
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        
        var lbl = cell.viewWithTag(10001) as? UILabel
        lbl?.text = json["exercisestitle"].stringValue
        lbl = cell.viewWithTag(20001) as? UILabel
        lbl?.text = "考试时间  \(json["starttime"].stringValue)"
        lbl = cell.viewWithTag(20002) as? UILabel
        lbl?.text = "\(json["exercisesscore"].intValue)"
        
        
        return cell
        
    }
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.width, height: 85)
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}
