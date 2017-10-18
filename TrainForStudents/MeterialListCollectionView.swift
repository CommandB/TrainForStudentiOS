//
//  MeterialListCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/6.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MeterialListCollectionView : MyBaseCollectionView{
    
    var parentView : MeterialListController? = nil
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["title"].stringValue
        lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = json["state_name"].stringValue
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = json["creater"].stringValue + "  " + json["createtime"].stringValue
        
        var v = arc4random() % 10
        
        while v >= 4 {
            v = arc4random() % 10
        }
        
        switch json["type"].intValue {
//        switch v {
        case 0: //视频
            let img = cell.viewWithTag(30001) as! UIImageView
            img.image = UIImage(named: "video")
            break
        case 1: //ppt
            let img = cell.viewWithTag(30001) as! UIImageView
            img.image = UIImage(named: "ppt")
            break
        case 2: //word
            let img = cell.viewWithTag(30001) as! UIImageView
            img.image = UIImage(named: "word")
            break
        case 3: //音频
            let img = cell.viewWithTag(30001) as! UIImageView
            img.image = UIImage(named: "voice")
            break
        case 4: //图片
            let img = cell.viewWithTag(30001) as! UIImageView
            img.image = UIImage(named: "picture")
            break
        default:
            break
        }
        
        return cell
    }
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.width - 20 , height: 85 )
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = getViewToStoryboard("onlineAskView") as! OnlineAskController
        vc.videoInfo = jsonDataSource[indexPath.item]
        vc.viewTitlte = "教材详情"
        parentView?.present(vc, animated: true, completion: nil)
        
    }
    
    override func refresh() {
        initLimitPage()
        parentView?.getMeterials()
    }
    
    override func loadMore() {
        parentView?.getMeterials()
    }
    
    override func initLimitPage() {
        super.initLimitPage()
        jsonDataSource = [JSON]()
    }
    
}


