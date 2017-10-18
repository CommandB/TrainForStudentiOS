//
//  SettingsCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit


class SettingsCollectionView : MyBaseCollectionView{
    
    var parentView : SettingsController? = nil
    
    //设置每个分区元素的个数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 2
        
    }
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cellName = "c\(indexPath.item + 1)"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        
        
        return cell
        
    }
    
    //cell被选中
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let t = cell?.tag{
            switch t {
            case 10001:
                myPresentView(parentView!, viewName: "changePersonInfoView")
            case 10002:
                myPresentView(parentView!, viewName: "changePasswordView")
            case 10003:
                break
            default:
                break
            }
        }
        
    }
    
    //计算大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: UIScreen.width, height: 40)
    }
    
    
}
