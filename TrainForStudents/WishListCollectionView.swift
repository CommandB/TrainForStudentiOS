//
//  WishListCollection.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/29.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WishListCollectionView : MyBaseCollectionView{
    
    var parentView : WishListController? = nil
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        let json = jsonDataSource[indexPath.item]
        let state = json["state"].intValue
        var cell = UICollectionViewCell()
        
        if state <= 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c2", for: indexPath)
        }
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["wishcontent"].stringValue
        lbl = cell.viewWithTag(10002) as! UILabel
        switch state {
        case 0:
            lbl.text = "未安排"
            break
        case 1:
            lbl.text = "待安排"
            break
        case 2:
            lbl.text = "已安排"
            break
        case 3:
            lbl.text = "已结束"
            break
        case 99:
            lbl.text = "已取消"
            break
        default:
            break
        }
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = json["createtimeshow"].stringValue
        
        if state >= 2 {
            lbl = cell.viewWithTag(30001) as! UILabel
            lbl.text = json["managetimeshow"].stringValue
        }
        
        return cell
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = getViewToStoryboard("wishDetailView") as! WishDetailController
        vc.wishView.jsonDataSource = jsonDataSource[indexPath.item]
        parentView?.present(vc, animated: true, completion: nil)
        
    }
    
    //计算大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if jsonDataSource.count == 0 {
            return CGSize.init(width: UIScreen.width, height: 55)
        }
        
        var height = 0
        let json = jsonDataSource[indexPath.item]
        if json["state"].intValue <= 1 {
            height = 75
        }else{
            height = 105
        }
        return CGSize.init(width: UIScreen.width, height: CGFloat(height))
    }
    
    override func refresh() {
        initLimitPage()
        parentView?.wishCollection.reloadData()
        parentView?.getWishList()
    }
    
    override func loadMore() {
        parentView?.getWishList()
    }
    
}
