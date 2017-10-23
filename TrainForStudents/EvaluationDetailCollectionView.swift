//
//  EvaluationDetailCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class EvaluationDetailCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentVC = UIViewController()
    var jsonDataSource = JSON([:])
    var isReadonly = false
    let maxStarNumber = 5
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return jsonDataSource.count * 2
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cellName = "c1"
        var index = 0
        
        if indexPath.item == 0{
            index = 0
            cellName = "c1"
        }else if indexPath.item % 2 == 0{
            index = indexPath.item / 2
            cellName = "c1"
        }else{
            index = (indexPath.item - 1) / 2
            cellName = "c2"
        }
        //设置默认评价都为五颗星
//        jsonDataSource[index]["get_value"] = 5
        let data = jsonDataSource[index]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        
        if cellName == "c1"{
            let lbl = cell.viewWithTag(10001) as? UILabel
            lbl?.text = data["itemtitle"].stringValue
        }else{
            let selectedNumber = data["get_value"].int
            var lightNumber = data["starsvalue"].intValue
            if selectedNumber != nil{
                lightNumber = selectedNumber!
            }
            if isReadonly {
                lightNumber = data["numbervalue"].intValue
            }
            touchStar(cell: cell, lightNumber: lightNumber)
            
            for i in 1 ... maxStarNumber{
                let tag = 10000 + i
                let btn = cell.viewWithTag(tag) as! UIButton
                btn.restorationIdentifier = "\(index)"
                btn.addTarget(self, action: #selector(btn_star_inside), for: UIControlEvents.touchUpInside)
            }
            
        }
        
        
        return cell
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if indexPath.item % 2 == 1 && !isReadonly{
//            
//        }
        print(indexPath.item)
        
    }
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.width, height: 45)
        
    }
    
    func btn_star_inside(sender : UIButton){
        if !isReadonly {
            let index = sender.tag - 10000
            touchStar(cell: sender.superview!, lightNumber: index)
            let i = Int(sender.restorationIdentifier!)!
            jsonDataSource[i]["get_value"] = JSON(index)
            //print(jsonDataSource[index - 1].description)
        }
    }
    
    func touchStar(cell : UIView , lightNumber : Int){
        
        for i in 1 ... maxStarNumber{
            let tag = 10000 + i
            let btn = cell.viewWithTag(tag) as! UIButton
            if i <= lightNumber{
                btn.setBackgroundImage(UIImage(named: "lightStar.png"), for: .normal)
            }else{
                btn.setBackgroundImage(UIImage(named: "star.png"), for: .normal)
            }
        }
    }
    
    
}
