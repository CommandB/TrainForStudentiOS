//
//  OnlineAskCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/4.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class OnlineAskCollectionView : MyBaseCollectionView{
    
    var parentView : OnlineAskController? = nil

    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["title"].stringValue
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = ""
        if json["answers"].count != 0 {
            let answers = json["answers"].arrayValue
            lbl.text = answers[0]["answercontent"].stringValue
            lbl.numberOfLines = 2
        }
        
        return cell
    }
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.width , height: 100 )
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(parentView?.keyBoardHidden)!{
            parentView?.hiddenKeyBoard()
            return
        }
        
        if showNoDataCell{
            return
        }
        let vc = getViewToStoryboard("onlineAskDetailView") as! OnlineAskDetailController
        vc.headData = jsonDataSource[indexPath.item]
        parentView?.present(vc, animated: true, completion: nil)
        parentView?.player.pause()
        
    }
    
    override func refresh() {
        super.initLimitPage()
        if (parentView?.btn_toggle)!{
            parentView?.getAllDataSource()
        }else{
            parentView?.getMineDataSource()
        }
    }
    
    override func loadMore() {
        if (parentView?.btn_toggle)!{
            parentView?.getAllDataSource()
        }else{
            parentView?.getMineDataSource()
        }
    }
    
}


