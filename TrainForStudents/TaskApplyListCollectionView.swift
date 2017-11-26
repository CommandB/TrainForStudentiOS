//
//  TaskApplyListCollection.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/17.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TaskApplyListCollectionView : MyBaseCollectionView{
    
    var parentView : TaskApplyListController? = nil

    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["traincontent"].stringValue
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = "\(json["createtimeshow"].stringValue)"
        lbl = cell.viewWithTag(30001) as! UILabel
        lbl.text = json["stateshow"].stringValue
        
        switch json["state"].intValue {
        case 0: //待审批
            lbl.textColor = UIColor(hex: "3b454f")
        case 1: //通过
            lbl.textColor = UIColor(hex: "62a6e9")
        case 2: //被拒绝
            lbl.textColor = UIColor(hex: "f95050")
        case 3: //已取消
            lbl.textColor = UIColor(hex: "9ba6ae")
        default:
            lbl.textColor = UIColor(hex: "3b454f")
            break
        }
        
        return cell
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = jsonDataSource[indexPath.item]
        let vc = getViewToStoryboard("taskApplyDetailView") as! TaskApplyDetailController
        vc.headData = data
        parentView?.present(vc, animated: true, completion: nil)
        
    }
    
    //计算大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: UIScreen.width, height: 80 )
    }
    
    public override func refresh() {
        initLimitPage()
        parentView?.getTaskApplyList()
    }
    
    override func loadMore() {
        parentView?.getTaskApplyList()
    }
    
    
}
