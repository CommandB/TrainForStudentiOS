//
//  TaskApplyDetailImageCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/15.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TaskApplyDetailImageCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentView : TaskApplyDetailController? = nil
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        //显示图片
        let imgView = cell.viewWithTag(10001) as! UIImageView
        do{
            try imgView.image = UIImage(data: Data(contentsOf: URL(string:jsonDataSource[indexPath.item]["url"].stringValue)!))
        }catch{
            
        }
        
        return cell
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    //计算大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 70, height: 70 )
    }
    
    
}
