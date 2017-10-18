//
//  DifficultListCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/1.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DifficultListCollectionView : MyBaseCollectionView{
    
    var parentView : DifficultListController? = nil
    var isMine = false
    
    //实现UICovarctionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["title"].stringValue
        let image = cell.viewWithTag(10002) as! UIImageView
        if json["ishot"].stringValue == "0"{
            image.isHidden = true
        }else{
            let imageX = lbl.frame.origin.x + (lbl.text?.getWidth(font: lbl.font))! + 5
            let imageOrigin = CGPoint(x: imageX, y: image.frame.origin.y)
            image.frame = CGRect(origin: imageOrigin, size: image.frame.size)
        }
        
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = "\(json["content"])"
        
        lbl = cell.viewWithTag(30001) as! UILabel
        lbl.text = "\(json["creater"].stringValue) · \(json["createtime"].stringValue)"
        
        lbl = cell.viewWithTag(30002) as! UILabel
        lbl.text = "\(json["answers"].count) 回答"
        
        
        return cell
    }
    
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.width - 10, height: 130)
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item < jsonDataSource.count{
            let vc = getViewToStoryboard("difficultDetailView") as! DifficultDetailController
            vc.headData = jsonDataSource[indexPath.item]
            parentView?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    override func refresh() {
        if isMine{
            parentView?.mineView.initLimitPage()
            parentView?.getMineDatasource()
        }else{
            parentView?.officeView.initLimitPage()
            parentView?.getOfficeDatasource()
        }
    }
    
    override func loadMore() {
        if isMine{
            parentView?.getMineDatasource()
        }else{
            parentView?.getOfficeDatasource()
        }
    }
    
    override func initLimitPage() {
        super.initLimitPage()
        if isMine{
            parentView?.mineCollection.reloadData()
        }else{
            parentView?.officeCollection.reloadData()
        }
    }
    
}

