//
//  AssistantCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/12.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AssistantCollectionView: UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentView : UIViewController? = nil
    
    var jsonDataSource = JSON("")
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return jsonDataSource.count
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        let json = jsonDataSource[indexPath.item]
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["personname"].stringValue
        lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = json["phoneNo"].stringValue
        lbl = cell.viewWithTag(10003) as! UILabel
        lbl.text = json["signresultshow"].stringValue
    
    
        return cell
        
    }
    
    //cell被选中
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
    //计算cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    
    
}
